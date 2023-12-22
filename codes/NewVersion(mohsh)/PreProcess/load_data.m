function [data, fs] = load_data(pwd, ses_no, oddball_ratio, exp_no)

    filename = strcat('\sessionDataoddball', ses_no, '_', ...
                   oddball_ratio, '_', exp_no, '.mat');
    file_path = [pwd, '\Data', '\Oddball', filename];
    data = load(file_path);
    fs = data.SampleRate;

end