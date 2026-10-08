---
description: Address every review comment on your PR with subagents. Scout collects comments, planner triages, worker fixes.
---
Fix review comments on PR: $@

1. Resolve the PR yourself (first integer in the arguments, else the current branch's PR). Run `gh pr view <N> --json number,title,url,author,state,headRefName,headRefOid,headRepository,headRepositoryOwner`. Stop and ask if the current branch is not `headRefName`, the working tree is dirty, or the PR is closed or merged.
2. Launch this workflow: put it in your reply as a ```js workflow fenced block and call `subagent({ workflow: true, async: true })` in the same reply. Fill PR (number, url, owner/repo, headRefOid) as a JS string. If the tool says the block is missing, write the script to `$(git rev-parse --show-toplevel)/tmp/review/fix-pr-<N>.js` and pass that absolute path as `workflow` instead.

```js workflow
const PR = "<metadata>";
const SKILL = "~/.agents/skills/fix-pr-comments/SKILL.md";
const comments = await runs.run("scout", { agent: "scout", task: "Collect every review comment on this PR, exactly as listed in 'What to load' in " + SKILL + " (inline comments, reviews, issue comments, GraphQL review threads with resolved/outdated state). Do not edit files.\nPR: " + PR + "\nFor each comment return author, comment id, path:line, full body, and the current code at that location. Label comments by abyigiter as the author's own notes." });
const plan = await runs.run("triage", { agent: "planner", task: "Read " + SKILL + " and apply its 'Decide per comment' rules to these comments. Return a deduped numbered checklist, each item marked fix / add-test / disagree (with a 1-2 sentence reply) / ask (with why), with exact files and the concrete change for every fix and add-test item. Start with: N comments, M distinct issues, K to fix, D disagree, A ask.\n\nComments:\n" + comments.output });
const fix = await runs.run("fix", { agent: "worker", task: "Implement only the fix and add-test items from this checklist. Skip disagree and ask items. Edit only what those items need, run the repo's scoped lint, type-check and tests (Makefile first). Do not commit or push.\n\nChecklist:\n" + plan.output });
return { checklist: plan.output, report: fix.output };
```

3. When the workflow completes: print the checklist, then the worker report.
4. Reply in-thread on the disagree items only (`gh api -X POST repos/<owner>/<repo>/pulls/<N>/comments -f body=... -F in_reply_to=<id>`). Ask the user about every ask item; do not guess.
5. Commit only if the arguments include `commit` (a new follow-up commit, never amend). Push only if they include `push`. Report what landed, what you pushed back on, and what is waiting on the user.
