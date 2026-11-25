---
description: Wraps the built-in /code-review and always posts inline PR comments (adds --comment). Named cr so it does not shadow code-review.
argument-hint: [level] [PR number, branch, or path]
---
Call the Skill tool with skill `code-review` and args `$ARGUMENTS --comment`. Do nothing else first.

When posting to GitHub, post ALL findings as ONE review, never one comment per call:
`POST repos/{owner}/{repo}/pulls/{pr}/reviews` with `commit_id` (PR head SHA), `event: "COMMENT"`, a one-line `body`, and a `comments` array (`path`, `line`, `side: "RIGHT"`, `body` each). Build the JSON in a scratchpad file and send it with `gh api ... --input <file>`. Do not use `pulls/{pr}/comments` or the per-comment inline tool: each of those calls creates its own review.
