#import "@preview/polylux:0.4.0": *
#import "@preview/polylux:0.4.0": toolbox.pdfpc
#import "@preview/fontawesome:0.6.0": *
#import "lib.typ": *

// Defnine slides, so we can include it in handout mode
#let slides = [
#show: setup

#title-slide(
  title: [
    Wenn Gurken-Code plötzlich Spaß macht!
  ],
  authors: [
    Christian Budde #link("")[#fa-github() cwbudde] \
    Lukas Nagel #link("")[#fa-github() lukasngl] \
  ],
  extra: [
    Hannover Gophers, 14.10.2025
  ],
  url: "https://github.com/lukasngl/2025-10-14-gopher-meetup-cucumber-presentation",
)


#slide[
  == Outline
  #pdfpc.speaker-note[```md
    @cwbudde: Hier können wir speaker notes nach lust und laune reinhauen.
  ```]

  #set text(size: 12pt)
  #columns(2)[

    - Szenario einführen: Wir sind eine Bank
      - (Disclaimer: nicht unsere Domain, aber alle kennen es)
      - Alice und Bob können sich Geld überweisen
      - Nutzer können überweisen etc
      - TODO: rahmen für business logik an präsentation anpassen
    - Kurze Motivation: Warum testen?
      - Z.b. Geldverlust, Reputationsverlust, regulatorische Anforderungen
    - Story: von Go test zu cucumber
      1. einfacher Go test, noch alles übersichtlich
      2. mehrere Tests, setup code wird dupliziert
      3. identifizieren von Given/When/Then blöcken
      4. extrahieren in funktionen
      5. Transition zu cucumber
    - Perspektive: Wann und wofür macht sowas Sinn?
      - Einordnung:
        - Test Pyramide?: #strike()[Unit], Integration, E2E
        - Fokus auf business logik, weniger technische details
      - Steak-Holder (pun intended) einführen: Kann plötzlich mitreden
        - BDD anreißen/einführen?
      - Dokumentation
        - Tests sind lebende Dokumente
        - Anforderungen werden automatisch getestet und liegen beim Code
          - Kein "schau mal bei Confluence oder Jira, warum das so ist..."
        - veraltet nicht
    - Vorsprung durch Technik: Wie nutze ich cucumber, godog
      - godog schritte aufbau
      - Table Driven Tests
      - Szenario Outlines
      - Claudia Code??
    - Praxis Tipp: Test Suite für handler/integrations tests.
  ]
]
]

#slides
