;; Weighted fifteen puzzle example task.

(define (problem fifteen-puzzle-example)

  (:domain weighted-sliding-tile)

  (:objects
   tile1 tile2 tile3 tile4 tile5
   tile6 tile7 tile8 tile9 tile10
   tile11 tile12 tile13 tile14 tile15
   row1 row2 row3 row4
   col1 col2 col3 col4)

  (:init
   (IS-TILE tile1)
   (IS-TILE tile2)
   (IS-TILE tile3)
   (IS-TILE tile4)
   (IS-TILE tile5)
   (IS-TILE tile6)
   (IS-TILE tile7)
   (IS-TILE tile8)
   (IS-TILE tile9)
   (IS-TILE tile10)
   (IS-TILE tile11)
   (IS-TILE tile12)
   (IS-TILE tile13)
   (IS-TILE tile14)
   (IS-TILE tile15)
   (IS-ROW row1)
   (IS-ROW row2)
   (IS-ROW row3)
   (IS-ROW row4)
   (NEXT-ROW row1 row2)
   (NEXT-ROW row2 row3)
   (NEXT-ROW row3 row4)
   (IS-COLUMN col1)
   (IS-COLUMN col2)
   (IS-COLUMN col3)
   (IS-COLUMN col4)
   (NEXT-COLUMN col1 col2)
   (NEXT-COLUMN col2 col3)
   (NEXT-COLUMN col3 col4)

   ;; initial state: first (top) row, left-to-right
   (tile-at tile9 row1 col1)
   (tile-at tile2 row1 col2)
   (tile-at tile12 row1 col3)
   (tile-at tile7 row1 col4)
   ;; initial state: second row, left-to-right
   (tile-at tile5 row2 col1)
   (tile-at tile6 row2 col2)
   (tile-at tile14 row2 col3)
   (tile-at tile13 row2 col4)
   ;; initial state: third row, left-to-right
   (tile-at tile3 row3 col1)
   (is-blank row3 col2)
   (tile-at tile11 row3 col3)
   (tile-at tile1 row3 col4)
   ;; initial state: fourth (bottom) row, left-to-right
   (tile-at tile15 row4 col1)
   (tile-at tile4 row4 col2)
   (tile-at tile10 row4 col3)
   (tile-at tile8 row4 col4)

   (= (total-cost) 0)
   ;; Set the weight of each tile to the
   ;; number of its prime factors.
   (= (WEIGHT tile1) 0)
   (= (WEIGHT tile2) 1)
   (= (WEIGHT tile3) 1)
   (= (WEIGHT tile4) 2)
   (= (WEIGHT tile5) 1)
   (= (WEIGHT tile6) 2)
   (= (WEIGHT tile7) 1)
   (= (WEIGHT tile8) 3)
   (= (WEIGHT tile9) 2)
   (= (WEIGHT tile10) 2)
   (= (WEIGHT tile11) 1)
   (= (WEIGHT tile12) 3)
   (= (WEIGHT tile13) 1)
   (= (WEIGHT tile14) 2)
   (= (WEIGHT tile15) 2)
   )

  ;; goal state
  (:goal
   (and
    (tile-at tile1 row1 col1)
    (tile-at tile2 row1 col2)
    (tile-at tile3 row1 col3)
    (tile-at tile4 row1 col4)
    (tile-at tile5 row2 col1)
    (tile-at tile6 row2 col2)
    (tile-at tile7 row2 col3)
    (tile-at tile8 row2 col4)
    (tile-at tile9 row3 col1)
    (tile-at tile10 row3 col2)
    (tile-at tile11 row3 col3)
    (tile-at tile12 row3 col4)
    (tile-at tile13 row4 col1)
    (tile-at tile14 row4 col2)
    (tile-at tile15 row4 col3)))

  (:metric minimize (total-cost))
  )
