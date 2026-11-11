---
description: Reviewer finds changed code with no tests, worker writes them. Tests only, no production edits
---
Scope (empty means the current diff): $@

Launch exactly this workflow: put the block below in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Do not write it to a file. Replace TASK with the task above, as a JS string. Set TASK to the scope, or "the current diff" when empty.

```js workflow
const TASK = "<scope>";
const gaps = await runs.run("gaps", { agent: "reviewer", task: "Review " + TASK + ". List changed or new behavior that has no test. For each gap give the file, function, the behavior to assert, and the nearest existing test file or pattern to copy. Report gaps only, no style findings. If there are none, say NO GAPS." });
if (/NO GAPS/.test(gaps.output)) return gaps;
return runs.run("tests", { agent: "worker", task: "Write the missing tests for " + TASK + ".\n\nGap list:\n" + gaps.output + "\n\nFollow the repo's existing test style. Do not edit production code. If a gap needs a production change to be testable, report it instead. Run the scoped test target." });
```

Return the gap list, the tests added, and the test run result.
