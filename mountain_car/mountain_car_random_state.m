function state = mountain_car_random_state(domain_params)

 x = [((domain_params.POS_RANGE(2) - domain_params.POS_RANGE(1)) * rand) + domain_params.POS_RANGE(1);
         ((domain_params.VEL_RANGE(2) - domain_params.VEL_RANGE(1)) * rand) + domain_params.VEL_RANGE(1)];
            
 y = [(domain_params.c_map_pos(1) * x(1)) + domain_params.c_map_pos(2);
         (domain_params.c_map_vel(1) * x(2)) + domain_params.c_map_vel(2)];

state.x = x;
state.y = y;     
state.isgoal = 0;

end