;; Mode: 3
;; Field size: 6x6
;; 3 Stones

;; Legend:
;; # = wall
;; O = stone
;; @ = goal
;; P = player
;;     1 2 3 4 5 6 
;;   # # # # # # # #
;; 1 # P @         #
;; 2 #   O     @   #
;; 3 #         # # #
;; 4 #       #     #
;; 5 #   O @ #     #
;; 6 #       #   O #
;;   # # # # # # # #

(define (problem sokoban-problem)
  (:domain sokoban-sequential)
  (:objects
    dir-down - direction
    dir-left - direction
    dir-right - direction
    dir-up - direction
    player-1 - player
    pos-1-1 - location
    pos-1-2 - location
    pos-1-3 - location
    pos-1-4 - location
    pos-1-5 - location
    pos-1-6 - location
    pos-2-1 - location
    pos-2-2 - location
    pos-2-3 - location
    pos-2-4 - location
    pos-2-5 - location
    pos-2-6 - location
    pos-3-1 - location
    pos-3-2 - location
    pos-3-3 - location
    pos-3-4 - location
    pos-3-5 - location
    pos-3-6 - location
    pos-4-1 - location
    pos-4-2 - location
    pos-4-3 - location
    pos-4-4 - location
    pos-4-5 - location
    pos-4-6 - location
    pos-5-1 - location
    pos-5-2 - location
    pos-5-3 - location
    pos-5-4 - location
    pos-5-5 - location
    pos-5-6 - location
    pos-6-1 - location
    pos-6-2 - location
    pos-6-3 - location
    pos-6-4 - location
    pos-6-5 - location
    pos-6-6 - location
    stone-1 - stone
    stone-2 - stone
    stone-3 - stone
  )
  (:init
    (MOVE-DIR pos-2-2 pos-1-2 dir-left)
    (MOVE-DIR pos-2-2 pos-2-1 dir-up)
    (MOVE-DIR pos-2-2 pos-3-2 dir-right)
    (MOVE-DIR pos-2-2 pos-2-3 dir-down)
    (MOVE-DIR pos-2-3 pos-1-3 dir-left)
    (MOVE-DIR pos-2-3 pos-2-2 dir-up)
    (MOVE-DIR pos-2-3 pos-3-3 dir-right)
    (MOVE-DIR pos-2-3 pos-2-4 dir-down)
    (MOVE-DIR pos-2-4 pos-1-4 dir-left)
    (MOVE-DIR pos-2-4 pos-2-3 dir-up)
    (MOVE-DIR pos-2-4 pos-3-4 dir-right)
    (MOVE-DIR pos-2-4 pos-2-5 dir-down)
    (MOVE-DIR pos-2-5 pos-1-5 dir-left)
    (MOVE-DIR pos-2-5 pos-2-4 dir-up)
    (MOVE-DIR pos-2-5 pos-3-5 dir-right)
    (MOVE-DIR pos-2-5 pos-2-6 dir-down)
    (MOVE-DIR pos-3-2 pos-2-2 dir-left)
    (MOVE-DIR pos-3-2 pos-3-1 dir-up)
    (MOVE-DIR pos-3-2 pos-4-2 dir-right)
    (MOVE-DIR pos-3-2 pos-3-3 dir-down)
    (MOVE-DIR pos-3-3 pos-2-3 dir-left)
    (MOVE-DIR pos-3-3 pos-3-2 dir-up)
    (MOVE-DIR pos-3-3 pos-4-3 dir-right)
    (MOVE-DIR pos-3-3 pos-3-4 dir-down)
    (MOVE-DIR pos-3-4 pos-2-4 dir-left)
    (MOVE-DIR pos-3-4 pos-3-3 dir-up)
    (MOVE-DIR pos-3-4 pos-4-4 dir-right)
    (MOVE-DIR pos-3-4 pos-3-5 dir-down)
    (MOVE-DIR pos-3-5 pos-2-5 dir-left)
    (MOVE-DIR pos-3-5 pos-3-4 dir-up)
    (MOVE-DIR pos-3-5 pos-4-5 dir-right)
    (MOVE-DIR pos-3-5 pos-3-6 dir-down)
    (MOVE-DIR pos-4-2 pos-3-2 dir-left)
    (MOVE-DIR pos-4-2 pos-4-1 dir-up)
    (MOVE-DIR pos-4-2 pos-5-2 dir-right)
    (MOVE-DIR pos-4-2 pos-4-3 dir-down)
    (MOVE-DIR pos-4-3 pos-3-3 dir-left)
    (MOVE-DIR pos-4-3 pos-4-2 dir-up)
    (MOVE-DIR pos-4-3 pos-5-3 dir-right)
    (MOVE-DIR pos-4-3 pos-4-4 dir-down)
    (MOVE-DIR pos-4-4 pos-3-4 dir-left)
    (MOVE-DIR pos-4-4 pos-4-3 dir-up)
    (MOVE-DIR pos-4-4 pos-5-4 dir-right)
    (MOVE-DIR pos-4-4 pos-4-5 dir-down)
    (MOVE-DIR pos-4-5 pos-3-5 dir-left)
    (MOVE-DIR pos-4-5 pos-4-4 dir-up)
    (MOVE-DIR pos-4-5 pos-5-5 dir-right)
    (MOVE-DIR pos-4-5 pos-4-6 dir-down)
    (MOVE-DIR pos-5-2 pos-4-2 dir-left)
    (MOVE-DIR pos-5-2 pos-5-1 dir-up)
    (MOVE-DIR pos-5-2 pos-6-2 dir-right)
    (MOVE-DIR pos-5-2 pos-5-3 dir-down)
    (MOVE-DIR pos-5-3 pos-4-3 dir-left)
    (MOVE-DIR pos-5-3 pos-5-2 dir-up)
    (MOVE-DIR pos-5-3 pos-6-3 dir-right)
    (MOVE-DIR pos-5-3 pos-5-4 dir-down)
    (MOVE-DIR pos-5-4 pos-4-4 dir-left)
    (MOVE-DIR pos-5-4 pos-5-3 dir-up)
    (MOVE-DIR pos-5-4 pos-6-4 dir-right)
    (MOVE-DIR pos-5-4 pos-5-5 dir-down)
    (MOVE-DIR pos-5-5 pos-4-5 dir-left)
    (MOVE-DIR pos-5-5 pos-5-4 dir-up)
    (MOVE-DIR pos-5-5 pos-6-5 dir-right)
    (MOVE-DIR pos-5-5 pos-5-6 dir-down)
    (MOVE-DIR pos-2-1 pos-1-1 dir-left)
    (MOVE-DIR pos-2-1 pos-3-1 dir-right)
    (MOVE-DIR pos-2-1 pos-2-2 dir-down)
    (MOVE-DIR pos-2-6 pos-1-6 dir-left)
    (MOVE-DIR pos-2-6 pos-2-5 dir-up)
    (MOVE-DIR pos-2-6 pos-3-6 dir-right)
    (MOVE-DIR pos-3-1 pos-2-1 dir-left)
    (MOVE-DIR pos-3-1 pos-4-1 dir-right)
    (MOVE-DIR pos-3-1 pos-3-2 dir-down)
    (MOVE-DIR pos-3-6 pos-2-6 dir-left)
    (MOVE-DIR pos-3-6 pos-3-5 dir-up)
    (MOVE-DIR pos-3-6 pos-4-6 dir-right)
    (MOVE-DIR pos-4-1 pos-3-1 dir-left)
    (MOVE-DIR pos-4-1 pos-5-1 dir-right)
    (MOVE-DIR pos-4-1 pos-4-2 dir-down)
    (MOVE-DIR pos-4-6 pos-3-6 dir-left)
    (MOVE-DIR pos-4-6 pos-4-5 dir-up)
    (MOVE-DIR pos-4-6 pos-5-6 dir-right)
    (MOVE-DIR pos-5-1 pos-4-1 dir-left)
    (MOVE-DIR pos-5-1 pos-6-1 dir-right)
    (MOVE-DIR pos-5-1 pos-5-2 dir-down)
    (MOVE-DIR pos-5-6 pos-4-6 dir-left)
    (MOVE-DIR pos-5-6 pos-5-5 dir-up)
    (MOVE-DIR pos-5-6 pos-6-6 dir-right)
    (MOVE-DIR pos-1-2 pos-1-1 dir-up)
    (MOVE-DIR pos-1-2 pos-2-2 dir-right)
    (MOVE-DIR pos-1-2 pos-1-3 dir-down)
    (MOVE-DIR pos-6-2 pos-5-2 dir-left)
    (MOVE-DIR pos-6-2 pos-6-1 dir-up)
    (MOVE-DIR pos-6-2 pos-6-3 dir-down)
    (MOVE-DIR pos-1-3 pos-1-2 dir-up)
    (MOVE-DIR pos-1-3 pos-2-3 dir-right)
    (MOVE-DIR pos-1-3 pos-1-4 dir-down)
    (MOVE-DIR pos-6-3 pos-5-3 dir-left)
    (MOVE-DIR pos-6-3 pos-6-2 dir-up)
    (MOVE-DIR pos-6-3 pos-6-4 dir-down)
    (MOVE-DIR pos-1-4 pos-1-3 dir-up)
    (MOVE-DIR pos-1-4 pos-2-4 dir-right)
    (MOVE-DIR pos-1-4 pos-1-5 dir-down)
    (MOVE-DIR pos-6-4 pos-5-4 dir-left)
    (MOVE-DIR pos-6-4 pos-6-3 dir-up)
    (MOVE-DIR pos-6-4 pos-6-5 dir-down)
    (MOVE-DIR pos-1-5 pos-1-4 dir-up)
    (MOVE-DIR pos-1-5 pos-2-5 dir-right)
    (MOVE-DIR pos-1-5 pos-1-6 dir-down)
    (MOVE-DIR pos-6-5 pos-5-5 dir-left)
    (MOVE-DIR pos-6-5 pos-6-4 dir-up)
    (MOVE-DIR pos-6-5 pos-6-6 dir-down)
    (MOVE-DIR pos-1-1 pos-1-2 dir-down)
    (MOVE-DIR pos-1-1 pos-2-1 dir-right)
    (MOVE-DIR pos-1-6 pos-2-6 dir-right)
    (MOVE-DIR pos-1-6 pos-1-5 dir-up)
    (MOVE-DIR pos-6-1 pos-5-1 dir-left)
    (MOVE-DIR pos-6-1 pos-6-2 dir-down)
    (MOVE-DIR pos-6-6 pos-5-6 dir-left)
    (MOVE-DIR pos-6-6 pos-6-5 dir-up)
    (at player-1 pos-1-1)
    (IS-NONGOAL pos-1-1)
    (IS-GOAL pos-2-1)
    (clear pos-2-1)
    (IS-NONGOAL pos-3-1)
    (clear pos-3-1)
    (IS-NONGOAL pos-4-1)
    (clear pos-4-1)
    (IS-NONGOAL pos-5-1)
    (clear pos-5-1)
    (IS-NONGOAL pos-6-1)
    (clear pos-6-1)
    (IS-NONGOAL pos-1-2)
    (clear pos-1-2)
    (IS-NONGOAL pos-2-2)
    (at stone-1 pos-2-2)
    (IS-NONGOAL pos-3-2)
    (clear pos-3-2)
    (IS-NONGOAL pos-4-2)
    (clear pos-4-2)
    (IS-GOAL pos-5-2)
    (at stone-2 pos-6-6)
    (IS-NONGOAL pos-6-2)
    (clear pos-6-2)
    (IS-NONGOAL pos-1-3)
    (clear pos-1-3)
    (IS-NONGOAL pos-2-3)
    (clear pos-2-3)
    (IS-NONGOAL pos-3-3)
    (clear pos-3-3)
    (IS-NONGOAL pos-4-3)
    (clear pos-4-3)
    (IS-NONGOAL pos-5-3)
    (IS-NONGOAL pos-6-3)
    (IS-NONGOAL pos-1-4)
    (clear pos-1-4)
    (IS-NONGOAL pos-2-4)
    (clear pos-2-4)
    (IS-NONGOAL pos-3-4)
    (clear pos-3-4)
    (IS-NONGOAL pos-4-4)
    (IS-NONGOAL pos-5-4)
    (clear pos-5-4)
    (IS-NONGOAL pos-6-4)
    (clear pos-6-4)
    (IS-NONGOAL pos-1-5)
    (clear pos-1-5)
    (IS-NONGOAL pos-2-5)
    (at stone-3 pos-2-5)
    (IS-GOAL pos-3-5)
    (clear pos-3-5)
    (IS-NONGOAL pos-4-5)
    (IS-NONGOAL pos-5-5)
    (clear pos-5-5)
    (IS-NONGOAL pos-6-5)
    (clear pos-6-5)
    (IS-NONGOAL pos-1-6)
    (clear pos-1-6)
    (IS-NONGOAL pos-2-6)
    (clear pos-2-6)
    (IS-NONGOAL pos-3-6)
    (clear pos-3-6)
    (IS-NONGOAL pos-4-6)
    (IS-NONGOAL pos-5-6)
    (clear pos-5-6)
    (IS-NONGOAL pos-6-6)
    (clear pos-6-6)
    (= (total-cost) 0)
  )
  (:goal (and
    (at-goal stone-1)
    (at-goal stone-2)
    (at-goal stone-3)
  ))
  (:metric minimize (total-cost))
)
