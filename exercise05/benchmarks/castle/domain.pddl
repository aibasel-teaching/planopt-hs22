(define (domain beleaguered-castle)
    (:requirements :strips)
    (:predicates
        (on ?c1 ?c2)
        (clear ?c)
        (discarded ?c)
        ;
        ; static predicates
        (has-consecutive-value ?c1 ?c2)
        (has-same-suit ?c1 ?c2)
    )

    (:action move
        :parameters (?c ?from ?to)
        :precondition (and
            (clear ?c)
            (clear ?to)
            (on ?c ?from)
            (not (discarded ?c))
            (has-consecutive-value ?c ?to)
            (not (discarded ?to))
        )
        :effect (and
            (not (clear ?to))
            (clear ?from)
            (not (on ?c ?from))
            (on ?c ?to)
        )
    )

    (:action discard
        :parameters (?c ?from ?to)
        :precondition (and
            (clear ?c)
            (clear ?to)
            (on ?c ?from)
            (not (discarded ?c))
            (has-consecutive-value ?to ?c)
            (has-same-suit ?c ?to)
            (discarded ?to)
        )
        :effect (and
            (not (clear ?to))
            (clear ?from)
            (not (on ?c ?from))
            (on ?c ?to)
            (discarded ?c)
        )
    )
)
