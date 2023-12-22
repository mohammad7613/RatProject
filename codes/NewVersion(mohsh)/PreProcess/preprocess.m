function out = preprocess(tstep, signal, digitalByte, band, rl, fs, type, zscore_type) 

    % preprocess: Preprocesses signal data based on specified parameters.
    % Inputs:
    %   tstep: Time step for selecting subsets of signal. [start end]
    %   signal: Input signal data.
    %   digitalByte: Representing Trigger values (20: standard and 10: target) for each trial.
    %   band: Frequency band for bandpass filtering.
    %   rl: Remove list.
    %   fs: Sampling frequency.
    %   type: Type of preprocessing (rest, stimulus, or rest&Stimulus).
    %   **Zscore-type: 'off' / 'over_trials' / 'over_channel' (must be imlpemented)**
    %
    % Output:
    %   out: Preprocessed signal data.
         
    % Filtering
    signal = bandpass(signal, band, fs); 
    step = 1; 
    q_target = 1; 
    q_std = 1;
    triggers_pulse = diff(digitalByte); 
            
    target_trial = find(triggers_pulse == 10);
    std_trial = find(triggers_pulse == 20);
    all_trial_idx = [target_trial; std_trial];
    
    epoch_idx = fs * tstep;
        
    
    if strcmpi(zscore_type, 'over_channel')
       signal = zscore(squeeze(signal)) ;  
       disp(size(signal))
    end
    
    if strcmpi(type, 'stimulus')
        
        epoch_len = fs * tstep(2);
        out_target = zeros(length(target_trial), epoch_len, size(signal, 2));
        out_std = zeros(length(std_trial), epoch_len, size(signal, 2));
        
        for i = 1 : max(size(all_trial_idx))
            if ~ismember(step, rl) && ismember(all_trial_idx(i), target_trial)
                out_target(q_target,:,:) = signal(all_trial_idx(i):all_trial_idx(i)+epoch_idx(2)-1,:); 
                q_target = q_target + 1; 
                step = step + 1; 
            elseif ~ismember(step, rl) && ismember(all_trial_idx(i), std_trial)
                out_std(q_std,:,:) = signal(all_trial_idx(i):all_trial_idx(i)+epoch_idx(2)-1,:);
                q_std = q_std + 1; 
                step = step + 1;
            elseif ismember(step, rl)
                step = step + 1; 
            end
        end
        
    elseif strcmpi(type, 'rest')
        
        epoch_len = fs * tstep(1);
        out_target = zeros(length(target_trial), epoch_len, size(signal, 2));
        out_std = zeros(length(std_trial), epoch_len, size(signal, 2));
        
        for i = 1 : max(size(all_trial_idx))
            if ~ismember(step, rl) && ismember(all_trial_idx(i), target_trial)
                out_target(q_target,:,:) = signal(all_trial_idx(i)-epoch_idx(1)+1:all_trial_idx(i),:); 
                q_target = q_target + 1; 
                step = step + 1; 
            elseif ~ismember(step, rl) && ismember(all_trial_idx(i), std_trial)
                out_std(q_std,:,:) = signal(all_trial_idx(i)-epoch_idx(1)+1:all_trial_idx(i),:);
                q_std = q_std + 1; 
                step = step + 1;
            elseif ismember(step, rl)
                step = step + 1; 
            end
        end
         
    elseif strcmpi(type, 'rest&Stimulus') 
        
        epoch_len = fs * (tstep(2) + tstep(1));
        out_target = zeros(length(target_trial), epoch_len, size(signal, 2));
        out_std = zeros(length(std_trial), epoch_len, size(signal, 2));
                
        for i = 1 : max(size(all_trial_idx))

            if ~ismember(step, rl) && ismember(all_trial_idx(i), target_trial)
                out_target(q_target,:,:) = signal(all_trial_idx(i)-epoch_idx(1)+1:all_trial_idx(i)+epoch_idx(2),:); 
                q_target = q_target + 1; 
                step = step + 1; 
            elseif ~ismember(step, rl) && ismember(all_trial_idx(i), std_trial)
                out_std(q_std,:,:) = signal(all_trial_idx(i)-epoch_idx(1)+1:all_trial_idx(i)+epoch_idx(2),:);
                q_std = q_std + 1; 
                step = step + 1;
            elseif ismember(step, rl)
                step = step + 1; 
            end
        end
        
    end
        
    if strcmpi(zscore_type, 'over_trial')
        out_target = zfunc(out_target);
        out_std = zfunc(out_std);
    end
    
    out = struct( ...
            'target', out_target, ...
            'standard', out_std ...
            );

end