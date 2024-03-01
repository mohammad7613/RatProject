function out = ampInTrial(x,interval,step)
    
    % x1: signal
    % Interval: length of the window
    % step: windows sweap length
    
    [~,sz] = size(x) ;
    s = 1 : step : sz - interval;
    amp_dyn = zeros(max(size(s)),1) ; 
    
    T = 1;
    for t = 1 : step : sz - interval
        w = x(t:t+interval);
        amp_dyn(T) = mean(w);
        T = T + 1;
    end
    
    out = struct( ...
        's', s, ...
        'amp', amp_dyn ...
    );
    
end