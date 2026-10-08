---
description: Address every review comment on your PR with subagents. Scout collects comments, planner triages, worker fixes.
argument-hint: [PR number or URL; defaults to the current branch's PR] [commit] [push]
---
Fix review comments on PR: $ARGUMENTS

Pass `model` on every Agent call: `scout` -> `haiku`, `planner` -> `opus`, `worker` -> `sonnet`.

1. Resolve the PR yourself (first integer in the arguments, else the current branch's PR). Run `gh pr view <N> --json number,title,url,author,state,headRefName,headRefOid,headRepository,headRepositoryOwner`. Stop and ask if the current branch is not `headRefName`, the working tree is dirty, or the PR is closed or merged.
2. Use the `scout` subagent. Task: collect every review comment on PR #<N>, exactly as listed in "What to load" in `~/.agents/skills/fix-pr-comments/SKILL.md` (inline comments, reviews, issue comments, and GraphQL review threads with resolved and outdated state). For each comment, return the author, comment id, path:line, the full body, and the current code at that location. Comments by `abyigiter` are the author's own notes: keep them, but label them.
3. Use the `planner` subagent. Give it the scout's full output. It must read `~/.agents/skills/fix-pr-comments/SKILL.md` and follow its "Decide per comment" rules. It returns a deduped, numbered checklist, each item marked fix / add-test / disagree (with a 1-2 sentence reply) / ask (with why), with exact files and the concrete change for every fix and add-test item.
4. Print the checklist, led by `N comments, M distinct issues, K to fix, D disagree, A ask.`
5. Use the `worker` subagent. Give it the fix and add-test items verbatim. It edits only what those items need, runs the repo's scoped lint, type-check, and tests (Makefile first), and does not commit or push.
6. Reply in-thread on the disagree items only (`gh api -X POST repos/<owner>/<repo>/pulls/<N>/comments -f body=... -F in_reply_to=<id>`). Ask the user about every ask item; do not guess.
7. Commit only if the arguments include `commit` (a new follow-up commit, never amend). Push only if they include `push`. Report what landed, what you pushed back on, and what is waiting on the user.
