function domain_params = mountain_car_create_domain
domain_params = [];

domain_params.name = 'mountain_car';
domain_params.dynamics = @mountain_car_dynamics;
domain_params.random_state = @mountain_car_random_state;
domain_params.calc_score = @mountain_car_calc_score;
domain_params.perf_eval = @mountain_car_perf_eval;
domain_params.calculate_reward = @mountain_car_calculate_reward;
domain_params.is_goal = @mountain_car_is_goal;

domain_params.state_kernel_kx = @mountain_car_kernel_kx; 
domain_params.state_kernel_kxx = @mountain_car_kernel_kxx;
domain_params.state_kernel_k = @mountain_car_kernel_k;

domain_params.POS_RANGE = [-1.2; 0.5];
domain_params.VEL_RANGE = [-0.07; 0.07];

domain_params.GOAL = domain_params.POS_RANGE(2);

domain_params.POS_MAP_RANGE = [0; 1];
domain_params.VEL_MAP_RANGE = [0; 1];
domain_params.GRID_SIZE = [4; 4];

%% features init (same in more domains)

domain_params.c_map_pos = [domain_params.POS_RANGE(1), 1; domain_params.POS_RANGE(2), 1] \ [domain_params.POS_MAP_RANGE(1); domain_params.POS_MAP_RANGE(2)];
domain_params.c_map_vel = [domain_params.VEL_RANGE(1), 1; domain_params.VEL_RANGE(2), 1] \ [domain_params.VEL_MAP_RANGE(1); domain_params.VEL_MAP_RANGE(2)];

domain_params.GRID_STEP = [(domain_params.POS_MAP_RANGE(2) - domain_params.POS_MAP_RANGE(1)) / domain_params.GRID_SIZE(1);
    (domain_params.VEL_MAP_RANGE(2) - domain_params.VEL_MAP_RANGE(1)) / domain_params.GRID_SIZE(2)];

domain_params.NUM_STATE_FEATURES = domain_params.GRID_SIZE(1) * domain_params.GRID_SIZE(2);

domain_params.GRID_CENTERS = zeros(2,domain_params.NUM_STATE_FEATURES);

for i = 1:domain_params.GRID_SIZE(1)
    for j = 1:domain_params.GRID_SIZE(2)
        domain_params.GRID_CENTERS(:,((i - 1) * domain_params.GRID_SIZE(2)) + j) =  [domain_params.POS_MAP_RANGE(1) + ((i - 0.5) * domain_params.GRID_STEP(1)); domain_params.VEL_MAP_RANGE(1) + ((j - 0.5) * domain_params.GRID_STEP(2))];
    end
end
%%

domain_params.sig_grid = 1.3 * domain_params.GRID_STEP(1);
domain_params.sig_grid2 = domain_params.sig_grid^2;
domain_params.SIG_GRID = domain_params.sig_grid2 * eye(2);
domain_params.INV_SIG_GRID = inv(domain_params.SIG_GRID);

domain_params.phi_x = zeros(domain_params.NUM_STATE_FEATURES,1);

domain_params.NUM_ACT = 2;
domain_params.ACT = [-1; 1];
domain_params.num_policy_param = domain_params.NUM_STATE_FEATURES * domain_params.NUM_ACT;

end