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
      Christian Budde #link("https://github.com/cwbudde")[#fa-github() cwbudde] \
      Lukas Nagel #link("https://github.com/cwbudde")[#fa-github() lukasngl] \
    ],
    extra: [
      Hannover Gophers, 14.10.2025
    ],
    url: "https://github.com/lukasngl/2025-10-14-gopher-meetup-cucumber-presentation",
    title-image: image(
      "../assets/pickle-gophers_building_the_hannover_rathaus.png",
      alt: "Pickle-Gophers building the Hannover Rathaus",
      height: 100%,
    ),
  )

  #section-slide([Die Realität])[ ]

  #content-slide([Wer kennt das nicht?])[
    #set align(horizon + center)
    #set text(size: 20pt)

    #uncover((beginning: 1))[
      *Wo war nochmal die Spezifikation?*

      Irgendwo in Jira... oder war's Confluence? \
      Oder in dem Teams-Chat von vor 3 Monaten?
    ]

    #only(1)[
      // Floating logos
      #place(top + left, dx: 0%, dy: 20%, rotate(-15deg, image(
        "../assets/jira.svg",
        height: 2em,
      )))
      #place(top + right, dx: -5%, dy: 15%, rotate(12deg, image(
        "../assets/confluence.svg",
        height: 2em,
      )))
      #place(top + left, dx: 5%, dy: 45%, rotate(8deg, image(
        "../assets/teams.svg",
        height: 2em,
      )))
      #place(top + right, dx: 5%, dy: 40%, rotate(-10deg, image(
        "../assets/slack.svg",
        height: 2em,
      )))
    ]

    #uncover((beginning: 2))[
      #v(1em)
      *Was macht die Funktion nochmal?*

      500 Zeilen, 8 verschachtelte Ifs, keine Kommentare \
      Edge Cases? Das finden wir schon raus... irgendwann
    ]

    #only(2)[
      // Floating question marks
      #place(top + left, dx: 0%, dy: 45%, rotate(-15deg, text(
        size: 3em,
        fill: meko_grey,
      )[?]))
      #place(top + right, dx: -5%, dy: 45%, rotate(12deg, text(
        size: 3em,
        fill: meko_grey,
      )[\#]))
      #place(top + left, dx: 5%, dy: 75%, rotate(8deg, text(
        size: 3em,
        fill: meko_grey,
      )[\@]))
      #place(top + right, dx: 5%, dy: 70%, rotate(-10deg, text(
        size: 3em,
        fill: meko_grey,
      )[?]))
    ]

    #uncover((beginning: 3))[
      #v(1em)

      *Ist das durch Tests abgedeckt?*
    ]
  ]

  #content-slide([Die Folgen])[
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
  ]

  #content-slide([Was wäre, wenn...])[
    #set align(horizon + center)
    #set text(size: 18pt)

    ...wir eine *gemeinsame Single Source of Truth* hätten?

    #text(size: 15pt, style: "italic")[Spezifikation = Tests = Dokumentation]

    #v(0.5em)

    ...unsere Dokumentation *immer aktuell* bliebe?

    #text(size: 15pt, style: "italic")[Veraltete Doku würde sofort auffallen]

    #v(0.5em)

    ...wir uns auf *Geschäftslogik statt Implementierung* fokussieren?

    #text(size: 15pt, style: "italic")[Was, nicht Wie]

    #v(0.5em)

    ...*alle im Team* mitreden könnten?

    #text(size: 15pt, style: "italic")[Auch ohne Programmierkenntnisse]
  ]

  #content-slide([Das Rezept-Prinzip])[
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

    // Floating GopherCucumber
    #place(top + right, dx: 4%, dy: 20%, image(
      "../assets/GopherCucumber.svg",
      height: 4em,
    ))
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
      ],
    )
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

    // Floating GopherGherkin
    #place(top + right, dx: 0%, dy: 18%, image(
      "../assets/GopherGherkin.png",
      height: 6em,
    ))
  ]

  #content-slide([Key Features])[
    #let emph-on(on, of, body) = {
      if on > 1 { only((until: on - 1), body) }
      only(on, underline(emph(body)))
      if on < of { only((beginning: on + 1), emph(body)) }
    }

    #show: set align(center + horizon)

    #toolbox.side-by-side(
      columns: (60%, 40%),
      [
        *Lebendige Dokumentation* \
        Spezifikation werden automatisch getestet

        #uncover(2)[
          #v(1em)

          *Natürliche Sprache* \
          über 80 Sprachen
        ]
        #uncover(3)[

          #v(1em)

          *Methoden die Stakeholder in den Entwicklungsprozess einbindet*
        ]
      ],

      align(horizon + center)[
        #text(style: "italic", size: 0.9em)[
          "Cucumber is a tool for running #emph-on(1, 3)[automated acceptance tests], #emph-on(2, 3)[written in plain language].
          Because they're written in plain language, they #emph-on(3, 3)[can be read by anyone on your team],
          improving communication, collaboration and trust."
        ]

        #v(0.5em)

        #text(size: 0.7em)[
          -- #link("https://cucumber.io/")[cucumber.io]
        ]
      ],
    )
  ]

  #section-slide([Hands-On])[
    #set image(height: 4cm)
    #set figure(numbering: none)
    #let arrow = text(size: 2cm, emph(fa-arrow-right()))

    #stack(
      dir: ltr,
      spacing: 1em,
      ..(
        (caption: "Stake Holder", image: "../assets/steak-holder.png"),
        (caption: "Spezifikation", image: "../assets/pickle-gopher.png"),
        (caption: "Implementierung", image: "../assets/godog.png"),
      )
        .map(x => figure(caption: x.caption, image(x.image, alt: x.caption)))
        .intersperse(arrow),
    )
  ]

  #content-slide([Anforderungen vom Steakholder])[
    #toolbox.side-by-side(
      columns: (1fr, auto),
      [
        #align(center)[*User-Story*]
        #v(1em)

        *Als* Qualitätsprüfer \
        *Möchte ich* gemessene Werte für definierte Dimensionen erfassen \
        *Damit* die Maßhaltigkeit des Werkstücks dokumentiert wird \

        #uncover(1)[

          #align(center)[*Akzeptanzkriterien*]
          #v(1em)

          - Maßhaltig wenn alle Messungen innerhalb der Toleranz
          - Messung vollständig wenn für alle Dimensionen ein Wert erfasst wurde
          - ...
        ]
      ],
      [ #image("../assets/steak-holder.png", height: 5cm) ],
    )
  ]

  #content-slide([Beschreiben des Verhaltens durch Beispiele])[
    #toolbox.side-by-side(
      columns: (1fr, auto),
      [
        #set align(center)

        *Akzeptanzkriterium*
        #v(0.5em)

        _"Maßhaltig wenn alle Messungen innerhalb der Toleranz"_

        #v(1.5em)

        #align(center)[*Beispiel*]
        #v(0.5em)

        Ich hab eine Messvorlage "Stent-Typ-A" mit einem Durchmesser von 3.5mm ± 0.1mm.

        Wenn beim ich den Durchmesser 3.7mm messe dann ist das Teil außerhalb
        der Toleranz und somit nicht maßhaltig.

        #v(1em)

        #text(size: 0.85em, style: "italic")[
          → Das Beispiel beschreibt konkret, wie sich das System _verhalten_ soll
        ]
      ],
      [ #image("../assets/steak-holder.png", height: 5cm) ],
    )
  ]

  #content-slide([Spezifikation in Gherkin])[
    #toolbox.side-by-side(
      columns: (auto, 1fr),
      [ #image("../assets/pickle-gopher.png", height: 5cm) ],
      [
        #reveal-code(lines: (2, 5, 16), full: true)[```feature
          pin13#+language: depin14
          Funktionalität: pin4Messwert erfassenpin5
            pin1Als Qualitätsprüfer
            Möchte ich gemessene Werte für definierte Dimensionen erfassenpin3
            Damit die Maßhaltigkeit des Werkstücks dokumentiert wirdpin2

          pin6Regel: Maßhaltig wenn alle Messungen innerhalb der Toleranzpin7

            pin8Szenario: Messwert außerhalb Toleranzpin9
              pin10Angenommen Messvorlage "MV123" mit Dimensionen existiert:pin11
                | Name        | Einheit | Nominal | Untere | Obere |
                | Durchmesser | mm      | 3.5     | 3.4    | 3.6   |
              Und eine Messung gestartet wurde
              Wenn der Wert 3.7 für "Durchmesser" erfasst wird
              Dann ist die Messung vollständig
              Und das Teil ist nicht maßhaltigpin12
        ```]

        #only(1)[
          #pinit-highlight(4, 5, fill: yellow.transparentize(80%))
          #pinit-point-from(
            (4, 5),
            offset-dy: 2.5em,
            offset-dx: 5em,
            body-dy: -0.5em,
            pin-dy: 0.25em,
            pin-dx: 0em,
          )[_Name des Features_]
          #pinit-highlight(13, 14, fill: blue.transparentize(80%))
          #pinit-point-from(
            (13, 14),
            offset-dy: -2em,
            offset-dx: 5em,
            body-dy: -0.5em,
            pin-dy: -1em,
            pin-dx: 0em,
          )[_#emoji.wand Sprache via magic comment_]
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

        #uncover(5)[
          ...weitere Szenarien um z.B. Edgecases abzudecken
        ]
      ],
    )
  ]

  #content-slide([Exkurs: Verhalten in Go Test abbilden])[
    #show raw: set text(size: 12pt)
    #toolbox.side-by-side(
      [
        ```go
        func TestMeasurementOutOfTolerance(t *testing.T) {
          pin1db := setupTestDB(t)
          templateRepo := templaterepo.New(db)
          measurementRepo := measurementrepo.New(db)
          mde := app.New(templateRepo, measurementRepo)

          templateID, _ := template.NewID("MV123")
          dimensions := []template.Dimension{{ ... }}
          mde.CreateTemplate(ctx, app.CreateTemplate{
            ID: templateID, Dimensions: dimensions,
          })

          measurementID, _ := app.StartMeasurement(ctx,
            app.StartMeasurement{TemplateID: templateID})pin2
        ```
      ],
      [
        ```go
          pin3mde.MeasureValue(ctx, app.ObserveValueCommand{pin7
            MeasurementID: measurementID,
            Label: template.MustNewLabel("Durchmesser"),
            Value: 3.7, // außerhalb Toleranz!
          })pin4

          pin5status, _ := app.GetMeasurementStatus(ctx,
            app.GetMeasurementStatus{MeasurementID: measurementID})

          assert.True(t, status.IsFinished)
          assert.False(t, status.IsDimensionallyAccurate)pin6
        }
        ```
      ],
    )

    #uncover(2)[
      #pinit-highlight(1, 2, fill: green.transparentize(80%))
      #pinit-highlight(3, 4, 7, fill: blue.transparentize(80%))
      #pinit-highlight(5, 6, fill: orange.transparentize(80%))
      #pinit-place((1, 2), dy: 4cm, text(fill: green.darken(50%))[Given])
      #pinit-place((3, 4, 7), dy: -2.25cm, text(fill: blue.darken(50%))[When])
      #pinit-place((5, 6), dy: 2cm, text(fill: orange.darken(50%))[Then])
    ]
  ]

  #content-slide([Refactored: Funktionen extrahiert])[
    ```go
    func TestMeasurementOutOfTolerance(t *testing.T) {
      // Given
      app := setupApp(t)
      templateID := givenTemplateExists(t, app, "MV123", []Dimension{
        { Label: "Durchmesser", Unit: "mm",
          Nominal: 3.5, Lower: 3.4, Upper: 3.6,
        },
      })
      measurementID := givenMeasurementStarted(t, app, templateID)

      // When
      whenIObserveValue(t, app, measurementID, "Durchmesser", 3.7)

      // Then
      thenMeasurementIsFinished(t, app, measurementID)
      thenItIsNotDimensionallyAccurate(t, app, measurementID)
    }
    ```
  ]

  #content-slide([Weiter refactored: Suite mit Methoden])[
    Lokale Variablen wandern in die Suite
    #toolbox.side-by-side(
      columns: (1fr, 1fr),
      [
        *Go-Test*
        #set text(size: 11pt)
        ```go
        func TestMeasurementOutOfTolerance(t *testing.T) {
          suite := &testSuite{app: setupApp(t)}
          suite.givenTemplateExists("MV123", []Dimension{...})
          suite.givenMeasurementStarted()
          suite.whenIObserveValue("A", 3.7)
          suite.thenMeasurementIsFinished(t)
          suite.thenItIsNotDimensionallyAccurate(t)
        }
        ```
      ],
      [
        #uncover(2)[
          *Gherkin*
          #set text(size: 11pt)
          ```feature
          Szenario: Messwert außerhalb Toleranz
            Angenommen Messvorlage "MV123"
              mit Dimensionen existiert:
              | Name        | Einheit | Nominal |
              | Durchmesser | mm      | 3.5     |
            Und eine Messung gestartet wurde

            Wenn der Wert 3.7 für "A" erfasst wird

            Dann ist die Messung vollständig
            Und das Teil ist nicht maßhaltig
          ```
        ]
      ],
    )
  ]

  #content-slide([Implementierung mit Godog: Steps definieren])[
    Jeder Gherkin-Step wird via Regex einer Suite-Methode zugeordnet
    #toolbox.side-by-side(
      columns: (1fr, auto),
      [
        ```go
        func InitializeScenario(sc *godog.ScenarioContext) {
          suite := &testSuite{}

          sc.Before(func(context.Context, sc *godog.Scenario) {
            suite.app = setupApp()
          })

          sc.Given(`^Messvorlage "([^"]*)" mit Dimensionen existiert:$`,
            suite.givenTemplateExists)
          sc.When(`^der Wert ([\d.]+) für "([^"]*)" erfasst wird$`,
            suite.whenIObserveValue)
          sc.Then(`^die Messung vollständig$`,
            suite.thenMeasurementIsFinished)

          ...
        }
        ```
      ],
      [ #image("../assets/godog.png", height: 5cm) ],
    )
  ]

  #content-slide([Test Suite ausführen])[
    #toolbox.side-by-side(
      columns: (1fr, auto),
      [
        #set text(size: 14pt)

        ```go
        func TestFeatures(t *testing.T) {
          suite := godog.TestSuite{
            ScenarioInitializer: pin1InitializeScenariopin2,
            Options: &godog.Options{
              Format:   "pretty",
              Paths:    []string{"features"},
              TestingT: t,
            },
          }

          if suite.Run() != 0 {
            t.Fatal("non-zero status returned")
          }
        }
        ```

        #pinit-highlight(1, 2, fill: blue.transparentize(80%))
      ],
      [ #image("../assets/godog.png", height: 5cm) ],
    )
  ]

  #content-slide([Run the Test])[
    #set align(horizon + center)
    #image("../assets/godog-run.png", height: 1fr)

    // Floating GopherHappy
    #place(horizon + right, dx: 5%, image(
      "../assets/GopherHappy.png",
      height: 8em,
    ))
  ]

  #section-slide([Gherkin Highlights])[]

  #content-slide([Background])[
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

  #content-slide([Szenario Outline])[
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

  #content-slide([Table])[
    #toolbox.side-by-side(
      columns: (2fr, 1fr),
      [
        ```go
        // ^Messvorlage "(MV\d+)" existiert$
        func GivenTemplateExists(
          ctx context.Context,
          id string,
          table *godog.Table,
        ) {
          for _, row := range table.Rows[1:] {
            // row.Cells[0] -> Dimension
            // row.Cells[2] -> Nominal
          }
        }
        ```
      ],
      [
        ```feature
        Angenommen Messvorlage "MV123" existiert
          | Dimension | Nomininal |
          | A         |       5mm |
          | B         |      42mm |
          | C         |   1337deg |
        ```
      ],
    )
  ]

  #content-slide([DocString])[
    #toolbox.side-by-side(
      [
        ```feature
        Feature: Ceaser Cipher Encryption

          Scenario: Encrypt a Message
            When I run rotcli with input:
              """
              HELLO WORLD
              """
            Then the output should be:
              """
              URYYB JBEYQ
              """
        ```
      ],
      [
        ```go
        // "^the output should be:$"
        func(ctx context.Context,
          input *godog.DocString,
        ) error {
          expected := input.Content
          actual := getOutput(ctx)
          // Compare
        },
        ```
      ],
    )
  ]

  #section-slide[Tools die wir nutzen][ ]

  #content-slide[Ghokin][
    #toolbox.side-by-side(
      [
        *Formatter für Gherkin files* \
        #link("https://github.com/antham/ghokin")
        - In go geschrieben
        - Kann DocStrings formatieren
      ],
      [
        #align(center)[
          ```feature
          Scenario: A scenario to test
            Given a thing
            # @json
            """
            {
              "test": "test"
            }
            """
          ```
        ],
      ],
    )

  ]

  #content-slide[Godotils][
    #toolbox.side-by-side(
      [
        *Ergonomische API für godog.Table* \
        #link("https://github.com/lukasngl/godotils")
        - (Shamelessss Plug)
      ],
      [
        #align(center)[
          ```go
          type Row struct {
              Name  string  `table:"name"`
              Age   int     `table:"age"`
          }

          table := godotils.Table([][]string{
              {"name", "age"},
              {"Alice", "30", "95.5"},
              {"Bob", "25", "87.3"},
          })

          var rows []Row
          err := godotils.UnmarshalTable(table, &rows)
          ```
        ],
      ],
    )

  ]

  #content-slide[Godotils][
    #toolbox.side-by-side(
      [
        *Ergonomische API für godog.Table* \
        #link("https://github.com/lukasngl/godogen")
        - Step Patterns als directive direkt an der Funktion
        - Inklusive Linter
        - `InitializeSteps` wird via code-gen erstellt
        - Kann (noch) keine Methoden Steps
          - State muss mittels `context.Context` durchgeschleift werden

      ],
      [
        #align(center)[
          ```go
          //godog:step ^I eat (\d+)$
          func iEat(num int) {
            // ...
          }
          ```
        ],
      ],
    )

  ]

  #section-slide([Fazit])[
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
      ],
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
    - Testmethoden als lesbare Sätze
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

    #place(bottom + left, dx: 0%, dy: 6%, text(size: 11pt)[
      Quelle: #link("https://dannorth.net/blog/introducing-bdd/")[Dan North - Introducing BDD]
    ])

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
      ],
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
      ],
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
        #link(
          "https://www.linkedin.com/posts/davidavpereira_fixing-production-bugs-is-640x-more-expensive-activity-7286021036976857089-UHmI/",
        )[David Pereira]
      ],
    )
  ]

  #slide[
    #image("../assets/TestPyramide.svg", width: 80%)
  ]

  #content-slide([Alternative: Ginkgo])[
    #set text(size: 16pt)

    *Ein weiteres BDD-Framework für Go*

    #v(1em)

    *Was ist Ginkgo?*
    - BDD Testing Framework für Go
    - Fokus auf ausdrucksstarke, lesbare Tests
    - Arbeitet mit Gomega Matcher-Library zusammen

    #v(1em)

    *Key Features:*
    - Verschachtelte Test-Organisation mit `Describe`, `Context`, `When`
    - Parallelisierung & Randomisierung von Tests
    - Umfangreiche Setup/Teardown-Möglichkeiten
    - Flexibel: Unit-, Integration- & Performance-Tests

    #v(1.5em)

    #text(size: 11pt)[
      Quelle: #link("https://github.com/onsi/ginkgo")[github.com/onsi/ginkgo]
    ]
  ]

  #content-slide([Ginkgo vs. Godog])[
    #set text(size: 16pt)

    *Beispiel: Ginkgo-Syntax*
    ```go
    Describe("Checking books out", func() {
        When("the library has the book", func() {
            It("lends it to the reader", func() {
                // Test logic
            })
        })
    })
    ```

    #v(1em)

    *Der Unterschied:*

    #grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      align(left)[
        *Ginkgo*
        - Code-basiertes BDD
        - Tests in Go geschrieben
        - Strukturiert & lesbar
        - Für Developer
      ],
      align(left)[
        *Godog*
        - Cucumber-Style
        - Natural Language (Gherkin)
        - Feature-Files
        - Für alle Stakeholder
      ],
    )
  ]

  #content-slide([Warum Ginkgo keine gute Wahl ist])[
    #set text(size: 14pt)

    #v(1em)

    #grid(
      columns: (60%, 40%),
      column-gutter: 2em,
      [
        - *Gomega Matcher-Probleme*
          - Eigene DSL für Assertions (nicht Standard-Go)
          - Steile Lernkurve für neue Teammitglieder
          - Fehler sind oft schwer zu verstehen
          - Beispiel: `Expect(result).To(BeNumerically(">=", 42))`

        #v(0.5em)

        - *Nur für Entwickler lesbar*
          - Code bleibt Code – keine natürliche Sprache
          - Stakeholder können Tests nicht lesen oder reviewen
          - Keine direkte Dokumentation für nicht-technische Personen

        #v(0.5em)

        - *Kein echter BDD-Workflow*
          - Keine Trennung zwischen Spezifikation und Implementierung
          - Tests sind immer noch eng an Code gekoppelt
          - Kollaboration mit Business bleibt schwierig
      ],
      align(horizon + center)[
        #text(size: 14pt, style: "italic", fill: orange.darken(20%))[
          Ginkgo verbessert die Teststruktur, \
          löst aber nicht das \
          Kommunikationsproblem \
          zwischen Teams
        ]
      ],
    )
  ]

  #content-slide([Herausforderungen von BDD/Cucumber])[
    #set text(size: 15pt)

    - *Akzeptanz*
      - Widerstand gegen neue Arbeitsweise
      - "Das ist doch nur für Developer" – mangelndes Verständnis des Wertes
      - Stakeholder nehmen sich keine Zeit für Feature-Reviews

    #v(0.5em)

    - *Hoher Aufwand* bei Erstellung und Wartung von Szenarien
      - Jedes Szenario muss manuell geschrieben werden
      - Änderungen an Features erfordern Updates vieler Szenarien

    #v(0.5em)

    - *Begrenzte Ausdruckskraft*
      - Komplexe Logik schwer in Gherkin abbildbar
      - Tendenz zu technischen Details in Business-Szenarien
  ]

  #content-slide([Noch mehr Herausforderungen])[
    #set text(size: 15pt)

    - *Wenig Einblick in Coverage & Qualität*
      - Welche Kombinationen wurden getestet?
      - Wo sind Lücken in der Testabdeckung?
      - Welche Szenarien sind wirklich relevant?

    #v(0.5em)

    - *Skalierungsprobleme*
      - Hunderte von Features schwer zu überblicken
      - Redundanz und Inkonsistenzen können zunehmen
  ]

  #content-slide([Ausblick: Modellbasierter Ansatz])[
    #set text(size: 15pt)

    *Ein vielversprechender Forschungsansatz*

    #v(1em)

    Statt manuell geschriebener Szenarien werden *formale Modelle* zur Grundlage verwendet:

    #v(1em)

    #grid(
      columns: (1fr, 1fr),
      column-gutter: 1.5em,
      align(left)[
        *Vorteile:*
        - Automatische Testgenerierung
        - Impact-Analysen
        - Regression Test Selection
        - Qualitätsbewertungen
      ],
      align(left)[
        *Möglichkeiten:*
        - Effizientere Zusammenarbeit
        - Tiefe Einblicke in Risiken
        - KI-Integration in BDD
        - Systematische Coverage
      ],
    )

    #v(1.5em)

    #align(center)[
      #text(size: 14pt, style: "italic", fill: blue.darken(20%))[
        Der modellbasierte Ansatz ist aktuell noch Forschungsthema, \
        zeigt aber vielversprechende Potenziale für die Zukunft von BDD
      ]
    ]

    #place(
      bottom + right,
      dx: -1em,
      dy: -1em,
      text(size: 11pt)[
        #link(
          "https://www.meetup.com/de-DE/ict-improve/events/310953461/?eventOrigin=group_similar_events",
        )[
          → "Gherkin is dead, long live BDD?", 21.10. in Eindhoven
        ]
      ],
    )
  ]

]

#slides
