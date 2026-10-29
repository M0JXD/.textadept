// Used to collect sidebar articles.
#let articles = state("articles", ())

// This function gets your whole document as its `body` and formats
// it as the fun newsletter of a college department.
#let newsletter(
  // The newsletter's title.
  title: [Newsletter title],

  // The edition, displayed at the top of the sidebar.
  edition: none,

  // A hero image at the start of the newsletter. If given, should be a
  // dictionary with two keys: A `path` to an image file and a `caption`
  // that is displayed to the right of the image.
  hero-image: none,

  // Details about the publication, displayed at the end of the document.
  publication-info: none,

  // The newsletter's content.
  body
) = {
  // Set document metadata.
  set document(title: title)

  // Configure pages. The background parameter is used to
  // add the right background to the pages.
  set page(
    margin: (left: 2.5cm, right: 1.6cm),
    background: place(right + top, rect(
      fill: red,
      height: 100%,
      width: 7.8cm,
    ))
  )

  // Configure document title
  show std.title: upper
  show std.title: set text(font: "Syne", size: 23pt, weight: 800)

  // Set the body font.
  set text(12pt, font: "Barlow")

  // Configure headings.
  show heading: set text(font: "Syne")
  show heading.where(level: 1): set text(1.1em)
  show heading.where(level: 1): set par(leading: 0.4em)
  show heading.where(level: 1): set block(below: 0.8em)
  show heading: it => {
    set text(weight: 600) if it.level > 2
    it
  }

  // Links should be underlined.
  show link: underline

  // Configure figures.
  set figure(gap: 24pt)
  show figure: it => block({
    // Display a backdrop rectangle.
    move(dx: -3%, dy: 1.5%, rect(
      fill: rgb("FF7D79"),
      inset: 0pt,
      move(dx: 3%, dy: -1.5%, it.body)
    ))

    // Display caption.
    if it.has("caption") {
      show figure.caption: caption => {
        set align(center)
        set text(font: "Syne")
        [-- ]
        caption.body
        if caption.numbering != none {
          [ (] + numbering(caption.numbering, ..counter(figure).at(it.location())) + [)]
        }
        [ --]
      }

      v(if it.has("gap") { it.gap } else { 24pt }, weak: true)
      it.caption
    }

    v(48pt, weak: true)
  })

  // The document is split in two with a grid. A left column for the main
  // flow and a right column for the sidebar articles.
  grid(
    columns: (1fr, 7.8cm - 1.6cm - 18pt),
    column-gutter: 36pt,
    row-gutter: 32pt,

    // Title.
    std.title(),

    // Edition.
    text(fill: white, weight: "medium", 14pt, align(right + bottom, edition)),

    // Hero image.
    context {
      if hero-image == none {
        return
      }

      // Measure the image and text to find out the correct line width.
      // The line should always fill the remaining space next to the image.
      let img = {
        set image(width: 14cm)
        hero-image.image
      }
      let text = text(size: 25pt, fill: white, font: "Syne Tactile", hero-image.caption)
      let img-size = measure(img)
      let text-width = measure(text).width + 12pt
      let line-length = img-size.height - text-width

      grid(
        columns: (img-size.width, 1cm),
        column-gutter: 16pt,
        rows: img-size.height,
        img,
        grid(
          rows: (text-width, 1fr),
          move(dx: 11pt, rotate(
            90deg,
            origin: top + left,
            box(width: text-width, text)
          )),
          line(angle: 90deg, length: line-length, stroke: 3pt + white),
        ),
      )
    },

    // Nothing next to the hero image.
    none,

    // The main flow with body and publication info.
    {
      // A stylized block with a quote and its author.
      show quote: it => {
        if not it.block {
          return it
        }

        box(inset: (x: 0.4em, y: 12pt), width: 100%, {
          set text(font: "Syne")
          grid(
            columns: (1em, auto, 1em),
            column-gutter: 12pt,
            rows: (1em, auto),
            row-gutter: 8pt,
            text(5em)["],
            line(start: (0pt, 0.45em), length: 100%),
            none, none,
            text(1.4em, align(center, it.body)),
            none, none,
            v(8pt) + align(right, text(font: "Barlow")[---#it.attribution]),
          )
        })
      }

      set par(justify: true)
      body
      v(1fr)
      set text(0.7em)
      publication-info
    },

    // The sidebar with articles.
    context {
      set text(fill: white, weight: 500)
      show heading: underline.with(stroke: 2pt, offset: 4pt)
      v(44pt)
      for element in articles.final() {
        element
        v(24pt, weak: true)
      }
    },
  )
}

// An article that is displayed in the sidebar. Can be added
// anywhere in the document. All articles are collected automatically.
#let article(body) = articles.update(it => it + (body,))

#import "@preview/dashing-dept-news:0.1.1": newsletter, article

#show: newsletter.with(
  title: [Chemistry Department],
  edition: [
    March 18th, 2023 \
    Purview College
  ],
  hero-image: (
    image: image("newsletter-cover.jpg"),
    caption: [Award-wining science],
  ),
  publication-info: [
    The Dean of the Department of Chemistry. \
    Purview College, 17 Earlmeyer D, Exampleville, TN 59341. \
    #link("mailto:newsletter@chem.purview.edu")
  ],
)

= The Sixtus Award goes to Purview
It's our pleasure to announce that our department has recently been awarded the highly-coveted Sixtus Award for Excellence in Chemical Research. This is a massive achievement for our department, and we couldn't be prouder.

#quote(block: true, attribution: [Prof. Herzog])[
  Our Lab has synthesized the most elements of them all.
]

The Sixtus Award is a prestigious recognition given to institutions that have demonstrated exceptional performance in chemical research. The award is named after the renowned chemist Sixtus Leung, who made significant contributions to the field of organic chemistry.

This achievement is a testament to the hard work, dedication, and passion of our faculty, students, and staff. Our department has consistently produced groundbreaking research that has contributed to the advancement of the field of chemistry, and we're honored to receive this recognition.

The award will be presented to our department in a formal ceremony that will take place on May 15th, 2023. We encourage all members of our department to join us in celebrating this achievement.

#article[
  = Guest lecture from Dr. Elizabeth Lee
  Elizabeth Lee, a leading researcher in the field of biochemistry, spoke about her recent work on the development of new cancer treatments using small molecule inhibitors, and the lecture was very well-attended by both students and faculty.

  In case you missed it, there's a recording on #link("http://purview.edu/lts/2023-lee")[EDGARP].
]

#article[
  = Safety first
  Next Tuesday, there will be a Lab Safety Training.

  These trainings are crucial for ensuring that all members of the department are equipped with the necessary knowledge and skills to work safely in the laboratory. *Attendance is mandatory.*
]

#figure(
  rect(width: 100%, height: 80pt, fill: white, stroke: 1pt),
  caption: [Our new department rectangle],
)

#article[
  = Tigers win big
  #text(weight: "bold", font: "Syne", pad(x: 12pt, grid(
    columns: (1fr, auto, 1fr),
    row-gutter: 8pt,
    text(32pt, align(right)[12]),
    text(32pt)[---],
    text(32pt)[4],
    align(right)[Tigers],
    none,
    [Eagles]
  )))

  Another great game on the path to win the League. \
  Go tigers!
]

== Another Success
#lorem(20)

#lorem(20)
