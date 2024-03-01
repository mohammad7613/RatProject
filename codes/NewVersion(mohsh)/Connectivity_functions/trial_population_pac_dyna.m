function [PAC_std, PAC_target] = trial_population_pac_dyna(data, n)

    std_tr_num = size(data.standard, 1);
    target_tr_num = size(data.target, 1);
    
    PAC_std = [];
    for i=1:n
       
        rand_idx = randperm(std_tr_num, target_tr_num);
        pac_avg = mean(data.standard(rand_idx,:));
        PAC_std = [PAC_std; pac_avg];
    end
    
    PAC_target = mean(data.target);

end