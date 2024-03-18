#import "@preview/tidy:0.2.0"
#import "@preview/harbinger:1.0.0"

#set text(font: "New Computer Modern Sans")

#align(center)[
  #text(24pt)[*harbinger*]
  #v(1em, weak:true)
  #text(12pt)[A package for shadow boxes in Typst.]
]

#show terms.item: it => [- #par(hanging-indent: 1em)[*#it.term:*  #it.description]]


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

#let docs = tidy.parse-module((read("src/shadow-box.typ"),read("src/fast-shadow-box.typ")).join(), scope: (harbinger:harbinger), name: "functions")

#tidy.show-module(docs)

