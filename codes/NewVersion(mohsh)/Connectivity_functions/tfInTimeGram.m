function out = tfInTimeGram(x1,x2,Fs,interval,step,thetaBand, fGamma, f_step, n_trial)

    f = fGamma(1) : f_step : fGamma(2) ; 
    s = 1 : step : n_trial - interval ; 
    table = zeros(max(size(s)),max(size(f))) ; 
    S = 1 ; 
    for s = 1 : step : n_trial - interval
        K = 1 ; 
        w1 = rid_rihaczek(mean(x1(s:s + interval,:),1),Fs) ; 
        w2 = rid_rihaczek(mean(x2(s:s + interval,:),1),Fs) ; 
        for f = fGamma(1) : f_step : fGamma(2) 
            MVL = 0;
            for i = thetaBand(1):thetaBand(2)
                MVL = MVL + tfMVL(w1, w2, f, i);
            end
            table(S,K) = MVL / (thetaBand(2)-thetaBand(1) + 1) ;
            K = K + 1 ; 
        end
        S = S + 1 ;
    end
    
    s = 1 : step : 120 - interval ; 
    S = max(size(s)) ; 
    
    out = struct( ...
        's', s, ...
        'table', table ...
    );

end
