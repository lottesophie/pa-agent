# Vooruitkijken slot — nog niet gekoppeld, maar lowest-effort

Unlocked by: mostly nothing new. `agenda-briefing` (B2) already fetches "today + tomorrow in detail, rest of the coming 7 days as outline" (Step 1 — Gather). This slot is largely a second pass of interpretation over data the Agenda slot already has, not a new data source.

## Intended scope (from the source brainstorm)

- Flag what later this week needs prep (e.g. "donderdag presentatie — wil je daar vandaag tijd voor blokken?").
- Flag what must be decided/sent today so something else can proceed later.

## Open design question for whoever builds this (not decided now)

Because this reuses Agenda-slot data rather than fetching anything new, it's worth asking at build time whether "vooruitkijken" should really be a **sixth sub-skill**, or whether it's better folded into `agenda-briefing` itself as a deeper read of the 7-day outline it already gathers — the "one skill = one source" rule (see orchestrator `SKILL.md`) argues for folding it in, since there's no separate source here, only a separate interpretation pass. Left open rather than pre-decided, since it doesn't block anything else in this draft.

## Not in this draft

The actual look-ahead interpretation logic — not written, whichever shape it ends up taking.
