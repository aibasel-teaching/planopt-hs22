#include "relaxed_task.h"

#include "../task_proxy.h"

#include "../task_utils/task_properties.h"


using namespace std;

namespace planopt_heuristics {
RelaxedTask::RelaxedTask(const TaskProxy &task_proxy) {
    task_properties::verify_no_axioms(task_proxy);
    task_properties::verify_no_conditional_effects(task_proxy);

    VariablesProxy vars = task_proxy.get_variables();
    proposition_ids.resize(vars.size());
    PropositionID prop_id = 0;
    for (VariableProxy var : vars) {
        vector<PropositionID> &prop_ids = proposition_ids[var.get_id()];
        int num_values = var.get_domain_size();
        prop_ids.reserve(num_values);
        for (int value = 0; value < num_values; ++value) {
            Proposition prop;
            prop.id = prop_id;
            prop.name = var.get_name() + var.get_fact(value).get_name();
            propositions.push_back(prop);
            prop_ids.push_back(prop.id);
            ++prop_id;
        }
    }

    OperatorsProxy global_operators = task_proxy.get_operators();
    operators.reserve(global_operators.size());
    int op_id = 0;
    for (OperatorProxy op : global_operators) {
        RelaxedOperator relaxed_op;
        relaxed_op.id = op_id;
        relaxed_op.name = op.get_name();
        relaxed_op.cost = op.get_cost();

        PreconditionsProxy preconditions = op.get_preconditions();
        relaxed_op.preconditions.reserve(preconditions.size());
        for (FactProxy pre : preconditions) {
            PropositionID prop_id = get_proposition_id(pre);
            relaxed_op.preconditions.push_back(prop_id);
        }

        EffectsProxy effects = op.get_effects();
        relaxed_op.effects.reserve(effects.size());
        for (EffectProxy eff : effects) {
            PropositionID prop_id = get_proposition_id(eff.get_fact());
            relaxed_op.effects.push_back(prop_id);
        }
        operators.push_back(relaxed_op);
        ++op_id;
    }

    GoalsProxy global_goal = task_proxy.get_goals();
    goal.reserve(global_goal.size());
    for (FactProxy g : global_goal) {
        PropositionID prop_id = get_proposition_id(g);
        goal.push_back(prop_id);
    }

    State global_init = task_proxy.get_initial_state();
    initial_state.reserve(global_init.size());
    for (FactProxy f : global_init) {
        PropositionID prop_id = get_proposition_id(f);
        initial_state.push_back(prop_id);
    }
}

PropositionID RelaxedTask::get_proposition_id(const FactProxy &fact) {
    return proposition_ids[fact.get_variable().get_id()][fact.get_value()];
}

vector<int> RelaxedTask::translate_state(const State &state) {
    state.unpack();
    vector<PropositionID> strips_state;
    int num_values = state.size();
    strips_state.reserve(num_values);
    for (int var = 0; var < num_values; ++var) {
        int value = state[var].get_value();
        PropositionID prop_id = proposition_ids[var][value];
        strips_state.push_back(prop_id);
    }
    return strips_state;
}
}
