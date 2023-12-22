function T = calc_TransferEntropy(sig1, sig2, t, w, fs, interval, sigLen, tstep)
    
    tstep = tstep * fs;
    sigLen = sigLen * fs;
    interval = interval * fs;
    T_len = ((sigLen(2)-interval) + sigLen(1))/tstep + 1;
    T = zeros(1, T_len);
    
    for i=1:length(T)
        
        start_idx = 1 + (i-1)*tstep;
        end_idx = start_idx + interval - 1;
        X = sig1(start_idx:end_idx);
        Y = sig2(start_idx:end_idx);
        [T(i), nPar, dimPar]=transferEntropyPartition(X,Y,t,w);
    
    end
    
end