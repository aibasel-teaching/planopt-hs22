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
    
    // add your implementation of exercise 5.4 a) here
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
