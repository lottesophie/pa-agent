#!/bin/bash
# MINIMALE DIAGNOSE-VERSIE (6 augustus 2026) — geen jq, geen bestand-reads,
# geen matcher-filter. Doel: alleen vaststellen of SessionStart hooks
# in Cowork überhaupt uitgevoerd worden voor deze plugin. Zodra bevestigd,
# gaat de echte versie (persona + bootstrap) terug.
echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"[DEBUG] SessionStart hook is uitgevoerd. Dit is een vaste teststring — geen bestand gelezen, geen jq gebruikt. Toon deze regel letterlijk als eerste ding in je eerste antwoord."}}'
exit 0
