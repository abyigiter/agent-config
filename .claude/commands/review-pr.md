---
description: Review a GitHub PR with subagents. Peer PR -> post a submitted inline review. Own PR (self-review) -> markdown only, nothing posted.
argument-hint: [PR number or URL; defaults to the current branch's PR]
---
Review PR: $ARGUMENTS

Pass `model` on every Agent call: `scout` -> `haiku`, `reviewer` -> `opus`.

1. Resolve the PR yourself (first integer in the arguments, else `gh pr view --json number` for the current branch). Run `gh api user --jq .login` and `gh pr view <N> --json number,title,url,author,state,isDraft,headRefName,headRefOid,baseRefName,headRepository,headRepositoryOwner`. Stop if the PR is closed or merged. **Self-review** means the author login equals your login.
2. Set `TMP=$(git rev-parse --show-toplevel)/tmp/review` and run `gh pr diff <N> --color=never > $TMP/pr-<N>.diff`. If `git rev-parse HEAD` is not `headRefOid`, run `git fetch origin pull/<N>/head` and `git worktree add --detach $TMP/pr-<N>-head FETCH_HEAD`; that directory is the PR code. Otherwise the repo root is. Never check out the PR in the user's working tree.
3. Use the `scout` subagent. Task: read-only recon for reviewing PR #<N>. Give it the PR metadata, the diff path, and the PR code directory. It must load the PR body, all prior reviews, inline comments, and issue comments (`gh api --paginate repos/<owner>/<repo>/pulls/<N>/{reviews,comments}`, `.../issues/<N>/comments`), the repo's review rules (`.codex/review-prompt.md`, `AGENTS.md`, `CLAUDE.md`, matching project skills under `.agents/skills/`), and the callers and tests of the changed code. It returns compressed context with exact paths and lines, plus what other reviewers already raised.
4. Use the `reviewer` subagent. Give it the PR metadata, the diff path, the PR code directory, and the scout's full output. It must read `~/.agents/skills/pr-comment-review/SKILL.md` and follow its review bar and findings JSON (step 4 there). It reviews only lines in the diff, skips points other reviewers already made, and returns the findings JSON plus a one-line verdict.
5. Deliver:
   - **Self-review:** print one copyable ```markdown block with sections Bugs, Design / follow-ups, Nits; clickable refs like `[file.go:42](path/file.go#L42)`; a short rationale per item; a final verdict line. Do NOT post, comment, push, or touch the PR in any way.
   - **Peer review:** follow `~/.agents/skills/pr-comment-review/SKILL.md` steps 4-6 to validate the findings and post one submitted `COMMENT` review.
6. If you created `$TMP/pr-<N>-head`, remove it with `git worktree remove $TMP/pr-<N>-head`.
