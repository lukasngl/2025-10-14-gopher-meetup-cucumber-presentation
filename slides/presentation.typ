#import "@preview/polylux:0.4.0": *
#import "@preview/polylux:0.4.0": toolbox.pdfpc
#import "@preview/fontawesome:0.6.0": *
#import "@preview/pinit:0.2.2": *
#import "lib.typ": *
#import "lib.typ" as lib

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

  #content-slide([Agenda])[
    #pdfpc.speaker-note[```md
      Structure: Problem → Solution → Payoff with recurring characters (Developer, Stakeholder, Colleague)
    ```]

    #set text(size: 11pt)
    #columns(2)[

      *1. Introduction (3-5 min)*
      - Who we are
      - What is BDD/Cucumber?
        - Brief overview
        - Tools: Cucumber, godog
        - Visual Aid: Show cucumber and godog logos
      - Structure of feature file
        - Feature, Scenario, [Rule], Given/When/Then
        - Visual Aid: Simple example feature file
          ```feature
          Feature: Feature development
            Rule: Using godog rules
              Scenario: Using godog
              Given I use godog
              When I implement a feature
              Then I am happy
          ```
      - Why BDD/Cucumber?
        - Readable Test
        - Living documentation
        - Collaboration between developers and stakeholders
        - Clearer requirements
      - The killer feature:
        - Mulilangual support
          - #link(
              "https://cucumber.io/docs/gherkin/languages",
            )[80 languages supported]
          - Translation layer from the Domain language to code
          - Visual Aid: English Code and German Cucumber side by side

      *2. The Problem - Act by Act (15-20 min)*
      - Setting the scene
        - New Messvorlagen feature request
        - Specification lives in Jira
          - Visual Aid: Show a broken jira page; and a fixed on the next. (Oh broken, let's reload; there we go)
        - Developer writes Go test

      - Developer's pain
        - Show convoluted Go test code
        - First: whole test (wall of code, overwhelming)
        - Then: break into chunks to analyze
        - Lots of setup, unclear structure
        - Business logic buried in technical details

      - Stakeholder's pain
        - "Can you explain what this test does?"
        - Show Go code rendered as Egyptian hieroglyphs (𓀀 𓀁 𓀂 𓀃 𓀄...)
        - "This is hieroglyphs to me!"
        - Can't verify if requirements are met

      - Colleague's pain
        - Makes a subtle logic change to the code
        - Updates the Go tests (they pass ✅)
        - Forgets to update Jira/Confluence spec
        - Spec and implementation have silently drifted apart
        - No one notices until much later...

      *3. The Refactoring Journey (10-15 min)*
      - Step 1: Identify structure
        - Highlight Given/When/Then blocks in the messy test
        - User story was already in the godoc!

      - Step 2: Extract functions
        - Refactor into named functions
        - Code becomes more readable

      - Step 3: Transform to Cucumber
        - Show 1:1 mapping from functions to steps
        - User story from godoc → feature file

      - Developer interlude
        - "But table-driven tests are more convenient!"
        - Show verbose Go struct list

      - Counter: Scenario Outline
        - Same convenience, readable syntax
        - Show cucumber table syntax

      *4. The Resolution (5 min)*
      - Stakeholder's relief
        - "I can read this!"
        - Spec can be published to wiki
        - Can participate in review

      - Colleague's relief
        - "Now when I change the logic, the test fails until I update the spec"
        - Documentation literally cannot be outdated
        - Living documentation guarantee

      - Developer's relief
        - Less boilerplate
        - Clearer intent
        - Better collaboration

      *5. Technical Deep Dive (5-10 min)*
      - godog step definitions
      - Running tests
      - Integration with test suite
      - Quick tips & tricks

      *6. Positioning & Best Practices (5 min)*
      - Test pyramid: where does this fit?
        - #strike()[Unit], Integration, E2E
        - Focus on business logic, less technical details
      - When to use BDD/Cucumber
        - Complex business logic
        - Stakeholder collaboration needed
      - When NOT to use it
        - Unit tests
        - Simple CRUD operations

      *7. Conclusion (2-3 min)*
      - Recap benefits: Living docs, collaboration, clarity
      - Links & resources
        - #link("https://cucumber.io/docs/bdd/")
      - Q&A
    ]
  ]

  #section-slide([Die Realität])[
    #align(horizon + center)[
      #text(size: 1.2em)[
        Probleme sind nur dornige Chancen \
        #v(0.5em)
        #text(size: 0.5em)[-- Deutschlands frechster Arbeitsloser]
      ]
    ]
  ]

  #slide[
    == Wer kennt das nicht?

    #set align(horizon + center)
    #set text(size: 20pt)

    *Wo war nochmal die Spezifikation?*

    Irgendwo in Jira... oder war's Confluence? \
    Oder in dem Teams-Chat von vor 3 Monaten?

    #v(1em)
    #box(height: 8em)[] // Placeholder space

    // TODO: Add image
  ]

  #slide[
    == Wer kennt das nicht?

    #set align(horizon + center)
    #set text(size: 20pt)

    *Wo war nochmal die Spezifikation?*

    Irgendwo in Jira... oder war's Confluence? \
    Oder in dem Teams-Chat von vor 3 Monaten?

    #v(1em)

    *Was macht die Funktion nochmal?*

    500 Zeilen, 8 verschachtelte Ifs, keine Kommentare \
    Edge Cases? Das finden wir schon raus... irgendwann

    #v(1em)
    #box(height: 2em)[] // Placeholder space

    // TODO: Add image
  ]

  #slide[
    == Wer kennt das nicht?

    #set align(horizon + center)
    #set text(size: 20pt)

    *Wo war nochmal die Spezifikation?*

    Irgendwo in Jira... oder war's Confluence? \
    Oder in dem Teams-Chat von vor 3 Monaten?

    #v(1em)

    *Was macht die Methode nochmal?*

    500 Zeilen, 8 verschachtelte Ifs, keine Kommentare \
    Edge Cases? Das finden wir schon raus... irgendwann

    #v(1em)

    *Ist das durch Tests abgedeckt?*
  ]

  #slide[
    == Die Folgen

    #set align(horizon + center)
    #set text(size: 22pt)

    ❌ Spezifikation und Code driften auseinander

    #v(1em)

    ⚠️ Jede Änderung ist ein Risiko

    #v(1em)

    🚫 Stakeholder können Requirements nicht verifizieren

    #v(1.5em)

    #text(size: 0.9em, style: "italic")[
      Es muss doch einen besseren Weg geben...
    ]

    // TODO: Add image
  ]

  #slide[
    == Was wäre, wenn...

    #set align(horizon + center)
    #set text(size: 18pt)

    ...wir eine #text(weight: "bold")[gemeinsame Single Source of Truth] hätten?

    #text(size: 15pt, style: "italic")[Spezifikation = Tests = Dokumentation]

    #v(0.5em)

    ...unsere Dokumentation #text(weight: "bold")[immer aktuell] bliebe?

    #text(size: 15pt, style: "italic")[Veraltete Doku würde sofort auffallen]

    #v(0.5em)

    ...wir uns auf #text(weight: "bold")[Geschäftslogik statt Implementierung] fokussieren?

    #text(size: 15pt, style: "italic")[Was, nicht Wie]

    #v(0.5em)

    ...#text(weight: "bold")[alle im Team] mitreden könnten?

    #text(size: 15pt, style: "italic")[Auch ohne Programmierkenntnisse]
  ]

  #slide[
    == Das Rezept-Prinzip

    #set align(horizon + center)
    #set text(size: 19pt)

    #text(style: "italic")[
      *Angenommen* ich habe Gurken, Essig und Dill \
      *Wenn* ich die Gurken schneide, würze
      *und* 10 Minuten ziehen lasse \
      *Dann* erhalte ich einen leckeren Gurkensalat
    ]

    #v(1.5em)

    Man beschreibt die *Ausgangslage*, die *Handlung* \
    und das *erwartete Ergebnis* – und prüft, ob es stimmt.

    #v(1.5em)

    In der Softwareentwicklung nennt man dieses Prinzip \
    *BDD – Behavior Driven Development*.
  ]

  #section-slide([Und warum die Gurken?])[
    #align(horizon + center)[
      #text(size: 0.9em)[
        Cucumber ist ein BDD-Framework
      ]

      #v(2em)

      #text(style: "italic", size: 0.85em)[
        "Cucumber is a tool for running automated acceptance tests, written in plain language.
        Because they're written in plain language, they can be read by anyone on your team,
        improving communication, collaboration and trust."
      ]

      #v(0.5em)

      #text(size: 0.7em)[
        -- #link("https://cucumber.io/")[cucumber.io]
      ]
    ]
  ]

  #content-slide([Die gemeinsame Sprache])[
    #toolbox.side-by-side(
      [
        *Developer* 🧑‍💻 \
        _"Ich brauche eine klare, \
        stabile Spezifikation"_

        #v(1em)

        *QA* 🧪 \
        _"Ich will nachprüfbare \
        Validierung"_

        #v(1em)

        *Stakeholder* 👔 \
        _"Ich will verstehen, \
        was gebaut wird"_
      ],
      align(horizon)[
        *BDD (Cucumber) löst das:* \
        Eine Sprache für alle

        #v(0.5em)

        ```feature
        Szenario: Stent-Dimension validieren
          Angenommen eine Messvorlage "MV-42"
            mit Toleranz 100mm ± 5mm
          Wenn ich 103mm messe
          Dann ist das Produkt in Ordnung
        ```

        #v(0.5em)

        ✅ Entwickler: Klare Spec \
        ✅ QA: Automatisierter Test \
        ✅ Stakeholder: Lesbar
      ]
    )
  ]

  #content-slide([Key Features])[
    #let emph-on(on, body) = {
      only((until: on - 1), body)
      only(on, underline(emph(body)))
      only((beginning: on + 1), emph(body))
    }

    #show: set align(horizon)

    #toolbox.side-by-side(
      columns: (60%, 40%),
      lib.item-by-item()[
        - Lebendige Dokumentation
          - Spezifikation werden automatisch getestet
        - Natürliche Sprache
          - über 80 Sprachen
        - Methoden die Stakeholder in den Entwicklungsprozess einbindet
      ],

      align(horizon + center)[
        #text(style: "italic", size: 0.9em)[
          "Cucumber is a tool for running #emph-on(1)[automated acceptance tests], #emph-on(2)[written in plain language].
          Because they're written in plain language, they #emph-on(3)[can be read by anyone on your team],
          improving communication, collaboration and trust."
        ]

        #v(0.5em)

        #text(size: 0.7em)[
          -- #link("https://cucumber.io/")[cucumber.io]
        ]
      ],
    )
  ]

  #section-slide([Beispiel: Feature spezifieren und implementieren])[
    #align(left)[
      - ohne cucumber:
        - anforderung in jira
        - test in go
        - documentation in confluence
      - mit cucumber
        - => nice!
    ]
  ]

  #slide[
    == Wie spezifiere ich eine Feature?

    #set align(horizon)

    #reveal-code(lines: (1, 4, 11), full: true)[```feature
      Feature: pin4Withdrawing cashpin5
        pin1As a bank customer
        I want to withdraw cash from an ATMpin3
        So that I can buy hotdogspin2

      pin6Rule: Can withdraw cash if sufficient fundspin7

        pin8Scenario: Successful withdrawal within balancepin9
          pin10Given Alice has 234.56 in their account
          When Alice tries to withdraw 200.00
          Then the withdrawal is successfulpin11
    ```]

    #only(1)[
      #pinit-highlight(4, 5, fill: yellow.transparentize(80%))
      #pinit-point-from(
        (4, 5),
        offset-dy: -2em,
        offset-dx: 5em,
        body-dy: -0.5em,
        pin-dy: -1em,
        pin-dx: 0em,
      )[_Name des Features_]
    ]

    #only(2)[
      #pinit-highlight(1, 2, 3)
      #pinit-point-from(
        (1, 2, 3),
        pin-dy: 1cm,
        offset-dy: 1.5cm,
        body-dy: -0.25em,
      )[_Freitext (hier User-Story)_]
    ]

    #only(3)[
      #pinit-highlight(fill: white, 6, 7)
      #pinit-highlight(8, 9)
      #pinit-point-from(
        (8, 9),
        pin-dy: -0.5cm,
        offset-dy: -1.5cm,
        body-dy: -0.25em,
      )[_Spezifikation des Features durch Beispiele_]
    ]

    #only(4)[
      #pinit-highlight(6, 7)
      #pinit-point-from(
        (6, 7),
        // pin-dy: 1cm,
        offset-dy: 0.5cm,
        body-dy: -0.25em,
      )[_Optional: Gruppierung nach z.B. Akzeptanzkriterium_]
    ]

  ]

  #slide[
    == My English is not the yellow of the egg

    #set align(horizon)

    ```feature
      pin1#+language: depin2
      pin3Funktionalitätpin4: Geld abheben
        Als Bankkunde
        Möchte ich Geld von einem Geldautomaten abheben
        Damit ich Hotdogs kaufen kann

      Szenario: Erfolgreiche Abhebung innerhalb des Guthabens
        Angenommen Alice hat 234,56 auf ihrem Konto
        Wenn Alice versucht 200,00 abzuheben
        Dann ist die Abhebung erfolgreich
    ```

    #show: later

    #pinit-highlight(1, 2)
    #pinit-point-from(
      (1, 2),
      offset-dy: -2em,
      offset-dx: 5em,
      body-dy: -0.5em,
      pin-dy: -1em,
      pin-dx: 0em,
    )[Sprache mittels magic-comment festlegen]
  ]

  #section-slide([Implementierung])[
    Wie kriege ich das jetzt zum Laufen?
  ]

  #slide[
    === Godog

    - bla
    - bluh
    - blups
  ]

  #slide[
    === Schritte implementieren

    - Schritte entsprechen einer Go Funktion

    ```go
    func InitializeSteps(sc *godog.ScenarioContext) {
      sc.When(`^I measure (\d+)mm$`, func(mm int) error {
        state := FromCtx(ctx)
        return state.app.ObserveMeasurement(ctx, mm)
      })
    }
    ```
  ]

  #slide[
    === Background
    Schritte die vor jedem Szenario ausgeführt werden:
    #toolbox.side-by-side(
      [
        ```go
        func setup(t*testing.T) {
          // create MV123
        }

        func TestAbove(t*testing.T) {
          setup(t)
          // ...
        }

        func TestBelow(t*testing.T) {
          setup(t)
          // ...
        }
        ```
      ],
      [
        ```feature
        Grundlage:
          Angenommen "MV123" existiert
        Szenario: Zu hoch
          Wenn ich 1337mm messe
          Dann ist das Teil Ausschuss
        Szenario: Zu niedrig
          Wenn ich 42mm messe
          Dann ist das Teil Ausschuss
        ```
      ],
    )
  ]

  #slide[
    === Szenario Outline
    Den selben Test/Szenario mit unterschiedlichen Parametern ausführen:
    #toolbox.side-by-side(
      [
        ```go
        var testCases = []struct {
          name      string
          messwert  int
          expected  bool
        }{
          {"below_tolerance", 0, false},
          {"in_spec", 42, true},
          {"above_tolerance", 1337, false},
        }
        for _, tc := range testCases { ... }
        ```
      ],
      [
        ```feature
        Szenario Grundriss: <Ergebnis>
          Wenn ich <Messwert> messe
          Dann ist das Teil <Ergebnis>
          Examples:
            | Messwert     | Ergebnis   |
            |    0mm       | Ausschuss  |
            |   42mm       | in Ordnung |
            | 1337mm       | Ausschuss  |
        ```
      ],
    )
  ]

  #content-slide([Warum überhaupt testen?])[
    - Ein Softwarefehler in Medizinprodukten kann Leben gefährden
    - Regulatorische Anforderungen (MDR, FDA)
      - Softwarevalidierung verpflichtend

    #v(1em)
    #align(center)[
      #text(size: 0.9em, style: "italic")[
        Tests verhindern nicht nur Produktionsausfälle, \
        sondern schützen am Ende auch Menschenleben.
      ]
    ]
  ]

  #content-slide([BDD + Klassisches Testen = 💚])[
    #set align(horizon)

    *BDD und klassisches Testen schließen sich nicht aus* – \
    sie ergänzen einander!

    #v(1em)

    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      align(left)[
        *Vor dem Coding:*
        - Klare, gemeinsame Definition
        - Erwartungen für alle lesbar
        - Missverständnisse früh erkennen
      ],
      align(left)[
        *Nach dem Coding:*
        - Automatische Verifikation
        - Leicht validierbar
        - Living Documentation
      ]
    )

    #v(1.5em)

    #align(center)[
      #text(size: 0.95em, style: "italic", fill: green.darken(20%))[
        *Gurken-Code kann Spaß machen,* \
        wenn er für alle Beteiligten Mehrwert schafft!
      ]
    ]

  ]

  #section-slide([Appendix])[
    #align(horizon + center)[
      #text(size: 1.2em)[
        Zusätzliche Informationen & Hintergründe
      ]
    ]
  ]

  #content-slide([Die Entstehung von BDD])[
    #set text(size: 15pt)

    *Dan North, ca. 2003-2004*

    #v(0.5em)

    *Das Problem:*
    - TDD-Entwickler kämpften mit grundlegenden Fragen:
      - Wo anfangen? Was testen? Was nicht testen?
      - Wie viel in einem Test? Wie Tests benennen?

    #v(0.5em)

    *Die Entwicklung:*
    - Entdeckung von "agiledox" → Testmethoden als lesbare Sätze
    - Namenskonvention: Methoden beginnen mit "should"
    - Paradigmenwechsel: Von "Tests" zu "Verhalten" (Behaviour)
    - Entwicklung von JBehave als JUnit-Ersatz

    #v(0.5em)

    *Die Schlüsselerkenntnis:*

    #align(center)[
      #text(style: "italic", fill: blue.darken(20%))[
        "Behaviour" ist nützlicher als "Test" – \
        Requirements sind fundamentally about behavior
      ]
    ]

    #v(0.5em)

    #text(size: 11pt)[
      Quelle: #link("https://dannorth.net/blog/introducing-bdd/")[Dan North - Introducing BDD]
    ]
  ]

  #content-slide([Wie war das nochmal mit den Gurken?])[
    #toolbox.side-by-side(
      columns: (60%, 40%),
      [
        #v(0.5em)

        *Cucumber* (das Tool)
        - Entwickelt von *Aslak Hellesøy* \ (ursprünglich "Stories Runner" für Ruby)
        - Suchte nach einem einprägsamen Namen
        - Seine Verlobte schlug "Cucumber" vor
        - Kein tiefer technischer Bezug, \ sondern kreativ & merkbar

        #v(0.5em)
      ],
      align(horizon + center)[
        #image("../assets/cucumber.jpg", width: 100%)
      ]
    )
  ]

  #content-slide([Und was ist "Gherkin"?])[
    #toolbox.side-by-side(
      columns: (60%, 40%),
      [
        #v(0.5em)

        *Gherkin* (die Sprache)
        - DSL für Feature-Files, die Cucumber interpretiert
        - Englisch: "gherkin" = kleine eingelegte Gurke \ (pickled cucumber)
        - Etymologie: vom niederländischen *Gurken*
        - Metapher: \ Requirements werden "eingelegt" / konserviert

      ],
      align(horizon + center)[
        #image("../assets/gherkin.jpg", width: 100%)
      ]
    )
  ]

  #slide[
    #text(size: 9pt)[
      Bei Palm führten sie 2006 eine Studie durch, die zeigte: Wird ein Bug 3 Wochen später behoben, kostet die Behebung desselben Bugs das 24-fache an Aufwand.
      #text(style: "italic")[
        (Quelle: Jeff Sutherland)
      ]
    ]

    #image("../assets/DownShift.gif", width: 85%)

    #place(
      right,
      dy: -1em,
      text(size: 10pt, style: "italic")[
        Bildquelle:
        #link("https://www.linkedin.com/posts/davidavpereira_fixing-production-bugs-is-640x-more-expensive-activity-7286021036976857089-UHmI/")[David Pereira]
      ]
    )
  ]

  #slide[
    #image("../assets/TestPyramide.svg", width: 80%)
  ]

  #slide[
    #image("../assets/V-Modell-Cucumber.svg", width: 85%)

    #place(
      right,
      dy: -1em,
      text(size: 10pt, style: "italic")[
        Quelle:
        #link("https://de.wikipedia.org/wiki/V-Modell")[Wikipedia "V-Modell"]
      ]
    )
  ]

]

#slides
