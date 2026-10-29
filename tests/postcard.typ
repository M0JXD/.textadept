#let auto-fit-image(bytes, flipped) = context {
  let img = image(bytes)
  let (width, height) = measure(img)
  if flipped {
    if width < height {
      image(width: 101%, bytes)
    } else {
      image(height: 101%, bytes)
    }
  } else {
    if width < height {
      image(height: 101%, bytes)
    } else {
      image(width: 101%, bytes)
    }
  }
}

#let divider-line(length, stroke) = {
  length = (100% - length) / 2
  line(start: (0%, length), end: (0%, 100% - length), stroke: stroke)
}

#let right-side(stamp-area, address-area) = {
  grid(
    columns: 100%,
    rows: (1fr, auto),
    align: bottom + right,
    stamp-area,
    address-area,
  )
}

#let address-area(stroke, entries, gutter, length) = {
  let address-table-args = (
    columns: length,
    row-gutter: gutter,
    align: left + bottom,
    stroke: (_, y) => { (bottom: stroke) },
  )
  if type(entries) == array {
    table(..address-table-args, ..entries)
  } else if type(entries) == int {
    address-table-args.insert("rows", entries)
    table(..address-table-args)
  } else {
    [address-lines must be either of type 'array' or 'int']
  }
}

#let stamp-area(post-stamp) = {
  if type(post-stamp) == content {
    align(top + right, post-stamp)
  }
}

#let postcard(
  motif: none,
  background-motif: none,
  margin: 10%,
  paper: "a6",
  flipped: true,
  post-stamp: none,
  footer: none,
  address-lines: 4,
  address-lines-gutter: 10pt,
  address-line-length: 90%,
  address-stroke: stroke(thickness: 0.3mm),
  divider-dx: 50%,
  divider-length: 100%,
  divider-stroke: stroke(thickness: 0.5mm),
  divider-gutter: 15%,
  body,
) = {
  set page(
    paper: paper,
    flipped: flipped,
    margin: 0%,
  )

  if type(motif) == content {
    motif
    pagebreak()
  } else if type(motif) == bytes {
    auto-fit-image(motif, flipped)
    pagebreak()
  }


  set page(
    margin: margin,
    footer: footer,
    footer-descent: 0%,
    background: background-motif,
  )

  // using layout creates a weird gap?
  context {
    // funky shit
    let width = float(repr(page.width).trim("pt"))
    let height = float(repr(page.height).trim("pt"))

    let normalize-factor = 1

    if margin != 0% {
      normalize-factor = (width * height) / ((width * height) * float(100% - 2 * margin))
    }

    place(dx: divider-dx, divider-line(
      divider-length * normalize-factor,
      divider-stroke,
    ))
  }

  grid(
    columns: (divider-dx - divider-gutter / 2, divider-gutter, auto),
    block(body),
    block(),
    right-side(
      stamp-area(post-stamp),
      address-area(
        address-stroke,
        address-lines,
        address-lines-gutter,
        address-line-length,
      ),
    ),
  )
}

/* AFTER */

#import "@preview/basic-postcard:1.0.0": postcard

#show: postcard.with(
  motif: image("pretty-picture.png")
)
Hey, i recently visited the "Curly Bar" and it was simply *amazing*!

Best Regards

/* SUPER AFTER */

#show: postcard.with(
  // This parameter can be also of type content or none if you want to omit it.
  // This way however the template will try to fill out the entire page with your image.
  motif: read(encoding: none, "example.png"),
  // This parameter can be also of type none if you want to omit it.
  background-motif: image(width: 85%, "triangles.png"),
  // Parameter of type length, will just be passed to the margin parameter of the page function.
  margin: 5%,
  // Parameter of type string, will just be passed to the paper parameter of the page function.
  paper: "a6",
  // Parameter of type bool, will just be passed to the flipped parameter of the page function. Useful if you want a portrait postcard.
  flipped: true,
  // Parameter of type content or none, will insert a placeholder post-stamp in the upper right corner.
  post-stamp: [#rect(height: 30.13mm, width: 31.80mm, align(horizon + right, text(size: 5em, emoji.mail)))],
  // Parameter of type content, will just be passed to the footer parameter of the page function.
  footer: [Retro Landscape by GrossKahn, 2020],
  // Parameter of type array or int, if you input an array, a line for every element will be created together with it's content. For int there will be the value of int lines created.
  address-lines: ("John Doe", "7 Hairy Man Road", "Round Rock", "Texas", "78681", "USA"),
  // Parameter of type length, the spacing between address-lines.
  address-lines-gutter: 1pt,
  // Parameter of type length, the length of address-lines.
  address-line-length: 80%,
  // Parameter of type stroke, the stroking of the address-lines.
  address-stroke: stroke(1pt + color.fuchsia.darken(50%)),
  // Parameter of type length, the amount by which the big line in the middle is offset to the right.
  divider-dx: 60%,
  // Parameter of type length, the length of the big line in the middle. Set it to 0% to omit the divider-line. Note: The divider line does not respect the postcard margin.
  divider-length: 90%,
  // Parameter of type stroke, the stroking of the big line in the middle.
  divider-stroke: stroke(4pt + gradient.linear(..color.map.flare, angle: 90deg)),
  // Parameter of type length, the space between the writing-area/address-area and the divider.
  divider-gutter: 5%,
)
