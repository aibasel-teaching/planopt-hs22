#ifndef PLANOPT_HEURISTICS_H_ADD_H
#define PLANOPT_HEURISTICS_H_ADD_H

#include "relaxed_task_graph.h"

#include "../heuristic.h"

namespace planopt_heuristics {
class HAddHeuristic : public Heuristic {
    RelaxedTaskGraph relaxed_task_graph;
protected:
    virtual int compute_heuristic(const State &ancestor_state) override;
public:
    explicit HAddHeuristic(const options::Options &options);
};
}
#endif
