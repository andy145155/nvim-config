Hey @SeniorEng, I’ve been iterating on our Windows-2019 AMI bake pipeline and wanted your feedback on this minimal-effort Slack notification approach—based on our current baking architecture, it’s the simplest way to get immediate visibility:

yaml
Copy
Edit
- slack/notify:
    event: always
    channel: "#infra-ami-updates"
    custom: |
      {% if build_status == "success" %}
      *✅ Windows 2019 AMI Bake Succeeded*  
      • *AMI:* `<https://console.aws.amazon.com/ec2/v2/home?region=${AWS_REGION}#Images:search=${WINDOWS_2019_DYNAMIC_AMI}|${WINDOWS_2019_DYNAMIC_AMI}>`  
      • *Project Version:* `${PROJECT_VERSION_WINDOWS_2019}`  
      • *Build:* `<${CIRCLE_BUILD_URL}|#${CIRCLE_BUILD_NUM}>`
      {% else %}
      *❌ Windows 2019 AMI Bake Failed*  
      • *Build:* `<${CIRCLE_BUILD_URL}|#${CIRCLE_BUILD_NUM}>`  
      • *Known fix PRs:*  
        {% assign prs = env.LAST_FIX_PRS | split: "," -%}
        {% for pr in prs -%}
        <https://github.com/our-org/our-repo/pull/{{ pr }}|PR #{{ pr }}>{% if forloop.last == false %}, {% endif %}
        {% endfor %}
  
      _If this is a new failure, please add your PR number to `LAST_FIX_PRS` so it shows up next time._
      {% endif %}
Why this approach?

✅ Success posts AMI link, project version, and build URL.

❌ Failures list all known fix PRs and remind the team to update the list.

Least effort: a single slack/notify step at the end of our existing build-windows-2019 job.

Since you mentioned in yesterday’s meeting you were still investigating some edge cases, please let me know if there’s anything this doesn’t cover or any extra info you’d like surfaced (e.g. bake duration, packer logs, tags). Thanks!
— Andy