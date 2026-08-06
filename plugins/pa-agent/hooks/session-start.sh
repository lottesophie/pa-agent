#!/bin/bash
# SessionStart hook: injecteert CLAUDE.md + index.md als context, en zet
# personal/, memory/, config/ leeg klaar bij een klant die ze nog niet heeft
# (index.md "First run"-regel — nooit vooraf gevuld).

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

for dir in personal memory config; do
  if [ ! -d "${PROJECT_DIR}/${dir}" ]; then
    mkdir -p "${PROJECT_DIR}/${dir}" 2>/dev/null
  fi
done

PERSONA=$(cat "${PLUGIN_ROOT}/CLAUDE.md" 2>/dev/null)
ROUTING=$(cat "${PLUGIN_ROOT}/index.md" 2>/dev/null)

CONTEXT="${PERSONA}

${ROUTING}"

jq -n --arg ctx "$CONTEXT" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
exit 0
