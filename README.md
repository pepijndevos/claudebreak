# claudebreak

A Claude Code hook that gently reminds you to take breaks. It tracks time since your last break in `~/.break.txt` and nudges Claude to suggest a break at natural pauses when you're overdue.

## Install

```bash
git clone https://github.com/pepijndevos/claudebreak.git
cd claudebreak
./install.sh
```

This copies the hook to `~/.claude/hooks/` and registers it in `~/.claude/settings.json`. Requires `jq`.

## Configure

The default interval is 45 minutes. Override it by setting `BREAKMCP_INTERVAL` in your shell profile:

```bash
export BREAKMCP_INTERVAL=30  # minutes
```

## How it works

1. Every time you submit a prompt, the hook checks if `~/.break.txt` contains a past timestamp
2. If you're overdue: it resets the timer and tells Claude you need a break
3. Claude mentions it once at the next natural pause, then drops it
4. When you say you took a break, Claude resets the timer

## Uninstall

```bash
./uninstall.sh
```
