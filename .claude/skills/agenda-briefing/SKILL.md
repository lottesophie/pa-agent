---
name: agenda-briefing
description: Produce a readable calendar overview (briefing) with priorities, flagged problems, and proposals. Use when the user asks for their agenda, day or week overview, what their day/week looks like, or a briefing of upcoming appointments.
---

# Agenda briefing

Read-only skill (autonomy level 1): gather, interpret, and present — never create, modify, or decline anything. All actions beyond presenting are phrased as proposals to the user.

## Before you start

1. Read `personal/agenda-briefing.md` (personal preferences for this skill). Treat "file doesn't exist" the same as "file is empty" — this is expected on a first run and is not an error. If it is empty, missing, or missing a topic, apply the defaults below and **state the assumption explicitly** in the briefing.
2. Capability needed: calendar read. Which server provides it: see `config/tools.md`. Do not reference any provider by name in your output.
3. Which calendar means what (personal/business/shared): see `personal/preferences.md`.

## Step 1 — Gather

- Window: default **today + tomorrow in detail, rest of the coming 7 days as outline** (preference: window).
- Per event: time, title, location or video link, attendees, status (confirmed/tentative), recurring or one-off, attachments/description if present.
- Do not silently drop events you cannot interpret — list them and say what is unclear.

## Step 2 — Structure

- Chronological, grouped per day (day briefing: morning/afternoon).
- Distinguish hard (confirmed) from soft (tentative/optional) appointments.

## Step 3 — Flag problems

Check for, and report only what is actually found:

- Overfull days: back-to-back meetings without breathing room (default threshold: no gap of ≥15 min between consecutive meetings for 3+ hours).
- Missing lunch/break window (default: no free slot of ≥30 min between 12:00–14:00).
- Travel time: this is **standing context for every event with a physical location, not just a conflict check**. You always have to get there from wherever you currently are — a big gap before an event doesn't make the question irrelevant, it just makes the answer "comfortable" instead of "tight". For every physical-location event, briefly state whether travel is accounted for (an explicit travel/buffer block exists), looks comfortable (large gap to the previous location-bearing commitment), or is tight/unaccounted (short or no gap after another physical location, or the preceding event's location is unknown). There is no maps/travel-time capability connected, so never invent a duration or distance — only reason about gaps between calendar entries.
- **Don't assume "has a conferenceUrl" means "no travel needed".** If the title suggests a physical activity (coffee, lunch, dinner, drinks, walk, etc.) and there is no explicit location, a conferenceUrl does not resolve the ambiguity — flag it explicitly ("is this online or in person?") instead of silently treating it as online and skipping the travel-time check.
- Double bookings and conflicts.
- Events without a clear purpose: check **every event**, not only the obviously empty ones. A title alone is not automatically clear — judge whether a reader with no other context could tell what the appointment is for from title + location + description together. If not, say so, even if a title is present.
- Unanswered invitations that require a response.

Overlap note: this skill **signals** hygiene issues (missing travel time, bad titles); fixing them belongs to a future agenda-hygiene skill, not here.

## Step 4 — Prioritize and interpret

- Mark what is important. Default signals: explicit markers, one-on-ones, external parties, one-off over recurring. Personal priority rules override defaults (preference: priority rules).
- Note, per day, what needs preparation before it starts — every event with an external party, no prior context, or an attachment/description worth reading is a candidate. State only that prep may be needed and why (e.g. "external party, no prior context known") — never invent what the preparation should contain. What the prep actually *is* (mail thread, meeting history) belongs to a future briefing-preparation skill, not here — this skill only flags the need.
- Changes since the previous briefing (new/moved/cancelled): only report if you can actually determine this. There is no memory between sessions yet — if unknown, say nothing about changes rather than guessing.

## Step 5 — Propose, never act

- Overfull day → phrase it as a question, e.g. "Do you want me to suggest moving X?" — never as an action.
- Never modify the calendar. The connected capability is read-only; keep it that way in behavior as well.

## Step 6 — Present

- Scannable summary at the top (3–5 lines), details per day below.
- Output language and tone: follow `CLAUDE.md` (Dutch, informal "je"), not this file.
- State every assumption made due to missing preferences at the bottom, briefly.

## Learning from corrections

This is permanent behavior, not a one-time calibration phase — the skill keeps learning for as long as it runs. When the user corrects the briefing (wrong priority, too much/little detail, wrong order, something unwanted included or missing):

1. Ask, if needed, one short question to make the underlying preference explicit.
2. Record the learned preference as one line in `personal/agenda-briefing.md` — only what was actually learned, never pre-filled templates or empty placeholder categories.
3. Preferences that clearly apply beyond this skill (tone → `personal/style-guide.md`, who people are → `personal/stakeholders.md`, calendar meanings → `personal/preferences.md`) go to those files instead — do not duplicate them here.

Known preference topics to listen for (checklist, not a form to fill): timing & frequency, window, form & length, what counts as "too full", lunch/break guarding, focus blocks, priority rules, autonomy, tone, what to exclude, signal threshold.
