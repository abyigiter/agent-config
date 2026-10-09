---
description: Fix something on your own PR. pr-fixer (Sonnet 5.5) makes the fix you describe, then a new follow-up commit lands. Push only on `push`.
argument-hint: [PR number or URL; defaults to the current branch's PR] <what to fix> [push]
---
Fix on PR: $ARGUMENTS

Pass `model` on every Agent call: `pr-fixer` -> `sonnet`.

1. Split the arguments: an optional leading PR number or URL, an optional trailing `push`, and the rest is the fix request. No fix request: ask for one and stop.
2. Resolve the PR: `gh pr view <arg> --json number,title,url,state,headRefName,headRefOid,baseRefName`. Stop and ask if the current branch is not `headRefName`, `git rev-parse HEAD` is not `headRefOid` (pull first), the working tree is dirty, or the PR is closed or merged.
3. Use the `pr-fixer` subagent. Give it the PR number, title, url, base branch, and the fix request verbatim.
4. If it stopped or changed nothing, relay why and stop.
5. Read `git diff`. If it strays from the request, say so and stop without committing. Otherwise stage only the files it listed and make a new commit (never amend) with a conventional message for the fix.
6. Push only if the arguments include `push`. Report the fix, checks run, the commit sha, and whether it was pushed.
