---
description: Reviewer finds changed code with no tests, worker writes them. Tests only, no production edits.
argument-hint: [scope, default current diff]
---
Run this as a subagent chain. Pass `model` on every Agent call: `reviewer` -> `opus`, `worker` -> `sonnet`.

1. Use the `reviewer` subagent on the current diff (or "$ARGUMENTS" if given). Task: list changed or new behavior that has no test. For each gap give the file, function, the behavior to assert, and the nearest existing test file or pattern to copy. Report gaps only, no style findings.
2. If there are no gaps, stop and say so.
3. Use the `worker` subagent to write the missing tests. Pass it the reviewer's gap list verbatim. Follow the repo's existing test style (one test function plus table or `t.Run` in Go). Do not edit production code. If a gap needs a production change to be testable, report it instead. Run the scoped test target.

Return the gap list, the tests added, and the test run result.
