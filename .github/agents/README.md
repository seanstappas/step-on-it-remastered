# Elephant / Goldfish agents

An implementation of the [Elephant-Goldfish Model](https://drensin.medium.com/elephants-goldfish-and-the-new-golden-age-of-software-engineering-c33641a48874)
(Dave Rensin) and the [vshvedov/elephant-goldfish](https://github.com/vshvedov/elephant-goldfish)
workflow set, as native VS Code custom agents.

- **Elephant** = the orchestrator agent you talk to. It holds full conversation context.
- **Goldfish** = zero-context subagents. Each receives ONLY the artifact the elephant hands it
  (a problem statement, a design doc, or a diff) — never the conversation. That blindness is the test.

## Pipeline

| Start with… | Run | Produces |
|---|---|---|
| A half-formed idea | `eg-brainstorm` | A concepts brief; pick a direction |
| A direction, no requirements | `eg-prd` | A PRD: scope, requirements, metrics, open questions |
| An existing design doc/plan/PRD to vet | `eg-design-review` | A gated review report (no building) |
| A clear feature to build | `eg-new-feature` | Design doc (gated) → implemented + reviewed code |
| A bug or #issue | `eg-fix-bug` | A failing-test-driven fix, reviewed |
| A diff already in hand | `eg-precommit-review` | A reviewer-cleared diff |

Each upstream stage can hand off to the next. Implementation stages stop short of committing — you authorize the commit.

## How to use

1. Open Copilot Chat and select an `eg-*` agent from the agent picker (the goldfish are hidden — they run only as subagents).
2. Give a one-liner and attach any relevant doc/file.
3. Expand the tool call in chat to watch goldfish spin up in parallel with isolated context.

## Files

**Orchestrators (Elephant):** `eg-brainstorm`, `eg-prd`, `eg-design-review`, `eg-new-feature`, `eg-fix-bug`, `eg-precommit-review`.

**Goldfish (subagents, `user-invocable: false`):**
- Idea lenses: `eg-goldfish-technical`, `eg-goldfish-business`, `eg-goldfish-ux`, `eg-goldfish-contrarian`, `eg-goldfish-market`
- Codebase grounding: `eg-goldfish-explorer`
- Design gate: `eg-goldfish-comprehension`, `eg-goldfish-critic`, `eg-goldfish-readiness`
- Bug diagnosis: `eg-goldfish-diagnostician`
- Code review: `eg-goldfish-reviewer`

## Key mechanics preserved from the source

- **No-code gate** (`eg-new-feature`): no implementation until Critic returns `design ready` AND Readiness returns `implementation ready` in the same round.
- **Round caps** (5) with user escalation on non-convergence.
- **Verbatim triage:** every finding is fixed or rebutted in writing — no silent dismissals.
- **Hidden hypothesis** (`eg-fix-bug`): the elephant's guess is never shown to the diagnostician; convergence buys confidence, divergence is signal.
- **Failing test first**, before any bug fix.
