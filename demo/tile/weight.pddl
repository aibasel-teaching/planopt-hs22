;; The weighted sliding-tile puzzle.
;;
;; Tile positions are encoded by the predicate
;;     (tile-at <tile> <row> <col>).
;;
;; Blank position is encoded by the predicate
;;     (is-blank <row> <col>).
;;
;; This simplest level of PDDL does not know about
;; numbers, so we tell it which rows/columns follow
;; which other rows/columns with static predicates
;;     (NEXT-ROW ?r1 ?r2)
;;     (NEXT-COLUMN ?c1 ?c2)
;;
;; There are also static predicates for encoding tiles,
;; rows and columns, which are not strictly necessary but
;; may help with readability.
;;
;; Each tile has a weight that determines the cost of moving it.

(define (domain weighted-sliding-tile)

  (:requirements :strips :action-costs)

  (:predicates
   (IS-TILE ?x)
   (IS-ROW ?x)
   (IS-COLUMN ?x)
   (NEXT-ROW ?r1 ?r2)
   (NEXT-COLUMN ?c1 ?c2)
   (tile-at ?t ?r ?c)
   (is-blank ?r ?c)
   )

  (:functions
   (WEIGHT ?t) - number
   (total-cost) - number
   )

  (:action move-tile-down
    :parameters (?tile ?old-row ?new-row ?col)
    :precondition (and (IS-TILE ?tile)
                       (IS-ROW ?old-row)
                       (IS-ROW ?new-row)
                       (IS-COLUMN ?col)
                       (NEXT-ROW ?old-row ?new-row)
                       (tile-at ?tile ?old-row ?col)
                       (is-blank ?new-row ?col))
    :effect (and (not (tile-at ?tile ?old-row ?col))
                 (not (is-blank ?new-row ?col))
                 (tile-at ?tile ?new-row ?col)
                 (is-blank ?old-row ?col)
                 (increase (total-cost) (WEIGHT ?tile))))

  (:action move-tile-up
    :parameters (?tile ?old-row ?new-row ?col)
    :precondition (and (IS-TILE ?tile)
                       (IS-ROW ?old-row)
                       (IS-ROW ?new-row)
                       (IS-COLUMN ?col)
                       (NEXT-ROW ?new-row ?old-row)
                       (tile-at ?tile ?old-row ?col)
                       (is-blank ?new-row ?col))
    :effect (and (not (tile-at ?tile ?old-row ?col))
                 (not (is-blank ?new-row ?col))
                 (tile-at ?tile ?new-row ?col)
                 (is-blank ?old-row ?col)
                 (increase (total-cost) (WEIGHT ?tile))))

  (:action move-tile-right
    :parameters (?tile ?row ?old-col ?new-col)
    :precondition (and (IS-TILE ?tile)
                       (IS-ROW ?row)
                       (IS-COLUMN ?old-col)
                       (IS-COLUMN ?new-col)
                       (NEXT-COLUMN ?old-col ?new-col)
                       (tile-at ?tile ?row ?old-col)
                       (is-blank ?row ?new-col))
    :effect (and (not (tile-at ?tile ?row ?old-col))
                 (not (is-blank ?row ?new-col))
                 (tile-at ?tile ?row ?new-col)
                 (is-blank ?row ?old-col)
                 (increase (total-cost) (WEIGHT ?tile))))

  (:action move-tile-left
    :parameters (?tile ?row ?old-col ?new-col)
    :precondition (and (IS-TILE ?tile)
                       (IS-ROW ?row)
                       (IS-COLUMN ?old-col)
                       (IS-COLUMN ?new-col)
                       (NEXT-COLUMN ?new-col ?old-col)
                       (tile-at ?tile ?row ?old-col)
                       (is-blank ?row ?new-col))
    :effect (and (not (tile-at ?tile ?row ?old-col))
                 (not (is-blank ?row ?new-col))
                 (tile-at ?tile ?row ?new-col)
                 (is-blank ?row ?old-col)
                 (increase (total-cost) (WEIGHT ?tile))))

  )
