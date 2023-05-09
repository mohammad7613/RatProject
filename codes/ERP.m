clc;
clear;
close all;

eve=10;

d = 'C:\Users\Fazeli\Desktop\Monkey\mice\mice-main\Recording\AssociationOdorAndAudio\011110\AuditoryOdor\Session2\MatData\github\Data\';

mat_files = dir(fullfile(d,strcat('**/Epoch_event_',int2str(eve),'.mat')));

for i = 1:length(mat_files)

    if ~exist(fullfile(mat_files(i).folder,'ERP'), 'dir')
        mkdir(fullfile(mat_files(i).folder,'ERP'));
        %mkdir(folder_paths{i});

    end
    
    eeg = load(fullfile(mat_files(i).folder, mat_files(i).name));
    event = eeg.data;
    trialnumber = size(event,3);
    %fs=1000
    event_mean_bs = mean(event(:,1:1000,:),2);
    event_demean = event - event_mean_bs;
    S30 = mean(event_demean,3);
    std30 = std(event_demean,1,3)/sqrt(trialnumber);

    ts = tinv([0.025 0.975],trialnumber-1);
    CI_1 = S30 + ts(1) * std30;
    CI_2 = S30 + ts(2) * std30;


    t=-1000:11000;


    for c = 1:3
    
        % confidence interval plot
        curve1 = CI_2(c,:);
        curve2 = CI_1(c,:);
        t2 = [t, fliplr(t)];
        inBetween = [curve1, fliplr(curve2)];
        fill(t2, inBetween, 'b','FaceAlpha',0.3);
        hold on;   
        plot(t,S30(c,:),'LineWidth', 3);
        xlim([-1000 11000]);
        set(gcf,'Position',get(0,'Screensize'));
        title(strcat('ERP__event:',int2str(eve),'__CH:',int2str(c)));
        xlabel('time(ms)');
        saveas(gcf,strcat(mat_files(i).folder,'\ERP\event',int2str(eve),'_CH',int2str(c),'.png'))
        close all;
    end

end