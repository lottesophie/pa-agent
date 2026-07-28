# Agenda slot — actief

Status: already real. This slot does **not** get its own sub-skill file — it delegates entirely to the existing `agenda-briefing` skill (`.claude/skills/agenda-briefing/SKILL.md`, story B2).

Step 2 of `dagstart`'s `SKILL.md` simply invokes `agenda-briefing` via the Skill tool and takes its output as the Agenda slot content, unmodified. No logic is duplicated here.

Functional scope this slot already covers (from B2, do not redesign): conflict/double-booking signaling, travel-time context, prep-time flagging (as a question, e.g. "plan ik 9:30 in om je voor te bereiden?"), missing-info detection (no location/video link/agenda), and priority marking of today's most important appointment.

Nothing to build for this slot. It stays a pointer.
