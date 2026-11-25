---
description: Full implementation workflow - scout gathers context, planner creates plan, worker (Gemini 4 Neon high) implements
---
Task: $@

First, classify the task. Ready means goal, scope, and done-criteria are clear and no open decision would change the plan: write one line `Classifier: ready - <reason>` and set DECISIONS to "none". If thin, load the `grilling` skill and grill me only on the open decisions, wait until I confirm shared understanding, then set DECISIONS to a short summary of the settled decisions.

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK and DECISIONS with the task and the settled decisions, as JS strings.

```js workflow
const TASK = "<task>";
const DECISIONS = "<decisions>";
const scout = await runs.run("scout", { agent: "scout", task: "Find all code relevant to: " + TASK });
const plan = await runs.run("plan", { agent: "planner", task: "Create an implementation plan (with acceptance criteria) for: " + TASK + "\n\nSettled decisions:\n" + DECISIONS + "\n\nScout context:\n" + scout.output });
return runs.run("implement", { agent: "worker", model: "openrouter/google/gemini-4-neon:high", task: "Implement this plan for: " + TASK + "\n\nPlan:\n" + plan.output });
```

Return the worker's report.
