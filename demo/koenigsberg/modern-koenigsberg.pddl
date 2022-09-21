;; modern-koenigsberg.pddl - the classical "Seven bridges of
;; Königsberg" problem adapted to modern times

(define (problem euler-koenigsberg)

 (:domain bridges)

 (:objects
  altstadt
  vorstadt
  kneiphof
  lomse

  ; gruene-bruecke ; replaced by nameless concrete bridge
  ; kraemerbruecke ; replaced by nameless concrete bridge
  ; schmiedebruecke
  ; koettelbruecke
  honigbruecke
  holzbruecke
  hohe-bruecke
  concrete-bridge-1
  concrete-bridge-2
  )

 (:init
  (IS-LAND-MASS altstadt)
  (IS-LAND-MASS vorstadt)
  (IS-LAND-MASS kneiphof)
  (IS-LAND-MASS lomse)

  ; (IS-BRIDGE gruene-bruecke)
  ; (IS-BRIDGE kraemerbruecke)
  ; (IS-BRIDGE schmiedebruecke)
  ; (IS-BRIDGE koettelbruecke)
  (IS-BRIDGE honigbruecke)
  (IS-BRIDGE holzbruecke)
  (IS-BRIDGE hohe-bruecke)
  (IS-BRIDGE concrete-bridge-1)
  (IS-BRIDGE concrete-bridge-2)

  ; (CONNECTS gruene-bruecke vorstadt kneiphof)
  ; (CONNECTS gruene-bruecke kneiphof vorstadt)
  ; (CONNECTS kraemerbruecke altstadt kneiphof)
  ; (CONNECTS kraemerbruecke kneiphof altstadt)
  ; (CONNECTS schmiedebruecke altstadt kneiphof)
  ; (CONNECTS schmiedebruecke kneiphof altstadt)
  ; (CONNECTS koettelbruecke vorstadt kneiphof)
  ; (CONNECTS koettelbruecke kneiphof vorstadt)
  (CONNECTS honigbruecke kneiphof lomse)
  (CONNECTS honigbruecke lomse kneiphof)
  (CONNECTS holzbruecke altstadt lomse)
  (CONNECTS holzbruecke lomse altstadt)
  (CONNECTS hohe-bruecke vorstadt lomse)
  (CONNECTS hohe-bruecke lomse vorstadt)
  (CONNECTS concrete-bridge-1 vorstadt kneiphof)
  (CONNECTS concrete-bridge-1 kneiphof vorstadt)
  (CONNECTS concrete-bridge-2 altstadt kneiphof)
  (CONNECTS concrete-bridge-2 kneiphof altstadt)

  (is-current-location kneiphof)
  )

 (:goal (forall (?b) (imply (IS-BRIDGE ?b)
                            (bridge-has-been-used ?b))))
)
