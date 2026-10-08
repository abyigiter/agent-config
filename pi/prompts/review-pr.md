---
description: Review a GitHub PR with subagents. Peer PR -> post a submitted inline review. Own PR (self-review) -> markdown only, nothing posted.
---
Review PR: $@

1. Resolve the PR yourself (first integer in the arguments, else `gh pr view --json number` for the current branch). Run `gh api user --jq .login` and `gh pr view <N> --json number,title,url,author,state,isDraft,headRefName,headRefOid,baseRefName,headRepository,headRepositoryOwner`. Stop if the PR is closed or merged. **Self-review** means the author login equals your login.
2. Set `TMP=$(git rev-parse --show-toplevel)/tmp/review` and run `gh pr diff <N> --color=never > $TMP/pr-<N>.diff`. If `git rev-parse HEAD` is not `headRefOid`, run `git fetch origin pull/<N>/head` and `git worktree add --detach $TMP/pr-<N>-head FETCH_HEAD`; that directory is the PR code. Otherwise the repo root is. Never check out the PR in the user's working tree.
3. Launch this workflow: put it in your reply as a ```js workflow fenced block and call `subagent({ workflow: true, async: true })` in the same reply. Fill PR (number, title, url, author, headRefOid, owner/repo), DIFF (absolute path) and CODE (absolute path) as JS strings. If the tool says the block is missing, write the script to `$TMP/review-pr-<N>.js` and pass that absolute path as `workflow` instead.

```js workflow
const PR = "<metadata>", DIFF = "<diff path>", CODE = "<pr code dir>";
const ctx = await runs.run("scout", { agent: "scout", task: "Read-only recon for reviewing this PR. Do not edit files.\nPR: " + PR + "\nDiff: " + DIFF + "\nPR code: " + CODE + "\nLoad the PR body, all prior reviews, inline comments and issue comments (gh api --paginate repos/<owner>/<repo>/pulls/<N>/reviews, .../pulls/<N>/comments, .../issues/<N>/comments), the repo review rules (.codex/review-prompt.md, AGENTS.md, CLAUDE.md, matching .agents/skills/*), and the callers and tests of the changed code. Return compressed context with exact paths and lines, plus what other reviewers already raised." });
return runs.run("review", { agent: "reviewer", task: "Review this PR. Read ~/.agents/skills/pr-comment-review/SKILL.md and follow its review bar and findings JSON (step 4). Review only lines in the diff and skip points other reviewers already made. Do not edit files.\nPR: " + PR + "\nDiff: " + DIFF + "\nPR code: " + CODE + "\n\nScout context:\n" + ctx.output + "\n\nReturn the findings JSON and a one-line verdict." });
```

4. When the workflow completes, deliver:
   - **Self-review:** print one copyable ```markdown block with sections Bugs, Design / follow-ups, Nits; clickable refs like `[file.go:42](path/file.go#L42)`; a short rationale per item; a final verdict line. Do NOT post, comment, push, or touch the PR in any way.
   - **Peer review:** follow `~/.agents/skills/pr-comment-review/SKILL.md` steps 4-6 to validate the findings and post one submitted `COMMENT` review.
5. If you created `$TMP/pr-<N>-head`, remove it with `git worktree remove $TMP/pr-<N>-head`.
