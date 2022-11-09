#include "relaxed_task_graph.h"

#include <iostream>
#include <vector>

using namespace std;

namespace planopt_heuristics {
RelaxedTaskGraph::RelaxedTaskGraph(const TaskProxy &task_proxy)
    : relaxed_task(task_proxy),
      variable_node_ids(relaxed_task.propositions.size()) {
    /*
      Compute the AND/OR graph for the given relaxed STRIPS task. Note
      that since we consider only the STRIPS case, for each operator,
      there is a precondition node and an effect node (there are no
      nodes for conditional effects). To support operator cost, we
      associate costs with operator effect nodes.
    */

    // Solution for part 6.3 (a).
    for (const Proposition &proposition : relaxed_task.propositions) {
        variable_node_ids[proposition.id] = graph.add_node(NodeType::OR);
    }

    initial_node_id = graph.add_node(NodeType::AND);
    for (PropositionID id : relaxed_task.initial_state) {
        graph.add_edge(variable_node_ids[id], initial_node_id);
    }

    for (const RelaxedOperator &op : relaxed_task.operators) {
        NodeID precondition_node_id = graph.add_node(NodeType::AND);
        for (PropositionID pre : op.preconditions) {
            graph.add_edge(precondition_node_id, variable_node_ids[pre]);
        }

        // We set the cost of an effect node here for part (d)
        NodeID effect_node_id = graph.add_node(NodeType::AND, op.cost);
        for (PropositionID eff : op.effects) {
            graph.add_edge(variable_node_ids[eff], effect_node_id);
        }

        graph.add_edge(effect_node_id, precondition_node_id);
    }

    goal_node_id = graph.add_node(NodeType::AND);
    for (PropositionID goal : relaxed_task.goal) {
        graph.add_edge(goal_node_id, variable_node_ids[goal]);
    }
}

void RelaxedTaskGraph::change_initial_state(const State &state) {
    // Remove all initial edges that where introduced for relaxed_task.initial_state.
    for (PropositionID id : relaxed_task.initial_state) {
        graph.remove_edge(variable_node_ids[id], initial_node_id);
    }

    // Switch initial state of relaxed_task
    relaxed_task.initial_state = relaxed_task.translate_state(state);

    // Add all initial edges for relaxed_task.initial_state.
    for (PropositionID id : relaxed_task.initial_state) {
        graph.add_edge(variable_node_ids[id], initial_node_id);
    }
}

bool RelaxedTaskGraph::is_goal_relaxed_reachable() {
    // Compute the most conservative valuation of the graph and use it to
    // return true iff the goal is reachable in the relaxed task.

    graph.most_conservative_valuation();
    return graph.get_node(goal_node_id).forced_true;
}

int RelaxedTaskGraph::additive_cost_of_goal() {
    // Compute the weighted most conservative valuation of the graph and use it
    // to return the h^add value of the goal node.

    graph.weighted_most_conservative_valuation();
    return graph.get_node(goal_node_id).additive_cost;
}

int RelaxedTaskGraph::ff_cost_of_goal() {
    graph.weighted_most_conservative_valuation();

    // Solution for part 6.3 (b).
    unordered_set<NodeID> best_achievers;
    vector<NodeID> queue = {goal_node_id};
    while (!queue.empty()) {
        NodeID id = queue.back();
        queue.pop_back();
        if (best_achievers.insert(id).second) {
            const AndOrGraphNode &node = graph.get_node(id);
            if (node.type == NodeType::OR) {
                queue.push_back(node.achiever);
            } else {
                for (NodeID succ: node.successor_ids) {
                    queue.push_back(succ);
                }
            }
        }
    }
    int cost = 0;
    for (NodeID id : best_achievers) {
        cost += graph.get_node(id).direct_cost;
    }
    return cost;
}

}
