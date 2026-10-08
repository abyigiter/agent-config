---
description: Scout gathers context, planner writes the implementation plan. No implementation.
argument-hint: <task>
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `planner` and `reviewer` -> `opus`, `worker` -> `sonnet`.

1. Use the `scout` subagent to find all code relevant to: $ARGUMENTS
2. Use the `planner` subagent to create an implementation plan for "$ARGUMENTS". Pass it the scout's full output and the original request.

Return the planner's plan. Do NOT implement anything.
