function [signif_TEs, p_vals, significant_lags] = benjamin_hosh(source_target, target_target, source_std, target_std, lags, stim_len, configs, q, test_side, is_plot)

    stim_len = (stim_len * 1000) + 1000;
    n_points = stim_len(2) - stim_len(1);
    if n_points > 1000
        error('ERROR: The number of points for the stimulus period must not exceed 1000 !!')
    end
    
    p_vals = zeros(size(lags));
    all_TEs = [];

    for i = 1:numel(lags)
        lag = round(lags(i));
        T_target = calc_TransferEntropy(...
                source_target, target_target, ...
                lag, lag, configs.fs,...
                configs.interval, configs.sig_len, 0.001);
            
        T_std = calc_TransferEntropy(...
                source_std, target_std, ...
                lag, lag, configs.fs,...
                configs.interval, configs.sig_len, 0.001);

        pop1 = T_std(stim_len(1):stim_len(2)-1);
        pop2 = T_target(stim_len(1):stim_len(2)-1);
        [~, pValue] = ttest2(pop1, pop2,...
                             'Tail', test_side);
        p_vals(i) = pValue;
        all_TEs = [all_TEs; T_target];
        fprintf('sample lag = %d, p value = %.20f \n', lag, pValue)
    end

    % Sort the p-values and maintain the indices
    [sortedPValues, sortedIndices] = sort(p_vals);

    m = numel(p_vals); % Total number of tests

    % Calculate the critical threshold for each p-value rank
    thresholds = (1:m) / m * q;

    % Find the largest index k such that sortedPValues(k) <= thresholds(k)
    k = find(sortedPValues <= thresholds, 1, 'last');
    
    significant_lags = sortedIndices(1:k);
    signif_TEs = all_TEs(1:k, :);
    
    if is_plot
        figure;
        plot(sortedPValues, 'linewidth', 2)
        ylabel('p values')
        title('Sorted p values')
    end

end