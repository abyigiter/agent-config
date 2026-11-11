---
description: Scout gathers context, planner writes the plan, worker (Haiku, max effort) implements it, reviewer (Opus 5.5 medium) does a fast review.
argument-hint: <task>
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `worker` -> `haiku` with `effort: max`, `reviewer` -> `opus`. For `planner`, you pick per task: `fable` for large, ambiguous, cross-cutting, or architecture-heavy work; `opus` for small or well-scoped work. State the pick and why in one line before calling it.

1. Use the `scout` subagent to find all code relevant to: $ARGUMENTS
2. Use the `planner` subagent to create an implementation plan for "$ARGUMENTS". Pass it the scout's full output and the original request.
3. Use the `worker` subagent to implement the plan. Pass `model: haiku` and `effort: max`. Give it the original request and the planner's full plan verbatim. Then check `git status` / `git diff --stat` to confirm the edits landed.
4. Use the `reviewer` subagent for a fast review of the resulting diff against "$ARGUMENTS". Pass `model: opus` and `effort: medium`. Pass it the worker's report. Report only; do not apply fixes.

Return the worker's report, the diff stat, and the reviewer's verdict.
