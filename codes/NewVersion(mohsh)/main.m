%% Setup and import functions

clc; clear; close all;

addpath('Codes/PreProcessing')
addpath('Codes/Functions')

%% Load data

file_path_to_sessionData = pwd;
session_no = '1';
oddball_ratio = '2080';
exp_no = '2';
filename = strcat('\sessionDataoddball', session_no, '_', ...
                   oddball_ratio, '_', exp_no, '.mat');
file_path = [pwd, '\Data', '\Oddball', filename];
load(file_path)
fs = SampleRate;

%%

figure;
plot(digitalByte)


%% Preprocess
clc; close all;

signal = channelData ; 
tstep = [0.2, 0.9] ; 
band = [1 300] ; 
rl = [] ;
type = 'rest&Stimulus'; 
data = preprocess(tstep, channelData, digitalByte, band, rl, fs, type);

%% save preprocessed data

filename = strcat('\sessionDataoddball', session_no, '_', ...
                   oddball_ratio, '_', exp_no, '_preProc', '.mat');
file_path = [pwd, '\Data', '\Oddball', filename];

save(file_path, 'data')


%% PAC

clc;

thetaBand = [5 8] ; 
fGamma = [33, 36];
interval = 0.2 * fs ; 
step = 0.1 * fs ; 

sig1 = squeeze(mean(data.target(:,:,2),1));
sig2 = squeeze(mean(data.target(:,:,1),1));
PAC_target = tfInTrialGram(sig1 ,sig2, fs, interval, step, thetaBand, fGamma, 1);

%%

PAC_mat = PAC_target.table;
tint = PAC_target.s / fs * 1000 - 200;
tfGram(PAC_mat,tint,fGamma,1,1)
title('Target PAC - Driver: Hippo - Reciever: mPFC')
xline(0, '--')
set(gca,'CLim',[0 1]);
colorbar

%%

tint = PAC_target.s / fs * 1000 - 100;
figure;
plot(tint, mean(PAC_mat, 2))

%%

sig1 = squeeze(mean(data.standard(:,:,2),1));
sig2 = squeeze(mean(data.standard(:,:,1),1));
PAC_std = tfInTrialGram(sig1 ,sig2, fs, interval, step, thetaBand, fGamma, 1);

%%

PAC_mat = PAC_std.table;
tint = PAC_std.s / fs * 1000 - 200;
tfGram(PAC_mat,tint,fGamma,1,1)
title('Standard PAC - Driver: Hippo - Reciever: mPFC')
xline(0, '--')
set(gca,'CLim',[0 1]);
colorbar

%%

tint = PAC_target.s / fs * 1000 - 200;
figure;
plot(tint, mean(PAC_target.table, 2)); hold on;
plot(tint, mean(PAC_std.table, 2)); hold off;

