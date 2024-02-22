#import "@preview/tidy:0.2.0"
#import "@preview/harbinger:1.0.0"

#set text(font: "New Computer Modern Sans")

#align(center)[
  #text(24pt)[*harbinger*]
  #v(1em, weak:true)
  #text(12pt)[A package for shadow boxes in Typst.]
]

#show terms.item: it => [- #par(hanging-indent: 1em)[*#it.term:*  #it.description]]

#set heading(numbering: "1.1.")

#show heading: it => [
  #if it.level==1 and it.numbering!=none {
    pagebreak(weak: true)
  }
  #if it.level > 2 {
    it.body
  }else {
    it 
  }

]

#outline(depth: 3, indent:1em )

= Docs

#let docs = tidy.parse-module(read("src/shadow-box.typ"), scope: (harbinger:harbinger), name: "shadow-box")

#tidy.show-module(docs, style: tidy.styles.default)


#pagebreak()

#let docs2 = tidy.parse-module(read("src/fast-shadow-box.typ"), scope: (harbinger:harbinger), name: "fast-shadow-box")

#tidy.show-module(docs2, style: tidy.styles.default)