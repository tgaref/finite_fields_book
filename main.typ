#import "template.typ": *

#show: book-setup.with(
  title: "Πεπερασμένα Σώματα και Εφαρμογές",
  author: "Θεόδουλος Γαρεφαλάκης",
)

// Title Page
#align(center + horizon)[
  #text(size: 24pt, weight: "bold")[Πεπερασμένα Σώματα και Εφαρμογές]
  
  #v(1.5cm)
  #text(size: 14pt)[Σημειώσεις]
  
  #v(2cm)
  #text(size: 14pt, weight: "bold")[Θεόδουλος Γαρεφαλάκης]
  
  #v(2cm)
  #text(size: 12pt)[Οκτώβριος 2026]
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
#part(title: "Πεπερασμένα Σώματα")

= Αλγεβρικό υπόβαθρο
#include "algebraic_background.typ"

= Στοιχεία θεωρίας σωμάτων
#include "field_theory.typ"

= Πεπερασμένα σώματα
#include "finite_fields.typ"

#part(title: "Κωδικοποίηση")

= Εισαγωγή στη Θεωρία Κωδίκων
#include "coding_intro.typ"

= Γραμμικοί κώδικες
#include "linear_codes.typ"


// Bibliography
#pagebreak()
#bibliography("bib.bib", title: "Βιβλιογραφία", style: "ieee", full: true)
