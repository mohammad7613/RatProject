if ~exist('dataDir', 'var')
    dataDir = uigetdir([], 'Path to Mat Data Folder');
end

% Load Triggers
load(fullfile(dataDir, 'trigger.mat'))

% This code epoch the data based on the event
event=20;


% Decimate RawDataFiles
dataFile = ls(fullfile(dataDir, 'CleanData.mat')); % shape=  #channel*time
assert(size(dataFile, 1) == 1)

load(fullfile(dataDir, dataFile))


fs = 1000;

% Epoching
preOnsetSamples = 1000 ;  % 
postOnsetSamples = 11000;    % 11 sec after starting stimulus
time = -preOnsetSamples:postOnsetSamples;

% Convert trigger of rat to trigger of monkey
onsetTimes = find(trigger == event);
tag = onsetTimes (diff ([0 onsetTimes']) > 1);

data = nan(length(tag), preOnsetSamples + postOnsetSamples+ 1, ...
    size(rawData, 1));
for iTrial = 1:size(data, 1)
    os = tag(iTrial) ;
    data(iTrial, :, :) = rawData(:, os-preOnsetSamples:os+postOnsetSamples)';
end
clear iTrial filteredData postOnsetSamples preOnsetSamples os triggerTimes
clear nTrialSample 

data = permute(data,[3 2 1]);

% Saving Results
save(fullfile(dataDir, strcat('Epoch_event_',int2str(event))), 'trigger', 'data', 'time');