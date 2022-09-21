(define (problem random-3x3-10)
(:domain nurikabe)
(:objects
    pos-0-0 pos-0-1 pos-0-2 pos-1-0 pos-1-1 pos-1-2 pos-2-0 pos-2-1 pos-2-2 - cell
    n1 n2 - num
    g0 g1 - group
)
(:init
    (NEXT n0 n1)
    (NEXT n1 n2)
    (CONNECTED pos-0-0 pos-1-0)
    (CONNECTED pos-0-0 pos-0-1)
    (CONNECTED pos-0-1 pos-1-1)
    (CONNECTED pos-0-1 pos-0-2)
    (CONNECTED pos-0-1 pos-0-0)
    (CONNECTED pos-0-2 pos-1-2)
    (CONNECTED pos-0-2 pos-0-1)
    (CONNECTED pos-1-0 pos-2-0)
    (CONNECTED pos-1-0 pos-1-1)
    (CONNECTED pos-1-0 pos-0-0)
    (CONNECTED pos-1-1 pos-2-1)
    (CONNECTED pos-1-1 pos-1-2)
    (CONNECTED pos-1-1 pos-0-1)
    (CONNECTED pos-1-1 pos-1-0)
    (CONNECTED pos-1-2 pos-2-2)
    (CONNECTED pos-1-2 pos-0-2)
    (CONNECTED pos-1-2 pos-1-1)
    (CONNECTED pos-2-0 pos-2-1)
    (CONNECTED pos-2-0 pos-1-0)
    (CONNECTED pos-2-1 pos-2-2)
    (CONNECTED pos-2-1 pos-1-1)
    (CONNECTED pos-2-1 pos-2-0)
    (CONNECTED pos-2-2 pos-1-2)
    (CONNECTED pos-2-2 pos-2-1)
    (robot-pos pos-0-0)
    (moving)
    (SOURCE pos-2-0 g0)
    (SOURCE pos-0-1 g1)
    (available pos-1-2)
    (available pos-2-2)
    (part-of pos-2-1 g0)
    (part-of pos-1-0 g0)
    (part-of pos-1-1 g1)
    (part-of pos-0-2 g1)
    (part-of pos-0-0 g1)
    (remaining-cells g0 n2)
    (remaining-cells g1 n1)
)
(:goal
(and
    (group-painted g0)
    (group-painted g1)
)
)
)