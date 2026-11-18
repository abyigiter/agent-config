---
description: Scout gathers context, planner writes the plan, worker (Grok 4.7 medium, run via Pi) implements it, reviewer (Opus 5.5 medium) does a fast review.
argument-hint: <task>
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `reviewer` -> `opus`. For `planner`, you pick per task: `fable` for large, ambiguous, cross-cutting, or architecture-heavy work; `opus` for small or well-scoped work. State the pick and why in one line before calling it.

1. Use the `scout` subagent to find all code relevant to: $ARGUMENTS
2. Classify "$ARGUMENTS" using the scout's output for facts. Ready means goal, scope, and done-criteria are clear from the request plus scout context, and no open decision would change the plan. If ready, write one line `Classifier: ready - <reason>` and go to step 3. If thin, load the `grilling` skill in this session and grill me only on the open decisions, not the whole tree. Do not proceed until I confirm shared understanding.
3. Use the `planner` subagent to create an implementation plan for "$ARGUMENTS". Pass it the scout's full output, the original request, and any settled decisions from the grilling. It must include acceptance criteria.
4. Implement the plan with Grok 4.7 medium through Pi, not the Agent tool. Write the original request and the planner's full plan verbatim to a scratchpad file, then run `pi --provider openrouter --model x-ai/grok-4.7:medium -p "Implement the plan in <file> for: $ARGUMENTS. Edit files, run the repo's scoped checks (Makefile first), do not commit or push."` in the repo root (foreground, timeout 600000, or `run_in_background` if long). Then check `git status` / `git diff --stat` to confirm the edits landed.
5. Use the `reviewer` subagent for a fast review of the resulting diff against "$ARGUMENTS". Pass `model: opus` and `effort: medium`. Pass it the original request and the plan's Acceptance Criteria only, not the Pi run's output or reasoning. Report only; do not apply fixes.

Return Pi's report, the diff stat, and the reviewer's verdict.
