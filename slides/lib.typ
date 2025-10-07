#import "@preview/polylux:0.4.0": *
#import "@preview/tiaoma:0.3.0"

#let meko_green = rgb(0, 136, 133)
#let meko_grey = rgb("#4b4c53")

#let setup(body) = {
  set page(
    paper: "presentation-16-9",
    margin: (top: 30mm, x: 18mm, bottom: 10mm),
    header-ascent: 10mm,
    header: toolbox.full-width-block(
      inset: (left: 5%),
      fill: meko_grey,
      image("../assets/logo.svg"),
    ),
    footer: {
      h(1fr)
      set text(size: 12pt)
      toolbox.slide-number
    },
  )

  set text(
    font: "Fira Sans",
    size: 18pt,
  )
  show raw: set text(font: "Fira Code", size: 20pt)

  show emph: set text(fill: meko_green)

  show heading.where(level: 1): set text(size: 23pt, fill: meko_green)
  // show heading.where(level: 1): set block(spacing: 30pt)

  show heading.where(level: 2): set text(fill: meko_grey)

  set list(marker: text(fill: meko_green, sym.bullet), indent: 1em)

  show link: set text(fill: meko_green)
  show link: content => underline(content)

  body
}

#let title-slide(authors: [], title: [], extra: [], url: none) = slide[
  #grid(
    columns: (1fr, 2fr),
    rows: (2fr, 1fr),
    gutter: 1em,
    grid.cell(
      rowspan: 2,
      image(
        "../assets/pickle-gophers_building_the_hannover_rathaus.png",
        alt: "Pickle-Gophers building the Hannover Rathaus",
        height: 100%,
      ),
    ),
    [
      #set align(horizon)
      = #title
      #v(30pt, weak: true)
      #authors
      #v(30pt, weak: true)
      #extra
    ],
    if url != none {
      [
        #set align(bottom)
        #v(30pt, weak: true)
        #grid(
          columns: (auto, 1fr),
          gutter: 1em,
          align: horizon,
          tiaoma.barcode(
            url,
            "QRCode",
            options: (fg-color: meko_green, bg-color: none),
          ),
          {
            set text(size: 14pt)
            link(url)
          },
        )
      ]
    },
  )
]
