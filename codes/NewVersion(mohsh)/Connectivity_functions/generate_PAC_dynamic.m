function results = generate_PAC_dynamic(prep_data, n, ch1, ch2, configs, fig_title, alpha, is_normalizing, is_saving, save_path)
    
    [PAC_mat_std, PAC_target, s] = calc_PAC_dyn_stdT(prep_data, configs, n, ch1, ch2, is_normalizing);
    
    plot_t_std_conf_int(PAC_mat_std, PAC_target, s, configs.fs)
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