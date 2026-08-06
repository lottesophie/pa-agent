# Extern slot — nog niet gekoppeld

Unlocked by: **"dagcontext-extern" (weer/reisstoringen)** — sits in the takencatalogus in the backlog, no story number yet. Do not build against this slot until it has its own capability-story (its own `config/tools.md` row) and a separate content-story — capability and content are always two stories in this repo, never one.

## Intended scope (from the source brainstorm)

- Weer.
- Reisinfo (file/vertraging) relevant to today's physical-location appointments — this reads the Agenda slot's travel-time flags, it doesn't duplicate that logic.
- Relevant news about work or today's conversation partners.
- Birthdays/anniversaries of contacts — this one **is** already covered elsewhere: "stakeholder-onderhoud" in the takencatalogus (verjaardagen, mijlpalen, contactmomenten signaleren). Don't build a second birthday-check here once that exists; this slot should call it, not reimplement it.

## Not in this draft

Everything — no capability exists for weather, traffic, or news. This is the one slot with no existing MCP/tool candidate identified at all; figuring out what would even provide this data is part of its own future capability-story, not something to guess at here.
