function [PAC_mat_std, norm_PAC_target, s] = calc_PAC_dyn_stdT(data, configs, n, ch1, ch2, is_normalizing, window_type)

    std_tr_num = size(data.standard, 1);
    target_tr_num = size(data.target, 1);

    PAC_mat_std = [];

    for i=1:n

       rand_idx = randperm(std_tr_num, target_tr_num);
       sig1 = squeeze(mean(data.standard(rand_idx,:,ch1),1));
       sig2 = squeeze(mean(data.standard(rand_idx,:,ch2),1));
       PAC = tfInTrialGram(sig1 ,sig2, configs.fs, configs.interval,...
                           configs.step, configs.thetaBand, ...
                           configs.fGamma, 1, window_type);
       
       if(is_normalizing)
           PAC_in = tfInTrialGram(sig1 ,sig1, configs.fs, configs.interval,...
                                  configs.step, configs.thetaBand, configs.fGamma, 1, window_type);
           norm_PAC = mean(PAC.table, 2) .* mean(PAC_in.table, 2) / max(mean(PAC_in.table, 2));
           PAC_mat_std = [PAC_mat_std; norm_PAC']; 
       else
           PAC_mat_std = [PAC_mat_std; mean(PAC.table, 2)'];
       end

       fprintf('Step %d / %d ... \n', i, n);

    end
    
    sig1 = squeeze(mean(data.target(:,:,ch1),1));
    sig2 = squeeze(mean(data.target(:,:,ch2),1));
    PAC_target = tfInTrialGram(sig1 ,sig2, configs.fs, configs.interval,...
                               configs.step, configs.thetaBand, configs.fGamma, 1, window_type);
    if(is_normalizing)
       PAC_target_in = tfInTrialGram(sig1 ,sig1, configs.fs, configs.interval,...
                               configs.step, configs.thetaBand, configs.fGamma, 1, window_type);
        norm_PAC_target = mean(PAC_target.table, 2) .* mean(PAC_target_in.table, 2) / max(mean(PAC_target_in.table, 2));
    else
        norm_PAC_target = mean(PAC_target.table, 2);
    end
    
    s = PAC.s;

end