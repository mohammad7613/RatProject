function plot_pval_std_t_2(PAC_mat_std, PAC_target, s, fs, alpha)

    pvals = zeros(1,size(PAC_mat_std,2));
    for i=1:size(PAC_mat_std,2)
        [~, pvals(i)] = ttest(PAC_mat_std(:,i), PAC_target(i));
    end

    figure;
    hold on;
    y = -log(pvals);
%     y0 = -1 * log(alpha);
    yline(2.9957, '--', 'linewidth', 2);
    tint = s / fs * 1000 - 200;
    plot(tint, y, 'linewidth', 2);
    ylabel('-log(p-value)')
    xlabel('Time')
    xlim([-300, 1000])

end