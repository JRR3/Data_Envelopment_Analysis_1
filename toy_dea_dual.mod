set ENGINES = 1..7;   
set INPUTS = 1..2;
set OUTPUTS = {1};

param E0 > 0;
param epsilon >= 0;
param q_engine > 0;
param s_w {OUTPUTS, ENGINES} >= 0;
param s_u {INPUTS, ENGINES} >= 0;
param theta_star {ENGINES} >= 0;
param tau {ENGINES} >= 0;
param w_out {OUTPUTS, ENGINES} >= 0;
param u_in {INPUTS, ENGINES} >= 0;

param input_matrix {INPUTS,ENGINES} >= 0;
param output_matrix {OUTPUTS,ENGINES} >= 0;

########  Dual problem  #############
var theta;
var lambda {j in ENGINES} >= 0;
var input_slack {j in INPUTS} >= 0;
var output_slack {j in OUTPUTS} >= 0;

minimize dual_obj:  theta 
- epsilon * sum {j in INPUTS} input_slack[j]
- epsilon * sum {i in OUTPUTS} output_slack[i];

subject to input_constraints {i in INPUTS}:
   - input_slack[i] 
   - sum {j in ENGINES} lambda[j] * input_matrix[i,j]
   = -input_matrix[i,E0]*theta;

subject to output_constraints {i in OUTPUTS}:
   - output_slack[i] 
   + sum {j in ENGINES} lambda[j] * output_matrix[i,j] = output_matrix[i,E0];

#########  Primal problem  #############
# This problem is not required since we can extract the value
# of the dual variables using the [].dual method.
#
#var u {j in INPUTS};
#var w {j in OUTPUTS};
#
#maximize primal_obj:  sum {j in OUTPUTS} w[j] * output_matrix[j,E0];
#
#subject to virtual_inputs_sums_to_one:
    #sum {j in INPUTS} u[j] * input_matrix[j,E0] = 1;
    #
#subject to u_constraints {i in INPUTS}:
    #u[i] >= epsilon;
#
#subject to w_constraints {i in OUTPUTS}:
    #w[i] >= epsilon;
#
#subject to bounded_efficiency_constraints {i in ENGINES}:
    #sum {p in OUTPUTS} w[p] * output_matrix[p,i] <=
    #sum {q in INPUTS}  u[q] * input_matrix[q,i];
#

