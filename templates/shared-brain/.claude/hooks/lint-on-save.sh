#!/usr/bin/env bash
# lint-on-save.sh — runs the appropriate linter after Claude edits a file.
#
# Registration: add to .claude/settings.json (already included in this scaffold):
# {
#   "hooks": {
#     "PostToolUse": [{
#       "matcher": "Edit|Write",
#       "hooks": [{ "type": "command", "command": "bash .claude/hooks/lint-on-save.sh" }]
#     }]
#   }
# }

set -euo pipefail

# Claude Code passes the tool use event as JSON on stdin.
INPUT="$(cat)"
FILE=""

if command -v jq &>/dev/null; then
  FILE="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
fi

# Exit silently if no file path or file does not exist.
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  exit 0
fi

case "$FILE" in
  *.py)
    if command -v ruff &>/dev/null; then
      ruff check --fix "$FILE" 2>&1 || true
    fi
    ;;
  *.js|*.ts|*.jsx|*.tsx|*.mjs|*.cjs)
    if command -v eslint &>/dev/null; then
      eslint --fix "$FILE" 2>&1 || true
    fi
    ;;
esac
