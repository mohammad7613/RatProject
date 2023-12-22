function plot_TEntropy_allConfigs(Sigs, configs, sig_Labels, savePath)
    
    addpath('Codes/Functions')

    n = size(Sigs.target, 3);
    
    for i=1:n
        for j=1:n
            
            sig_Label = [sig_Labels(i), sig_Labels(j)];
            [T_target, T_std] = calc_Entropy_inTrial(Sigs, configs, i, j);
            plot_Entropy_inTrial(T_std, T_target, sig_Label, savePath, configs)
            
            % Close the figure to avoid overlapping plots
            close(gcf);
            
        end
    end

end