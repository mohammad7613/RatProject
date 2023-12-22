clc; close all; clear;

addpath('Codes/PreProcessing')
addpath('Codes/Functions')
addpath('Codes/Visualization')


%% Data 1:

clc;

[data, fs] = load_data(pwd, '1', '2080', '2');

%% Preprocess
clc; close all;

tstep = [0.3, 1] ; 
band = [1 300] ; 
rl = [] ;
type = 'rest&Stimulus'; 
prep_data = preprocess(tstep, data.channelData, data.digitalByte,...
                  band, rl, fs, type, 'over_trials');

              
%%

clc; close all;

directoryPath = strcat('Results/Transfer_Entropy',...
                       '\sessionDataoddball', '1', '_', ...
                       '2080', '_', '2'); 
if exist(directoryPath, 'dir') ~= 7
        mkdir(directoryPath);
end

configs = struct(...
    'lag' , 0.05 * fs,...
    'interval', 0.4,...
    'step', 0.1,... 
    'sig_len', [0.3 1],...
    'fs', fs...
    );

sig_Labels = ["mPFC", "Hippo"];

[T_target, T_std] = calc_Entropy_inTrial(prep_data, configs, 1, 2);
plot_Entropy_inTrial(T_std, T_target, sig_Labels, directoryPath, configs)

%%

clc; close all;

sig_Labels = ["mPFC", "Hippo", "NAcc", "LGN"];
plot_TEntropy_allConfigs(prep_data, configs, sig_Labels, directoryPath);

%% Enrtopy comodolugram

clc; close all;

[Entropy_table_target, Entropy_table_std] = EntropyComoolugram(prep_data, 2, 1);

%%
deltaLag = 0.001;
lags = (0:deltaLag:0.05) * 1000;
figure; xticks = lags;
time = -configs.sig_len(1)*1000:configs.step*1000:(configs.sig_len(2)-configs.interval)*1000;

pcolor(lags,time,Entropy_table_target'); shading(gca,'interp');
colormap(jet);
set(gca,'FontSize',10);
xlabel('Lag (ms)','FontSize',10);ylabel('Tine','FontSize',10);
set(gca,'FontName','Arial');
set(gca,'XTick',xticks);
set(gca,'CLim',[0 2]);
colorbar

