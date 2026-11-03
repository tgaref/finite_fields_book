#let setminus = math.without
#let lcm = math.op("lcm")
#let ord = math.op("ord")
#let char = math.op("char")
#let enc = math.op("enc")
#let dec = math.op("dec")
#let wt(x) = $op("wt")(#x)$
#let dist = math.op("d")
#let an(..args) = $chevron.l #args.pos().join($,$) chevron.r$
#let ff(q) = $FF_(#q)$
#let Ball = math.op("B")
#let supp = math.op("supp")
#let span = math.op("span")
#let rank = math.op("rk")
#let pmod(n) = $#h(0.3em) (op("mod") #n)$
#let part-counter = counter("part")

#let part(title: none) = {
  part-counter.step()
  context {
    let p-num = part-counter.display("I")
    let p-title = if title != none [Μέρος #p-num: #title] else [Μέρος #p-num]
    [#heading(level: 1, numbering: none, outlined: true)[#p-title] <part>]
  }
}
// template.typ - Styling and environments for the book

#let book-setup(
  title: "Πεπερασμένα Σώματα και Εφαρμογές",
  author: "Θεόδουλος Γαρεφαλάκης",
  body
) = {
  set document(
    title: title,
    author: if author != none { author } else { () }
  )

  // Page geometry: top=2.0cm, bottom=3.0cm, left=3.5cm, right=3.5cm
  set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 3.5cm, right: 3.5cm),
    header: context {
      let page-num = here().page()
      let i = counter(page).get().first()
      let headings = query(heading.where(level: 1)).filter(h => h.location().page() <= page-num)
      
      // Frontmatter (before Chapter 1 or Part 1)
      if headings.len() == 0 {
        if page-num > 1 {
          align(right)[#text(size: 9pt, fill: luma(80))[#numbering("i", i)]]
        }
      } else {
        // Suppress header on part divider pages
        let parts-on-page = query(heading.where(level: 1)).filter(h => h.location().page() == page-num and h.has("label") and h.label == <part>)
        if parts-on-page.len() > 0 {
          none
        } else {
          // Check if a normal chapter begins on this page
          let chaps-on-page = query(heading.where(level: 1)).filter(h => h.location().page() == page-num and (not h.has("label") or h.label != <part>))
          if chaps-on-page.len() > 0 {
            // Chapter opening page: show page number at top outer margin
            if calc.even(i) {
              align(left)[#text(size: 9pt, fill: luma(80))[#i]]
            } else {
              align(right)[#text(size: 9pt, fill: luma(80))[#i]]
            }
          } else {
            let prev-chaps = query(heading.where(level: 1)).filter(h => h.location().page() < page-num and (not h.has("label") or h.label != <part>))
            if prev-chaps.len() > 0 {
              let last-chap = prev-chaps.last()
              let chap-num = counter(heading).at(last-chap.location()).first()
              if last-chap.numbering != none {
                if calc.even(i) {
                  align(left)[#text(size: 9pt, fill: luma(80))[#i #h(1.5em) Κεφάλαιο #chap-num. #last-chap.body]]
                } else {
                  align(right)[#text(size: 9pt, fill: luma(80))[#last-chap.body #h(1.5em) #i]]
                }
              } else {
                if calc.even(i) {
                  align(left)[#text(size: 9pt, fill: luma(80))[#i #h(1.5em) #last-chap.body]]
                } else {
                  align(right)[#text(size: 9pt, fill: luma(80))[#last-chap.body #h(1.5em) #i]]
                }
              }
            }
          }
        }
      }
    },
    footer: none
  )

  // Typography matching LaTeX Minion Pro and Greek settings
  set text(
    font: ("Minion Pro", "Libertinus Serif", "DejaVu Serif"),
    size: 11pt,
    lang: "el",
    hyphenate: true
  )

  // Paragraph spacing matching LaTeX: skip=8pt, indent=0pt
  set par(
    spacing: 8pt,
    leading: 0.65em,
    justify: true,
    first-line-indent: 0pt
  )

  // Math font
  show math.equation: set text(font: "Libertinus Math")

  // Equation numbering: only number labeled equations as (chapter.number)
  set math.equation(numbering: num => context {
    let h = counter(heading).at(here())
    let chap = if h.len() > 0 { h.first() } else { 0 }
    if chap > 0 {
      "(" + str(chap) + "." + str(num) + ")"
    } else {
      "(" + str(num) + ")"
    }
  })

  show math.equation: it => {
    if it.block and not it.has("label") and it.numbering != none {
      counter(math.equation).update(v => v - 1)
      math.equation(it.body, block: true, numbering: none)
    } else {
      it
    }
  }

  // Heading numbering and styling
  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    if it.has("label") and it.label == <part> {
      pagebreak(weak: true, to: "odd")
      v(1fr)
      align(center)[
        #text(size: 18pt, weight: "regular")[#it.body]
      ]
      v(1fr)
      pagebreak(weak: true)
    } else {
      counter(figure.where(kind: "thm")).update(0)
      counter(math.equation).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      pagebreak(weak: true)
      v(1.5cm)
      block(width: 100%)[
        #if it.numbering != none [
          #text(size: 14pt, weight: "bold", fill: luma(100))[
            Κεφάλαιο #counter(heading).display()
          ]
          #v(0.5em)
        ]
        #text(size: 20pt, weight: "bold")[
          #it.body
        ]
      ]
      v(1cm)
    }
  }

  show heading.where(level: 2): it => {
    v(1.2em)
    block[
      #text(size: 13pt, weight: "bold")[
        #counter(heading).display() #h(0.5em) #it.body
      ]
    ]
    v(0.6em)
  }

  show heading.where(level: 3): it => {
    v(1em)
    block[
      #text(size: 11.5pt, weight: "bold")[
        #counter(heading).display() #h(0.5em) #it.body
      ]
    ]
    v(0.5em)
  }

  // Reference formatting for Greek grammar compatibility
  show ref: it => {
    let el = it.element
    if el != none and el.func() == figure and el.kind == "thm" {
      let chap = counter(heading).at(el.location()).first()
      let num = counter(figure.where(kind: "thm")).at(el.location()).first()
      let num-str = str(chap) + "." + str(num)
      link(el.location(), num-str)
    } else if el != none and el.func() == math.equation {
      let h = counter(heading).at(el.location())
      let chap = if h.len() > 0 { h.first() } else { 0 }
      let num = counter(math.equation).at(el.location()).first()
      let num-str = if chap > 0 { str(chap) + "." + str(num) } else { str(num) }
      link(el.location(), "(" + num-str + ")")
    } else if el != none and el.func() == figure and el.kind != "thm" {
      let chap = counter(heading).at(el.location()).first()
      let num = counter(figure.where(kind: el.kind)).at(el.location()).first()
      let num-str = if chap > 0 { str(chap) + "." + str(num) } else { str(num) }
      link(el.location(), [#el.supplement #num-str])
    } else {
      it
    }
  }

  // Figure caption formatting: chapter.figure
  show figure.caption: it => context {
    if it.kind != "thm" {
      let h = counter(heading).at(here())
      let chap = if h.len() > 0 { h.first() } else { 0 }
      let num = counter(figure.where(kind: it.kind)).at(here()).first()
      let num-str = if chap > 0 { str(chap) + "." + str(num) } else { str(num) }
      [#it.supplement #num-str: #it.body]
    } else {
      it
    }
  }

  // Figure spacing for non-theorems (diagrams, images, tables)
  show figure.where(kind: image): set block(spacing: 2.2em)
  show figure.where(kind: image): set figure(gap: 1.2em)
  show figure.where(kind: table): set block(spacing: 2em)
  show figure.where(kind: table): set figure(gap: 1em)
  show figure.where(kind: raw): set block(spacing: 2em)
  show figure.where(kind: raw): set figure(gap: 1em)

  // Theorem figure rendering
  show figure.where(kind: "thm"): it => {
    let chap = counter(heading).at(it.location()).first()
    let num = counter(figure.where(kind: "thm")).at(it.location()).first()
    let num-str = str(chap) + "." + str(num)
    block(
      width: 100%,
      breakable: true,
      spacing: 1.2em,
      [
        #set align(left)
        #strong[#it.supplement #num-str#if it.caption != none [ (#it.caption.body)].]
        #h(0.5em)
        #it.body
      ]
    )
  }

  // Show bibliography heading without chapter number
  show bibliography: set heading(numbering: none)

  body
}

// Theorem environments
#let thm-box(supplement, title: none, body, italic: true) = figure(
  kind: "thm",
  supplement: supplement,
  caption: if title != none { title } else { none },
  numbering: "1.1",
  outlined: false,
  if italic { emph(body) } else { body }
)

#let definition(title: none, body) = thm-box("Ορισμός", title: title, body, italic: false)
#let theorem(title: none, body) = thm-box("Θεώρημα", title: title, body, italic: true)
#let proposition(title: none, body) = thm-box("Πρόταση", title: title, body, italic: true)
#let lemma(title: none, body) = thm-box("Λήμμα", title: title, body, italic: true)
#let corollary(title: none, body) = thm-box("Πόρισμα", title: title, body, italic: true)
#let remark(title: none, body) = thm-box("Παρατήρηση", title: title, body, italic: false)
#let example(title: none, body) = thm-box("Παράδειγμα", title: title, body, italic: false)

#let observe(title: none, body) = {
  counter(figure.where(kind: "thm")).step()
  context {
    let chap = counter(heading).get().first()
    let num = counter(figure.where(kind: "thm")).get().first()
    let num-str = str(chap) + "." + str(num)
    block(
      width: 100%,
      spacing: 1.2em,
      [
        #set align(left)
        #strong[Παρατηρήσεις #num-str#if title != none [ (#title)].]
      ]
    )
  }
  body
}

// Proof environment with QED Halmos square
#let proof(body) = block(
  width: 100%,
  breakable: true,
  spacing: 1em,
  [
    #set align(left)
    #emph[Απόδειξη.] #h(0.5em) #body #h(1fr) $square$
  ]
)

// Algorithm box styling
#let algorithm-box(title: none, body) = figure(
  kind: "algorithm",
  supplement: "Αλγόριθμος",
  caption: title,
  outlined: false,
  block(
    stroke: (top: 1pt + black, bottom: 1pt + black),
    inset: (y: 8pt),
    width: 100%,
    [
      #align(left)[
        #set text(size: 10pt)
        #body
      ]
    ]
  )
)

#let algo-line(num, content, indent: 0) = {
  grid(
    columns: (2em, indent * 1.5em, 1fr),
    align: (right + top, left + top, left + top),
    gutter: 0.5em,
    text(fill: luma(120), font: "DejaVu Sans Mono", size: 8pt)[#num],
    [],
    content
  )
}
