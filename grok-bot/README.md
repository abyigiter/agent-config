# Grok Bot instructions

Generic copies of the instructions my Grok Bot teammates run on. One file per bot.

Behavior, voice, safety rules, and workflows are the real ones. Only identifiers are swapped for placeholders. The real, exact versions live in `local/grok-bot/` (gitignored, see [Local overlay](../README.md#local-overlay)).

| File | Bot |
|---|---|
| `engineering-manager.md` | Investigates bugs and features, hands implementation to a coding agent |
| `reviewer.md` | PR reviews, drafts the GitHub review |
| `bug-watcher.md` | Bug reports and prod alerts |
| `data-engineer.md` | Data repo, pipelines, ClickHouse / Lightdash / Bruin |
| `chief-of-staff.md` | Daily brief and weekly view |
| `meeting-prep.md` | Meeting one-pagers and notes |
| `standup.md` | Daily standup draft |
| `weekly-report.md` | Friday report draft |
| `sena.md` | Default description, nothing custom |

## Placeholders

| Placeholder | Means |
|---|---|
| `<USER_NAME>` | My name |
| `<GITHUB_USER>` | My GitHub handle |
| `<TIMEZONE>` | My time zone |
| `<LOCAL_LANGUAGE>` | My non-English language |
| `<ORG>` | Employer and its GitHub org |
| `<PARTNER_ORG>` | Another GitHub org some work spans |
| `<MAIN_REPO>` | Main work repo (`<MAIN_REPO>-api` etc. are its services) |
| `<SIBLING_REPO_1>`, `<SIBLING_REPO_2>`, `<SIBLING_REPO_3>` | Sibling work repos |
| `<DATA_REPO>` | Data pipelines repo |
| `<PRODUCT_NAME>` | Main product name |
| `<CONTRACT_IDL>` | API schema language used next to OpenAPI |
| `<SLACK_CHANNEL>`, `<SLACK_CHANNEL_ID>` | Team channel and its ID |
| `<SIBLING_TEAM_CHANNEL>` | Sibling team channel |
| `<BUGS_CHANNEL>`, `<ALERTS_CHANNEL>`, `<PROD_ALERTS_CHANNEL>` | Bug and alert channels |
| `<GRAFANA_URL>` | Grafana Cloud stack |
| `<GRAFANA_PROM_UID>`, `<GRAFANA_LOGS_UID>`, `<GRAFANA_TRACES_UID>` | Prod datasource UIDs (`-stg` / `-dev` suffixes for other envs) |
| `<DASHBOARD_UID>` | App metrics dashboard UID |
| `<MAC_MACHINE_ID>` | My laptop's Grok Bot machine ID |
| `<WORK_DIR>` | Directory on my laptop holding work repos |
| `<TOKEN_ENV_VAR>` | Env var with the work GitHub token |
| `<PERSONAL_TOKEN_ENV_VAR>` | Env var with the personal GitHub token |
| `<COWORKER_NAME_1>`, `<COWORKER_NAME_2>` | Coworkers |
| `<FEATURE_A>`, `<FEATURE_B>`, `<ENTITY>`, `<PR_NUMBER>` | Example values in the standup and reviewer samples |

PR numbers in examples are made up.
