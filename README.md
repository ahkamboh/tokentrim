<h1 align="center">tokentrim</h1>

<p align="center"><b>Drop-in cost-optimized Claude Code subagents — route grunt work to cheap Haiku, climb to Opus/Fable only when the job earns it.</b></p>

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT" />
  <img src="https://img.shields.io/badge/agents-8-a3e635" alt="8 agents" />
  <img src="https://img.shields.io/badge/tiers-haiku→sonnet→opus→fable-success" alt="4 tiers" />
  <img src="https://img.shields.io/badge/runtime-zero-blue" alt="zero runtime" />
</p>

<p align="center">
  <a href="https://ahkamboh.github.io/tokentrim/"><b>🌐 Live site</b></a> ·
  <a href="#-set-it-up-with-your-ai-agent"><b>⚡ Set up</b></a> ·
  <a href="#model-tiers--which-model-for-what"><b>Tiers</b></a> ·
  <a href="#how-it-saves--and-roughly-how-much"><b>How it saves</b></a>
</p>

---

You're a vibe coder running everything on one expensive model. Most of what it does is **grunt work** — grepping for a function, reading a log, running tests, fixing a typo — and you're paying frontier-model prices for all of it.

tokentrim is **8 ready-made Claude Code subagents** spread across four model tiers. Drop them into `.claude/agents/` and Claude Code automatically does the grunt work on cheap **Haiku**, normal coding on **Sonnet**, and only climbs to **Opus**/**Fable** for the rare task that truly needs it — no `/model` switching, just cheaper sessions.

## ⚡ Set it up with your AI agent

Paste this into **Claude Code, Cursor, Codex — or any AI agent** and it installs tokentrim for you:

```
Set up tokentrim for me — a pack of cost-optimized Claude Code subagents that route
grunt work (search, reading, tests, trivial edits) to cheap Haiku so my expensive
model only does the hard parts (github.com/ahkamboh/tokentrim). Do this:

1. git clone https://github.com/ahkamboh/tokentrim ~/tokentrim
2. Ask me: install to THIS project or globally? then run
   bash ~/tokentrim/install.sh --project   (from my project root)   OR
   bash ~/tokentrim/install.sh --global
3. Confirm .claude/agents/trim-*.md lists 8 agents.
```

## Or install it yourself

```bash
git clone https://github.com/ahkamboh/tokentrim
bash tokentrim/install.sh --project     # → ./.claude/agents  (committable, per-repo)
# or
bash tokentrim/install.sh --global      # → ~/.claude/agents  (all your projects)
```

Run it with no flag and it asks which you want. Safe to re-run — it never overwrites an agent you've edited (skips it unless you pass `--force` or `--backup`).

## Model tiers — which model for what

tokentrim defaults everything to the **cheapest tier that can do the job** and only climbs when the task demands it. That climb is the whole game:

| Tier | Model | Cost | Reach for it when… | Agent |
|------|-------|------|--------------------|-------|
| 1 · top | `fable` <sub>claude-fable-5</sub> | 🔴 priciest (~2× Opus) | a **huge, long-horizon, autonomous** job must stay coherent across many steps — codebase-wide migration, sweeping multi-file refactor, deep research+build | `trim-marathon` |
| 2 · hard | `opus` <sub>claude-opus-4-8</sub> | 🟠 high | the **hard 10%** — architecture, a subtle cross-cutting bug, tricky concurrency/security/data tradeoffs | `trim-architect` |
| 3 · normal | `sonnet` <sub>claude-sonnet-4-6</sub> | 🟡 mid | **everyday coding** — implement a feature, write tests, a moderate refactor, review a diff | `trim-coder` |
| 4 · grunt | `haiku` <sub>claude-haiku-4-5</sub> | 🟢 cheapest, fastest | **high-volume legwork** — search, read→digest, run tests, trivial edits, version/API lookups | `trim-scout · trim-reader · trim-runner · trim-edit · trim-deps` |

Most of a session lives in tier 4 (cheap). Tiers 1–2 are deliberate escalations — they cost *more* when used, but only on the few tasks that actually need them.

## The 8 agents

| Agent | Model | Does |
|-------|-------|------|
| `trim-scout` | 🟢 haiku | find files / symbols / usages → paths only |
| `trim-reader` | 🟢 haiku | read big/many files → a tight digest |
| `trim-runner` | 🟢 haiku | run tests / build / lint → failures only |
| `trim-edit` | 🟢 haiku | trivial mechanical edits (rename, typo, import, version) |
| `trim-deps` | 🟢 haiku | version / API / docs lookup |
| `trim-coder` | 🟡 sonnet | everyday coding — features, tests, moderate refactors, reviews |
| `trim-architect` | 🟠 opus | hard design / deep debugging (a thinker — returns a plan) |
| `trim-marathon` | 🔴 fable | huge long-horizon jobs — migrations, sweeping refactors |

## How it saves — and roughly how much

Two honest mechanisms, no magic:

1. **Cheap model does the legwork.** Work delegated to a `haiku` agent runs on Haiku, not your pricey main model.
2. **Your main context stays lean.** Each subagent has its *own* context window and returns a short digest — so a 2,000-line log or four full files never pile into your expensive main thread.

```
You: "Find every call site of useAuth and read the 3 biggest."
Without tokentrim   ~38k tokens on your MAIN model (Opus)   grep + 3 full files in context
With tokentrim      ~3k on Opus  +  the rest on Haiku       trim-scout finds → trim-reader digests
```

**Rough math — how much you save (illustrative, not a benchmark):**
Haiku is several times cheaper per token than Opus. If, say, ~60% of an Opus-main session is grunt work and it shifts to Haiku, your spend lands around `40% + 60%÷several ≈ half` of what it was — realistically a **~30–60% lower bill** on an Opus-main session. Less if your main model is Sonnet; **~0% if your main is already Haiku**. (The opus/fable agents add cost *when used* — but only on the rare jobs that need them.)

**Speed:** Haiku runs faster and the leaner main context means less to re-read each turn, so grunt steps come back quicker. But your *main* reasoning model is unchanged, so end-to-end speed gains are **modest and situational** — the reliable win is **cost**, not raw speed. (No fake "3× faster" badge here.)

> Numbers are illustrative of the mechanism — actual savings depend on your codebase, your main model, and how Claude routes.

## Tune it

Every agent is a plain markdown file in `.claude/agents/`. Open one and change `model:` (`haiku`/`sonnet`/`opus`/`fable`/`inherit`), tighten its `description:`, adjust `tools:`, or delete the ones you don't want. `trim-edit` and `trim-marathon` are the two most worth reviewing — keep `trim-edit` to trivial edits, and `trim-marathon` to genuinely huge jobs (it's your most expensive tier).

## Honesty — read this

- **It helps most if your main model is Opus or Sonnet.** Already on Haiku? There's little to save.
- **Delegation is Claude's choice.** Claude routes to these agents by reading their descriptions — tokentrim raises the odds, it can't force it.
- **It does not change your main-loop model.** The top-level model stays whatever you set; savings come from offloaded sub-tasks and a leaner context.
- **The escalation tiers cost more when used.** `opus`/`fable` agents are there for the rare hard/huge task — used sparingly by design.

## Uninstall

```bash
rm .claude/agents/trim-*.md
```

## License

[MIT](LICENSE) © [ahkamboh](https://github.com/ahkamboh) · built with [Claude Code](https://claude.com/claude-code)
