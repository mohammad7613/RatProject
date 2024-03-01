clc; clear; close all;

addpath('Codes/PreProcessing')
addpath('Codes/Functions')
addpath('Codes/Visualization')
addpath('Data/PAC_Trial')

%% Data 1:

clc;

% filename = '/oddballData R7\Dataoddball -  2 - 12 - 3/MatData/sessionData.mat';
filename = '';
[data, fs] = load_data(pwd, '1', '2080', '2', filename);
PAC_all = load('./Data/PAC_Trial\1_2080_2\theta5_8_gamma33_36\step100m\causal_window\PAC_all_trials.mat');
PAC_all = PAC_all.PAC_all_results;

%%

triggers_pulse = diff(data.digitalByte); 
all_trial = triggers_pulse(triggers_pulse == 10 | triggers_pulse == 20);
stimuli = all_trial > 10;

%% Optimum w
clc;

n_trials = length(PAC_all{2,1}.standard) + length(PAC_all{1,2}.target);
PAC_dyn = zeros(n_trials, 12);
PAC_dyn(stimuli == 1, :) = PAC_all{2,1}.standard;
PAC_dyn(stimuli == 0, :) = PAC_all{2,1}.target;

%%
window_idx = 4;
[optim_w, cor] = calc_best_suprise_w(stimuli, PAC_dyn, window_idx);

%% suprise correlation
clc;

surprise = three_state_KL_on_params_SM(stimuli,2^(optim_w-10),3);
corr_dynamic = zeros(1, 12);

for i=1:12
    corr = corrcoef(PAC_dyn(2:end,i),surprise(2:end));
    corr_dynamic(i) = corr(1,2);
end

%% visualize

plot(corr_dynamic, 'linewidth', 2);
title('suprise and PAC correlation')
ylabel('corr coef')
xlabel('PAC window')
xlim([0 13])
xticks(1:12)
xticklabels({'[-300,-100]','[-200,0]','[-100,100]','[0,200]',...
             '[100,300]', '[200,400]','[300,500]','[400,600]',...
             '[500,700]','[600,800]','[700,900]','[800,1000]'})

