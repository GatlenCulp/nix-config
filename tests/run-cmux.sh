#!/usr/bin/env bash
# Runs the cmux/orca hermetic test and validates the committed cmux.json.
# NIX_SSL_CERT_FILE is honored if the caller sets it; otherwise nix uses the
# system trust store.
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

echo "== cmux/orca test =="
out="$(nix eval --raw -f "$here/cmux-editable.nix" 2>&1)"
rc=$?
echo "$out"
echo

if [ $rc -ne 0 ]; then
  echo "RESULT: EVAL ERROR (rc=$rc)"
  exit 1
fi

# cmux.json must be valid JSON.
if ! jq -e . "$here/../home/cmux/cmux.json" >/dev/null 2>&1; then
  echo "RESULT: cmux.json is not valid JSON"
  exit 1
fi
echo "OK: home/cmux/cmux.json is valid JSON"

printf '%s\n' "$out" | grep -q "RESULT: ALL PASS"
