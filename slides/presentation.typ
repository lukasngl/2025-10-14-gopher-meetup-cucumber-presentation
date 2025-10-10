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
    Structure: Problem → Solution → Payoff with recurring characters (Developer, Stakeholder, Colleague)
  ```]

  #set text(size: 11pt)
  #columns(2)[

    *1. Introduction (3-5 min)*
    - Who we are
    - Hook: "Testing is important, but who actually reads the tests?"

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

]

#slides
