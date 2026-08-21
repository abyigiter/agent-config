---
name: pr-comment-review
description: >-
  Review or re-review a GitHub pull request and post a submitted inline GitHub
  review (not a draft, not a stacked counter-PR). Use when the user asks to
  review a PR and leave/post comments, re-review after new commits, check
  previous findings, "self-review", "self review", "review my PR", "review PR N
  and leave comments", "post comments on the PR", or pastes a GitHub PR URL with
  "leave comments". Skips per-finding triage and draft/stacked delivery prompts.
  Do not use when he is the author asking to check/fix incoming teammate or bot
  reviews (fix-pr-comments). Do not use for working-tree review.
---

# PR comment review

Review a GitHub PR, then **post a submitted inline review**. No triage loop. No draft. No stacked counter-PR.

Bugra's default when he says "review and leave comments", "self-review", or "re-review": do the review and put the comments on the PR.

Self-review uses this same skill and the same bar. Do not go easy because he is the author.

If he says "triage first", "leave as draft", or "open a stacked PR", follow that instead.

## Anti-triggers

- Working-tree / file / commit review: not this skill.
- He is the author and said check review / check PR comments / fix bot or teammate feedback: `fix-pr-comments`.
- Repo `/review N` **without** comment / self-review / re-review wording: use the repo review skill as written, including its checkpoints.

## Defaults (do not ask)

| Choice | Default |
|---|---|
| Delivery | Inline GitHub review comments |
| Event | `COMMENT` (submitted, visible immediately) |
| Summary body | Yes, 1-2 lines, ≤200 chars |
| Per-finding triage | Skip |
| Stacked counter-PR | No |
| PENDING draft | No |
| Self-review | Same as peer review. Post comments. Same severity bar. |

Ask only if the PR is draft, closed, or merged. Default option: Stop.

## Voice

- Peer-level. Blunt. No praise. No "Claude" / "AI" in comments.
- Findings only. No recap after posting.
- No em dashes.
- Severity: `Critical` (correctness, security, data loss), `Important` (conventions, missing tests, perf), `Suggestion` (style, optional cleanup).

## First review vs re-review

After resolving the PR, load prior reviews and inline comments.

```bash
ME=$(gh api user --jq .login)
gh api --paginate "repos/$OWNER/$REPO/pulls/<N>/reviews"
gh api --paginate "repos/$OWNER/$REPO/pulls/<N>/comments"
```

This is a **re-review** if any of these is true:

- The user said re-review, review again, new commits, or check previous findings.
- `ME` already submitted a review on this PR.
- `headRefOid` differs from that last review's `commit_id`.

Otherwise it is a **first review**. Self-review (`ME == AUTHOR`) is still a first review until a review by `ME` exists.

Chat header:

- First, peer: `Reviewing PR #N by @<author>: "<title>"`
- First, self: `Self-review of PR #N (yours): "<title>"`
- Re-review: `Re-review of PR #N since <old-sha-short>: "<title>"`

## Workflow

### 1. Resolve the PR

Parse the first integer from the prompt (strip `#`). One PR only.

```bash
gh auth status
gh api user --jq .login
gh pr view <N> --json number,title,url,author,baseRefName,headRefName,headRefOid,baseRefOid,state,isDraft,isCrossRepository,headRepository,headRepositoryOwner
```

Stop if unauthenticated (`Run gh auth login.`), 404, or empty `headRefOid`.

Store `OWNER` / `REPO` from `headRepositoryOwner.login` and `headRepository.name`. Never assume a default owner or repo.

### 2. Fetch diffs

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
TMP="$REPO_ROOT/tmp/review"
mkdir -p "$TMP"
gh pr diff <N> --color=never > "$TMP/pr-<N>.diff"
```

If `tmp/` is not writable, use `$HOME/tmp/review`. Never `/tmp/claude/`.

Empty full diff → `PR #N has no file diff. Nothing to review.` Stop.

If the full diff is >3000 lines, still review. Mention the size. Do not ask to continue.

On **re-review**, also fetch the incremental diff since the last review by `ME`:

```bash
LAST_SHA=<commit_id of ME's latest review>
gh api "repos/$OWNER/$REPO/compare/${LAST_SHA}...${HEAD_SHA}" --jq .files
```

If `LAST_SHA == HEAD_SHA`, still re-check prior findings against current code. Say head has not moved.

### 3. Review

Read `$REPO_ROOT/.codex/review-prompt.md` if it exists. Else review against `AGENTS.md` / `CLAUDE.md` and any matching project skills (`api`, `sql`, `schema`, `webapps`, `modern-go`).

Also load the PR body and existing conversation so comments are not duplicates of other reviewers.

#### First review

Review the full PR diff. Produce findings JSON (below).

#### Re-review (required checks)

Do both, every time:

1. **Previous findings.** For each inline comment authored by `ME` (top-level, not replies): decide `addressed`, `still-open`, or `obsolete`.
   - Read current code at `HEAD` for that path. Do not trust "resolved" thread state alone.
   - `addressed`: the cited issue is gone.
   - `still-open`: the issue is still present (maybe moved).
   - `obsolete`: file removed, or the hunk no longer exists and the issue cannot be judged.
2. **New regressions.** Review the incremental diff (`LAST_SHA...HEAD`) for new bugs, convention breaks, and incomplete fixes. Then skim the full diff only as needed so a new change is not a false positive against already-reviewed code.

Do not re-post a still-open finding as a new inline comment on the same thread. Reply in-thread instead.

```bash
gh api -X POST "repos/$OWNER/$REPO/pulls/<N>/comments" \
  -f body="<status>" -F in_reply_to=<comment_id>
```

Reply text:

- Addressed: `Addressed in <new-sha-short>.`
- Still open: `Still open on <new-sha-short>. <one-line why>.`
- Obsolete: `Obsolete on <new-sha-short> (hunk gone).`

New findings (regressions or new issues) go in the new review as inline comments, same JSON shape as a first review.

### 4. Findings JSON

Output a JSON array of **new** inline findings only (not in-thread replies):

```json
{
  "path": "relative/path/from/repo/root",
  "line": 42,
  "start_line": 40,
  "side": "RIGHT",
  "severity": "Critical",
  "body": "**Critical:** …",
  "suggestion": "exact replacement code"
}
```

Rules:

- `path` must appear in the diff being commented (full diff on first review; incremental or full on re-review, whichever hunk contains the line).
- `line` must be in a changed hunk (`+` or context for RIGHT; `-` or context for LEFT).
- `start_line` only for multi-line spans (`start_line < line`, same hunk, same side).
- `body` markdown, lead with `**<Severity>:**`. No echoing the diff.
- `suggestion` only for a concrete in-place replacement. No triple backticks inside it. Omit it if applying the suggestion would duplicate neighboring lines.

Drop invalid findings.

First review, none remain: `No actionable findings on PR #N.` Stop. Do not post an empty review.

Re-review, no new inline findings: still post a submitted review **body** that reports addressed / still-open / obsolete / new counts. That is the re-review artifact.

### 5. Show, then post

Print a short list in chat (severity, path:line, first paragraph). On re-review, print the prior-finding tally first:

```
Prior: <a> addressed, <s> still open, <o> obsolete
New: <n> findings
```

Then post in the same turn. Do not wait for "post" / "triage" / delivery mode.

Review body:

- First review: 1-2 lines, ≤200 chars, no severity counts, no "This PR…".
- Re-review: 1-2 lines that include the tally, ≤200 chars. Example: `Re-review of abc1234. 3 prior findings addressed, 1 still open. 2 new issues on the incremental diff.`

Build `$TMP/pr-<N>.review.json`:

```json
{
  "commit_id": "<HEAD_SHA>",
  "body": "<summary>",
  "event": "COMMENT",
  "comments": []
}
```

`comments` holds only **new** inline findings. Include `start_line` / `start_side` only on multi-line comments. Append the suggestion fence only when `suggestion` is present. Do not double the `**<Severity>:**` prefix if `body` already has it.

Post in-thread replies **before** the new review so the review body can mention them.

```bash
gh api -X POST "repos/$OWNER/$REPO/pulls/<N>/reviews" \
  --input "$TMP/pr-<N>.review.json"
```

Success, one line then stop:

`Submitted review with N comments: <html_url>`

On re-review, `N` is new inline comments. In-thread replies are extra and already on the PR.

### 6. Errors

- HTTP 422 "Position is invalid": head moved. Re-fetch the diff, re-validate, post again. Tell the user the SHA changed.
- Other non-2xx: print the response. Stop. No retries except one 5xx with 2s backoff.
- Rate limit 403: print reset time. Stop.
