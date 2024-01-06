clc; close all; clear;


addpath('PreProcess')
addpath('Connectivity_functions')
addpath('Visualization')


%% Data:

clc;
session_no = '4';
oddball_ratio = '4060';
exp_no = '3';
[data, fs] = load_data('../..', session_no, oddball_ratio, exp_no);

%% Preprocess
clc; close all;

tstep = [0.3, 1] ; 
band = [1 300] ; 
rl = [] ;
type = 'rest&Stimulus'; 
prep_data = preprocess(tstep, data.channelData, data.digitalByte,...
                  band, rl, fs, type, 'over_trials');

%%

clc;

configs = struct(...
    'lag' , 0.055 * fs,...
    'interval', 0.2,...
    'step', 0.1,... 
    'sig_len', [0.3 1],...
    'fs', fs...
    );
deltaLag = 0.001;
lags = deltaLag:deltaLag:0.05;
lags = lags * configs.fs;
driver_ch = 1;
receiver_ch = 2;

source = squeeze(mean(prep_data.target(:,:,driver_ch),1));
target = squeeze(mean(prep_data.target(:,:,receiver_ch),1));
q = 0.01;

test_side = 'left';
stim_len = [0.1, 0.3];
[p_vals, signif_idx] = benjamin_hosh(source, target, lags, stim_len, configs, q, test_side);

%%
clc;

for i=1:length(signif_idx)
   fprintf("lag = %f ,   p value = %.20f \n", lags(signif_idx(i)), ...
            p_vals(signif_idx(i))) 
end
signif_lags = lags(signif_idx);
