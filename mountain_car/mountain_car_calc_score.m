function [a, scr] = mountain_car_calc_score(theta,state,domain_params,~)

y = state.y;

% feature values
phi_x = zeros(domain_params.NUM_STATE_FEATURES,1);
mu = zeros(domain_params.NUM_ACT,1);

for tt = 1:domain_params.NUM_STATE_FEATURES
    tmp1 = y - domain_params.GRID_CENTERS(:,tt);
    phi_x(tt) = exp(-0.5 * tmp1' * domain_params.INV_SIG_GRID * tmp1);
end

for tt = 1:domain_params.NUM_ACT
    if (tt == 1)
        phi_xa = [phi_x; zeros(domain_params.NUM_STATE_FEATURES,1);];    
    else
        phi_xa = [zeros(domain_params.NUM_STATE_FEATURES,1); phi_x];
    end
    mu(tt) = exp(phi_xa' * theta);
end
mu = mu / sum(mu);

tmp2 = rand;
if (tmp2 < mu(1))
    a = domain_params.ACT(1);
    scr = [phi_x * (1 - mu(1)); -phi_x * mu(2)];
else
    a = domain_params.ACT(2);
    scr = [-phi_x * mu(1); phi_x * (1 - mu(2))];
end
