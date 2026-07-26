# Plan: PA-agent in Claude Code
> Contextbestand voor vervolgstappen. Bevat het volledige plan + takenlijst + openstaande uitzoekpunten. Versie 6 — laatst bijgewerkt: 26 juli 2026
> 
> Wijzigingen t.o.v. v5: A1 en A2 gemarkeerd als afgerond (✅), met bij elk wat daadwerkelijk gebouwd en getest is in plaats van (alleen) wat gepland was — inclusief een routing-bug die pas bij het testen van A2 aan het licht kwam en is gefixt. Rest van het document doorgenomen op consistentie met deze wijzigingen: geen verdere aanpassingen nodig, alles sluit nog aan.
## 1. Visie
Een persoonlijke assistent-agent die gradueel groeit: begint met één taak onder volledige goedkeuring, breidt uit in taken én autonomie. De PA is meer dan een takenlijst — een poortwachter met eigen grondhouding, geheugen en protocollen.
Bijkomend uitgangspunt: dit wordt mogelijk later een product voor anderen. Dat verandert nu niets aan de bouwvolgorde, maar wel aan een handvol scheidingen die gratis zijn als je ze vanaf dag één maakt en duur worden als je ze later inhaalt. Zie §9.
## 2. Architectuur
Vuistregel:
- Is het **contextuele kennis / werkwijze** → skill (laag 2)
- Is het een **delegatiegrens / zware leestaak** → subagent
- Is het **altijd-geldende richtlijn** → kort in de persona-laag (laag 1)
- Moet een regel **afgedwongen** worden → weglaten van de tool, anders hooks/permissions (laag 4)
De vierde laag staat bewust achteraan in de roadmap. Reden: zolang er geen schrijf- of verstuurtool verbonden is, borg je "de PA verstuurt niets" niet door hem te blokkeren maar door hem niet te verbinden. Geen tool = niets te omzeilen. Hooks worden noodzakelijk zodra er tools aanwezig zijn die écht kunnen schrijven of versturen.
### Laag 1 — Persona & grondhouding
Geldt altijd, over alle taken heen:
- **Poortwachter**: filter tussen buitenwereld en executive. Criteria: `personal/stakeholders.md` (bekende contacten) en `personal/escalation.md` (crisisdefinitie, altijd-doorverbinden-lijst). Zolang `escalation.md` leeg is, valt niets onder crisis (§5).
- **Stem & stijlgids**: standaard tekenen als PA ("namens..."); tekenen als executive alleen na expliciete instructie per geval — nooit default, want een bericht namens de executive is zelf al een vorm van toezegging. Hard verbod op toezeggingen namens de executive (financieel, speeches, commitments). Toon en formulering: zie `personal/style-guide.md`.
- **Discretie**: nooit agenda-inhoud of redenen naar derden laten doorschemeren ("dat moment lukt niet" i.p.v. "hij heeft dan een overleg").
- **Eigen grenzen**: aannames altijd melden, onzekerheid benoemen. "Checken" betekent hier: vastleggen en inbrengen bij het eerstvolgende batch-moment — niet direct navragen bij de gebruiker (zie volgende bullet).
- **Standaardregel bij twijfel**: **noteren-en-wachten**. De PA legt de twijfel vast en brengt hem in bij het volgende batch-moment; hij onderbreekt niet en gokt niet. Alleen wat onder de crisis-definitie valt (§5) doorbreekt dit — en zolang die definitie leeg is, is er geen uitzondering.
- **Follow-up discipline**: niets valt op de grond; alle toezeggingen worden bewaakt.
- **Briefing-denken**: elke afspraak krijgt context (wie, historie, open punten, doel).
- **Uitvoertaal**: één expliciete regel voor het gesprek met de gebruiker, hier en nergens anders (§9.6): altijd Nederlands, informeel "je". Externe correspondentie volgt de toon uit `personal/style-guide.md` in plaats van deze regel — formeel Nederlands, Engels, of ander hangt af van de ontvanger.
Deze laag is gesplitst in twee bestanden (zie §6 en §9): `CLAUDE.md` bevat het generieke PA-gedrag hierboven; alles wat over de gebruiker persoonlijk gaat — toon, stijlgids, persoonlijke grenzen — staat in `personal/`.
Let op: dit zijn _richtlijnen_, geen _garanties_. Wat écht nooit mag gebeuren, moet ook technisch onmogelijk zijn — eerst door de tool weg te laten, later door laag 4.
### Laag 2 — Taken (skills)
Elke taak = een skill met expliciet: autonomieniveau, benodigde **capability** (niet: benodigde tool), bijbehorend protocol, en welk model/subagent de taak uitvoert. Startpunt: de Dagstart. Volledige takencatalogus: §7.
**Skills noemen geen providers.** Een skill beschrijft de intentie — "inbox triëren", "beschikbaarheid zoeken", "concept opstellen" — en verwijst naar een capability. Welke MCP-server die capability uitvoert staat op één plek: `tools.md` (§6). Zonder deze regel zit "Gmail" over tientallen skills verspreid en is Microsoft-support later een herschrijving.
**Skills noemen ook geen taal.** Ze beschrijven wát er moet gebeuren, niet in welke taal het antwoord komt. Zie de taalconventie in §6 en §9.6.
### Laag 3 — Geheugen & context
Externe tools (agenda, mail, Notion) = werkomgeving; repo-bestanden = geheugen van de PA. Drie bronnen:
1. **Repo-markdown** (handmatig gecureerd, §6) — de bewuste, controleerbare kennis
2. **Auto-memory** — Claude Code werkt tijdens sessies zelf geheugen bij; periodiek reviewen en waardevolle inzichten promoveren naar repo-markdown
3. **Subagent-memory** — subagents kunnen eigen kennis opbouwen over sessies heen
Aandachtspunt bij lokaal draaien: er is geen continu proces dat state vasthoudt tussen runs. De sessie-overdracht is daarmee geen nice-to-have maar de plek waar de continuïteit leeft.
### Laag 4 — Handhaving (hooks & permissions), vanaf story D1
Deterministische grenzen, onafhankelijk van wat het model "wil". Komen aan de orde **vóórdat** de eerste schrijf-capability wordt verbonden — story D1, vóór agendabeheer (E1):
- **PreToolUse-hooks** blokkeren verboden acties technisch
- **Permissions** per tool: lezen vs. schrijven vs. versturen
- Autonomieniveaus (§4) worden hiermee een _technische garantie_: promotie van een taak = permissie/hook aanpassen
- Optioneel: hooks voor sessie-start (context laden) en sessie-einde (overdracht wegschrijven)
Tot en met story C5 volstaat: alleen lees- en concept-capabilities verbonden, plus een deny-list voor de zekerheid. Niveau 1 en 2 zijn dan een eigenschap van de omgeving, niet van een regel. Vanaf de agenda kan dat niet meer, omdat een agenda geen concept-variant heeft: je maakt de afspraak of niet.
### Doorsnijdend: subagents & model-routing
- Zware leestaken (volledige inbox, lange stukken) → subagent met eigen contextvenster; alleen de samenvatting komt terug in de hoofdsessie (houdt context klein én goedkoop)
- Model per taak: Haiku voor triage/classificatie, Sonnet voor briefings en concepten, zwaarder model alleen voor complexe afwegingen
## 3. Het ritme
|Moment|Inhoud|
|---|---|
|**Dagstart** (10–15 min)|Prioriteiten, wijzigingen, urgente acties + stemmingscheck + inbox-verwerking ronde 1|
|**Middagcheck** (optioneel)|Inbox-verwerking ronde 2, tussentijdse escalaties|
|**Weekafsluiting**|Agenda komende weken opschonen, reisschema's checken, knelpunten oplossen + **evaluatie-loop**: wat ging goed/fout, welke regel/protocol/permissie passen we aan?|
Dit ritme is het einddoel, niet het startpunt. In de eerste stories bestaat alleen de Dagstart; de Middagcheck en de Weekafsluiting komen pas als er genoeg taken zijn om te batchen (respectievelijk na C3 en in G1).
**Realiteitscheck scheduling:** de aanname is dat scheduling in Claude Code bestaat (scheduled agents). Dit is niet geverifieerd tegen actuele documentatie en staat als open punt 1. "Continu" blijft onrealistisch; vaste batch-momenten zijn het doel.
**Gemiste runs zijn de norm, niet de uitzondering.** Lokaal draaien betekent: laptop dicht om 7:30 = geen Dagstart. De Dagstart-skill mag daarom niet uitgaan van "de vorige run was 24 uur geleden", maar moet zelf vaststellen hoe lang het sinds de laatste overdracht is en het venster daarop aanpassen. Idem voor de inbox-triage: geen vaste periode, maar "alles sinds het laatste verwerkte punt".
## 4. Autonomieniveaus
Per skill vastgelegd, per taak te "promoveren".
|Niveau|Gedrag|Borging t/m C5|Borging vanaf D1|
|---|---|---|---|
|1|Alleen voorstellen doen|Schrijf-capabilities niet verbonden|Alle schrijf-/verstuuracties geblokkeerd|
|2|Uitvoeren ná goedkeuring|Alleen concept-capabilities verbonden|Acties vereisen expliciete bevestiging|
|3|Uitvoeren, achteraf rapporteren|—|Acties toegestaan, rapportageplicht in skill|
|4|Volledig zelfstandig|—|Acties toegestaan|
Laag 4 wordt niet verplicht bij niveau 3, maar bij de eerste verbonden **schrijf**-capability — in deze roadmap story E1. Daarom staat D1 ervóór. Tot dat moment is de omgeving zelf de garantie.
## 5. Escalatieprotocol
- Definitie van "crisis" (concreet: wat rechtvaardigt storen tijdens overleg?) — _open, punt 12; wordt gesloten in story E2_
- Vaste lijst: wie mag altijd door, wie wordt resoluut afgehouden — _idem_
- **Standaardregel bij twijfel**: noteren-en-wachten (vastgesteld)
- Alles wat geen crisis is → wacht tot Dagstart/Middagcheck
- **Interim (zolang `escalation.md` leeg is)**: niets telt als crisis, alles volgt noteren-en-wachten. Dit is zelf de tijdelijke crisis-definitie, geen gat.
## 6. Geheugen & documentatie
**Drie lagen, drie behandelingen.** Dit is een vaste indeling, niet iets wat per story opnieuw ter discussie staat:
- **Project/plan** — dit document zelf (`planning/pa-agent-plan.md`). Documentatie óver het project, geen instructie áán de agent (zie taalconventie hieronder) — de agent leest dit nooit automatisch tijdens gebruik. Git-tracked, puur voor de versiegeschiedenis van het plan.
- **De agent zelf (productizable)** — `CLAUDE.md`, `index.md`, `tools.md` (het schema, niet de ingevulde rijen), `protocols/`, `config/` (structuur/sjabloon). Het herbruikbare deel: wat je 1-op-1 aan een andere gebruiker zou geven als dit ooit een product wordt (§1, §9).
- **Persoonlijke context** — `personal/`, `memory/`, en de daadwerkelijk ingevulde waarden in `config/` en `tools.md`. Groeit alleen over tijd door gebruik (§ "Zachte data" hieronder), hoort niet in git, en gaat nooit mee als de agent-laag ooit gedupliceerd of aan iemand anders gegeven wordt.

Praktisch gevolg van die derde bullet: als dit ooit richting een ander soort interface gaat dan Claude Code (chatvenster, eigen app — zie open punt 8/23), is dit de scheidslijn die bepaalt wat er mee moet migreren (persoonlijke context) en wat er opnieuw as-is kan worden neergezet (de agent-laag).

**Structuur**, met generiek en persoonlijk gescheiden:
```
planning/
  pa-agent-plan.md          dit document — project/plan, buiten de agent-runtime
CLAUDE.md                  generieke PA-persona (productiseerbaar)
tools.md                   capability → MCP-server + rechten (start leeg)
config/                    machine-specifiek: paden, accounts, env
index.md                   wegwijzer: welk bestand wanneer inladen
protocols/                 per proces (generiek waar mogelijk)
personal/
  preferences.md
  style-guide.md           ⚑ inhoud in het Nederlands
  stakeholders.md
  escalation.md
memory/
  open-loops.md            context bij follow-ups (géén takenlijst)
  decisions-actions.md
  handoff.md               state tussen sessies
  log/                     stemming, geleerde regels
```
**Git-historie:** `personal/`, `memory/` en de daadwerkelijk ingevulde waarden in `config/` zijn persoonlijke context, geen product — die worden vanaf story A2 bewust buiten git gehouden (`.gitignore`), zodat het herbruikbare deel van de repo (`CLAUDE.md`, `index.md`, `tools.md`-schema, `protocols/`) altijd schoon te dupliceren is zonder eerst iemands persoonlijke data uit de geschiedenis te moeten strippen.
### Taalconventie
Bestands- en mapnamen, skill-namen, capability-namen en **alle instructietekst zijn Engels**. Drie redenen: Claude Code's eigen conventies zijn Engels (`CLAUDE.md`, `.claude/skills/`, hooks, `settings.json`) en een mix wordt bij elke padverwijzing irritant; namen blijven zonder diacritica en spaties, dus git- en URL-veilig; en instructievolging in het Engels is marginaal betrouwbaarder, terwijl elk prompt-patroon dat je online tegenkomt al Engels is.
Nederlands blijft alleen waar de taal zélf de instructie is:
- **Toonvoorbeelden en standaardformuleringen** in `personal/style-guide.md`. Je kunt niet in het Engels "informal but not familiar" opschrijven en hopen dat de je/u-keuze goed uitpakt. Dit zijn feitelijk few-shot-voorbeelden in de doeltaal.
- **Domeintermen die letterlijk moeten**: btw, factuur, functietitels, namen van vaste overleggen.
- **Waarden die tegen bestaande bronnen matchen**: Gmail-labelnamen, Notion-propertynamen. Die zijn wat ze zijn.
Vuistregel: **Engelse container, Nederlandse inhoud waar de vorm de inhoud is.**
Dit plandocument valt buiten de conventie. Het is documentatie _over_ het project, geen instructie _aan_ de agent — die twee mogen uit elkaar lopen.
### `tools.md` — de abstractielaag
Per capability: welke server, welke rechten, sinds welke story verbonden, welk autonomieniveau.
**Dit bestand begint leeg.** Een rij wordt toegevoegd op het moment dat een taak de capability nodig heeft en hij daadwerkelijk verbonden wordt — niet vooruit, als plan. `tools.md` beschrijft wat er ís, de roadmap (§8) beschrijft wat er komt. Die twee mag je niet door elkaar laten lopen: zodra `tools.md` voornemens bevat, is het geen betrouwbaar permissions-overzicht meer.
|Capability|Server|Rechten|Verbonden sinds|Niveau|
|---|---|---|---|---|
|_(leeg)_|||||
Kolomdefinities:
- **Capability** — intentie, providerloos: "mail lezen", "beschikbaarheid zoeken", "concept opstellen"
- **Server** — de MCP-server die hem nu uitvoert; het enige veld dat verandert bij een providerwissel
- **Rechten** — lezen / concept / schrijven / versturen, zo fijnmazig als de server toelaat
- **Verbonden sinds** — welke story; maakt achteraf traceerbaar waarom iets er is
- **Niveau** — autonomieniveau uit §4, als data (§9.5)
Dit is tegelijk het permissions-overzicht voor laag 4. Een taak promoveren = één rij aanpassen.
### Bron van waarheid voor taken: Notion
Eén richting van autoriteit:
- **Notion** = de takenlijst. Wat de gebruiker ziet en aanpast is leidend. Visueel inzichtelijk buiten de agent om.
- **Repo** = het geheugen: waarom iets belangrijk is, wat is toegezegd, wie wacht erop. Verwijst naar Notion-items via ID en **dupliceert ze nooit**.
Gevolg voor `open-loops.md`: de open lus zelf is een Notion-item; het bestand bevat alleen de context die niet in een Notion-veld past (voorgeschiedenis, gevoeligheden, wat er eerder is geprobeerd). Het is expliciet géén tweede takenlijst — en dat wordt getest in story F2, niet alleen hier opgeschreven.
### Categorieën
|Categorie|Elementen|Let op|
|---|---|---|
|Processen & logistiek|Reisboekingen, onkosten, onboarding, VIP-ontvangst|Als herbruikbare protocollen|
|Persoonlijke voorkeuren|Dieet, restaurants, stoelen, vergadertijden, koffie|→ `personal/`|
|Netwerk & stakeholders|Verjaardagen, partners/kinderen, beslissingsbevoegdheid, informele macht|Groeit organisch via evaluatie-loop|
|Vergaderingen|Besluiten, actiepunten, backlog|Actiepunten → Notion; context → repo|
|Administratie & toegang|**Alleen verwijzingen** ("paspoort → 1Password item X")|⚠️ Nooit de data zelf in de agent-context|
**Zachte data:** niet vooraf bedenken maar vastleggen zodra het zich voordoet — stemming via de dagelijkse check, ongeschreven regels via het logboek, timing-inschattingen via het escalatieprotocol. Auto-memory vangt hier een deel van op; wekelijks reviewen bij de Weekafsluiting.
## 7. Takencatalogus
Elke taak wordt t.z.t. een skill met eigen autonomieniveau. ✅ = in roadmap (§8); de rest volgt in blok H.
### Agenda & planning
1. **Dagstart** ✅ — dagoverzicht: prioriteiten, wijzigingen, urgente acties, stemmingscheck
2. **Agendabeheer** ✅ — afspraken inplannen/verzetten/annuleren; conflicten signaleren
3. **Vergaderverzoeken afhandelen** ✅ — inkomende verzoeken beoordelen (poortwachter), tijdvoorstellen doen
4. **Focus-/bufferblokken bewaken** ✅ — reistijd, pauzes en werkblokken beschermen
5. **Weekafsluiting** ✅ — komende weken opschonen, knelpunten oplossen, evaluatie-loop
### Communicatie
6. **Inbox-verwerking** ✅ — triëren: urgent/actie/lezen/archief; concepten voorstellen
7. **Conceptmails opstellen** ✅ — antwoorden in de juiste stem (als PA of als executive), ter goedkeuring
8. **Follow-up & takenbeheer** ✅ — onbeantwoorde mails en toezeggingen najagen; Notion als bron van waarheid synchroon houden, deadlines bewaken, context in `open-loops.md` _(samenvoeging van de eerdere taken 8 en 22, die op dezelfde bron landen)_
9. **Afwezigheidscommunicatie** — out-of-office, doorverwijzingen, verwachtingsmanagement
### Vergaderingen
10. **Briefings voorbereiden** — per afspraak: wie, historie, open punten, doel
11. **Vergaderoutput verwerken** ✅ — besluiten/actiepunten vastleggen (actiepunten → Notion, context → `decisions-actions.md`)
12. **Agenda's opstellen** — agendapunten verzamelen en rondsturen voor terugkerende overleggen
### Reizen & logistiek
13. **Reisplanning** — opties voorstellen conform voorkeuren; boeken bij hoger autonomieniveau
14. **Reisschema's samenstellen** — itinerary met tijden, adressen, contactpersonen, buffers
15. **Onkosten** — bonnetjes verzamelen, declaraties voorbereiden
### Netwerk & relaties
16. **Stakeholder-onderhoud** — verjaardagen, mijlpalen, contactmomenten signaleren
17. **Cadeaus & attenties** — voorstellen bij gelegenheden, conform budget en smaak
18. **Introducties & doorverwijzingen** — warme introducties opstellen
### Informatie & voorbereiding
19. **Monitoring/nieuwssamenvatting** — sector, concurrenten, genoemde namen
20. **Research op verzoek** — achtergrond over personen/bedrijven vóór een gesprek
21. **Documenten voorbereiden** — stukken verzamelen en klaarzetten vóór overleggen
### Taken & projecten
22. **Delegatie-tracking** — wat is bij wie belegd, wanneer terugkoppeling verwacht
23. **Herinneringen** — persoonlijk (tandarts, verlengingen) en zakelijk (deadlines, rapportages)
### Persoonlijk
24. **Restaurant-/lunchreserveringen** — conform voorkeuren en dieet
25. **Privé-agenda afstemmen** — gezin en werk niet laten botsen (discretie!)
## 8. Roadmap als user stories
Vier regels die de ordening bepalen:
1. **Eén nieuw ding per story.** Óf een capability verbinden, óf een skill toevoegen, óf een niveau promoveren. Nooit twee.
2. **Capability en gebruik zijn aparte stories.** Eerst verbinden en de ruwe data bekijken, dan pas een skill eromheen. Zo weet je bij slechte output altijd aan welke kant het zit.
3. **Elke story heeft een inhoudelijk klaar-criterium.** Niet "het werkt", maar "de output is goed genoeg dat ik hem zou gebruiken".
4. **Evalueren is geen fase.** Het is het acceptatiecriterium van iedere story. De Weekafsluiting formaliseert later alleen wat je al doet.
Stories die op elkaar wachten omdat er _materiaal_ moet ontstaan (stijlgids, escalatielijst) staan expliciet zo genoteerd. Dat is geen vertraging maar de reden dat die open punten open staan.
### A — Fundament
**✅ A1. Persona staat.** Als gebruiker wil ik dat de PA weet wie hij is en waar zijn grenzen liggen, zodat al het volgende daarop kan bouwen.
→ **Gedaan:** repo aangemaakt; `CLAUDE.md` bevat rol (poortwachter, criteria volgen later), stem & stijl (PA tekent, executive alleen na expliciete instructie, hard verbod op toezeggingen), discretie, eigen grenzen + de noteren-en-wachten-regel uit §5 (inclusief "zolang `escalation.md` leeg is, geen uitzondering"), follow-up-discipline, briefing-denken en uitvoertaal (Nederlands, je-vorm). `index.md` als wegwijzer aangemaakt, `tools.md` leeg, `config/` aangemaakt en gescheiden (leeg, niet git-tracked).
→ **Extra t.o.v. de oorspronkelijke scope:** een expliciete "Never do"-regel in `CLAUDE.md` toegevoegd — nooit bestandspaden of verwijzingen noemen die niet bestaan. Kwam uit een eerdere versie die te ver vooruitwees naar nog niet gebouwde bestanden; sindsdien bewaakt deze regel dat CLAUDE.md alleen dekt wat er werkelijk is.
→ **Getoetst:** in een lege sessie gevraagd "wie ben je, wat mag je niet, wat doe je bij twijfel" — antwoord kwam overeen met §1 en §5. Nul capabilities verbonden.
→ Niet hierin gedaan, zoals gepland: skills, tools, geheugen.
**✅ A2. De wegwijzer werkt.** Als gebruiker wil ik dat de PA het juiste bestand inlaadt op het juiste moment, zodat de context klein blijft.
→ **Gedaan:** `personal/preferences.md` aangemaakt, `memory/` en `protocols/` aangelegd (leeg, zelfde behandeling als `config/`). `index.md` bijgewerkt: de preferences-regel is niet langer "(later, once populated)" maar actief. Daarna `personal/` en `memory/` uit git-tracking gehaald (`.gitignore`) — persoonlijke context krijgt bewust geen git-historie, zie §6.
→ **Afwijking t.o.v. de letterlijke spec, bewust gekozen:** `preferences.md` is niet gevuld met verzonnen voorbeeldvoorkeuren en ook niet met een lege categorieën-template. In plaats daarvan staat er een korte, echte conventie-notitie (wat dit bestand is, dat het vult tijdens gebruik). Reden: de gebruiker wil voorkeuren laten ontstaan door daadwerkelijk gebruik, niet vooraf verzinnen of laten dicteren — dit is het "Zachte data"-principe uit §6 letterlijk toegepast, niet alleen opgeschreven.
→ **Bug gevonden én gefixt tijdens het testen:** de wegwijzer werkte aanvankelijk niet. `index.md` werd door niets aangeroepen — Claude Code laadt bij sessiestart automatisch alleen `CLAUDE.md`, dus de routing had geen ingang. Op het eerste zicht leek de bestandsstructuur correct, maar in een losse testsessie ("hoe laat vergader ik het liefst?") werd alleen de (lege) auto-memory gecheckt, nooit `index.md` of `preferences.md`. Gefixt met één regel in `CLAUDE.md`: "lees bij sessiestart ook `index.md`".
→ **Getoetst na de fix:** een geïsoleerde subagent kreeg dezelfde vraag en moest zijn Read-calls rapporteren. Las nu `CLAUDE.md` → `personal/preferences.md` → `index.md` (en, als kleine overshoot, ook het lege `tools.md`) — en gaf eerlijk aan het niet te weten in plaats van te gokken.
→ Niet hierin gedaan, zoals gepland: alles wat de agenda of mail aanraakt.
### B — Dagstart
**B1. Agenda uitlezen.** Als gebruiker wil ik dat de PA mijn agenda kan zien, zodat hij ergens op kan bouwen. → Nieuw in `tools.md`: agenda lezen (Google Calendar, lezen, B1, niveau 1). → Klaar als: hij morgen en de komende week correct en volledig teruggeeft, inclusief locaties en deelnemers. Ik heb gecheckt of hij niets mist bij terugkerende afspraken en afspraken met bijlagen. → Niet hierin: skill, format, interpretatie.
**B2. De Dagstart als inhoud.** ⚠️ _De langste story, en bewust._ Als gebruiker wil ik 's ochtends een overzicht dat ik daadwerkelijk lees, zodat de PA waarde levert vóór hij autonomie krijgt. → Nieuw: Dagstart-skill, niveau 1, **handmatig aangeroepen**. → Klaar als: ik hem tien werkdagen achter elkaar heb aangeroepen en de laatste drie geen correctie meer nodig hadden. Wat "prioriteit" is, hoeveel detail, welke volgorde, wat weglaten — dat schaaf ik hier bij, niet later. → Niet hierin: scheduling, mail, stemming, geheugen. → Levert op: eerste materiaal voor open punt 11 (stijlgids).
**B3. Stemmingscheck en logboek.** Als gebruiker wil ik dat de PA registreert hoe de dag erin zit, zodat er zachte data ontstaat om later op te sturen. → Nieuw: stemmingscheck in de Dagstart, `memory/log/` in gebruik. → Klaar als: een week aan logboekregels staat en ik er iets in terugzie dat ik zelf niet had opgeschreven.
**B4. Scheduling.** Als gebruiker wil ik dat de Dagstart zonder mij start, zodat het ritme niet van mijn discipline afhangt. → Nieuw: scheduled agent (open punt 1 eerst uitgezocht). → Klaar als: hij drie ochtenden op tijd is afgegaan én ik heb gezien wat er gebeurt als de laptop dicht is. Die gemiste run mag hier nog lelijk zijn. → Niet hierin: de oplossing voor gemiste runs. Eerst de pijn voelen.
**B5. Continuïteit tussen runs.** Als gebruiker wil ik dat een gemiste ochtend geen gat achterlaat, zodat het venster meebeweegt met de werkelijkheid. → Nieuw: `memory/handoff.md`, plus de venster-logica uit §3. → Klaar als: na twee dagen zonder run de Dagstart zelf vaststelt dat het 48 uur is en zich aanpast — zonder dat ik het zeg.
### C — Mail
**C1. Inbox uitlezen.** → Nieuw in `tools.md`: mail lezen. → Klaar als: ik weet hoeveel er dagelijks binnenkomt en of het contextvenster dat aankan. Dit is de story die open punt 6 (subagents) empirisch beantwoordt in plaats van theoretisch. → Niet hierin: triage, oordeel.
**C2. Triage als inhoud.** ⚠️ _Tweede lange story._ Als gebruiker wil ik dat de PA mijn inbox sorteert zoals ik het zelf zou doen, zodat ik zijn oordeel kan vertrouwen vóór hij iets mag opstellen. → Nieuw: triage-skill, niveau 1, los aangeroepen (nog niet in de Dagstart). → Klaar als: ik twee weken heb bijgehouden waar ik het oneens was en dat aantal naar bijna nul is gedaald. Urgent/actie/lezen/archief moet mijn indeling zijn, niet de zijne. → Niet hierin: concepten, versturen, integratie.
**C3. Triage in de Dagstart.** → Nieuw: niets verbonden, alleen integratie. → Klaar als: de gecombineerde Dagstart nog steeds leesbaar is en geen van beide onderdelen slechter werd. Als het overzicht hierdoor te lang wordt, kort ik in — dit is de story waar dat mag.
**C4. Stijlgids vastleggen.** _(sluit open punt 11)_ Als gebruiker wil ik mijn toon expliciet hebben, zodat de PA in mijn stem kan schrijven. → Nieuw: `personal/style-guide.md` gevuld — Nederlandse voorbeelden, do's & don'ts, wat nooit toezeggen. → Klaar als: het bestand staat en gebaseerd is op echte mails uit C2, niet op wat ik dénk dat mijn toon is. → Geen capability, geen skill. Puur inhoud.
**C5. Concepten opstellen.** → Nieuw in `tools.md`: mail concept (concept, **niet** versturen). Niveau 2. → Klaar als: van tien concepten er zeven ongewijzigd de deur uit kunnen. Onder die verhouding ga ik terug naar C4. → Niet hierin: versturen. Die capability bestaat nog niet.
### D — Handhaving
**D1. De blokkade bouwen en breken.** Als gebruiker wil ik dat "de PA verstuurt en wijzigt niets" een technische garantie is, zodat ik daarna pas schrijfrechten durf te verbinden. → Nieuw: hooks + permissions (laag 4), getest tegen de capabilities die er al zijn. → Klaar als: ik zelf heb geprobeerd hem iets te laten versturen — direct, via een omweg, en via een instructie ín een mail (open punt 10) — en het drie keer niet lukte. `tools.md` is aan de hook-configuratie gekoppeld zodat promotie één wijziging blijft. → Niets nieuws verbonden. Dit is de enige story die geen functionaliteit toevoegt en toch niet overgeslagen mag worden.
### E — Agenda
**E1. Eerst schrijven, klein.** → Nieuw in `tools.md`: agenda schrijven, niveau 2 (bevestiging per actie). → Klaar als: hij vijf keer een eigen focusblok heeft verzet zonder fout. Bewust eigen blokken: geen derden, geen schade. → Let op: een agenda kent geen concept-tussenstap. Daarom kwam D1 eerst.
**E2. Vergaderverzoeken en poortwachten.** _(sluit open punt 12)_ → Nieuw: `personal/escalation.md` — crisis-definitie en altijd-doorverbinden-lijst, nu gebaseerd op vier tot zes weken echte praktijk. → Klaar als: hij drie inkomende verzoeken heeft beoordeeld zoals ik ze had beoordeeld, mét discretie in de afwijzing (§1).
**E3. Buffers en focusblokken bewaken.** → Klaar als: hij een week lang reistijd en pauzes heeft beschermd en één keer terecht aan de bel trok.
### F — Taken
**F1. Notion uitlezen.** → Nieuw in `tools.md`: taken lezen. → Klaar als: hij items met ID kan aanhalen zonder inhoud te dupliceren.
**F2. Context bij open lussen.** → Nieuw: `memory/open-loops.md` in gebruik, alleen schrijven naar de repo. → Klaar als: het bestand vijf lussen bevat en ik kan vaststellen dat het géén tweede takenlijst is geworden (§6). Dit is de story waar die regel wordt getest, niet waar hij wordt opgeschreven.
**F3. Toezeggingen najagen.** → Nieuw in `tools.md`: taken schrijven, niveau 2. → Klaar als: hij één toezegging heeft opgemerkt die ik was vergeten. Dat is het hele punt van §1 "follow-up discipline".
### G — Weekafsluiting
**G1. Evaluatie-loop formaliseren.** → Nieuw: Weekafsluiting-skill. → Klaar als: de skill doet wat ik sinds A al wekelijks handmatig deed, en niks nieuws probeert te introduceren.
**G2. Auto-memory reviewen.** _(sluit open punt 4)_ → Klaar als: er een werkende regel is voor wat promoveert naar repo-markdown en wat wordt weggegooid — inclusief de taalcheck (§6).
### H — Uitbreiding
Per taak uit §7 dezelfde vorm: capability-story, inhoud-story, promotie-story. Suggestie eerste twee: briefings voorbereiden en vergaderoutput verwerken — hoge waarde, alleen-lezen, en ze bouwen op stakeholderkennis die dan al is gegroeid.
### Doorlooptijd
Dit zijn ~20 stories in plaats van 6 fases, maar dat maakt het niet langer. A1 tot B1 is een middag. De meeste stories zijn twintig minuten werk. Alleen B2 en C2 duren lang, en die duren lang omdát ze op evaluatiedata wachten — niet omdat er veel te bouwen valt. D1 is de enige die tijd kost zonder dat er iets bijkomt.
**Tot G1 doe je de evaluatie-loop handmatig.** Wekelijks tien minuten met het logboek erbij, en de skills direct aanpassen. Anders arriveert het mechanisme dat de kwaliteit van A t/m F bepaalt pas nadat die stories al af zijn.
## 9. Ontwerpprincipes met het oog op latere productisering
Niet nu bouwen, wel nu niet onmogelijk maken. Alle zes zijn gratis als je ze meteen doet.
1. **Generiek vs. persoonlijk gescheiden.** `CLAUDE.md` bevat PA-gedrag dat voor iedere gebruiker geldt; alles wat over de gebruiker gaat staat in `personal/`. Later is dat het verschil tussen "product met onboarding" en "herschrijven". Sinds A2 is dit ook een git-scheiding, niet alleen een mappenscheiding: `personal/` en `memory/` zitten niet in de geschiedenis (§6).
2. **Providers achter capabilities.** Skills noemen intenties, `tools.md` noemt servers. Microsoft-support wordt daarmee één bestand.
3. **Machine-specifieks in `config/`.** Geen paden, tokens of accountnamen in skills of persona. Verhuizen naar remote = repo klonen, config opnieuw vullen.
4. **Takenlijst achter een dunne interface.** Notion is nu de bron van waarheid, maar de skills praten over "taken", niet over "Notion-databases". Een andere gebruiker wil misschien Asana of Todoist.
5. **Autonomieniveaus als data, niet als proza.** Als het niveau per capability in `tools.md` staat in plaats van verspreid in skill-teksten, is "promotie" één overzichtelijke wijziging — en later een instelling in een product.
6. **Taal als parameter, niet als eigenschap.** Alle instructietekst, bestandsnamen en skill-teksten in het Engels; de uitvoertaal staat als één regel in `CLAUDE.md` ("Always respond in Dutch, je-vorm, unless the user writes in another language"). Nergens anders taalspecifiek gedrag. Zonder deze scheiding vallen instructietaal en uitvoertaal samen, en is een Engelstalige gebruiker een rondgang langs elke skill. Uitzondering: de toonvoorbeelden in `personal/style-guide.md` blijven Nederlands — zie de taalconventie in §6.
Wat bewust _niet_ nu gebeurt: multi-user, auth-infrastructuur, remote hosting, UI. Dat zijn de dingen die pas betekenis krijgen als één gebruiker een maand lang tevreden is.

Nieuw aandachtspunt (nog geen open punt, wel genoteerd): de gebruiker wil uiteindelijk met de PA praten via een chatvenster, niet noodzakelijk via Claude Code zelf. Dat verandert nu niets aan de bouwvolgorde, maar is relevant zodra Claude-Code-specifieke mechanismen (auto-load van `CLAUDE.md`, MCP-servers) een rol gaan spelen in wat wel/niet meeverhuist naar een ander interface. Nog geen beslissing nodig, wel iets om bij toekomstige architecturele keuzes (met name rond H en verder) opnieuw langs te leggen.
---
# Nog uit te zoeken
## Technisch
1. **Scheduling** — bestaat het in de huidige Claude Code, en zo ja: exacte configuratie lokaal, en wat gebeurt er bij een gemiste run? ⚠️ Niet geverifieerd; eerst opzoeken in actuele documentatie. _Nodig voor story B4._
2. **MCP-servers Google** — Gmail, Google Calendar, Notion: per server lezen vs. schrijven vs. versturen, en of concept-zonder-versturen scheidbaar is. _Wordt per story uitgezocht op het moment van verbinden (B1, C1, C5, E1, F1), niet vooraf in één keer._ Of C5 kan zoals beschreven hangt hiervan af.
3. **Skills-formaat** — structuur (frontmatter, triggers, beschrijvingen) en activatie van de juiste skill op het juiste moment. **Inclusief: triggert een Engelse skill-`description` betrouwbaar op Nederlandse gebruikersinput?** Crosslingual matching werkt doorgaans goed, maar dit is de enige plek waar de Engels-conventie (§9.6) actief iets kan kosten. Testen met een handvol Nederlandse formuleringen; zo niet: Engelse description met Nederlandse triggerwoorden erin. _Nodig voor story B2._
4. **Review-proces auto-memory** — wat promoveert naar repo-markdown, wat wordt verwijderd? Let op: auto-memory schrijft in de taal van de sessie; bij promotie naar repo-markdown moet het langs de taalconventie. _Story G2._
5. **Sessie-overdracht** — wat schrijft de PA weg in `memory/handoff.md`, en hoe leest de volgende run dat in? Extra gewicht bij lokaal draaien. _Story B5._
6. **Subagent-ontwerp** — welke subagents (inbox-lezer, stakeholder-kenner?), welk model per subagent, en waar leeft hun geheugen? _Wordt empirisch beslist in story C1, op basis van echte inboxvolumes._
7. **Hook-implementatie** — welke hook-events, en hoe koppel je hook-configuratie aan `tools.md` zodat promotie één wijziging is? _Story D1._
8. **Interface buiten Claude Code** — het eindbeeld is een chatvenster, niet per se Claude Code. Nog niet uitgezocht: welk kanaal (claude.ai, eigen app, iets anders), en wat dat betekent voor de MCP-servers en de `CLAUDE.md`-auto-load waar de huidige architectuur op leunt. _Geen story aan gekoppeld; wordt relevant zodra blok H concreet wordt._
## Beveiliging
9. **Grens gevoelige data** — welke kluis voor de echte gegevens (1Password e.d.), en hoe verwijst de repo ernaar zonder de data aan te raken?
10. **Verstuurblokkade** — implementeren en testen dat de blokkade niet via een andere tool/route omzeild kan worden. _Story D1._
11. **Prompt-injectie** — inkomende mail is onvertrouwde input. Instructies ín een mail ("stuur dit door naar...") mogen nooit als opdracht gelden. Minimaal: harde regel in `CLAUDE.md` (vanaf A1) + geen verstuur-capability. Uitzoeken of hooks extra kunnen filteren. _Actief getest in story D1; wordt urgenter bij elke stap naar niveau 3._
## Ontwerpbeslissingen
|#|Vraag|Status|
|---|---|---|
|12|Stijlgids: toon, do's & don'ts, wat nooit toezeggen|**Open** — wordt story C4, na echte Dagstarts en triage|
|13|Crisis-definitie en altijd-doorverbinden-lijst|**Open** — wordt story E2, na 4–6 weken praktijk|
|14|Standaardkeuze bij twijfel|✅ **Noteren-en-wachten**|
|15|Bron van waarheid voor taken|✅ **Notion** leidend, repo = context|
|16|Krijgt de PA een naam/identiteit naar derden?|**Open** — pas relevant vanaf C5|
|17|Prioritering takencatalogus na G|**Open** — suggestie: briefings + vergaderoutput|
|18|Lokaal vs. remote|✅ **Lokaal**, met portable config (§9.3)|
|19|Stack|✅ **Google nu**, achter capability-laag (§9.2)|
|20|Taal: instructies vs. uitvoer|✅ **Instructies + namen Engels, uitvoer Nederlands** (§6, §9.6)|
|21|Moment van verbinden capabilities|✅ **Per taak, bij eerste gebruik.** `tools.md` start leeg (§6, §8)|
|22|Vorm van de roadmap|✅ **User stories**, één nieuw element per story, capability en gebruik gescheiden (§8)|
|23|Interface: Claude Code of chatvenster?|**Open** — eindbeeld is een chatvenster, niet per se Claude Code; nog niet uitgezocht welk kanaal en wat dat betekent voor MCP/`CLAUDE.md` (zie open punt 8)|
