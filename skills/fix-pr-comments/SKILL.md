---
name: fix-pr-comments
description: >-
  Address GitHub review comments on the user's PR as the author. Use when the
  user says check review, check PR comments, check reviews on PR N, fix
  feedback, address nits, bot comments, Claude review, Copilot, or
  pastes a teammate/bot review thread. Read every human and bot comment. Always
  fix easy nits and easy test gaps. Do not defer small work. New follow-up
  commit (no amend), scoped Make, no CI polling. Do not use for posting a
  review (pr-comment-review) or for new feature work.
---

# Fix PR comments

Bugra is the author. Check **every** review. Teammates and bots count the same. Easy nits and easy test gaps always land. Do not defer small work.

## Anti-triggers

- Posting a review (he is the reviewer): `pr-comment-review`.
- Self-review of his own PR to find new issues: `pr-comment-review`.
- New feature work unrelated to the thread: `development` / `implement-feature`.

"Check review on PR N" / "check PR comments" is this skill, not `pr-comment-review`.

## Defaults (do not ask)

| Choice | Default |
|---|---|
| Who | Every comment: humans, bots, resolved threads, outdated hunks, review bodies, issue comments. |
| Bots | Same bar as teammates. Do not skip because it is Claude, Copilot, Bugbot, Cursor, or Actions. |
| Nits | Always fix if it is easy. Not a product change. |
| Test gaps | Always add if the case is small and the harness already exists. |
| Defer | No, unless it is actually hard or a product decision. Ask; do not TODO it. |
| Duplicates | Fix once. Do not implement the same nit three times. |
| His comments | `abyigiter` is his own note, not a reviewer. Still follow it if it is an instruction. |
| Commit | New follow-up commit. No amend. Commit only if he asked. |
| Extra work | None beyond the comments. No adjacent refactors. |
| Checks | Fast, scoped Make (`development`). |
| CI | Do not poll. |

## What to load

```bash
gh pr view <N> --json number,title,url,author,headRefName,headRefOid
gh api --paginate "repos/$OWNER/$REPO/pulls/<N>/comments"
gh api --paginate "repos/$OWNER/$REPO/pulls/<N>/reviews"
gh api --paginate "repos/$OWNER/$REPO/issues/<N>/comments"
```

Also pull review threads (resolved vs open, outdated):

```bash
gh api graphql -f query='
query($o:String!,$n:String!,$p:Int!){
  repository(owner:$o,name:$n){
    pullRequest(number:$p){
      reviewThreads(first:100){
        nodes{ isResolved isOutdated path
          comments(first:20){ nodes{ databaseId author{login} body } } }
      }
    }
  }
}' -F o=$OWNER -F n=$REPO -F p=<N>
```

Do not stop at the first review. Do not skip resolved or outdated until you have judged the code at HEAD.

Bots you will see (not an allowlist, not skippable): `claude[bot]`, `copilot-pull-request-reviewer`, `github-actions[bot]`, Cursor bots, Bugbot, CodeQL comments that are review notes.

## Decide per comment

Judge the **current code**, not the comment's age.

| Kind | Do |
|---|---|
| Easy nit (name, import, comment, one-liner, obvious convention) | Always fix. |
| Easy test gap (one case, existing `StartServer` / Vitest harness, the branch is in this PR) | Always add. |
| Bug, convention break, missing check | Always fix. |
| Same point from two reviewers | Fix once. |
| Wrong, stale, or already fixed | Reply why. No code change. |
| Product / scope / another team | Ask him. Do not guess. |
| Hard (new design, large rewrite, new infra) | Ask. Name why it is hard. Do not bury a TODO. |

**Easy** means about 15 minutes or less, no new architecture, no new test harness.

A missing test for logic this PR already added is easy. Do not call it follow-up.

Do not argue with cheap nits. If the suggestion is harmless and local, take it.

## Workflow

1. Resolve the PR number. Load every source above.
2. Build a checklist of distinct issues (dedupe bots + humans).
3. Print the list in chat: fix / add-test / disagree / ask. Then start fixing. Do not wait for triage unless something is **ask**.
4. Edit only what those items require. Follow `development`.
5. Run scoped Make for touched packages.
6. Reply on threads that asked a question or that you disagreed with. Skip "done" spam on a pile of nits unless he asked to reply.
7. Commit if he asked. Push if he asked. Give the PR URL. Stop.

Disagree reply: one or two sentences, why the code stays. No essay.

## Chat

Lead with the count: `N comments, M distinct issues, K to fix, D disagree, A ask.`

Number the distinct issues. Afterward: what landed, what you pushed back on, anything still waiting on him. One next action.
