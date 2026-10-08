---
description: Scout gathers context, planner creates implementation plan (no implementation)
---
Task: $@

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK with the task above, as a JS string.

```js workflow
const TASK = "<task>";
const scout = await runs.run("scout", { agent: "scout", task: "Find all code relevant to: " + TASK });
return runs.run("plan", { agent: "planner", task: "Create an implementation plan for: " + TASK + "\n\nScout context:\n" + scout.output });
```

Return the planner's plan. Do NOT implement anything.
