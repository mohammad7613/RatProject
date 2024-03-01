function [optim_w, cor] = calc_best_suprise_w(stimuli, PAC_dyn, window_idx)
    
    n_trial = length(stimuli);
    cor=-inf;
    p=zeros(20,n_trial);
    optim_w = 0;
    
    for w=1:20
        p(w, :)= three_state_KL_on_params_SM(stimuli,2^(w-10),3);
        a=[];
        b=[];
        for j=2:n_trial
            a=[a,PAC_dyn(j,window_idx)];
            b=[b,p(w,j)];
        end
        c=corrcoef(b,a);
        if c(1,2)>=cor
            cor=c(1,2);
            optim_w = w;
        end
    end
    
end