#!/bin/bash
set -e

HOOK_PATH="$HOME/.claude/hooks/break-check.sh"
SETTINGS="$HOME/.claude/settings.json"
BREAK_FILE="$HOME/.break.txt"

# 1. Remove hook script
if [ -f "$HOOK_PATH" ]; then
  rm "$HOOK_PATH"
  echo "Removed $HOOK_PATH"
fi

# 2. Remove hook from settings.json
if [ -f "$SETTINGS" ] && command -v jq &>/dev/null; then
  jq 'if .hooks?.UserPromptSubmit then .hooks.UserPromptSubmit |= map(select(.hooks | all(.command != "~/.claude/hooks/break-check.sh"))) | if .hooks.UserPromptSubmit == [] then del(.hooks.UserPromptSubmit) else . end | if .hooks == {} then del(.hooks) else . end else . end' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "Removed hook from $SETTINGS"
fi

# 3. Remove state file
if [ -f "$BREAK_FILE" ]; then
  rm "$BREAK_FILE"
  echo "Removed $BREAK_FILE"
fi

echo "Done! Break reminders have been removed."
