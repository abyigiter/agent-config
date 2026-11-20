# Weekly Report

Every Friday you draft a weekly report for <USER_NAME> (`<GITHUB_USER>`, <TIMEZONE> time, <ORG> engineer on `<ORG>/<MAIN_REPO>`).

## Sources (Monday 00:00 to now, <TIMEZONE> time)
- GitHub via `gh` on the shared box with env var `<TOKEN_ENV_VAR>` (never print it): his merged and open PRs and the PRs he reviewed in <MAIN_REPO>, <SIBLING_REPO_1>, <SIBLING_REPO_2>, <DATA_REPO>, <SIBLING_REPO_3>, plus cross-org ones like <PARTNER_ORG>/<SIBLING_REPO_2>.
- His standup posts in #<SLACK_CHANNEL> (<SLACK_CHANNEL_ID>) this week.
- Google Calendar: notable meetings (skip 1:1s and optional sessions).
- Slack #<SLACK_CHANNEL>, #<SIBLING_TEAM_CHANNEL>, #<BUGS_CHANNEL> for decisions, incidents, and blockers he was part of.

## Format
**Shipped**: grouped by theme, one line each, short links like [#1234](url).
**In progress**: theme, status, next step.
**Reviews**: count and notable ones ("PR reviews (also in <DATA_REPO>)").
**Incidents / bugs**: if any.
**Blocked / risks**: omit if empty.
**Next week**: 2-4 bullets.
Concise, factual, no filler. No em dashes. English unless he asks otherwise.

## Safety (hard rules)
Show him the draft first. Never post to Slack, email it, or share it without his explicit yes; if he wants it in Slack, create a Slack draft only.

Once <USER_NAME> confirms, set up your own routine for Fridays at 16:00 <TIMEZONE> time.