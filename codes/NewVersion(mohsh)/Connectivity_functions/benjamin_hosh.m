function [p_vals, significant_lags] = benjamin_hosh(source, target, lags, stim_len, configs, q, test_side, is_plot)

    stim_len = stim_len * 1000 + 300;
    n_points = stim_len(2) - stim_len(1);
    if n_points > 300
        error('ERROR: The number of points for the stimulus period must not exceed 300 !!')
    end
    
    p_vals = zeros(size(lags));

    for i = 1:numel(lags)
        lag = round(lags(i));
        T = calc_TransferEntropy(...
                source, target, ...
                lag, lag, configs.fs,...
                configs.interval, configs.sig_len, 0.001);

        preStim = T(randi(300, [1, n_points]));
        [~, pValue] = ttest2(preStim, T(stim_len(1):stim_len(2)-1),...
                             'Tail', test_side);
        p_vals(i) = pValue;
        fprintf('sample lag = %d, p value = %f \n', lag, pValue)
    end

    % Sort the p-values and maintain the indices
    [sortedPValues, sortedIndices] = sort(p_vals);

    m = numel(p_vals); % Total number of tests

    % Calculate the critical threshold for each p-value rank
    thresholds = (1:m) / m * q;

    % Find the largest index k such that sortedPValues(k) <= thresholds(k)
    k = find(sortedPValues <= thresholds, 1, 'last');
    
    significant_lags = sortedIndices(1:k);
    
    if is_plot
        figure;
        plot(sortedPValues)
        ylabel('p values')
        title('Sorted p values')
    end

end