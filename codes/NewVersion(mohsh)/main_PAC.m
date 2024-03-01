clc; close all; clear;

addpath('Codes/PreProcessing')
addpath('Codes/Functions')
addpath('Codes/Visualization')

%% Data 1:

clc;

filename = '/oddballData R7\Dataoddball -  2 - 12 - 3/MatData/sessionData.mat';
% filename = '';
[data, fs] = load_data(pwd, '2', '2080', '2', filename);

%% Check Triggers

figure;
plot(data.digitalByte);

triggers_pulse = diff(data.digitalByte);
all_trial = find(triggers_pulse == 10 | triggers_pulse == 20);
time = diff(all_trial);
figure;
histogram(time);

%%
target_trial = find(triggers_pulse == 10);
std_trial = find(triggers_pulse == 20);

%% Plot trigers

figure;
plot(triggers_pulse);

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
              
%%
clc;

configs = struct(               ...
    'thetaBand' , [4 8] ,       ... 
    'fGamma' , [30, 50],        ...
    'interval' , 0.2 * fs -1 ,  ... 
    'step' , 0.1 * fs ,         ...
    'fs', fs                    ...
);  

ch1 = 1;
ch2 = 2;
n = 2;
prep_data.target = gpuArray(prep_data.target);
prep_data.standard = gpuArray(prep_data.standard);
[PAC_mat_std, PAC_target, s] = calc_PAC_dyn_stdT(prep_data, configs, n, ch1, ch2, 1);

%%
close all; clc;

plot_t_std_conf_int(PAC_mat_std, PAC_target, s, fs)
title('PAC - Driver: mPFC - Reciever: mPFC');
plot_pval_std_t(PAC_mat_std, PAC_target, s, fs)
title('PAC p-value - Driver: NAcc - Reciever: Hippo');

%%

clc;

thetaBand = [5 8] ; 
fGamma = [33, 36];
interval = 0.2 * fs -1 ; 
step = 0.1 * fs ; 

sig1 = squeeze(mean(prep_data.target(:,:,1),1));
sig2 = squeeze(mean(prep_data.target(:,:,2),1));
PAC_target = tfInTrialGram(sig1 ,sig2, fs, interval, step, thetaBand, fGamma, 1);

%%

tint = PAC_target.s / fs * 1000 - 100;
figure;
plot(tint, mean(PAC_target.table, 2))

%%

prep_data.target = prep_data.target(prep_data.target_idx <= 120, :, :);
prep_data.standard = prep_data.standard(prep_data.std_idx <= 120, :, :);

%%
clc; close all;

save_path = strcat('Results/PAC_dynamics',...
                       '/oddballData R7\Dataoddball -  2 - 12 - 3/',...
                       'theta5_8_gamma33_36\step100m\causal_window\'); 
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

channel_labels = ["Hippo", "Pulvinar(LP)", "DS(CPu)", "PFC"];
n_channel = length(channel_labels);
% n_channel = 2;
PAC_all_results = cell(n_channel, n_channel);
is_saving = 1;
alpha = 0.05;
window_type = "causal";
epoch_t_start = 0.3;
range = [-0.2 3];

for i=1:n_channel
    for j=1:n_channel
        fig_title = strcat("Driver-", channel_labels(i), "-Receiver-", channel_labels(j));
        fprintf("*****   connection : %s       ***** \n", fig_title);
        is_normalizing = i ~= j;
        PAC_all_results{i,j} = generate_PAC_dynamic(prep_data, n, i, j, configs,...
            fig_title, alpha, is_normalizing, is_saving, save_path,...
            window_type, epoch_t_start, range);
    end
end

if is_saving
    save(strcat(save_path,'PAC_all_results.mat'), 'PAC_all_results')
end

%% One connectivity only
clc;

i = 1;
j = 1;
fig_title = strcat("Driver-", channel_labels(i), "-Receiver-", channel_labels(j));
fprintf("*****   connection : %s       ***** \n", fig_title);
is_normalizing = i ~= j;
PAC_all_results{i,j} = generate_PAC_dynamic(prep_data, n, i, j, configs,...
            fig_title, alpha, is_normalizing, 0, save_path);
