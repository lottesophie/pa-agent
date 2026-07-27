---
name: dagstart
description: DRAFT — not active. Orchestrates the morning briefing across multiple sources (agenda, inbox, tasks, contact context, external context, look-ahead). Use when the user asks for their full morning briefing/Dagstart, not just the agenda.
---

# Dagstart (DRAFT — not active)

> **Status: draft, not an installed skill.** This file lives in `planning/drafts/dagstart/` on purpose, not in `.claude/skills/`, so it does not appear in the skill listing and cannot be invoked. It will not be promoted (moved to `.claude/skills/dagstart/SKILL.md`) until B2's done-criterion is met — see `planning/pa-agent-plan.md` story B3 and `memory/project_status.md`. Until then this is a design document, not behavior.
>
> Written after a Fable-assisted design session (2026-07-27) that worked out the full functional scope and sub-skill decomposition ahead of when it's needed, so nothing gets lost. Filling in each section below still waits for that section's own capability + content stories (see per-section notes).

Read-only orchestrator (autonomy level 1): gathers output from sub-skills, does not interpret on their behalf, and never creates/modifies/declines anything itself. Ends in proposals, never actions — same rule as every sub-skill it calls.

## Design principle

One skill = one source or one type of operation. If a candidate skill name needs "and" to describe it, it is probably two skills. This is why Dagstart is not one monolithic skill: a source can fail (mail down, Notion unreachable) without breaking the whole briefing, and each source is independently testable/reusable outside the morning context.

## Pipeline

For every connected slot: **fetch → enrich (attach context) → analyze (conflicts/gaps/priorities) → summarize in a fixed structure → end in proposals/questions.**

This orchestrator does not implement the pipeline itself — each sub-skill implements its own pipeline for its own source. The orchestrator's job is only: call each connected sub-skill, collect its output, and assemble the fixed presentation structure below.

## Slot structure

Each slot below is either **actief** (a real sub-skill exists and gets called) or **nog niet gekoppeld** (no sub-skill exists yet — say so explicitly in the output, never silently omit the section). Never fake content for an unconnected slot.

| Slot | Sub-skill file | Status | Unlocked by |
|---|---|---|---|
| Agenda | `sections/agenda.md` | **actief** | already exists — B2 (`agenda-briefing`) |
| Inbox | `sections/inbox.md` | nog niet gekoppeld | C1 (mail lezen) + C2 (triage als inhoud) |
| Taken | `sections/taken.md` | nog niet gekoppeld | F1 (Notion uitlezen) |
| Contact-context | `sections/contact.md` | nog niet gekoppeld | blok H (briefings voorbereiden) + `personal/stakeholders.md` |
| Extern | `sections/extern.md` | nog niet gekoppeld | **new** — not yet in the task catalog, see note in section file |
| Vooruitkijken | `sections/vooruitkijken.md` | nog niet gekoppeld, maar lowest-effort — see note in section file | mostly reuses B2's existing 7-day outline window |

See each file in `sections/` for what that sub-skill will do once it exists, and exactly which story unlocks it.

## Step 1 — Call connected sub-skills

For each slot marked **actief**, invoke that sub-skill (via the Skill tool where the sub-skill is itself a registered skill, e.g. `agenda-briefing`) and take its output as-is. Never reimplement a sub-skill's interpretation logic inside the orchestrator — if something is wrong with a slot's content, that is a bug in the sub-skill, not here.

For each slot marked **nog niet gekoppeld**, do not attempt to fill it. State plainly in the output: "Nog niet gekoppeld: <slot>." No invented content, no partial guess.

## Step 2 — Assemble

Fixed presentation order: Agenda → Contact-context → Inbox → Taken → Extern → Vooruitkijken. (Rationale: what's happening today, who's involved, what needs a response, what's outstanding, what's around it, what's coming — roughly the order a person would want to orient.)

## Step 3 — Propose, never just report

Per design principle (from the source brainstorm): the briefing must end in concrete decision points the PA is waiting on ("wil je dat ik de 14:00 verzet?"), not a flat report. This rule belongs to the orchestrator's presentation layer as well as to each sub-skill — a sub-skill proposes about its own source, the orchestrator does not invent cross-source proposals it has no basis for.

## Step 4 — Present

- Scannable summary at the top, details on request — same pattern as `agenda-briefing` Step 6.
- Output language and tone: follow `CLAUDE.md` (Dutch, informal "je"), not this file.
- Tone/filtering preferences (what gets reported, how short, what may be handled autonomously without asking) belong in `personal/dagstart.md` once this skill is real — do not pre-fill that file now.

## Not in this draft

- Actually calling any sub-skill other than `agenda-briefing` — they don't exist yet.
- New entries in `tools.md` — this file connects nothing.
- Deciding the exact wording of the "nog niet gekoppeld" message — that's a two-minute decision to make when this gets promoted, not worth freezing now.
