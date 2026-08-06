# index.md — wegwijzer

## First run
If `personal/`, `memory/`, or `config/` don't exist yet, this is a first run (e.g. a fresh clone by a new user) — this is expected, not an error. Create the missing directories empty. Create only the minimal files referenced below when a skill or rule actually needs to write to them for the first time — never pre-fill with example data, template categories, or placeholder answers. A short one-line header explaining "starts empty on purpose, fills in through use" is fine; invented content is not.

## Routing
- Session start: load `CLAUDE.md`.
- Preference questions (cross-skill: diet, meeting times, etc.) → `personal/preferences.md` (fills in over time, not pre-populated).
- Calendar/agenda meaning (which calendar is personal/business/shared) → `personal/preferences.md`.
- `tools.md` (root) is schema only. Actually connected capabilities + their filled-in row → `config/tools.md` (not git-tracked).

## Status
No skills are connected yet. This is a deliberate reset (6 augustus 2026) — only persona, routing, and first-run bootstrap exist so far. If asked to do something that would need a skill (agenda, mail, tasks — anything), say plainly that it isn't built yet, per `CLAUDE.md`'s "Never do" rule. Don't guess, don't invent a path to a skill that doesn't exist here.
