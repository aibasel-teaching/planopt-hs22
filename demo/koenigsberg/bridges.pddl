;; bridges.pddl - generalizes the "Seven bridges of
;; Königsberg" problem

(define (domain bridges)

  (:requirements :strips)

  (:predicates
   (IS-LAND-MASS ?lm)
   (IS-BRIDGE ?b)
   (CONNECTS ?b ?lm1 ?lm2)
   (is-current-location ?lm)
   (bridge-has-been-used ?b)
   )

  (:action cross-bridge
           :parameters (?b ?lm1 ?lm2)
           :precondition (and
                          (IS-BRIDGE ?b)
                          (IS-LAND-MASS ?lm1)
                          (IS-LAND-MASS ?lm2)
                          (CONNECTS ?b ?lm1 ?lm2)
                          (is-current-location ?lm1)
                          (not (bridge-has-been-used ?b))
                          )
           :effect (and
                    (bridge-has-been-used ?b)
                    (not (is-current-location ?lm1))
                    (is-current-location ?lm2)))
)
