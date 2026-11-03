# Kubernetes
Do not fabricate or guess Kubernetes manifest fields. When proposing YAML for any CRD or built-in resource:
1. Run `kubectl explain <resource>` and drill into nested fields to verify the exact schema before writing any YAML
2. If `kubectl explain` is unavailable or insufficient, check official documentation
3. Never propose a field structure you haven't verified

# Terragrunt
Do not fabricate or guess Terragrunt block syntax, attributes, or built-in functions. When proposing HCL for any Terragrunt configuration:
1. Check the official Terragrunt documentation for the exact block structure and supported attributes
2. Do not assume Terraform block syntax applies to Terragrunt — they diverge (e.g. `dependency`, `generate`, `include`, `inputs`)
3. Never propose a configuration pattern you haven't verified against docs
4. Repositories downloaded are always in $REPOS, avoid scanning the whole machine filesystem when looking for repositories and look in that folder first

# Git operations
When asked about PR descriptions, always wrap the full output in fenced markdown code block for an easy copy-paste.

# Github Actions
Before suggesting changes in actions versions, always check available versions online, do not rely on your memory as
actions change fast.
