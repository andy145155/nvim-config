#!/usr/bin/env bash
#
# run_kubepug_by_env_fixed.sh
#
# Predefined kube context groups for ptdev, dev, stg, prod.
# Runs kubepug checks and prints cluster summaries.
#
# Usage:
#   ENV=ptdev ./run_kubepug_by_env_fixed.sh
#   ENV=dev ./run_kubepug_by_env_fixed.sh
#   ENV=stg ./run_kubepug_by_env_fixed.sh
#   ENV=prod ./run_kubepug_by_env_fixed.sh
#
# Optional overrides:
#   K8S_VERSION=v1.31
#   DATABASE=/path/to/data.json
#

set -o pipefail

# ---- Config ----
if [[ -z "${ENV:-}" ]]; then
    echo "❌ Please set ENV=ptdev|dev|stg|prod"
    exit 1
fi

K8S_VERSION="${K8S_VERSION:-v1.31}"
DATABASE="${DATABASE:-}"

# Predefined groups (adjust these based on your kubeconfig)
PTDEV_CONTEXTS=(
    "hk-ptdev-apps-ro"
    "hk-ptdev-vault-ro"
    "hk-ptdev-forgerock-ro"
    "hk-ptdev-crossenv-ro"
    "hk-ptdev-cybesops-ro"
)
DEV_CONTEXTS=(
    "hk-dev-apps-ro"
    "hk-dev-vault-ro"
    "hk-dev-forgerock-ro"
    "hk-dev-frontend-ro"
    "hk-dev-integrations-ro"
    "hk-dev-iaspec-ro"
)
STG_CONTEXTS=(
    "hk-stg-apps-ro"
    "hk-stg-vault-ro"
    "hk-stg-forgerock-ro"
    "hk-stg-frontend-ro"
    "hk-stg-integrations-ro"
    "hk-stg-iaspec-ro"
    "hk-stg-keycloak-ro"
    "hk-stg-tm-vault-ro"
)
PROD_CONTEXTS=(
    "hk-prod-apps-ro"
    "hk-prod-vault-ro"
    "hk-prod-forgerock-ro"
    "hk-prod-frontend-ro"
    "hk-prod-integrations-ro"
    "hk-prod-iaspec-ro"
    "hk-prod-crossenv-ro"
    "hk-prod-cybesops-ro"
    "hk-prod-tm-vault-ro"
)

# Pick group
case "$ENV" in
    ptdev) TARGET_CONTEXTS=("${PTDEV_CONTEXTS[@]}") ;;
    dev) TARGET_CONTEXTS=("${DEV_CONTEXTS[@]}") ;;
    stg) TARGET_CONTEXTS=("${STG_CONTEXTS[@]}") ;;
    prod) TARGET_CONTEXTS=("${PROD_CONTEXTS[@]}") ;;
    *)
        echo "❌ Unknown ENV: $ENV (use ptdev|dev|stg|prod)"
        exit 1
        ;;
esac

if [[ ${#TARGET_CONTEXTS[@]} -eq 0 ]]; then
    echo "❌ No contexts defined for ENV=$ENV"
    exit 1
fi

echo "🔎 Running for ENV=$ENV with ${#TARGET_CONTEXTS[@]} contexts"
printf "   - %s\n" "${TARGET_CONTEXTS[@]}"

# ---- Ensure kubepug exists ----
if ! command -v kubepug >/dev/null 2>&1; then
    echo "❌ kubepug not found in PATH"
    exit 1
fi

# Build kubepug args
KUBEPUG_ARGS=("--k8s-version=${K8S_VERSION}")
if [[ -n "${DATABASE}" ]]; then
    KUBEPUG_ARGS+=("--database=${DATABASE}")
fi

# ---- Iterate contexts ----
i=0
for CTX in "${TARGET_CONTEXTS[@]}"; do
    i=$((i + 1))
    echo ""
    echo "======================================================================"
    echo "[$i/${#TARGET_CONTEXTS[@]}] Context: ${CTX} | ENV=${ENV} | K8S_VERSION=${K8S_VERSION}"
    if [[ -n "${DATABASE}" ]]; then
        echo "Database: ${DATABASE}"
    else
        echo "Database: (online fetch)"
    fi
    echo "----------------------------------------------------------------------"

    # Switch context
    if ! kubectl config use-context "${CTX}" >/dev/null 2>&1; then
        echo "❌ Failed to switch to context ${CTX} — skipping"
        continue
    fi

    # Cluster summary
    echo "Cluster summary:"
    kubectl get nodes -o wide || echo "⚠️  Could not list nodes"

    NS_COUNT="$(kubectl get ns --no-headers 2>/dev/null | wc -l | tr -d ' ')"
    POD_COUNT="$(kubectl get pods -A --no-headers 2>/dev/null | wc -l | tr -d ' ')"
    echo "[Summary] Namespaces: ${NS_COUNT:-0} | Pods: ${POD_COUNT:-0}"
    echo ""

    # Run kubepug
    kubepug "${KUBEPUG_ARGS[@]}"
done

echo ""
echo "✅ Completed for ENV=$ENV"
