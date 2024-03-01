function out = tfInTrialGram(x1,x2,Fs,interval,step,thetaBand, fGamma, f_step)
    
    % x1: signal 1
    % x1: signal 2
    % Interval: length of the window
    % step: windows sweap length
    % fGamma: [f_min_gamma f_max_gamma]
    % f_step: for gamma band
    % thetaBand: e.g. [4 8]
    
    [~,sz] = size(x1) ; 
    f = fGamma{1} : f_step : fGamma{2} ; 
    s = 1 : step : sz - interval ; 
    table = zeros(max(size(s)),max(size(f))) ; 
    S = 1 ; 
    for s = 1 : step : sz - interval
        K = 1 ; 
        w1 = rid_rihaczek(x1(s:s + interval),Fs) ; 
        w2 = rid_rihaczek(x2(s:s + interval),Fs) ; 
        for f = fGamma{1} : f_step : fGamma{2} 
            MVL = 0;
            for i = thetaBand(1):thetaBand(2)
                MVL = MVL + tfMWL(w1, w2, f, i);
            end
            table(S,K) = MVL / (thetaBand(2)-thetaBand(1) + 1) ; 
            K = K + 1 ; 
        end
        S = S + 1 ;
    end
    
    s = 1 : step : sz - interval ; 
    S = max(size(s)) ; 
    
    out = struct( ...
        'n_sample_max', S, ...
        'table', table ...
    );
    
end