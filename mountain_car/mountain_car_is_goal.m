function state = mountain_car_is_goal(state,domain_params)

if (state.x(1) >= domain_params.GOAL)
    state.isgoal = 1;
else 
    state.isgoal = 0;
end

return
