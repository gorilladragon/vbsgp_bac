function perf = mountain_car_perf_eval(theta,domain_params,learning_params)

step_avg = 0;

for l = 1:domain_params.num_episode_eval
    t = 0;
    state = domain_params.random_state(domain_params); % start from random state 
    [a, ~] = domain_params.calc_score(theta,state,domain_params); % return an action a   
    % fprintf(1,'x=%f %f a=%f\n',state.x,a);
    
    while (state.isgoal == 0 && t < learning_params.episode_len_max)                
        for istep = 1:domain_params.STEP            
            if (state.isgoal==0)
                [state,~] = domain_params.dynamics(state,a,domain_params); % take action a to new state
                state = domain_params.is_goal(state,domain_params); % check if goal state reached   
            end
        end
        [a, ~] = domain_params.calc_score(theta, state, domain_params,learning_params); % return next action a
        t = t + 1;                                        
    end
    step_avg = step_avg + t;
    % fprintf(1,'x=%f %f a=%f t = %d\n',state.x,a,t);
end 

perf = step_avg / domain_params.num_episode_eval;

return