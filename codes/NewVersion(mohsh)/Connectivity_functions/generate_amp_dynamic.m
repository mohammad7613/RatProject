function results = generate_amp_dynamic(prep_data, n, ch, configs, fig_title, alpha, is_saving, save_path)
    
    [amp_mat_std, amp_target, s] = calc_amp_dyn_stdT(prep_data, configs, n, ch);
    
    range = [-0.2 0.3];
    plot_t_std_conf_int(amp_mat_std, amp_target, s, configs.fs, range)
    title(fig_title);
    
    if(is_saving)
        figFilePath = strcat(save_path, '_amp_dyn_', fig_title, '.fig');
        savefig(figFilePath);
        % Save the figure as .png
        pngFilePath = strcat(save_path, '_amp_dyn_', fig_title, '.png');
        saveas(gcf, pngFilePath); 
    end
    
    plot_pval_std_t_2(amp_mat_std, amp_target, s, configs.fs, alpha)
    title(fig_title);
    
    if(is_saving)
        figFilePath = strcat(save_path, '_pval_', fig_title, '.fig');
        savefig(figFilePath);
        % Save the figure as .png
        pngFilePath = strcat(save_path, '_pval_', fig_title, '.png');
        saveas(gcf, pngFilePath); 
    end
    
    results = struct(...
        'PAC_mat_std', amp_mat_std, ...
        'PAC_target', amp_target, ...
        's', s ...
        );

end