clc;
clear;
close all;

load('presessionData_v2_normalizedLFPOverTime_EpochedData.mat')

if ~exist(fullfile(pwd,'ERP'), 'dir')
    mkdir(fullfile(pwd,'ERP'));
end

A=Epoch.data;
t=Epoch.events(1).trigger_index;
s=Epoch.events(2).trigger_index;
target = A (:,t,:);
target = permute(target,[1 3 2]);
standard = A (:,s,:);
standard = permute(standard,[1 3 2]);

event = standard;
eve='standard';

%0.2 sec pre and 1 sec post stimulus.
% fs = 1000;

trialnumber = size(event,3);
event_mean_bs = mean(event(:,1:200,:),2);
event_demean = event - event_mean_bs;
S30 = mean(event_demean,3);
std30 = std(event_demean,1,3)/sqrt(trialnumber);

ts = tinv([0.025 0.975],trialnumber-1);
CI_1 = S30 + ts(1) * std30;
CI_2 = S30 + ts(2) * std30;


t=-200:1000;
for c = 1:3
    
    % confidence interval plot
    curve1 = CI_2(c,:);
    curve2 = CI_1(c,:);
    t2 = [t, fliplr(t)];
    inBetween = [curve1, fliplr(curve2)];
    fill(t2, inBetween, 'b','FaceAlpha',0.3);
    hold on;   
    plot(t,S30(c,:),'LineWidth', 3);
    set(gcf,'Position',get(0,'Screensize'));
    title(strcat('ERP__event:',eve,'__CH:',int2str(c)));
    xlabel('time(ms)');
    saveas(gcf,strcat(pwd,'\ERP\event_',eve,'_CH',int2str(c),'.png'))
    close all;
end
