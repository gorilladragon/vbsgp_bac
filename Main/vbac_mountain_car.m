% setup for mountain car domain using VAC
clear;clc
% Set environment for C++ Armadillo
% setenv('BLAS_VERSION','/usr/lib/libblas.so');
% setenv('LAPACK_VERSION','/usr/lib/liblapack.so');
% add paths to other folders SGPs, mountain_car, and results
addpath(genpath('./'));     % add all folders in current directory
addpath(genpath('../'));    % all all folders in parent directory

% mountain car experiment domain set-up
domain_params = mountain_car_create_domain;
domain_params.num_episode_eval = 100;

% learning parameters set-up
learning_params = [];
learning_params.episode_len_max = 200; % number of steps per episode
learning_params.num_update_max = 20;   % 500; % Number of policy updates j
learning_params.sample_interval = 1;   % 50; % sample interval
learning_params.num_trial = 10;  % 100; % independent trial i
learning_params.gam = 0.99; 
learning_params.num_episode = 20; % episode l
learning_params.alp_init_VAC = 0.025; % initial learning rate
% learning rates
learning_params.alp_variance_adaptive = 0;
learning_params.alp_schedule = 0;
learning_params.alp_update_param = 500;
learning_params.SIGMA_INIT=1;

% Create a random number stream
s = RandStream('mt19937ar','Seed',1);
% Make it the global stream, so that the functions rand, randi, and randn draw values from it
RandStream.setGlobalStream(s);

% String of VAC learning parameters
learning_params.other_name =  ...
    sprintf('VAC numeps %d sample %d max %d', ...
        learning_params.num_episode,...
        learning_params.sample_interval,learning_params.num_update_max);
    
%     sprintf('VAC gau1 s1234 alpha %4.2f (%d %d - %4.2f)  numepisodes %d sample %d max %d', ...
%     learning_params.alp_init_VAC, learning_params.alp_variance_adaptive, ...
%     learning_params.alp_schedule, learning_params.alp_update_param, ...
%     learning_params.num_episode,...
%     learning_params.sample_interval,learning_params.num_update_max);

%% Run VAC on mountain car experiment
perf = vbac(domain_params,learning_params);

%% Store results in text file
fid1 = fopen('../results/perf_VAC_mountain_car.txt','w');
for tt = 1:size(perf,2)
     fprintf(fid1,'%f %f \n',mean(perf(:,tt)),std(perf(:,tt)));
end
fclose(fid1);
