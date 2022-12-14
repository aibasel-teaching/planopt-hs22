#include "h_greedy_relaxed_plan.h"

#include "../option_parser.h"
#include "../plugin.h"

using namespace std;

namespace planopt_heuristics {
GreedyRelaxedPlanHeuristic::GreedyRelaxedPlanHeuristic(const options::Options &options)
    : Heuristic(options),
      relaxed_task(task_proxy) {
}

int GreedyRelaxedPlanHeuristic::compute_heuristic(const State &ancestor_state) {
    State state = convert_ancestor_state(ancestor_state);
    relaxed_task.initial_state = relaxed_task.translate_state(state);

    vector<bool> proposition_reached(relaxed_task.propositions.size(), false);
    vector<bool> operator_used(relaxed_task.operators.size(), false);

    // set propositions that hold in the current state
    for (PropositionID id : relaxed_task.initial_state) {
        proposition_reached[id] = true;
    }

    auto prop_reached_func = [&] (PropositionID prop_id) {
        return proposition_reached[prop_id];
    };

    int h_value = 0;
    bool operator_found = true;
    while (operator_found) {
        operator_found = false;
        // determine if the goal has been reached
        if (all_of(relaxed_task.goal.begin(), relaxed_task.goal.end(), prop_reached_func)) {
            return h_value;
        }

        // find operator that reaches a previously unreached proposition
        for (const RelaxedOperator &op : relaxed_task.operators) {
            if (!operator_used[op.id] &&
                all_of(op.preconditions.begin(), op.preconditions.end(), prop_reached_func)) {
                for (PropositionID eff : op.effects) {
                    if (!proposition_reached[eff]) {
                        operator_found = true;
                        proposition_reached[eff] = true;
                    }
                }
                if (operator_found) {
                    operator_used[op.id] = true;
                    h_value += op.cost;
                    break;
                }
            }
        }
    }

    // there are no more operators that change a proposition and the goal hasn't been reached
    return DEAD_END;
}

static shared_ptr<Heuristic> _parse(OptionParser &parser) {
    Heuristic::add_options_to_parser(parser);
    Options opts = parser.parse();
    if (parser.dry_run()) {
        return 0;
    } else {
        return make_shared<GreedyRelaxedPlanHeuristic>(opts);
    }
}

static Plugin<Evaluator> _plugin("planopt_greedy_relaxed", _parse);

}
