function plot_pval_std_t(PAC_mat_std, PAC_target, s, fs, alpha, window_type, epoch_t_start)

    pvals = zeros(1,size(PAC_mat_std,2));
    target_dynm = mean(PAC_target, 2);
    for i=1:size(PAC_mat_std,2)
        [~, pvals(i)] = ttest(PAC_mat_std(:,i), target_dynm(i));
    end

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
    y = -log(pvals);
%     y0 = -1 * log(alpha);
    yline(2.9957, '--', 'linewidth', 2);
    plot(tint, y, 'linewidth', 2);
    ylabel('-log(p-value)')
    xlabel('Time')
    xlim(x_range)

end