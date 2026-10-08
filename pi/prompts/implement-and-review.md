---
description: Worker implements, reviewer reviews, worker applies feedback
---
Task: $@

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK with the task above, as a JS string.

```js workflow
const TASK = "<task>";
const impl = await runs.run("implement", { agent: "worker", task: "Implement: " + TASK });
const review = await runs.run("review", { agent: "reviewer", task: "Review the current diff for: " + TASK + "\n\nWorker report:\n" + impl.output });
return runs.run("fix", { agent: "worker", task: "Apply this review feedback for: " + TASK + ". If the verdict is OK with no findings, change nothing.\n\nReview:\n" + review.output });
```

Return the final worker report and the reviewer's verdict.
