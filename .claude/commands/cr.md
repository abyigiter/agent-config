---
description: Wraps the built-in /code-review and always posts inline PR comments (adds --comment). Named cr so it does not shadow code-review.
argument-hint: [level] [PR number, branch, or path]
---
Call the Skill tool with skill `code-review` and args `$ARGUMENTS --comment`. Do nothing else first.

When posting to GitHub, post ALL findings as ONE review, never one comment per call:
`POST repos/{owner}/{repo}/pulls/{pr}/reviews` with `commit_id` (PR head SHA), `event: "COMMENT"`, a structured `body` (format below), and a `comments` array (`path`, `line`, `side: "RIGHT"`, `body` each). Build the JSON in a scratchpad file and send it with `gh api ... --input <file>`. Do not use `pulls/{pr}/comments` or the per-comment inline tool: each of those calls creates its own review.

Review `body` format (markdown, only the sections that apply, in this order). Never mention the effort level, flags, model, or finding counts like "4 important, 10 nits":

```
**Overall**
- 1-3 bullets: is the approach sound, and what is the main risk.

**Must fix (N)**
- What breaks and when, with the file ref (`file.ts:59`). One bullet per blocking finding.

**Should fix (N)**
- Real issues that are not blocking, with file refs.

**Nits (N)**
- One line each, or "N minor style nits inline" if they are all trivial.

**Tests**
- What is untested that matters. Omit if nothing.

**CI:** status of checks, and name any failed or cancelled one.
```

Get CI status with `gh pr checks <pr> --repo {owner}/{repo}`. Every bullet in the body must match an inline comment, and the section counts must match the `comments` array. Details live in the inline comments, the body only summarizes.
