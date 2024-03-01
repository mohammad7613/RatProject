clc; close all; clear;

addpath('Codes/PreProcessing')
addpath('Codes/Functions')
addpath('Codes/Visualization')

%% Data 1:

clc;
filename = '';
[data, fs] = load_data(pwd, '1', '2080', '3', filename);

%% Preprocess
clc; close all;

tstep = [0.3, 1] ; 
band = [1 300] ; 
rl = [] ;
type = 'rest&Stimulus'; 
% prep_data = preprocess(tstep, data.channelData, data.digitalByte,...
%                   band, rl, fs, type, 'over_trials');

is_downsample = 0;
fs_down = 2000;
[fs, prep_data] = preprocess2(tstep, data.channelData, data.digitalByte,...
                              band, rl, fs, type, is_downsample, fs_down);


%% PAC in each trial
clc;

configs = struct(               ...
    'thetaBand' , [5 8] ,       ... 
    'fGamma' , [33, 36],        ...
    'interval' , 0.2 * fs -1 ,  ... 
    'step' , 0.1 * fs ,         ...
    'fs', fs                    ...
);

channel_labels = ["mPFC", "Hippo", "NAcc", "LGN"];
% n_channel = length(channel_labels);
n_channel = 2;
PAC_all_results = cell(n_channel, n_channel);
window_type = "causal";

for i=1:n_channel
    for j=1:n_channel
        fig_title = strcat("Driver-", channel_labels(i), "-Receiver-", channel_labels(j));
        fprintf("*****   connection : %s       ***** \n", fig_title);
        normalizing = i ~= j;
        PAC_all_results{i,j} = calc_PAC_for_trials(prep_data, configs, i, j, ...
            normalizing, window_type);
    end
end

% Save
% mkdir('./Data/PAC_Trial/1_2080_2/')
save_path = './Data/PAC_Trial/1_2080_3/theta5_8_gamma33_36\step100m\causal_window\'; 
if exist(save_path, 'dir') ~= 7
        mkdir(save_path);
end
save(strcat(save_path, 'PAC_all_trials_2ch.mat'), 'PAC_all_results')


%% PAC ERP

clc; close all;

for i=1:n_channel
    for j=1:n_channel
        data = PAC_all_results{i,j};
        s = 1 : configs.step : 2600 - configs.interval ;
        plot_t_std_conf_int_2t(zscore(data.standard, 0, 2), ...
            zscore(data.target,0, 2) , s, configs.fs)
        fig_title = strcat("Driver-", channel_labels(i), "-Receiver-", channel_labels(j));
        title(fig_title);
    end
end

%% PAC population
clc; close all;

save_path = strcat('Results/PAC_dynamics_trials',...
                       '\sessionDataoddball', '_1_', '_', ...
                       '2080', '_', '2\theta5_8_gamma33_36\theta5_8_gamma33_36'); 
if exist(save_path, 'dir') ~= 7
        mkdir(save_path);
end

PAC_all_results_pop = cell(n_channel, n_channel);
s = 1 : configs.step : 2600 - configs.interval ;
n = 30;
is_saving = 0;
alpha = 0.05;

for i=1:n_channel
    for j=1:n_channel
        data = PAC_all_results{i,j};
        fig_title = strcat("Driver-", channel_labels(i), "-Receiver-", channel_labels(j));
        fprintf("*****   connection : %s       ***** \n", fig_title);
        PAC_all_results_pop{i,j} = trial_generate_PAC_dynamic(data, n, s, configs, fig_title, alpha, is_saving, save_path);
        
    end
end