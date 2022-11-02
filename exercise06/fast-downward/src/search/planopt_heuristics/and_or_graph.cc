#include "and_or_graph.h"

#include "../utils/collections.h"

#include <algorithm>
#include <deque>
#include <iostream>
#include <queue>


using namespace std;

namespace planopt_heuristics {

NodeID AndOrGraph::add_node(NodeType type, int weight) {
    NodeID id = nodes.size();
    nodes.emplace_back(id, type, weight);
    return id;
}

void AndOrGraph::add_edge(NodeID from, NodeID to) {
    nodes[from].successor_ids.push_back(to);
    nodes[to].predecessor_ids.push_back(from);
}

template<typename T>
void remove_from_vector(vector<T> &v, const T &elem) {
    v.erase(remove(v.begin(), v.end(), elem), v.end());
}

void AndOrGraph::remove_edge(NodeID from, NodeID to) {
    /* Note that this is an inefficient way of removing the edge. We would need
       a different data structure to make this more efficient. */
    remove_from_vector(nodes[from].successor_ids, to);
    remove_from_vector(nodes[to].predecessor_ids, from);
}

const AndOrGraphNode &AndOrGraph::get_node(NodeID id) const {
    assert(utils::in_bounds(id, nodes));
    return nodes[id];
}

void AndOrGraph::most_conservative_valuation() {
    /*
      General approach for computing the most conservative valuation:

      For each node n keep track of the number of successors of n that are
      forced true in the member num_forced_successors.

      Use a queue of nodes that are forced true because they have the correct
      number of forced true successors.

      While there are nodes in the queue, remove one of them and increase the
      number of forced successors of all its predecessors by one. When this
      change means that a node is now forced true, add it to the queue.
      Take care to “expand” each node at most once.

      When the queue is empty the flag forced_true of a node should be set to
      true if and only if the node is forced true.
    */

    deque<NodeID> queue;

    for (AndOrGraphNode &node : nodes) {
        node.forced_true = false;
        node.num_forced_successors = 0;
        if (node.type == NodeType::AND && node.successor_ids.empty()) {
            queue.push_back(node.id);
        }
    }

    while (!queue.empty()) {
        NodeID id = queue.front();
        queue.pop_front();
        AndOrGraphNode &node = nodes[id];
        assert((node.type == NodeType::AND &&
            node.num_forced_successors == static_cast<int>(node.successor_ids.size())) ||
            (node.type == NodeType::OR &&
            node.num_forced_successors >= 1));
        if (node.forced_true) {
            // We handled this node already
            continue;
        }
        node.forced_true = true;
        for (NodeID pre_id : node.predecessor_ids) {
            AndOrGraphNode &pre = nodes[pre_id];
            ++pre.num_forced_successors;
            int num_successors = pre.successor_ids.size();
            assert(pre.num_forced_successors >= 1);
            assert(pre.num_forced_successors <= num_successors);
            if (pre.type == NodeType::OR || pre.num_forced_successors == num_successors) {
                queue.push_back(pre.id);
            }
        }
    }
}

void AndOrGraph::weighted_most_conservative_valuation() {
    /*
      General approach for computing the weighted most conservative valuation:

      Use the generalized Dijkstra's algorithm outlined above but now consider
      the cost of each node.

      Instead of picking any node from the queue, use a priority queue and
      expand nodes in order of increasing cost. Initialize all additive_cost
      values to infinity except for nodes that are initially in the queue
      (they have a cost of 0).

      Whenever the number of forced true successors of an OR node is increased,
      check if it can now be reached in a cheaper way (the cost to reach an
      OR node from a node n is its direct cost plus the additive cost of $n$).
      If the newly discovered way of reaching the OR node is cheaper then update
      its cost and add it to the queue again.

      Whenever the number of forced true successors of an AND node is increased
      to the total number of its successors, compute its cost (the sum of the
      additive costs of all its successors plus its direct cost) and add it to
      the queue.
    */

    using QueueEntry = pair<int, NodeID>;
    /*
      Priority queues usually order entries so the largest entry is the first.
      By using the comparator greater<T> instead of the default less<T>, we
      change the ordering to sort the smallest element first.
    */
    priority_queue<QueueEntry, vector<QueueEntry>, greater<QueueEntry>> queue;

    for (AndOrGraphNode &node : nodes) {
        node.forced_true = false;
        node.num_forced_successors = 0;
        if (node.type == NodeType::AND && node.successor_ids.empty()) {
            node.additive_cost = node.direct_cost;
            queue.push({0, node.id});
        } else {
            node.additive_cost = numeric_limits<int>::max();
        }
    }

    while (!queue.empty()) {
        pair<int, NodeID> cost_id_pair = queue.top();
        queue.pop();
        NodeID id = cost_id_pair.second;
        AndOrGraphNode &node = nodes[id];
        assert((node.type == NodeType::AND &&
            node.num_forced_successors == static_cast<int>(node.successor_ids.size())) ||
            (node.type == NodeType::OR &&
            node.num_forced_successors >= 1));
        if (node.forced_true) {
            // We handled this node already
            continue;
        }
        node.forced_true = true;
        for (NodeID pre_id : node.predecessor_ids) {
            AndOrGraphNode &pre = nodes[pre_id];
            ++pre.num_forced_successors;
            int num_successors = pre.successor_ids.size();
            assert(pre.num_forced_successors >= 1);
            assert(pre.num_forced_successors <= num_successors);

            if (pre.type == NodeType::OR) {
                int new_cost = node.additive_cost + pre.direct_cost;
                assert(node.additive_cost < numeric_limits<int>::max());
                assert(new_cost < numeric_limits<int>::max());
                assert(new_cost >= 0);
                if (new_cost < pre.additive_cost) {
                    pre.achiever = id;
                    pre.additive_cost = new_cost;
                    queue.push({pre.additive_cost, pre.id});
                }
            } else if (pre.type == NodeType::AND && pre.num_forced_successors == num_successors) {
                assert(pre.additive_cost == numeric_limits<int>::max());
                pre.additive_cost = 0;
                for (NodeID succ_id : pre.successor_ids) {
                    assert(nodes[succ_id].additive_cost < numeric_limits<int>::max());
                    assert(nodes[succ_id].forced_true);
                    pre.additive_cost = pre.additive_cost + nodes[succ_id].additive_cost;
                    // Required change for h^max
                    // pre.additive_cost = max(pre.additive_cost, nodes[succ_id].additive_cost);
                }
                pre.additive_cost += pre.direct_cost;
                queue.push({pre.additive_cost, pre.id});
            }
        }
    }
}

void add_nodes(vector<string> names, NodeType type, AndOrGraph &g, unordered_map<string, NodeID> &ids) {
    for (string name : names) {
        ids[name] = g.add_node(type);
    }
}

void add_edges(vector<pair<string, string>> edges, AndOrGraph &g, unordered_map<string, NodeID> &ids) {
    for (const auto &edge : edges) {
        g.add_edge(ids[edge.first], ids[edge.second]);
    }
}

void test_most_conservative_valuation(const unordered_set<string> &forced_true,
    const string &graph_name, AndOrGraph &g, unordered_map<string, NodeID> &ids) {
    cout << endl << "Verifying graph " << graph_name << endl;
    bool success = true;
    g.most_conservative_valuation();

    for (const auto &node : ids) {
        string name = node.first;
        NodeID id = node.second;
        bool is_set = g.get_node(id).forced_true;
        bool should_be_set = forced_true.find(name) != forced_true.end();
        if (is_set && !should_be_set) {
            cout << "The algorithm marked node " << name
                 << " as forced true but shouldn't have" << endl;
            success = false;
        } else if (!is_set && should_be_set) {
            cout << "The algorithm should have marked node " << name
                 << " as forced true but didn't" << endl;
            success = false;
        }
    }

    if (success) {
        cout << "Verification of " << graph_name << " successful" << endl;
    } else {
        cout << "Verification of " << graph_name << " failed" << endl;
    }
}

void test_and_or_graphs() {
    /*
      Graph g1 is from slides C3:

        O1 <---> A1              O5
                 |               ^
                 |               |
                 v               v
        O2 <---> A2      A4      O4
         \       |       /\      |
          \      |      /  \     |
           \     v     /    \    v
            \--> A3 <-/      \-> O3


      Nodes A2, A3, O2 are forced true.
    */
    AndOrGraph g1;
    unordered_map<string, NodeID> ids1;
    add_nodes({"O1", "O2", "O3", "O4", "O5"}, NodeType::OR, g1, ids1);
    add_nodes({"A1", "A2", "A3", "A4"}, NodeType::AND, g1, ids1);
    add_edges({
                  {"O1", "A1"},
                  {"A1", "O1"},
                  {"A1", "A2"},
                  {"A2", "O2"},
                  {"O2", "A2"},
                  {"O2", "A3"},
                  {"A2", "A3"},
                  {"A4", "A3"},
                  {"A4", "O3"},
                  {"O4", "O3"},
                  {"O5", "O4"},
                  {"O4", "O5"},
              }, g1, ids1);
    test_most_conservative_valuation({"A2", "A3", "O2"}, "g1", g1, ids1);

    /*
      Graph g2 is the relaxed task graph from slides C4 with the intial state
      that makes a, b and d true:

             Aop1<-\   Aop1e1<-\
             |     |    |  |   |
             v     |    |  |   |
           Oabc<--------/  |   |    Aop2   Aop3<-\    Aop4<-\
           /  \    |       |   |   / ^     /     |    /     |
          v    \   |       |   |  v  |    /      |   /      |
         Aab    \  | Acd<--/   | At  |   /     /----/       |
        /  \     \ | /  \      |     |  /     /  |          |
       v    v     v|v    v     |     | v     /   |          |
      Oa    Ob    Oc    Od    Oe      Of<---/    Og        Oh
       \    /           /      ^                   ^      ^
        v  v           /       |                    \    /
         AI<----------/        |                     \  /
                               AG-------------------->Agh

      All nodes are forced true.
    */
    AndOrGraph g2;
    unordered_map<string, NodeID> ids2;
    // Variable nodes
    add_nodes({"Oa", "Ob", "Oc", "Od", "Oe", "Of", "Og", "Oh"}, NodeType::OR, g2, ids2);
    // Effect nodes
    add_nodes({"Aop1", "Aop1e1", "Aop2", "Aop3", "Aop4"}, NodeType::AND, g2, ids2);
    // Initial node
    add_nodes({"AI"}, NodeType::AND, g2, ids2);
    // Goal node
    add_nodes({"AG"}, NodeType::AND, g2, ids2);
    // Formula nodes
    add_nodes({"Oabc"}, NodeType::OR, g2, ids2);
    add_nodes({"Aab", "Acd", "At", "Agh"}, NodeType::AND, g2, ids2);

    add_edges({
                  // Initial state
                  {"Oa", "AI"},
                  {"Ob", "AI"},
                  {"Od", "AI"},
                  // Preconditions
                  {"Aop1", "Oabc"},
                  {"Aop1e1", "Oabc"},
                  {"Aop1e1", "Acd"},
                  {"Aop2", "At"},
                  {"Aop3", "Of"},
                  {"Aop4", "Of"},
                  // Effects
                  {"Oc", "Aop1"},
                  {"Oe", "Aop1e1"},
                  {"Of", "Aop2"},
                  {"Og", "Aop3"},
                  {"Oh", "Aop4"},
                  // Goal
                  {"AG", "Oe"},
                  {"AG", "Agh"},

                  // Formula nodes
                  {"Oabc", "Aab"}, {"Oabc", "Oc"},
                  {"Aab", "Oa"}, {"Aab", "Ob"},
                  {"Acd", "Oc"}, {"Acd", "Od"},
                  {"Agh", "Og"}, {"Agh", "Oh"},

              }, g2, ids2);
    test_most_conservative_valuation({
            "Oa", "Ob", "Oc", "Od", "Oe", "Of", "Og", "Oh",
            "Aop1", "Aop1e1", "Aop2", "Aop3", "Aop4",
            "AI", "AG", "Oabc", "Aab", "Acd", "At", "Agh"
        }, "g2", g2, ids2);

    /*
      Graph g3 is the relaxed task graph from slides C4 with the intial state
      that only makes a and b true:

             Aop1<-\   Aop1e1<-\
             |     |    |  |   |
             v     |    |  |   |
           Oabc<--------/  |   |    Aop2   Aop3<-\    Aop4<-\
           /  \    |       |   |   / ^     /     |    /     |
          v    \   |       |   |  v  |    /      |   /      |
         Aab    \  | Acd<--/   | At  |   /     /----/       |
        /  \     \ | /  \      |     |  /     /  |          |
       v    v     v|v    v     |     | v     /   |          |
      Oa    Ob    Oc    Od    Oe      Of<---/    Og        Oh
       \    /                  ^                   ^      ^
        v  v                   |                    \    /
         AI                    |                     \  /
                               AG-------------------->Agh

      All nodes except Od, Oe, Acd, Aop1e1, and AG are forced true.
    */
    AndOrGraph g3;
    unordered_map<string, NodeID> ids3;
    // Variable nodes
    add_nodes({"Oa", "Ob", "Oc", "Od", "Oe", "Of", "Og", "Oh"}, NodeType::OR, g3, ids3);
    // Effect nodes
    add_nodes({"Aop1", "Aop1e1", "Aop2", "Aop3", "Aop4"}, NodeType::AND, g3, ids3);
    // Initial node
    add_nodes({"AI"}, NodeType::AND, g3, ids3);
    // Goal node
    add_nodes({"AG"}, NodeType::AND, g3, ids3);
    // Formula nodes
    add_nodes({"Oabc"}, NodeType::OR, g3, ids3);
    add_nodes({"Aab", "Acd", "At", "Agh"}, NodeType::AND, g3, ids3);

    add_edges({
                  // Initial state
                  {"Oa", "AI"},
                  {"Ob", "AI"},
                  // Preconditions
                  {"Aop1", "Oabc"},
                  {"Aop1e1", "Oabc"},
                  {"Aop1e1", "Acd"},
                  {"Aop2", "At"},
                  {"Aop3", "Of"},
                  {"Aop4", "Of"},
                  // Effects
                  {"Oc", "Aop1"},
                  {"Oe", "Aop1e1"},
                  {"Of", "Aop2"},
                  {"Og", "Aop3"},
                  {"Oh", "Aop4"},
                  // Goal
                  {"AG", "Oe"},
                  {"AG", "Agh"},

                  // Formula nodes
                  {"Oabc", "Aab"}, {"Oabc", "Oc"},
                  {"Aab", "Oa"}, {"Aab", "Ob"},
                  {"Acd", "Oc"}, {"Acd", "Od"},
                  {"Agh", "Og"}, {"Agh", "Oh"},

              }, g3, ids3);
    test_most_conservative_valuation({
            "Oa", "Ob", "Oc", "Of", "Og", "Oh",
            "Aop1", "Aop2", "Aop3", "Aop4",
            "AI", "Oabc", "Aab", "At", "Agh"
        }, "g3", g3, ids3);
}

}
