# Contributing

tokentrim is just markdown + a shell installer — no build, no runtime. To change an
agent, edit its file in `agents/`. To propose a new one, add `agents/trim-<name>.md`
following the same frontmatter (`name`, `description`, `tools`, `model`) and a tight,
"Use PROACTIVELY for…" / "Do NOT use for…" body so Claude routes to it correctly.

## Commits

Author commits as [ahkamboh](https://github.com/ahkamboh) (`alihamzakamboh180@gmail.com`).
Keep messages conventional (`feat:`, `fix:`, `docs:` …). If an AI agent helped, a
`Co-authored-by:` trailer for that tool is welcome but not required.

## A note on the subagent spec

These agents rely on Claude Code's subagent frontmatter — `model:` accepting
`haiku | sonnet | opus | fable | inherit` (or a full model id, e.g. `claude-fable-5`)
and `tools:` taking comma-separated capitalized tool names. If Claude Code changes
that schema or the available models, the agents may need updating.
