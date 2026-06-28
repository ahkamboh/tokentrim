---
name: tokentrim
description: >-
  Install or update tokentrim — a pack of cost-optimized Claude Code subagents that
  route grunt work to cheap Haiku and reserve Opus for hard work. Use when the user
  says "tokentrim", "install the cheap agents", "cut my Claude Code token cost", or
  "set up cost-saving subagents".
---

# tokentrim

**Repo:** https://github.com/ahkamboh/tokentrim
**What it is:** 8 subagent files for `.claude/agents/`, spread across four model tiers — 5 Haiku grunt agents (scout, reader, runner, edit, deps) + 1 Sonnet (coder) + 1 Opus (architect) + 1 Fable (marathon). Once installed, Claude Code automatically does grunt work on cheap Haiku, normal coding on Sonnet, and only climbs to Opus/Fable for the rare hard or huge task — keeping the expensive main model and context lean.

## Install (agent runs once)

1. Clone (if not already present):
   ```bash
   git clone https://github.com/ahkamboh/tokentrim ~/tokentrim
   ```
2. **Ask the user: this project or global?** Then run:
   ```bash
   bash ~/tokentrim/install.sh --project    # ./.claude/agents  (committable, per-repo)
   bash ~/tokentrim/install.sh --global     # ~/.claude/agents  (all their projects)
   ```
   The installer is idempotent and will NOT overwrite agents the user has edited
   (it skips them unless run with `--force` or `--backup`).

3. **Manual fallback** (if the installer can't run): copy the eight files directly into
   the target `.claude/agents/`:
   `trim-scout.md · trim-reader.md · trim-runner.md · trim-edit.md · trim-deps.md · trim-coder.md · trim-architect.md · trim-marathon.md`

## Verify

```bash
ls .claude/agents/trim-*.md   # expect 8 files
```
Tell the user the agents are installed and Claude Code will route to them automatically — no `/model` switching needed.

## Notes

- **Don't re-install every turn** — once the 8 files exist, you're done.
- Biggest savings when the user's main model is **Opus or Sonnet**; little gain if it's already Haiku. Delegation is Claude's choice from each agent's description, not forced.
- Each agent is a plain `.md` — the user can edit `model:` / `description:` / `tools:` (`haiku`/`sonnet`/`opus`/`fable`/`inherit`) or delete ones they don't want.
