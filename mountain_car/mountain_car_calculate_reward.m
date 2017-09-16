% function reward = mountain_car_calculate_reward(state,~,~)
function reward = mountain_car_calculate_reward(state,d)
reward = state.isgoal - 1; % -2 at every step that's not goal
% reward = state.isgoal;

%     state.x(1)= state.x(1) + 1.2; % scale up to positive number
%     reward = reward + (state.x(1)/(d.GOAL+1.2)) * 10; % proportionate rewards from 0 to 10
    
return
