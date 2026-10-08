---
description: Worker implements, reviewer reviews the diff, worker applies the feedback.
argument-hint: <task>
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `planner` and `reviewer` -> `opus`, `worker` -> `sonnet`.

1. Use the `worker` subagent to implement: $ARGUMENTS
2. Use the `reviewer` subagent to review the resulting diff against the request "$ARGUMENTS". Pass it the worker's report.
3. If the reviewer found Bugs or Design issues, use the `worker` subagent to fix them. Pass it the full review and the original request. Skip this step if the verdict is OK.

Return the final worker report and the reviewer's verdict.
