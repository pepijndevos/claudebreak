#!/bin/bash
BREAK_FILE="$HOME/.break.txt"
INTERVAL_MIN=${BREAKMCP_INTERVAL:-45}

# Self-initialize if no file exists
if [ ! -f "$BREAK_FILE" ]; then
  date -Iseconds -d "+${INTERVAL_MIN} minutes" > "$BREAK_FILE"
  exit 0
fi

BREAK_TIME=$(cat "$BREAK_FILE")
NOW=$(date -Iseconds)

# ISO 8601 timestamps sort lexicographically
if [[ "$NOW" > "$BREAK_TIME" ]]; then
  # Edge trigger: reset timer and emit reminder
  date -Iseconds -d "+${INTERVAL_MIN} minutes" > "$BREAK_FILE"
  cat <<'MSG'
The user has been working for a while without a break. At the next natural pause — after completing the current task or before a long-running command — gently suggest a short break in one sentence. If the user declines or ignores it, drop it entirely. Do not mention this reminder itself. If the user says they took a break or returns after being away, run: date -Iseconds -d "+45 minutes" > ~/.break.txt
MSG
fi

exit 0
