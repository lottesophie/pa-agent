# index.md — wegwijzer

## First run
If `personal/`, `memory/`, or `config/` don't exist yet, this is a first run (e.g. a fresh clone by a new user) — this is expected, not an error. Create the missing directories empty. Create only the minimal files referenced below when a skill or rule actually needs to write to them for the first time — never pre-fill with example data, template categories, or placeholder answers. A short one-line header explaining "starts empty on purpose, fills in through use" is fine; invented content is not.

## Routing
- Session start: load `CLAUDE.md`.
- Preference questions (cross-skill: diet, meeting times, etc.) → `personal/preferences.md` (fills in over time, not pre-populated).
- Calendar/agenda meaning (which calendar is personal/business/shared) → `personal/preferences.md`.
- Agenda overview / briefing request ("what does my day/week look like", "hoe ziet mijn dag eruit") → skill `.claude/skills/agenda-briefing/SKILL.md`; its personal calibration lives in `personal/agenda-briefing.md` (fills in over time, not pre-populated). Pattern: each skill with its own personalization gets one line here pointing to its `personal/<skill-name>.md`. This is for a specific, narrow ask about the agenda itself — not for opening the day.
- Dagstart request — the opening-the-day moment, triggered only by an explicit "start mijn dagstart" (not a plain "goedemorgen" — that greeting is reserved for a different agent in this account, see `dagstart`'s `SKILL.md`) → skill `.claude/skills/dagstart/SKILL.md`; its personal calibration lives in `personal/dagstart.md`. Currently a thin wrapper around `agenda-briefing`, but the moment is meant to grow into much more (mail, taken, context).
- Inbox triage request ("what's in my mail", "what needs a reply", "sort my inbox") → skill `.claude/skills/email-triage/SKILL.md`; its personal calibration lives in `personal/email-triage.md` (fills in over time, not pre-populated).
- `tools.md` (root) is schema only. Actually connected capabilities + their filled-in row → `config/tools.md` (not git-tracked).
- (Later stories) Daily Start → also `memory/handoff.md`, `memory/open-loops.md`.
