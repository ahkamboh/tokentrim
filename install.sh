#!/usr/bin/env bash
# tokentrim installer — drop cost-optimized Claude Code subagents into .claude/agents/
# Usage:
#   bash install.sh                 # asks: this project or global?
#   bash install.sh --project       # ./.claude/agents
#   bash install.sh --global        # ~/.claude/agents
#   bash install.sh --dir <path>    # <path>/.claude/agents  (escape hatch / testing)
#   --force    overwrite agents that exist but differ
#   --backup   keep a .bak before overwriting a differing agent
set -euo pipefail

REPO_URL="https://github.com/ahkamboh/tokentrim"
TARGET=""        # project | global | dir
DIR_ARG=""
FORCE=0
BACKUP=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project) TARGET="project" ;;
    --global)  TARGET="global" ;;
    --dir)     TARGET="dir"; DIR_ARG="${2:?--dir needs a path}"; shift ;;
    --force)   FORCE=1 ;;
    --backup)  BACKUP=1 ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done

# --- locate the agent source (next to this script, or clone if run via curl|bash) ---
SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || echo "")"
SRC="$SCRIPT_DIR/agents"
CLONE_TMP=""
if [ ! -d "$SRC" ]; then
  echo "▸ fetching tokentrim agents…"
  CLONE_TMP="$(mktemp -d)"
  git clone --depth 1 "$REPO_URL" "$CLONE_TMP" >/dev/null 2>&1 || {
    echo "✗ could not clone $REPO_URL — clone it yourself and run bash install.sh" >&2; exit 1; }
  SRC="$CLONE_TMP/agents"
fi
[ -d "$SRC" ] || { echo "✗ agents/ not found at $SRC" >&2; exit 1; }

# --- choose where to install ---
case "$TARGET" in
  project) BASE="$PWD" ;;
  global)  BASE="$HOME" ;;
  dir)     BASE="$DIR_ARG" ;;
  "")
    if [ -t 0 ] && [ -t 1 ]; then
      printf 'Install tokentrim agents to:\n  [1] this project  (%s/.claude/agents)\n  [2] global        (%s/.claude/agents)\n> ' "$PWD" "$HOME"
      read -r choice
      case "$choice" in 2) BASE="$HOME" ;; *) BASE="$PWD" ;; esac
    else
      BASE="$PWD"
      echo "ℹ no target flag + non-interactive → installing to ./.claude/agents (re-run with --global to change)"
    fi ;;
esac

DEST="$BASE/.claude/agents"
mkdir -p "$DEST"

# --- copy with idempotency + clobber-guard ---
copied=0 same=0 updated=0 guarded=0 total=0
for f in "$SRC"/*.md; do
  [ -e "$f" ] || continue
  total=$((total+1))
  name="$(basename "$f")"
  dst="$DEST/$name"
  if [ ! -f "$dst" ]; then
    cp "$f" "$dst"; echo "+ installed $name"; copied=$((copied+1))
  elif cmp -s "$f" "$dst"; then
    echo "= $name (up to date)"; same=$((same+1))
  elif [ "$FORCE" = 1 ] || [ "$BACKUP" = 1 ]; then
    [ "$BACKUP" = 1 ] && cp "$dst" "$dst.bak"
    cp "$f" "$dst"
    if [ "$BACKUP" = 1 ]; then echo "~ updated $name (backup at $name.bak)"; else echo "~ overwrote $name"; fi
    updated=$((updated+1))
  else
    echo "! $name exists and differs — skipped (use --force to overwrite, --backup to keep a .bak)"
    guarded=$((guarded+1))
  fi
done

[ -n "$CLONE_TMP" ] && rm -rf "$CLONE_TMP"

# --- summary ---
echo ""
echo "✅ tokentrim → $DEST"
echo "   $total agents — haiku: scout reader runner edit deps · sonnet: coder · opus: architect · fable: marathon"
[ "$guarded" -gt 0 ] && echo "   ($guarded kept your edited version — re-run with --force or --backup to update them)"
echo "ℹ Biggest savings when your main model is Opus or Sonnet. Delegation is Claude's choice, not forced."
echo "Try: open Claude Code here and ask \"find where X is defined\" — watch trim-scout (haiku) take it."
echo "Tune or remove any agent in $DEST/*.md · re-run with --global to also install globally."
