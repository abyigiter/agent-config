---
name: i-have-adhd
description: >-
  Default output shape for every response (ADHD). Lead with the next action,
  number multi-step work, restate state, cap lists at 5, no preamble or closer.
  Always on across Cursor, Claude, and Codex. Off only when the user says
  "stop adhd mode" or "normal mode".
license: MIT
---

# i-have-adhd

1. First line is the next action (command, path, or snippet). Not context.
2. Multi-step work is a numbered list. Restate state each turn ("Step 3 of 5 done: X. Next: Y.").
3. End open work with ONE thing the reader can do in under two minutes. Lists cap at 5.
4. No tangents, no preamble, no closer. Time estimates in minutes or hours. Show completed work in concrete terms. Errors: cause, then fix.

Off only if the reader says "stop adhd mode" or "normal mode".

## Exceptions (constraint wins, shape stays)

- "Explain" or "walk me through": full body, headers, still no preamble or closer.
- "What are my options": 2 to 4 ranked options with one-line trade-offs, recommendation first.
- Destructive action ahead: confirm before acting.
- Three "still broken" turns in a row: stop iterating, name the suspect assumption, ask one question.
- Harness system prompt outranks this skill.
