clc; close all; clear;

addpath('PreProcess')
addpath('Connectivity_functions')
addpath('Visualization')

%% Data 1:

clc;

[data, fs] = load_data(pwd, '3', '4060', '3');

%% Preprocess
clc; close all;

tstep = [0.3, 1] ; 
band = [1 300] ; 
rl = [] ;
type = 'rest&Stimulus'; 
% prep_data = preprocess(tstep, data.channelData, data.digitalByte,...
%                   band, rl, fs, type, 'over_trials');

prep_data = preprocess2(tstep, data.channelData, data.digitalByte, band, rl, fs, type);
              


%%
clc; close all;

save_path = strcat('Results/PAC_dynamics',...
                       '\sessionDataoddball', '_3_', '_', ...
                       '4060', '_', '3\theta5_8_gamma33_36\theta5_8_gamma33_36'); 
if exist(save_path, 'dir') ~= 7
        mkdir(save_path);
end

n = 30;
configs = struct(               ...
    'thetaBand' , [5 8] ,       ... 
    'fGamma' , [33, 36],        ...
    'interval' , 0.2 * fs -1 ,  ... 
    'step' , 0.1 * fs ,         ...
    'fs', fs                    ...
);

channel_labels = ["mPFC", "Hippo", "NAcc", "LGN"];
n_channel = length(channel_labels);
PAC_all_results = cell(n_channel, n_channel);
is_saving = 1;
alpha = 0.05;

for i=1:n_channel
    for j=1:n_channel
        fig_title = strcat("Driver-", channel_labels(i), "-Receiver-", channel_labels(j));
        fprintf("*****   connection : %s       ***** \n", fig_title);
        is_normalizing = i ~= j;
        PAC_all_results{i,j} = generate_PAC_dynamic(prep_data, n, i, j, configs,...
            fig_title, alpha, is_normalizing, is_saving, save_path);
    end
end
