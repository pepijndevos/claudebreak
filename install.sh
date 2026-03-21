#!/bin/bash
set -e

HOOK_DIR="$HOME/.claude/hooks"
HOOK_PATH="$HOOK_DIR/break-check.sh"
SETTINGS="$HOME/.claude/settings.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Install hook script
mkdir -p "$HOOK_DIR"
cp "$SCRIPT_DIR/break-check.sh" "$HOOK_PATH"
chmod +x "$HOOK_PATH"
echo "Installed hook to $HOOK_PATH"

# 2. Add hook to settings.json
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required for installation. Install it and retry."
  exit 1
fi

HOOK_CONFIG='{"hooks":{"UserPromptSubmit":[{"matcher":"","hooks":[{"type":"command","command":"~/.claude/hooks/break-check.sh","timeout":5}]}]}}'
jq -s '.[0] * .[1]' "$SETTINGS" <(echo "$HOOK_CONFIG") > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
echo "Updated $SETTINGS"

echo "Done! Break reminders will activate in your next Claude Code session."
