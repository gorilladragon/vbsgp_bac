% VBAC
function [perf, theta] = vbac(d,learning_params)
%% initialization


% REMEMBER to DELETE
% d=domain_params;


learning_params.num_output = (learning_params.num_update_max / learning_params.sample_interval) + 1;
perf = zeros(learning_params.num_trial,learning_params.num_output);

if ~isfield(d,'STEP')
    d.STEP = 1;
end
%

for i = 1:learning_params.num_trial % for each independant trial, usually 100
% i=1;
%     exptime = now;
%     tic
    
    % create VAC experiment folder in results folder          
    exp_dir_name = strcat('results/',learning_params.other_name,'/');
    mkdir('../',exp_dir_name);
    % create text file for recording performance in each trial
    filename = sprintf('%s VAC - trial %i', d.name,i);
    f=fullfile(['../' exp_dir_name], strcat(filename, '.txt'));
    fid1 = fopen(f, 'a+');
    fclose(fid1);

    % initialize theta policy parameter
    theta = zeros(d.num_policy_param,1);
    
    % learning rate alpha schedule
    alpha_schedule = learning_params.alp_init_VAC * ...
        (learning_params.alp_update_param./ (learning_params.alp_update_param ...
        +  (1:(learning_params.num_update_max+1) - 1)));
    
    for j = 1:(learning_params.num_update_max+1) % policy updates 
%         j=1;
        % evaluate and print performance to result text file
        if (mod(j-1,learning_params.sample_interval) == 0)
            evalpoint =floor(j/learning_params.sample_interval)+1;
            perf(i,evalpoint) = d.perf_eval(theta,d,learning_params);        
            fid1 = fopen(f, 'a+');
%             fid1 = fopen(strcat(exp_dir_name,filename,'.txt'),'a+');
            fprintf(fid1,'%d,%f\n',j-1, perf(i,floor(j/learning_params.sample_interval)+1));
            fclose(fid1);  
            fprintf(1,'[assessment trial=%d upd=%d] %f\n',i,j, perf(i,floor(j/learning_params.sample_interval)+1));
            tic
        end
        
        % initialize sparse Fisher Info matrix 
        G = sparse(d.num_policy_param,d.num_policy_param); %fisher information matrix
        % initialize episode cells
%         episodes = cell(learning_params.num_episode,5);

%
% ADD
            episode_states = []; 
            episode_scores = []; 
            episode_actions = [];
            episode_rewards = [];

        % for each episode
        for l = 1:learning_params.num_episode 
%         l = 1;
            t = 0; % time-step
            
%             % initialize episode data
%             episode_states = []; 
%             episode_scores = []; 
%             episode_actions = [];
%             episode_rewards = [];
            
            state = d.random_state(d); % start from a random state
            
%             disp(state.x(1));
            
            % get a = next action, and scr = score
            [a, scr] = d.calc_score(theta, state,d,learning_params);
            scr = sparse(scr); % sparsify score vector
%             r = d.calculate_reward(state,d);
                        
            episode_actions = [episode_actions, a]; 
            episode_states = [episode_states, state];
%             episode_rewards = [episode_rewards, r];
            
            % while not reached goal state and time-step less than episode
            % length of 200
            while (~state.isgoal && t < learning_params.episode_len_max)                
                state_old = state;
                
                if (state.isgoal==0)    % if not in goal state
                    [state,~] = d.dynamics(state,a,d);  % change state
                    state = d.is_goal(state,d);     % check if new state is goal state                                   
                end
                
%                 r = d.calculate_reward(state_old,-1,d);
                r = d.calculate_reward(state_old,d);
                                 
                % Fisher Information matrix 
                G = G + (scr * scr');
                % add new data point
                episode_actions = [episode_actions, a];
                episode_rewards = [episode_rewards, r];
                episode_states = [episode_states, state]; %vac
                episode_scores = [episode_scores, scr]; %vac    
                
                [a, scr] = d.calc_score(theta, state, d,learning_params);
                scr = sparse(scr);
                t = t + 1;
            end % end timestep t while
            % no action at end state
            episode_actions = episode_actions(:, 1:end-1);              
            
            if (t < 200)
                episode_rewards(end) = 1; 
%                 disp('GOAL')
            end
                
        end % end episode l for    
        
%%
        % returned FI matrix est
        G = G + 1e-6*speye(size(G));             

% ================ RVGP using C++ ================ 

        % storing all data into txt file format 
        nSize = size(episode_rewards,2);
        
        % initialize txt file size
        vbac_mountaincar = (zeros(nSize, 10));
        % using shorter names
        states = episode_states;
        actions = episode_actions;
        rewards = episode_rewards;
        for steps = 1:nSize      %learning_params.episode_len_max 200
                % construct x and xt
                vbac_mountaincar(steps,:) = [states(steps).x(1), states(steps).x(2), ...
                states(steps).y(1), states(steps).y(2), actions(steps), ...
                states(steps+1).x(1), states(steps+1).x(2), ...
                states(steps+1).y(1), states(steps+1).y(2), rewards(steps)];
        end

        % write vbac_mountaincar to csv file
        csvwrite('vbac_mountaincar.csv', vbac_mountaincar);

        
%         % IMPORTANT! set environment or matlab will crash!
%         setenv('BLAS_VERSION','/usr/lib/libblas.so');setenv('LAPACK_VERSION','/usr/lib/liblapack.so');
    
        
%%
        
        

        % run SGPR
        % [mu, Sigma, Kmm_inv, Xm_index] = VBAC_RVGPopenMP ('../Config/vbacConfig.txt');

%         % C++ RVGP - reformat outputs mu, Sigma, Kmm_inv, and Xm_index
%         mu = mu';        
%         mSize = size(mu, 1); % support size
%         % convert vectors to matrices
%         Sigma = vec2mat(Sigma, mSize)';
%         Kmm_inv = vec2mat(Kmm_inv, mSize)';
%         
%         % === return support set scores === 
%         episode_scores = full(episode_scores); % from sparse matrix to full
%         Xm_indexTemp = Xm_index > 0; % convert from double to logical array
%         support_scores = episode_scores(:,Xm_indexTemp);
        
        

%%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  vbsgp
        mountaincar = load('vbac_mountaincar.csv');
        [mu, S, Kmm_inv, Xm_index] = vbsgp(mountaincar);
        
        % mu=m; Kmm_inv = Kuu_inv; 

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % VBSGP - reformat outputs mu, Sigma, Kmm_inv, and Xm_index        
        mSize = size(mu, 1); % support size
        
        % === return support set scores === 
        episode_scores = full(episode_scores); % from sparse matrix to full
        Xm_indexTemp = Xm_index > 0; % convert from double to logical array
        support_scores = episode_scores(:,Xm_indexTemp);        
        
        


        
        
%% ================ RVGP using MATLAB ================ 
%         % preprocess data for DTCplus training
%         [support_scores,Kmm_inv,mSize,nBlock] = ...
%             vbac_preprocess(episode_rewards, episode_states,...
%             episode_actions, d,episode_scores,G, learning_params);
% 
%         % AL ADDED
%         [mu, Sigma] = rvgp(mSize,nBlock);

        
        
%%        
        % compute gradient of theta
        gradient_mean = support_scores * Kmm_inv * mu;
            
%             % AL ADDED
%             B_t = support_scores;
%             B_0 = G;
%             gradient_Cov = B_0 - (B_t * Kmm_inv * B_t') + ...
%                 (B_t * Kmm_inv)*Sigma*(B_t * Kmm_inv)';
%             
%             gradient_Variance = diag(gradient_Cov);
%         disp(gradient_Variance);
            
%             variability = norm(gradient_Cov);
            
               

        % learning rate alpha
        if learning_params.alp_schedule
            alp = alpha_schedule(j);
        else
            alp = learning_params.alp_init_VAC;
        end
        
        % update theta at each policy update
        % AL ADDED
%         tau = 0.0003399;
%         if (variability < tau)
            grad_update = alp*gradient_mean;
%             if (size(grad_update,1)==32 && size(grad_update,2)==1)
                theta = theta + grad_update;
%             end         
%         end
            
            
    end
end
