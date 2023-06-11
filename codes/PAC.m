clc;
clear;
close all;

load('presessionData_v1_normalizedLFPOverTime_EpochedData.mat')

if ~exist(fullfile(pwd,'PAC'), 'dir')
    mkdir(fullfile(pwd,'PAC'));
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
% fs = 2000;
event_mean_bs = mean(event(:,1:400,:),2);
event_demean = event - event_mean_bs;
erp = mean(event_demean,3);

% Define window size and overlap
windowSize = 400; %fs=2000, so 2000 means 1sec
overlap = 200;



for c = 1:3 % c : channels
 data = erp(c,:,:);
 % Calculate number of windows
 numWindows = floor((length(data)-windowSize)/overlap)+1;
 pac =  nan(numWindows,1); % total time = 1 sec(200ms window with 100ms overlap)
 CI_1 =  nan(numWindows,1);
 CI_2 =  nan(numWindows,1);
 Fs = 2000;

 % PAC on the whole time
 high = [30 50]; % set the required amplitude frequency range
 low = [5 8]; % set the required phase frequency range
 highfreq = high(1):2:high(2);
 amp_length = length(highfreq);
 lowfreq = low(1):1:low(2);
 phase_length = length(lowfreq);
 tf_MVL_all = zeros(amp_length,phase_length);

 for k = 1:phase_length
     for j = 1:amp_length
         l_freq = lowfreq(k);
         h_freq = highfreq(j);
         [tf_MVL_all(j,k)] = tfMVL(data, h_freq, l_freq, Fs);
     end
 end
    
     plot_comodulogram(tf_MVL_all,high,low) %plot comodulogram
     set(gcf,'Position',get(0,'Screensize'));
    caxis([0, 1]); 
    colorbar;
    title(strcat('event:',eve,'__CH',int2str(c)));
    saveas(gcf,strcat(pwd,'\PAC\event_',eve,'_CH',int2str(c),'.png'))  
    
  % PAC on the time window
 for cnt = 1:numWindows
    idx = (cnt-1)*overlap+1;
    x = data(idx:idx+windowSize-1);
    
    high = [30 50]; % set the required amplitude frequency range
    low = [5 8]; % set the required phase frequency range
    highfreq = high(1):2:high(2);
    amp_length = length(highfreq);
    lowfreq = low(1):1:low(2);
    phase_length = length(lowfreq);
    tf_MVL_all = zeros(amp_length,phase_length);

    for k = 1:phase_length
        for j = 1:amp_length
            l_freq = lowfreq(k);
            h_freq = highfreq(j);
            [tf_MVL_all(j,k)] = tfMVL(x, h_freq, l_freq, Fs);
        end
    end
    
%     tf_MVL = abs(max(max(tf_MVL_all))); % Computed tf-MVL value
%     [high_in, low_in] = find((tf_MVL_all==tf_MVL));
%     high_pacf = highfreq(high_in); % Detected amplitude providing Frequency
%     low_pacf = lowfreq(low_in); % Detected phase providing Frequency
%     pacfreq = [low_pacf, high_pacf];
    plot_comodulogram(tf_MVL_all,high,low) %plot comodulogram
    set(gcf,'Position',get(0,'Screensize'));
    caxis([0, 1]); 
    colorbar;
    title(strcat('event:',eve,'__CH',int2str(c),'_step:',int2str(cnt)));
    saveas(gcf,strcat(pwd,'\PAC\event_',eve,'_CH',int2str(c),'step_',int2str(cnt),'.png'))  
    tf = tf_MVL_all(1:5,:);     %30-50 * 4-8 to 30-34 * 4*8
    tf_MVL_mean = mean(mean(tf)); 
    pac(cnt)=tf_MVL_mean;
    
    pac_v=tf(:)';
    trialnumber = length(pac_v);
    mean_sgn = mean(pac_v);
    std_sgn = std(pac_v,1)/sqrt(trialnumber);

    ts = tinv([0.025 0.975],trialnumber-1);
    CI_1(cnt) = mean_sgn + ts(1) * std_sgn;
    CI_2(cnt) = mean_sgn + ts(2) * std_sgn;

 end
    t= 1:numWindows;
    %figure('Position', [0 0 800 600])
    curve1 = CI_2(:);
    curve2 = CI_1(:);
    t2 = [t, fliplr(t)];
    inBetween = [curve1', fliplr(curve2')];
    fill(t2, inBetween, 'b','FaceAlpha',0.3);
    hold on;
    %save(strcat('pac_CH',int2str(c),'std'),'pac')
    xticklabels({'-200to0' '-100to100' '0to200' '100to300' '200to400' '300to500' '400to600' '500to700' '600to800' '700to900' '800to1000'})
    
    plot(t,pac);
    set(gcf,'Position',get(0,'Screensize'));
    title(strcat('dynamic_event:',eve,'__CH',int2str(c)));
    saveas(gcf,strcat(pwd,'\PAC\dynamic_event_',eve,'_CH',int2str(c),'.png'))
    close all;
end

