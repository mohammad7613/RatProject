function [Entropy_table_target, Entropy_table_std] = EntropyComoolugram(Sigs, driverCh, receiverCh)
    
    addpath('Codes/Functions')
    
    deltaLag = 0.001;
    lags = 0:deltaLag:0.05;
    
    Entropy_table_target = [];
    Entropy_table_std = [];
    
    for i=1:length(lags)
        
        fs = 2000;
        configs = struct(...
            'lag' , round(lags(i) * fs),...
            'interval', 0.4,...
            'step', 0.1,... 
            'sig_len', [0.3 1],...
            'fs', fs...
            );

        [T_target, T_std] = calc_Entropy_inTrial(Sigs, configs, driverCh, receiverCh);
        Entropy_table_target = [Entropy_table_target; T_target];
        Entropy_table_std = [Entropy_table_std; T_std];
        
    end

end