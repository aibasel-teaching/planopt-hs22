#ifndef PLANOPT_HEURISTICS_H_RELAXED_TASK_GRAPH_H
#define PLANOPT_HEURISTICS_H_RELAXED_TASK_GRAPH_H

#include "relaxed_task_graph.h"

#include "../heuristic.h"

namespace planopt_heuristics {
class RelaxedTaskGraphHeuristic : public Heuristic {
    RelaxedTaskGraph relaxed_task_graph;
    int min_operator_cost;
protected:
    virtual int compute_heuristic(const State &ancestor_state) override;
public:
    explicit RelaxedTaskGraphHeuristic(const options::Options &options);
};
}

#endif
