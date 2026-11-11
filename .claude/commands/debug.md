---
description: Scout traces the symptom, planner ranks root-cause hypotheses with a check each, worker runs the checks and fixes the confirmed cause.
argument-hint: <error or symptom>
---
Run this as a subagent chain. Pass `model` on every Agent call: `scout` -> `haiku`, `worker` -> `sonnet`. For `planner`, you pick per task: `fable` for cross-service or ambiguous bugs, `opus` for a single-module bug. State the pick and why in one line before calling it.

1. Use the `scout` subagent to trace the code path behind: $ARGUMENTS. Include the error text, call chain, recent `git log` on those files, and related tests.
2. Use the `planner` subagent. Pass it the scout's full output and the symptom. It must return up to 3 root-cause hypotheses ranked by likelihood, each with one concrete check (command, log line, or test) that confirms or kills it, then a fix plan for the top hypothesis.
3. Use the `worker` subagent. Pass it the symptom and the planner's output verbatim. Run the checks in rank order, stop at the first confirmed cause, apply the planned fix, and add a regression test when one fits. If no hypothesis is confirmed, report that and edit nothing.

Return the confirmed root cause (or "unconfirmed"), the diff stat, and the worker's verification output.
