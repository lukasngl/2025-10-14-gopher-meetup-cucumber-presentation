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

  #section-slide([Problem])[
    Probleme sind nur dornige Chancen \
    #text(size: 0.6em)[-- Deutschlands frechster Arbeitsloser]
  ]

  #content-slide([Unser Problem])[
    - Grosse Legacy Codebase
      - Spezifikation verteilt auf Tickets/Artikel in Jira/Confluence
      - Tests existieren kaum
      - Tested by production
    - Neuere Inititative: Tests in Go
      - Viel setup, da aggregate die ganze DB umspannen
      - Business Logik in technische Details vergraben
      - Stakeholder können nicht mitreden
    - Edgecases einigremasen unbekannt

    Dann:
    Spezifikation und Implementierung driften auseinander
  ]

  #section-slide([Was ist BDD/Cucumber?])[
    #align(horizon + center)[
      Cucumber is a tool for running automated acceptance tests, written in plain language.
      Because they're written in plain language, they can be read by anyone on your team,
      improving communication, collaboration and trust.

      -- #link("https://cucumber.io/")[cucumber.io]
    ]
  ]

  #content-slide([Key Features])[
    #let emph-on(on, body) = {
      if on > 1 { only((until: on - 1))[#body] }
      only((beginning: on), emph(body))
    }

    #show: set align(horizon)

    #toolbox.side-by-side(
      lib.item-by-item()[
        - Lebendige Dokumentation
          - Spezifikation werden automatisch getestet
        - Natürliche Sprache
          - über 80 Sprachen
        - Methoden die Stakeholder in den Entwicklungsprozess einbindet
      ],

      align(horizon + center)[
        Cucumber is a tool for running #emph-on(1)[automated acceptance tests], #emph-on(2)[written in plain language].
        Because they're written in plain language, they #emph-on(3)[can be read by anyone on your team],
        improving communication, collaboration and trust.

        -- #link("https://cucumber.io/")[cucumber.io]
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

]

#slides
