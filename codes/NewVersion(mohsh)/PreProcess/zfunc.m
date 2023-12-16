function out_mat = zfunc(input_mat)
    
    sz = size(input_mat) ; 
    out_mat = ones(sz) ; 
    sz = size(input_mat) ; 
    
    for i = 1 : sz(1)
        out_mat(i,:,:) = zscore(squeeze(input_mat(i,:,:))) ; 
    end
    
end