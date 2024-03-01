function [Entropy_table_target, Entropy_table_std] = EntropyComoolugram(Sigs, driverCh, receiverCh, configs)
    
    addpath('Codes/Functions')
    
    deltaLag = 0.001;
    lags = 0:deltaLag:0.1;
    
    Entropy_table_target = [];
    Entropy_table_std = [];
    
    for i=1:length(lags)
        
        configs.lag = round(lags(i) * configs.fs);
      
        [T_target, T_std] = calc_Entropy_inTrial(Sigs, configs, driverCh, receiverCh);
        Entropy_table_target = [Entropy_table_target; T_target];
        Entropy_table_std = [Entropy_table_std; T_std];
        
        fprintf("Step %d / %d ... \n", i, length(lags));
        
    end
    
    disp("Done :)")

end