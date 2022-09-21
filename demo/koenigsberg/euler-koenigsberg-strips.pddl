;; euler-koenigsberg-strips.pddl - the classical "Seven
;; bridges of Königsberg" problem using a STRIPS goal

(define (problem euler-koenigsberg)

 (:domain bridges)

 (:objects
  altstadt
  vorstadt
  kneiphof
  lomse

  gruene-bruecke
  kraemerbruecke
  schmiedebruecke
  koettelbruecke
  honigbruecke
  holzbruecke
  hohe-bruecke
  )

 (:init
  (IS-LAND-MASS altstadt)
  (IS-LAND-MASS vorstadt)
  (IS-LAND-MASS kneiphof)
  (IS-LAND-MASS lomse)

  (IS-BRIDGE gruene-bruecke)
  (IS-BRIDGE kraemerbruecke)
  (IS-BRIDGE schmiedebruecke)
  (IS-BRIDGE koettelbruecke)
  (IS-BRIDGE honigbruecke)
  (IS-BRIDGE holzbruecke)
  (IS-BRIDGE hohe-bruecke)

  (CONNECTS gruene-bruecke vorstadt kneiphof)
  (CONNECTS gruene-bruecke kneiphof vorstadt)
  (CONNECTS kraemerbruecke altstadt kneiphof)
  (CONNECTS kraemerbruecke kneiphof altstadt)
  (CONNECTS schmiedebruecke altstadt kneiphof)
  (CONNECTS schmiedebruecke kneiphof altstadt)
  (CONNECTS koettelbruecke vorstadt kneiphof)
  (CONNECTS koettelbruecke kneiphof vorstadt)
  (CONNECTS honigbruecke kneiphof lomse)
  (CONNECTS honigbruecke lomse kneiphof)
  (CONNECTS holzbruecke altstadt lomse)
  (CONNECTS holzbruecke lomse altstadt)
  (CONNECTS hohe-bruecke vorstadt lomse)
  (CONNECTS hohe-bruecke lomse vorstadt)

  (is-current-location kneiphof)
  )

 (:goal
  (and
   (bridge-has-been-used gruene-bruecke)
   (bridge-has-been-used kraemerbruecke)
   (bridge-has-been-used schmiedebruecke)
   (bridge-has-been-used koettelbruecke)
   (bridge-has-been-used honigbruecke)
   (bridge-has-been-used holzbruecke)
   (bridge-has-been-used hohe-bruecke)
   ))
)
