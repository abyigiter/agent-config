---
description: Scout traces the symptom, planner ranks root-cause hypotheses with a check each, worker runs the checks and fixes the confirmed cause
---
Symptom: $@

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK with the task above, as a JS string.

```js workflow
const TASK = "<symptom>";
const scout = await runs.run("scout", { agent: "scout", task: "Trace the code path behind: " + TASK + "\n\nInclude the error text, call chain, recent git log on those files, and related tests." });
const plan = await runs.run("plan", { agent: "planner", task: "Symptom: " + TASK + "\n\nScout context:\n" + scout.output + "\n\nReturn up to 3 root-cause hypotheses ranked by likelihood, each with one concrete check (command, log line, or test) that confirms or kills it, then a fix plan for the top hypothesis." });
return runs.run("fix", { agent: "worker", task: "Symptom: " + TASK + "\n\nPlanner output:\n" + plan.output + "\n\nRun the checks in rank order, stop at the first confirmed cause, apply the planned fix, and add a regression test when one fits. If no hypothesis is confirmed, report that and edit nothing." });
```

Return the confirmed root cause (or "unconfirmed"), the diff stat, and the worker's verification output.
