#!/usr/bin/env bash
# Guards for home/ghostty/config regressions (the file is live-editable, so
# these only assert machine-readable invariants, not taste):
#   1. `command` is unquoted — ghostty treats quotes as literal characters,
#      so a quoted path silently fails to exec (no zellij at startup).
#   2. `working-directory` does not use $HOME — ghostty does not expand
#      environment variables (use its `home` keyword instead).
set -uo pipefail
cfg="$(dirname "$0")/../home/ghostty/config"
rc=0

if grep -qE '^command = ".*"' "$cfg"; then
  echo "FAIL: ghostty 'command' value is quoted (quotes are literal in ghostty config)" >&2
  rc=1
else
  echo "OK: command is unquoted"
fi

if grep -qE '^working-directory = .*\$' "$cfg"; then
  echo "FAIL: ghostty 'working-directory' uses an env var (ghostty does not expand them)" >&2
  rc=1
else
  echo "OK: working-directory has no env vars"
fi

[ "$rc" -eq 0 ] && echo "ALL GREEN"
exit "$rc"
