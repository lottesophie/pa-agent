# Inbox slot — actief

Status: already real (story pa-8). This slot does **not** get its own sub-skill logic — it delegates entirely to the existing `email-triage` skill (`.claude/skills/email-triage/SKILL.md`, story pa-7).

Step 2 of `dagstart`'s `SKILL.md` simply invokes `email-triage` via the Skill tool and takes its output as the Inbox slot content, unmodified. No classification logic is duplicated here.

Functional scope this slot already covers (from pa-7, do not redesign): action-required/for-info/ignorable/spam-suspected classification, per-message content summary, urgency signals, phishing/spoofing safety check, unsubscribe-suggestion for recurring automated senders.

If the combined Agenda + Inbox output gets too long, shorten `email-triage`'s per-message summaries first (one line each) rather than cutting agenda content or dropping a message — see `dagstart`'s `SKILL.md` Step 3.

## Not in this slot

- Draft replies — that's **pa-11** (concepten opstellen), separate, later, pa-12-gated. A Dagstart briefing referencing a mail is fine, ghost-writing a reply is not.
- Linking inbox items to today's agenda items — real value, but a genuine cross-source correlation the orchestrator itself would have to do (neither sub-skill has both datasets). Not built yet; flagged here so it doesn't get silently forgotten, not assumed available.
