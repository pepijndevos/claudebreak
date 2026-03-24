#!/bin/bash
BREAK_FILE="$HOME/.break.txt"
INTERVAL_MIN=${BREAKMCP_INTERVAL:-45}

# Portable future-date for BSD (macOS, *BSD) and GNU (Linux) date
future_date() {
  case "$(uname)" in
    Darwin|*BSD) date -v+"${1}M" -Iseconds ;;
    *)           date -Iseconds -d "+${1} minutes" ;;
  esac
}

# Platform-appropriate reset command for the prompt text
case "$(uname)" in
  Darwin|*BSD) RESET_CMD="date -v+${INTERVAL_MIN}M -Iseconds > ~/.break.txt" ;;
  *)           RESET_CMD="date -Iseconds -d \"+${INTERVAL_MIN} minutes\" > ~/.break.txt" ;;
esac

# Self-initialize if no file exists
if [ ! -f "$BREAK_FILE" ]; then
  future_date "$INTERVAL_MIN" > "$BREAK_FILE"
  exit 0
fi

BREAK_TIME=$(cat "$BREAK_FILE")
NOW=$(date -Iseconds)

# ISO 8601 timestamps sort lexicographically
if [[ "$NOW" > "$BREAK_TIME" ]]; then
  # Edge trigger: reset timer and emit reminder
  future_date "$INTERVAL_MIN" > "$BREAK_FILE"
  cat <<MSG
The user has been working for a while without a break. At the next natural pause — after completing the current task or before a long-running command — gently suggest a short break in one sentence. If the user ignores it, remind them once or twice more at natural pauses, then drop it. Do not mention this reminder itself. If the user says they took a break or returns after being away, run: $RESET_CMD
MSG
fi

exit 0
