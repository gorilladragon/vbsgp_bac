function kx= mountain_car_kernel_kx( state, statedic, domain_params )
    sigk_x = 1;
    ck_x = 1;
    x = state.x';
    xdic = vertcat(statedic.x)';
    y = [domain_params.c_map_pos(1); domain_params.c_map_vel(1)] .* x;
    ydic = repmat([domain_params.c_map_pos(1); domain_params.c_map_vel(1)],1,size(xdic,2)) .* xdic ;
    temp = pdist2(y',ydic').^2;
    kx = ck_x * exp(-temp / (2 * sigk_x*sigk_x));
end

