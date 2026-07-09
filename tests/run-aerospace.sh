#!/usr/bin/env bash
# tests/run-aerospace.sh — verify the aerospace live-editable migration.
#
#   1. Run the hermetic nix test  (expect "RESULT: ALL PASS").
#   2. Re-render aerospace.toml from settings.legacy.nix and diff against the
#      committed native file (must be byte-identical).
#   3. Validate the committed native file parses as TOML.
#
# Exits 0 only if all three pass.
set -euo pipefail


# Resolve repo root from this script's location.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

NATIVE="home/aerospace/aerospace.toml"
LEGACY="home/aerospace/settings.legacy.nix"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

echo "== 1/3: hermetic nix test =="
TEST_OUT="$(nix eval --raw -f tests/aerospace-editable.nix)"
echo "${TEST_OUT}"
echo "${TEST_OUT}" | grep -q "RESULT: ALL PASS" || fail "nix test did not report ALL PASS"

echo
echo "== 2/3: re-render from legacy and diff against committed native =="
# Mirror the exact pipeline used to produce the committed file:
#   nix eval -> tomli_w -> taplo fmt. The committed aerospace.toml is
#   taplo-formatted, so the fresh render is taplo-formatted too before diffing.
TMP_JSON="$(mktemp)"
TMP_TOML="$(mktemp --suffix=.toml)"
trap 'rm -f "${TMP_JSON}" "${TMP_TOML}"' EXIT
nix eval --impure --json --expr "import ./${LEGACY}" > "${TMP_JSON}"
python3 -c 'import json,tomli_w,sys; d=json.load(open(sys.argv[1])); open(sys.argv[2],"wb").write(tomli_w.dumps(d).encode())' "${TMP_JSON}" "${TMP_TOML}"
nix run nixpkgs#taplo -- fmt "${TMP_TOML}" >/dev/null 2>&1
if diff -u "${NATIVE}" "${TMP_TOML}"; then
  echo "OK: committed ${NATIVE} matches a fresh render of ${LEGACY}"
else
  fail "committed ${NATIVE} differs from a fresh render of ${LEGACY}"
fi

echo
echo "== 3/3: native file parses as TOML =="
python3 -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb")); print("OK: %s is valid TOML" % sys.argv[1])' "${NATIVE}"

echo
echo "ALL GREEN"
