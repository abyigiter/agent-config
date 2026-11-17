---
description: Full implementation workflow - scout gathers context, planner creates plan, worker (Grok 4.7 medium) implements
---
Task: $@

First, load the `grilling` skill and grill me on the task in this session (skip only for a trivial, unambiguous one-liner). Wait until I confirm shared understanding. Then set DECISIONS below to a short summary of the settled decisions.

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK and DECISIONS with the task and the settled decisions, as JS strings.

```js workflow
const TASK = "<task>";
const DECISIONS = "<decisions>";
const scout = await runs.run("scout", { agent: "scout", task: "Find all code relevant to: " + TASK });
const plan = await runs.run("plan", { agent: "planner", task: "Create an implementation plan for: " + TASK + "\n\nSettled decisions:\n" + DECISIONS + "\n\nScout context:\n" + scout.output });
return runs.run("implement", { agent: "worker", model: "openrouter/x-ai/grok-4.7:medium", task: "Implement this plan for: " + TASK + "\n\nPlan:\n" + plan.output });
```

Return the worker's report.
