#!/bin/bash
# SessionStart hook: injecteert CLAUDE.md + index.md als context, en zet
# personal/, memory/, config/ leeg klaar bij een klant die ze nog niet heeft
# (index.md "First run"-regel — nooit vooraf gevuld).
#
# TIJDELIJK IN DEBUG-MODUS (6 augustus 2026): we weten nog niet zeker of
# CLAUDE_PROJECT_DIR in Cowork naar de echte, gesynchroniseerde projectmap
# wijst. Dit blok maakt zichtbaar wat de hook zag en deed, in plaats van
# stil te falen. Weghalen zodra dat bevestigd is.

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

BOOTSTRAP_LOG=""
for dir in personal memory config; do
  TARGET="${PROJECT_DIR}/${dir}"
  if [ -d "$TARGET" ]; then
    BOOTSTRAP_LOG="${BOOTSTRAP_LOG}
- ${dir}/ bestond al: ${TARGET}"
  else
    ERR=$(mkdir -p "$TARGET" 2>&1)
    if [ -d "$TARGET" ]; then
      BOOTSTRAP_LOG="${BOOTSTRAP_LOG}
- ${dir}/ aangemaakt: ${TARGET}"
    else
      BOOTSTRAP_LOG="${BOOTSTRAP_LOG}
- ${dir}/ AANMAKEN MISLUKT op ${TARGET} — fout: ${ERR:-onbekend}"
    fi
  fi
done

PERSONA=$(cat "${PLUGIN_ROOT}/CLAUDE.md" 2>/dev/null)
ROUTING=$(cat "${PLUGIN_ROOT}/index.md" 2>/dev/null)

DIAGNOSTICS="[DEBUG-INFO — toon dit blok letterlijk en volledig als allereerste ding in je eerste antwoord in deze sessie, vóór al het andere, ongeacht wat de gebruiker typt]
CLAUDE_PLUGIN_ROOT: ${PLUGIN_ROOT:-<leeg>}
CLAUDE_PROJECT_DIR: ${CLAUDE_PROJECT_DIR:-<leeg, hook viel terug op pwd>}
pwd tijdens hook-uitvoering: $(pwd)
Bootstrap-resultaat:${BOOTSTRAP_LOG}
[EINDE DEBUG-INFO]"

CONTEXT="${PERSONA}

${ROUTING}

${DIAGNOSTICS}"

jq -n --arg ctx "$CONTEXT" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
exit 0
