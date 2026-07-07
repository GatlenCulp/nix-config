#!/usr/bin/env bash
# Runs the symlink-migration unit tests. Exits non-zero if any check fails or
# the expression fails to evaluate. Needs only the `nix` evaluator (no network).
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

echo "== symlink-migration tests =="
out="$(nix eval --raw -f "$here/symlink-migration.nix" 2>&1)"
rc=$?
echo "$out"
echo

if [ $rc -ne 0 ]; then
  echo "RESULT: EVAL ERROR (rc=$rc)"
  exit 1
fi

if printf '%s\n' "$out" | grep -q "RESULT: ALL PASS"; then
  exit 0
fi
exit 1
