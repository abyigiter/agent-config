---
description: Scout gathers context, planner writes the plan, worker implements it.
argument-hint: <task>
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `planner` and `reviewer` -> `opus`, `worker` -> `sonnet`.

1. Use the `scout` subagent to find all code relevant to: $ARGUMENTS
2. Use the `planner` subagent to create an implementation plan for "$ARGUMENTS". Pass it the scout's full output and the original request.
3. Use the `worker` subagent to implement the planner's plan. Pass it the full plan verbatim and the original request.

Return the worker's report.
