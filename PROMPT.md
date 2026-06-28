# Paste-prompts

Copy one of these into your AI agent. It sets tokentrim up once; after that the
cost-saving agents are just there.

## Claude Code / Cursor / Codex — one-time setup

```
Set up tokentrim for me — a pack of cost-optimized Claude Code subagents that route
grunt work (search, reading, tests, trivial edits) to cheap Haiku so my expensive
model only does the hard parts (github.com/ahkamboh/tokentrim). Do this:

1. Clone it:
   git clone https://github.com/ahkamboh/tokentrim ~/tokentrim
2. Install the agents — ask me whether I want them in THIS project or globally, then:
   per-project:  bash ~/tokentrim/install.sh --project   (run from my project root)
   global:       bash ~/tokentrim/install.sh --global
3. Confirm: list .claude/agents/trim-*.md and tell me the 8 agents are installed.
After this, just work normally — you'll automatically hand search/reading/tests/
trivial edits to the cheap agents.
```

## Already cloned — just install

```
Run tokentrim's installer for this project: bash ~/tokentrim/install.sh --project
(or --global). Then confirm .claude/agents/trim-*.md shows 8 agents.
```
