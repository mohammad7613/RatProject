function [amp_mat_std, amp_target, s] = calc_amp_dyn_stdT(data, configs, n, ch)

    std_tr_num = size(data.standard, 1);
    target_tr_num = size(data.target, 1);

    amp_mat_std = [];

    for i=1:n

       rand_idx = randperm(std_tr_num, target_tr_num);
       sig = squeeze(mean(data.standard(rand_idx,:,ch),1));
       amp = ampInTrial(sig, configs.interval, configs.step);
       
       amp_mat_std = [amp_mat_std; amp.amp'];
       
       fprintf('Step %d / %d ... \n', i, n);

    end
    
    target_sig = squeeze(mean(data.target(:,:,ch),1));
    amp_target = ampInTrial(target_sig, configs.interval, configs.step);
    amp_target = amp_target.amp';
    s = amp.s;

end