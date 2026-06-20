#let size(level) = {
  if level == 1 { 18pt } else if level == 2 { 16pt } else { 14pt }
}

#let before(level) = {
  if level == 1 { 0pt } else if level == 2 { 32pt } else { 27pt }
}

#let after(level) = {
  if level == 1 { 36pt } else if level == 2 { 27pt } else { 24pt }
}

#let thesis(
  body,
) = {
  set page(
    paper: "a4",
    margin: (left: 3cm, right: 1cm, top: 2cm, bottom: 2cm),
  )

  set text(
    font: "Liberation Serif",
    size: 14pt,
    lang: "ru",
    region: "ru",
    hyphenate: auto,
  )

  set par(
    justify: true,
    spacing: 1.05em,
    leading: 1.05em,
    first-line-indent: (amount: 1cm, all: true),
  )

  set outline(
    title: "Содержание",
    depth: 2,
    indent: 0em,
  )

  show outline.entry: it => {
    let el = it.element

    link(el.location(), {
      let content = upper(it.indented(it.prefix(), it.inner()))

      if el.supplement == [Приложение] {
        content = if el.level == 1 {
          upper(it.indented([#it.element.supplement #it.prefix().], it.inner()))
        } else {
          none
        }
      } else if el.numbering != none {
        let nums = counter(heading).at(el.location())

        content = grid(
          columns: (30pt, 1fr),
          gutter: 0pt,
          context numbering(el.numbering, ..nums) + ".", upper(it.indented(none, it.inner())),
        )
      }

      if el.level == 1 {
        block(above: 1.5em, content)
      } else {
        content
      }
    })
  }

  set heading(numbering: "1.1")

  show heading: it => {
    set text(size: size(it.level), weight: "bold", hyphenate: false)
    set align(center)

    if it.level == 1 {
      pagebreak(weak: true)
    }

    block(above: before(it.level), below: after(it.level))[
      #if it.numbering != none {
        counter(heading).display(it.numbering) + "."
      }
      #upper(it.body)
    ]
  }

  set figure.caption(
    separator: sym.dash.fig,
  )

  show figure.caption: it => context [
    #it.supplement~#it.counter.display()~#it.separator~#it.body
  ]

  show figure.where(kind: image): set figure(
    supplement: "Рисунок",
  )

  show figure.where(kind: table): set figure(
    supplement: "Таблица",
  )

  set math.equation(numbering: "(1)")
  show math.equation.where(block: true): set block(above: 24pt, below: 24pt)

  show ref: it => {
    let el = it.element

    if el != none and el.has("numbering") {
      let format = if el.func() == math.equation {
        "1"
      } else {
        el.numbering
      }

      link(el.location(), context numbering(
        format,
        ..counter(el.func()).at(el.location()),
      ))
    } else {
      it
    }
  }

  set list(indent: 1cm)
  set enum(indent: 1cm)

  show figure: set block(above: 24pt, below: 24pt)
  show list: set block(above: 24pt, below: 24pt)
  show enum: set block(above: 24pt, below: 24pt)

  show raw.where(block: true): it => {
    set text(font: "Liberation Mono", size: 12pt)
    set block(above: 24pt, below: 24pt)
    set par(
      leading: 0.65em,
    )

    it
  }

  set bibliography(title: "Список литературы", style: "gost-r-705-2008-numeric.csl")

  body
}

#let preview(body, kwd: "") = {
  heading(numbering: none, outlined: false)[Аннотация]

  [
    Отчет
    #context {
      let pages = 64
      let chapters = query(heading)
        .filter(h => h.level == 1)
        .filter(h => h.supplement != [Приложение])
        .filter(h => h.numbering != none)
        .len()
      let figs = query(figure.where(kind: image))
        .filter(f => {
          let lh = query(heading.where(level: 1).before(f.location())).last()
          return lh.supplement != [Приложение]
        })
        .len()
      let tables = counter(figure.where(kind: table)).final().at(0)
      let cites = query(selector(ref)).filter(it => it.element == none).map(it => it.target).dedup().len()
      let apps = query(heading).filter(h => h.level == 1).filter(h => h.supplement == [Приложение]).len()

      [#pages с., #chapters ч., #figs рис., #tables табл., #cites источн., #apps
        прил.]
    }

    #block(above: 2em, below: 2em)[
      #set text(
        hyphenate: false,
      )

      #kwd
    ]
  ]

  body
}

#let appendix(body) = {
  let ru(n) = {
    let alphabet = "АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ".split("")
    alphabet.at(n - 1, default: str(n))
  }

  set heading(
    supplement: "Приложение",
    numbering: (..nums) => {
      ru(nums.pos().at(0))
    },
  )

  show heading: it => {
    set text(size: size(it.level), weight: "bold", hyphenate: false)
    set align(center)

    if it.level == 1 {
      pagebreak(weak: true)

      counter(figure.where(kind: image)).update(0)
      counter(math.equation).update(0)
    }

    block(above: before(it.level), below: after(it.level))[
      #if it.numbering != none {
        if it.level == 1 {
          [
            #upper(it.supplement)
            #counter(heading).display(it.numbering).
          ]
        }
      }
      #upper(it.body)
    ]
  }

  set math.equation(numbering: num => context [
    #let lh = query(heading.where(level: 1).before(here())).last()
    #let hn = numbering(lh.numbering, ..counter(heading).at(lh.location()))

    (#hn.#numbering("1", num))
  ])

  show figure.caption: it => context [
    #let lh = query(heading.where(level: 1).before(it.location())).last()
    #let hn = numbering(lh.numbering, ..counter(heading).at(lh.location()))

    #it.supplement~#hn.#it.counter.display()~#it.separator~#it.body
  ]

  show ref: it => {
    let el = it.element

    if el != none and el.has("numbering") {
      let num = none
      let fmt = none

      if el.func() == math.equation {
        fmt = "1"
        num = counter(math.equation).at(el.location())
      } else {
        fmt = el.numbering
        num = counter(figure.where(kind: image)).at(el.location())
      }

      let lh = query(heading.where(level: 1).before(el.location())).last()
      let hn = numbering(lh.numbering, ..counter(heading).at(lh.location()))
      let en = numbering(fmt, ..num)

      link(el.location())[#hn.#en]
    } else {
      it
    }
  }

  counter(heading).update(1)

  body
}

#let integration(body, who: "", seat: "") = {
  set page(
    paper: "a4",
    margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
    numbering: none,
  )

  counter(page).update(i => i - 1)

  show heading: it => {
    set text(size: size(it.level), weight: "bold")
    set align(center)

    block(above: before(it.level), below: after(it.level))[
      #upper(it.body)
    ]
  }

  align(right)[
    УТВЕРЖДАЮ \
    #seat \
    #who \
    #v(14pt)
    "#box(width: 1cm, stroke: (bottom: 1pt))"
    #h(4pt)
    #box(width: 3cm, stroke: (bottom: 1pt))
    #h(4pt)
    2026 г.
  ]

  align(horizon)[
    #heading(numbering: none, outlined: false)[Акт внедрения]
    #body
    #v(24pt)
  ]

  columns(2)[
    #block[#seat]

    #colbreak()

    #v(28pt)
    #align(right)[
      #box(
        width: 3cm,
        stroke: (top: 1pt),
        inset: (top: 8pt),
      )[#align(center)[_(подпись)_]]
      #box(
        width: 5cm,
        stroke: (top: 1pt),
        inset: (top: 8pt),
      )[#align(center)[_(расшифровка)_]]
    ]
  ]
}
