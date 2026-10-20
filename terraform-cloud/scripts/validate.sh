#!/usr/bin/env bash
# Format-check and validate every root module (no backend, no credentials needed).
set -euo pipefail
cd "$(dirname "$0")/.."
command -v terraform >/dev/null || { echo "terraform CLI not found"; exit 1; }
terraform fmt -check -recursive
fail=0
for dir in $(find . -name providers.tf -not -path '*/.terraform/*' -printf '%h\n' | sort); do
  echo "== $dir"
  terraform -chdir="$dir" init -backend=false -input=false >/dev/null
  terraform -chdir="$dir" validate || fail=1
done
exit $fail
