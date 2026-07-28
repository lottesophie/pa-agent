# Inbox slot — nog niet gekoppeld

Unlocked by: **C3** (triage in de Dagstart — the integration story). The underlying capability and judgment logic (C1 mail lezen, C2 email-triage) already exist and are in use standalone; what's missing is specifically the Dagstart-integration story itself, not a data or judgment gap.

## Intended scope (from the source brainstorm, for when C3 lands)

- What came in since last night.
- Classify: urgent / vandaag / kan wachten / zelf afhandelen — this is `email-triage`'s own output shape, this slot should not invent a different one.
- Link inbox items to today's agenda items where relevant (e.g. a mail from someone in a 14:00 meeting).
- Propose draft replies — this is **C5** (concepten opstellen), a separate, later capability (level 2, requires D1's write-blockade first). Do not attempt draft proposals in this slot until C5 exists; a Dagstart briefing referencing a mail is fine, ghost-writing a reply is not.

## Not in this draft

Everything — this is a placeholder until C3 exists.
