---
description: Fix something on your own PR. pr-fixer (Sonnet 5.5) makes the fix you describe, then a new follow-up commit lands. Push only on `push`.
---
Fix on PR: $@

1. Split the arguments: an optional leading PR number or URL, an optional trailing `push`, and the rest is the fix request. No fix request: ask for one and stop.
2. Resolve the PR: `gh pr view <arg> --json number,title,url,state,headRefName,headRefOid,baseRefName`. Stop and ask if the current branch is not `headRefName`, `git rev-parse HEAD` is not `headRefOid` (pull first), the working tree is dirty, or the PR is closed or merged.
3. Launch this workflow: put it in your reply as a ```js workflow fenced block and call `subagent({ workflow: true })` in the same reply. Fill PR (`"#<N> <title> <url> base <baseRefName>"`) and FIX (the fix request verbatim) as JSON string literals. If the tool says the block is missing, write the script to `$HOME/tmp/fix-pr/<N>-workflow.js` (mkdir first) and pass that absolute path as `workflow` instead.

```js workflow
const PR = "<metadata>";
const FIX = "<fix request>";
return runs.run("fix", { agent: "pr-fixer", task: "PR: " + PR + "\n\nFix requested by the PR author:\n" + FIX });
```

4. If pr-fixer stopped or changed nothing, relay why and stop.
5. Read `git diff`. If it strays from the request, say so and stop without committing. Otherwise stage only the files it listed and make a new commit (never amend) with a conventional message for the fix.
6. Push only if the arguments include `push`. Report the fix, checks run, the commit sha, and whether it was pushed.
