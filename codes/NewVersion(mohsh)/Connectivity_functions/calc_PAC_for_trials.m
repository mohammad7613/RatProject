function trial_PAC = calc_PAC_for_trials(data, configs, ch1, ch2, is_normalizing, window_type)

    t_n_trials = size(data.target, 1);
    s_n_trials = size(data.standard, 1);
    
    PAC_mat_target = [];
    for i=1:t_n_trials
       
       sig1 = data.target(i,:,ch1);
       sig2 = data.target(i,:,ch2);
       PAC = tfInTrialGram(sig1 ,sig2, configs.fs, configs.interval,...
                           configs.step, configs.thetaBand, ...
                           configs.fGamma, 1, window_type);
       
       if(is_normalizing)
           PAC_in = tfInTrialGram(sig1 ,sig1, configs.fs, configs.interval,...
                                  configs.step, configs.thetaBand, ...
                                  configs.fGamma, 1, window_type);
           norm_PAC = mean(PAC.table, 2) .* mean(PAC_in.table, 2) / max(mean(PAC_in.table, 2));
           PAC_mat_target = [PAC_mat_target; norm_PAC']; 
       else
           PAC_mat_target = [PAC_mat_target; mean(PAC.table, 2)'];
       end
       
       fprintf("Target trials, step %d / %d\n", i, t_n_trials)
       
    end
    
    % Standard truals
    PAC_mat_std = [];
    for i=1:s_n_trials
       
       sig1 = data.standard(i,:,ch1);
       sig2 = data.standard(i,:,ch2);
       PAC = tfInTrialGram(sig1 ,sig2, configs.fs, configs.interval,...
                           configs.step, configs.thetaBand, ...
                           configs.fGamma, 1, window_type);
       
       if(is_normalizing)
           PAC_in = tfInTrialGram(sig1 ,sig1, configs.fs, configs.interval,...
                                  configs.step, configs.thetaBand, ...
                                  configs.fGamma, 1, window_type);
           norm_PAC = mean(PAC.table, 2) .* mean(PAC_in.table, 2) / max(mean(PAC_in.table, 2));
           PAC_mat_std = [PAC_mat_std; norm_PAC']; 
       else
           PAC_mat_std = [PAC_mat_std; mean(PAC.table, 2)'];
       end
       
       fprintf("standard trials, step %d / %d \n", i, s_n_trials)
       
    end
    
    trial_PAC = struct(...
        'target', PAC_mat_target,...
        'standard', PAC_mat_std);

end