# index.md — wegwijzer

## First run
If `personal/`, `memory/`, or `config/` don't exist yet, this is a first run (e.g. a fresh clone by a new user) — this is expected, not an error. Create the missing directories empty. Create only the minimal files referenced below when a skill or rule actually needs to write to them for the first time — never pre-fill with example data, template categories, or placeholder answers. A short one-line header explaining "starts empty on purpose, fills in through use" is fine; invented content is not.

## Routing
- Session start: load `CLAUDE.md`.
- Preference questions (cross-skill: diet, meeting times, etc.) → `personal/preferences.md` (fills in over time, not pre-populated).
- Calendar/agenda meaning (which calendar is personal/business/shared) → `personal/preferences.md`.
- Agenda overview / briefing request ("what does my day/week look like") → skill `.claude/skills/agenda-briefing/SKILL.md`; its personal calibration lives in `personal/agenda-briefing.md` (fills in over time, not pre-populated). Pattern: each skill with its own personalization gets one line here pointing to its `personal/<skill-name>.md`.
- `tools.md` (root) is schema only. Actually connected capabilities + their filled-in row → `config/tools.md` (not git-tracked).
- (Later stories) Daily Start → also `memory/handoff.md`, `memory/open-loops.md`.
