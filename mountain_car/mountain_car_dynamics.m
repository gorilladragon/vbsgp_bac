function [nstate,out] = mountain_car_dynamics(state,a_old,domain_params)

x_old = state.x;

tmp3 = x_old(2) + (0.001 * a_old) - (0.0025 * cos(3 * x_old(1)));
x(2) = max(domain_params.VEL_RANGE(1) , min(tmp3 , domain_params.VEL_RANGE(2)));

tmp3 = x_old(1) + x(2);
x(1) = max(domain_params.POS_RANGE(1) , min(tmp3 , domain_params.POS_RANGE(2)));

if (x(1) == domain_params.POS_RANGE(1))
    x(2) = 0;
end

if (x(1) >= domain_params.GOAL)
    x(1) = domain_params.GOAL;
    x(2) = 0;
end                 

y = [(domain_params.c_map_pos(1) * x(1)) + domain_params.c_map_pos(2);
    (domain_params.c_map_vel(1) * x(2)) + domain_params.c_map_vel(2)];

nstate.x = x;
nstate.y = y;
nstate.isgoal = 0;
out = [];

return
