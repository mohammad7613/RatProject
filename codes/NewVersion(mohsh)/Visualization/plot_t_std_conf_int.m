function plot_t_std_conf_int(PAC_mat_std, PAC_target, s, fs, y_range, window_type, epoch_t_start)

    % window_type = causal, anticausal, semi-causal
    % epoch_t_start = time pre-stimulus for epoching is seconds
    
    % Calculate mean and confidence interval
    mean_data = mean(PAC_mat_std);
    std_data = std(PAC_mat_std);
    conf_interval = 1.96 * std_data / sqrt(size(PAC_mat_std, 1)); % 95% confidence interval
    % Calculate upper and lower bounds
    upper_bound = mean_data + conf_interval;
    lower_bound = mean_data - conf_interval;

    figure;
    tint = s / fs * 1000 - epoch_t_start*1000;
    
    if window_type == "causal"
        x_range = [-200, 1100];
    elseif window_type == "anticausal"
        x_range = [-400, 900];
    elseif window_type == "semi-causal"
        x_range = [-300, 1000];
    end
    
    hold on;
    
    plot(tint, mean_data, 'linewidth', 2);
    plot(tint, PAC_target, 'linewidth', 2);
    fill([tint, fliplr(tint)], [upper_bound, fliplr(lower_bound)], 'b', 'FaceAlpha', 0.3); % Fill confidence interval
    xline(0, '--', 'linewidth', 2);
    xlabel('time');
    ylabel('PAC');
    xlim(x_range)
    ylim(y_range)
    legend('Standard', 'Target')

end