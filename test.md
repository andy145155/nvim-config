# --- inside the OnDelete branch ---

# 1) build a clean label selector: key1=val1,key2=val2
selectors="$(echo "$match_labels" \
  | jq -r 'to_entries | map("\(.key)=\(.value)") | join(",")')"

echo "[INFO] selector for $res_kind/$res_ns/$res_name: $selectors"

# 2) list target pods in the SAME namespace as the resource
ondelete_res="$(kubectl get pods -n "$res_ns" -l "$selectors" -o json | jq -c '.items[]')"

pod_count="$(wc -l <<< "$ondelete_res" | tr -d ' ')"
echo "[INFO] will restart $pod_count pod(s) in ns=$res_ns for selector: $selectors"

while IFS= read -r pod_json; do
  ns="$(jq -r '.metadata.namespace' <<< "$pod_json")"   # should equal $res_ns
  name="$(jq -r '.metadata.name'      <<< "$pod_json")"

  echo "[INFO] Deleting pod: $ns/$name"
  kubectl delete pod -n "$ns" "$name" --wait=false

  echo "[INFO] Waiting for delete: $ns/$name"
  kubectl wait -n "$ns" --for=delete "pod/$name" --timeout=5m

  echo "[INFO] Waiting for replacement Ready (ns=$ns, selector=$selectors)"
  kubectl wait -n "$ns" -l "$selectors" --for=condition=Ready pod --timeout=10m

  echo "[INFO] Replacement for $ns/$name is Ready"
done <<< "$ondelete_res"

