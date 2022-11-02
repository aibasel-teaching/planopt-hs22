#include "h_ff.h"

#include "../option_parser.h"
#include "../plugin.h"

using namespace std;

namespace planopt_heuristics {
HFFHeuristic::HFFHeuristic(const options::Options &options)
    : Heuristic(options),
      relaxed_task_graph(task_proxy) {
}

int HFFHeuristic::compute_heuristic(const State &ancestor_state) {
    State state = convert_ancestor_state(ancestor_state);
    relaxed_task_graph.change_initial_state(state);
    if (relaxed_task_graph.is_goal_relaxed_reachable()) {
        return relaxed_task_graph.ff_cost_of_goal();
    } else {
        return DEAD_END;
    }
}

static shared_ptr<Heuristic> _parse(OptionParser &parser) {
    Heuristic::add_options_to_parser(parser);
    Options opts = parser.parse();
    if (parser.dry_run())
        return nullptr;
    else
        return make_shared<HFFHeuristic>(opts);
}

static Plugin<Evaluator> _plugin("planopt_ff", _parse);

}
