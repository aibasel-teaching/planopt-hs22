#ifndef PLANOPT_HEURISTICS_RELAXED_TASK_H
#define PLANOPT_HEURISTICS_RELAXED_TASK_H

#include <string>
#include <vector>

class FactProxy;
class State;
class TaskProxy;

namespace planopt_heuristics {

using PropositionID = int;

struct Proposition {
    PropositionID id;
    std::string name;
};

struct RelaxedOperator {
    int id;
    std::string name;
    std::vector<PropositionID> preconditions;
    /*
      Since this is a delete-relaxed STRIPS operator, its effect is represented
      as a list of (add) effects. There are no delete effects, or conditional
      effects.
    */
    std::vector<PropositionID> effects;
    int cost;
};

struct RelaxedTask {
    /*
      Instead of working with the propositions directly, we identify them by
      their ID. The ID of a proposition is unique and identifies its position
      in the following vector.
    */
    std::vector<Proposition> propositions;

    /*
      Instead of representing the intial state as a function mapping
      propositions to truth values, we represent it as the set of propositions
      that are mapped to true.
    */
    std::vector<PropositionID> initial_state;

    /*
      All operators are delete-relaxed STRIPS operators (see documentation of
      RelaxedOperator)
    */
    std::vector<RelaxedOperator> operators;

    /*
      The goal is represented as the set of propostions that should be true
      instead of using a conjunction of them.
    */
    std::vector<PropositionID> goal;

    /*
      The search is not working on the relaxed task (we only use it within
      the heuristic), so we store a mapping from facts in the search task to
      propositions in the relaxed task.
    */
    std::vector<std::vector<PropositionID>> proposition_ids;


    RelaxedTask(const TaskProxy &task_proxy);

    PropositionID get_proposition_id(const FactProxy &fact);
    std::vector<PropositionID> translate_state(const State &state);
};

}

#endif
