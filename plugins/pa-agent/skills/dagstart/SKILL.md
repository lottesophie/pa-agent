---
name: dagstart
description: The Dagstart moment — the ritual that opens the day, currently a thin wrapper around agenda-briefing with room for more sources to plug in later (inbox, tasks, contact context, external context, look-ahead), eventually a much bigger ritual than the agenda alone. Triggers only on an explicit "start mijn dagstart" (or "start dagstart") — not on a plain "goedemorgen", which is reserved for a different agent in this account and would otherwise collide. A specific, narrow "hoe ziet mijn dag eruit" / "how does my day look" is agenda-briefing's trigger instead.
---

# Dagstart

Read-only orchestrator (autonomy level 1): gathers output from sub-skills, does not interpret on their behalf, and never creates/modifies/declines anything itself. Ends in proposals, never actions — same rule as every sub-skill it calls.

Story pa-8 (Agenda since pa-5, Inbox since pa-8). Still deliberately thin: only Agenda and Inbox are connected. Every other slot is a placeholder that says so explicitly rather than being silently skipped — see the table below and `sections/`.

## Design principle

One skill = one source or one type of operation. If a candidate skill name needs "and" to describe it, it is probably two skills. This is why Dagstart is not one monolithic skill: a source can fail (mail down, Notion unreachable) without breaking the whole briefing, and each source is independently testable/reusable outside the morning context.

## Pipeline

For every connected slot: **fetch → enrich (attach context) → analyze (conflicts/gaps/priorities) → summarize in a fixed structure → end in proposals/questions.**

This orchestrator does not implement the pipeline itself — each sub-skill implements its own pipeline for its own source. The orchestrator's job is only: call each connected sub-skill, collect its output, and assemble the fixed presentation structure below.

## Slot structure

Each slot below is either **actief** (a real sub-skill exists and gets called) or **nog niet gekoppeld** (no sub-skill exists yet — say so explicitly in the output, never silently omit the section). Never fake content for an unconnected slot.

| Slot | Sub-skill file | Status | Unlocked by |
|---|---|---|---|
| Agenda | `sections/agenda.md` | **actief** | already exists — pa-4 (`agenda-briefing`) |
| Inbox | `sections/inbox.md` | **actief** | already exists — pa-7 (`email-triage`), wired here by pa-8 |
| Taken | `sections/taken.md` | nog niet gekoppeld | G1 (Notion uitlezen, backlog) |
| Contact-context | `sections/contact.md` | nog niet gekoppeld | "briefings voorbereiden" (takencatalogus, nog geen story) + `personal/stakeholders.md` |
| Extern | `sections/extern.md` | nog niet gekoppeld | "dagcontext-extern" (takencatalogus, nog geen story) |
| Vooruitkijken | `sections/vooruitkijken.md` | nog niet gekoppeld, maar lowest-effort — see note in section file | mostly reuses pa-4's existing 7-day outline window |

See each file in `sections/` for what that sub-skill will do once it exists, and exactly which story unlocks it.

## Step 1 — Open

Short opening line that frames the moment — not a generic greeting, a signal that this is the day's orientation point (e.g. "Goedemorgen, hier is je dag."). One sentence, no filler.

## Step 2 — Call connected sub-skills

For each slot marked **actief**, invoke that sub-skill (via the Skill tool, e.g. `agenda-briefing`, `email-triage`) and take its output as-is. Never reimplement a sub-skill's interpretation logic inside the orchestrator — if something is wrong with a slot's content, that is a bug in the sub-skill, not here.

For each slot marked **nog niet gekoppeld**, do not attempt to fill it and do not mention it in the output by default — an empty-placeholder line for every unbuilt slot would make the briefing worse than `agenda-briefing` alone, which the klaar-criterium explicitly rules out. Only name an unconnected slot if the user asks about that source directly (e.g. "wat staat er in mijn mail" while only Agenda is wired up) — then say plainly "Nog niet gekoppeld: <slot>", no invented content.

## Step 3 — Assemble

Fixed presentation order for whichever slots are actief: Agenda → Contact-context → Inbox → Taken → Extern → Vooruitkijken. (Rationale: what's happening today, who's involved, what needs a response, what's outstanding, what's around it, what's coming — roughly the order a person would want to orient.) Today that order reduces to Agenda → Inbox.

If the combined output gets too long to stay scannable, shorten — pa-8 explicitly allowed this. Prefer shortening `email-triage`'s per-message summaries to one line each over dropping content outright; never silently drop a message or an agenda item to save space.

## Step 4 — Propose, never just report

The briefing must end in concrete decision points the PA is waiting on ("wil je dat ik de 14:00 verzet?"), not a flat report. This rule belongs to the orchestrator's presentation layer as well as to each sub-skill — a sub-skill proposes about its own source, the orchestrator does not invent cross-source proposals it has no basis for.

## Step 5 — Present

- Scannable summary at the top, details on request — same pattern as `agenda-briefing` Step 6.
- Output language and tone: follow `CLAUDE.md` (Dutch, informal "je"), not this file.
- Tone/filtering preferences (what gets reported, how short, what may be handled autonomously without asking) belong in `personal/dagstart.md` — starts empty, fills organically. See "Learning from corrections" below.

## Learning from corrections

Same pattern as every other skill in this repo: a correction to the framing/opening/assembly logic (this file) is structural — fix it here directly. A correction to tone, phrasing, or what to open with is calibration — goes in `personal/dagstart.md`. Both happen immediately, the moment a correction occurs — no separate evaluation phase, no tracked log. The git history of this file and of `personal/dagstart.md` is the log.

## Not in this skill

- New entries in `config/tools.md` — this file connects nothing new.
- New interpretation logic for any source — that belongs to the source's own skill (e.g. agenda interpretation is `agenda-briefing`'s job, not this file's).
