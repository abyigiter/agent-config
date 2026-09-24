---
name: message
description: >-
  Draft Slack, email, GitHub, or Linear replies in Bugra's voice for copy-paste.
  Use when he asks for a reply, message, Slack draft, "write this", "what should
  I say", or pastes a thread and wants an answer. Always wrap the draft in a
  markdown fence. Slack is chat-typed, not email. No em dashes. Speak as if the
  other person is more senior. Do not use for how the agent talks to Bugra, for
  posting a GitHub review (pr-comment-review), or for fixing review comments
  (fix-pr-comments).
---

# Message

Draft text **Bugra will send**. Not how you talk to him.

He is **Bugra Yigiter** (`abyigiter`). If he pastes a Slack thread, find the speakers. He is Bugra.

## Hard rules

1. **No em dash.** Never write `—` (the long dash, Unicode em dash). Never write `–` (en dash). Never use `--` as a dash. Use a comma, a period, a hyphen `-`, or parentheses.
2. **Simple English.** Short words. Short sentences. One idea each. Max about 15 words. His English is not perfect. Do not polish him into a native C2 speaker.
3. **Copy-paste block.** The reply he will send is always inside one ` ```markdown ` fence. Nothing else belongs in that fence. No "here is a draft".
4. **Talk up.** Write as if the other person is bigger / more senior than him. Respect. Do not lecture. Do not sound sure when he is not. Fine to ask, check, or say "i might be wrong".

Chat outside the fence can be one ADHD line, then the fence. Example:

Copy this.

```markdown
I think this might be the bug. Can you check?
```

## Anti-triggers

- Talking to Bugra in Cursor / Claude / Codex: `i-have-adhd`. Not this skill.
- Post a GitHub review as the reviewer: `pr-comment-review`.
- He is the author and wants comments fixed: `fix-pr-comments`.
- PR description body: follow AGENTS.md PR skeleton. Still no em dash. Still simple English.

## Voice

Casual teammate. Not a document. Not a bot. Not corporate.

- Contractions are good: I'm, don't, it's, that's.
- Direct. No "Hope this helps", "Hey team", "Just circling back", "I wanted to reach out".
- No emoji unless his thread already has them.
- Match the thread language. English stays English. Turkish stays Turkish. Same simple level in both.
- Short. Slack: one or two sentences. Use bullets only if the thread is already a list of steps.
- Do not teach. Do not explain basics they already know.
- Do not fake broken English. Keep grammar readable. Do not add polish.

### Slack typing (default for Slack)

Slack is how he types in chat. Not how he writes a PR.

- Normal sentence case: `Yeah`, `I put`, `I think`. Start sentences with a capital, capitalize `I`. Not all-lowercase, not Title Case.
- Casual words, normal capitalization: `yeah`, `ok`, `btw` (only if he already uses it in that thread).
- Tickers and short names keep their usual form when he would: `USD/USDC/USDT` for a pair. Match the thread.
- One line if it fits. A colon is fine. No Title Case. No comma after `Yeah` unless needed.
- Do not add "that's better" hedging like `Yes, that's better.` or `Updated.`

Canonical Slack agree + done (senior teammate):

```markdown
Yeah it's better. I put the check in the handler so the bad path returns 400.
```

Bad (too formal / stiff):

```markdown
Yes, that's better. I have placed the check in the handler so that the bad path returns 400.
```

### Talk up (bigger person)

Treat the reader as more senior. Humble, not groveling.

Do:
- "I think…"
- "I might be wrong, but…"
- "Can you check…"
- "What do you think?"
- "If this is ok…"
- "I'm not sure, but maybe we can…"

Don't:
- "This is wrong. Do X."
- "You should have…"
- "The correct way is…"
- "Sorry to bother you" / "With all due respect" (too much)

Frontend: he can be a bit more sure, still polite.
Backend / Go: more "I think" and "Can you check". He has about 2 years of backend.

### People

- **Senior backend colleague**: short. Slack typing. No Go basics. Defer on Go style. Ask, don't declare.
- **Manager**: same simple voice. Slack typing. Add status, blocker, or the decision you need, so he does not have to ask again.
- Others: same humble teammate voice.

## Simple English

Prefer: think, check, maybe, because, so, also, still, now, need, can, should, wait, look, try, change, fix, ask, after, before, this, that, yeah, put.

Avoid: leverage, utilize, regarding, subsequently, nevertheless, furthermore, hence, thus, whilst, albeit, facilitate, accordingly, proceed, inquire, commence, "circle back", "loop in", "per my last", "going forward", "synergy".

Bad: "I'd argue we should leverage the existing abstraction, thereby reducing duplication."
Good: "I think we can reuse what we have. That way we don't copy the same code."

Bad: "This approach is incorrect; please implement X instead."
Good: "I think this might not work. Could we try X instead?"

## Channel notes

- **Slack:** chat typing (see above). No tables, no `#` headers. Lead with the point. Reply in the thread if he pasted a thread.
- **GitHub comment he will paste:** still simple. Sentence case is ok here (`I think`). Still one markdown fence. File refs like `[file.go:42](path/file.go#L42)` are ok.
- **Email:** sentence case. Greeting only if the source already has one. Still short.

## Pre-send check

Before you show the fence:

1. Search the draft for `—`, `–`, and `--`. Remove them.
2. Any sentence over ~15 words: split it.
3. Any fancy word: replace it with a common one.
4. Does it sound like he is teaching them? Soften it.
5. Can he copy only the fence and paste? If you added extra talk inside the fence, cut it.
6. Slack only: normal sentence case. Start with a capital, capitalize `I`. Not all-lowercase, not Title Case. No "Updated." / "Done." opener.

## Examples

Slack to a senior backend teammate (agree + what you did):

```markdown
Yeah it's better. I put the check in the handler so the bad path returns 400.
```

Slack to a senior backend teammate (Go question):

```markdown
I think the error handling here might be off, but I could miss something. Can you check if using `err` like this is ok?
```

Slack to a manager (status):

```markdown
API part is done. UI is in progress.
One blocker: I need a decision on the empty state. Keep it hidden, or show a placeholder?
```

PR reply (disagree, still talk up):

```markdown
I might be wrong, but I think this path is already covered in `TestCreate`. Happy to add another case if you still want it.
```

Turkish thread:

```markdown
bence burası yanlış olmuş olabilir, emin değilim. bir bakar mısın?
```
