#import "template.typ": *

#show: book-setup.with(
  title: "Πεπερασμένα Σώματα και Εφαρμογές"
)

// Title Page
#align(center + horizon)[
  #text(size: 24pt, weight: "bold")[Πεπερασμένα Σώματα και Εφαρμογές]
  
  #v(2cm)
  #text(size: 14pt)[Σημειώσεις Διδασκαλίας]
]

#pagebreak()

// Table of Contents
#outline(
  title: "Περιεχόμενα",
  indent: auto,
  depth: 3
)

#pagebreak()
#counter(page).update(1)

// Chapters
#part()

= Αλγεβρικό υπόβαθρο
#include "algebraic_background.typ"

= Στοιχεία θεωρίας σωμάτων
#include "field_theory.typ"

= Πεπερασμένα σώματα
#include "finite_fields.typ"

// Bibliography
#pagebreak()
#bibliography("bib.bib", title: "Βιβλιογραφία", style: "ieee", full: true)
