---
description: Full implementation workflow - scout gathers context, planner creates plan, worker implements
---
Task: $@

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK with the task above, as a JS string.

```js workflow
const TASK = "<task>";
const scout = await runs.run("scout", { agent: "scout", task: "Find all code relevant to: " + TASK });
const plan = await runs.run("plan", { agent: "planner", task: "Create an implementation plan for: " + TASK + "\n\nScout context:\n" + scout.output });
return runs.run("implement", { agent: "worker", task: "Implement this plan for: " + TASK + "\n\nPlan:\n" + plan.output });
```

Return the worker's report.
