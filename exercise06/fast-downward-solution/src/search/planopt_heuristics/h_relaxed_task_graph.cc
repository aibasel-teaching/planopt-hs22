#include "h_relaxed_task_graph.h"

#include "../option_parser.h"
#include "../plugin.h"
#include "../task_utils/task_properties.h"

using namespace std;

namespace planopt_heuristics {
RelaxedTaskGraphHeuristic::RelaxedTaskGraphHeuristic(const options::Options &options)
    : Heuristic(options),
      relaxed_task_graph(task_proxy),
      min_operator_cost(task_properties::get_min_operator_cost(task_proxy)){
}

int RelaxedTaskGraphHeuristic::compute_heuristic(const State &ancestor_state) {
    State state = convert_ancestor_state(ancestor_state);
    relaxed_task_graph.change_initial_state(state);
    if (relaxed_task_graph.is_goal_relaxed_reachable()) {
        if (task_properties::is_goal_state(task_proxy, state)) {
            return 0;
        } else {
            return min_operator_cost;
        }
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
        return make_shared<RelaxedTaskGraphHeuristic>(opts);
}

static Plugin<Evaluator> _plugin("planopt_relaxed_task_graph", _parse);

}
