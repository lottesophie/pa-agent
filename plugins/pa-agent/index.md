# index.md — wegwijzer

## First run
If `personal/`, `memory/`, or `config/` don't exist yet, this is a first run (e.g. a fresh clone by a new user) — this is expected, not an error. Create the missing directories empty. Create only the minimal files referenced below when a skill or rule actually needs to write to them for the first time — never pre-fill with example data, template categories, or placeholder answers. A short one-line header explaining "starts empty on purpose, fills in through use" is fine; invented content is not.

## Routing
- Session start: load `CLAUDE.md`.
- Preference questions (cross-skill: diet, meeting times, etc.) → `personal/preferences.md` (fills in over time, not pre-populated).
- Calendar/agenda meaning (which calendar is personal/business/shared) → `personal/preferences.md`.
- Mail-samenvatting ("check mijn mail", "wat staat er in mijn inbox") → skill `.claude/skills/check-mail/SKILL.md`; kalibratie in `personal/check-mail.md` (vult zich door gebruik, niet vooraf ingevuld).
- `tools.md` (root) is schema only. Actually connected capabilities + their filled-in row → `config/tools.md` (not git-tracked).

## Status
Reset op 6 augustus 2026: alleen persona, routing, first-run bootstrap (`setup`-skill) en nu `check-mail` staan live. Verder nog niets — geen agenda, geen taken, geen acties op mail. Als iets anders gevraagd wordt, zeg plainly dat het er nog niet is, per `CLAUDE.md`'s "Never do"-regel. Niet gokken, geen pad verzinnen naar een skill die hier niet bestaat.
