function results = trial_generate_PAC_dynamic(data, n, s, configs, fig_title, alpha, is_saving, save_path)
    
    [PAC_mat_std, PAC_target] = trial_population_pac_dyna(data, n);
    
    plot_t_std_conf_int(zscore(PAC_mat_std,0,2), zscore(PAC_target,0,2), s, configs.fs)
    title(fig_title);
    
    if(is_saving)
        figFilePath = strcat(save_path, '_PAC_', fig_title, '.fig');
        savefig(figFilePath);
        % Save the figure as .png
        pngFilePath = strcat(save_path, '_PAC_', fig_title, '.png');
        saveas(gcf, pngFilePath); 
    end
    
    plot_pval_std_t(PAC_mat_std, PAC_target, s, configs.fs, alpha)
    title(fig_title);
    
    if(is_saving)
        figFilePath = strcat(save_path, '_pval_', fig_title, '.fig');
        savefig(figFilePath);
        % Save the figure as .png
        pngFilePath = strcat(save_path, '_pval_', fig_title, '.png');
        saveas(gcf, pngFilePath); 
    end
    
    results = struct(...
        'PAC_mat_std', PAC_mat_std, ...
        'PAC_target', PAC_target, ...
        's', s ...
        );

end