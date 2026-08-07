# index.md — wegwijzer

## First run
If `personal/`, `memory/`, or `config/` don't exist yet, this is a first run (e.g. a fresh clone by a new user) — this is expected, not an error. Create the missing directories empty. Create only the minimal files referenced below when a skill or rule actually needs to write to them for the first time — never pre-fill with example data, template categories, or placeholder answers. A short one-line header explaining "starts empty on purpose, fills in through use" is fine; invented content is not.

## Routing
- Session start: load `CLAUDE.md`.
- Preference questions (cross-skill: diet, meeting times, etc.) → `personal/preferences.md` (fills in over time, not pre-populated).
- Calendar/agenda meaning (which calendar is personal/business/shared) → `personal/preferences.md`.
- Mail-samenvatting (`/check-mail`, betrouwbaarder dan natuurlijke taal — zie Status) → skill `.claude/skills/check-mail/SKILL.md`; kalibratie in `personal/check-mail.md` (vult zich door gebruik, niet vooraf ingevuld).
- Conceptreplies klaarzetten (`/draft-replies`) → skill `.claude/skills/draft-replies/SKILL.md`; kalibratie in `personal/draft-replies.md` (vult zich door gebruik, niet vooraf ingevuld). Verstuurt nooit, alleen concepten.
- `tools.md` (root) is schema only. Actually connected capabilities + their filled-in row → `config/tools.md` (not git-tracked).

## Status
Reset op 6 augustus 2026: persona, routing, first-run bootstrap (`setup`-skill), `check-mail` en nu `draft-replies` staan live. Verder nog niets — geen agenda, geen taken, geen versturen/archiveren/verwijderen/afmelden. Als iets anders gevraagd wordt, zeg plainly dat het er nog niet is, per `CLAUDE.md`'s "Never do"-regel. Niet gokken, geen pad verzinnen naar een skill die hier niet bestaat.

Natuurlijke-taal-triggers zijn niet betrouwbaar gebleken voor skills die iets doen wat Claude ook generiek zou kunnen (mail lezen, concepten maken) — gebruik altijd het schuine-streep-commando (`/check-mail`, `/draft-replies`, `/setup`). Zie `pa-agent-built.md` voor details.
