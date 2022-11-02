#ifndef PLANOPT_HEURISTICS_H_FF_H
#define PLANOPT_HEURISTICS_H_FF_H

#include "relaxed_task_graph.h"

#include "../heuristic.h"

namespace planopt_heuristics {
class HFFHeuristic : public Heuristic {
    RelaxedTaskGraph relaxed_task_graph;
protected:
    virtual int compute_heuristic(const State &ancestor_state) override;
public:
    explicit HFFHeuristic(const options::Options &options);
};
}
#endif
