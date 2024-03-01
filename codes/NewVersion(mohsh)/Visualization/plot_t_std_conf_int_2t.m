function plot_t_std_conf_int_2t(PAC_mat_std, PAC_mat_target, s, fs)

    % Calculate mean and confidence interval
    std_mean_data = mean(PAC_mat_std);
    std_data = std(PAC_mat_std);
    std_conf_interval = 1.96 * std_data / sqrt(size(PAC_mat_std, 1)); % 95% confidence interval
    % Calculate upper and lower bounds
    std_upper_bound = std_mean_data + std_conf_interval;
    std_lower_bound = std_mean_data - std_conf_interval;
    
    % Calculate mean and confidence interval
    target_mean_data = mean(PAC_mat_target);
    target_data = std(PAC_mat_target);
    target_conf_interval = 1.96 * target_data / sqrt(size(PAC_mat_target, 1)); % 95% confidence interval
    % Calculate upper and lower bounds
    target_upper_bound = target_mean_data + target_conf_interval;
    target_lower_bound = target_mean_data - target_conf_interval;

    figure;
    tint = s / fs * 1000 - 200;
    hold on;
    
    plot(tint, std_mean_data, 'linewidth', 2);
    fill([tint, fliplr(tint)], [std_upper_bound, fliplr(std_lower_bound)], 'b', 'FaceAlpha', 0.3); % Fill confidence interval
    plot(tint, target_mean_data, 'linewidth', 2);
    fill([tint, fliplr(tint)], [target_upper_bound, fliplr(target_lower_bound)], 'r', 'FaceAlpha', 0.3); % Fill confidence interval
    xline(0, '--', 'linewidth', 2);
    
    hold off;
    xlabel('time');
    ylabel('PAC');
    xlim([-300, 1000])
%     ylim([-0.2, 1])
    legend('Standard', 'standard 95% interval', 'Target', 'target 95% interval')

end