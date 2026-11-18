---
description: Worker implements, reviewer reviews the diff blind, worker fixes (max 2 fix/review cycles)
---
Task: $@

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK with the task above, as a JS string.

```js workflow
const TASK = "<task>";
const blocked = (r) => /BLOCK/.test(r.output.split("## Verdict").pop());
const impl = await runs.run("implement", { agent: "worker", task: "Implement: " + TASK });
let review = await runs.run("review1", { agent: "reviewer", task: "Review the current diff for: " + TASK + ". Judge the diff only." });
let fix = impl;
for (let i = 2; i <= 3 && blocked(review); i++) {
  fix = await runs.run("fix" + (i - 1), { agent: "worker", task: "Apply this review feedback for: " + TASK + "\n\nReview:\n" + review.output });
  review = await runs.run("review" + i, { agent: "reviewer", task: "Review the current diff for: " + TASK + ". Judge the diff only." });
}
return { worker: fix.output, review: review.output, stillBlocked: blocked(review) };
```

Return the final worker report and the reviewer's verdict. If stillBlocked is true, stop and ask me.
