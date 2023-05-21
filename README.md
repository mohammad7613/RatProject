Hi, This is your task file report MS fazeli :)

Tasks

- [x] Implement the genral code for preprocessing 
Both manual procedure(using EEGLAB GUI) and code procedures is checked.Tthe resulted EEG.datas are the same for Both.
All the codes are located in "/codes/preprocess/CleanData.m"
How to used it:
    - Specify the preprocess parmaters or steps in the code and document them in Versions.md maually.
    - Change the version integer in the code crospondingly with the previous step, a new version you have added to Version.md
    - run the preprocess section.
    - The resulted set file is going to be saved in Mat Folder along with raw data sessionData.mat
- [x] Normalized and Epoched Data
After preprocessing, the resulted data stored in a .set file is loaded and normalized through the time over each channel. The normalized data is epoched based the events
All the epoched data is stored in a struct with fields {events,data(array with shape(3,NumAllTrials,NumSamples))}. The "events" fields includes is a struct with fields trigger_index and name specifying the index of trials and the name of the event, respectively.
All the codes, including the validation codes, are located in "/codes/preprocess/EpochData.m".
How to use it:
    - Specify the resulted preprocessed .set file in the begining of the code
    - Load trigger info from rawdata sessionData.mat
    - Run Normalization section 
    - Specify events indexs and name
    - Run normalization section 
    - Run finally select a name and run save section.
    - The resulted set file is going to be saved in Mat Folder along with raw data sessionData.mat
- [x] Run PAC and ERP on Epoched and normalized Data 
After Epoched data, we can use ERP or PAC sepratly, all codesare located in "/codes/...".
In PAC three type diagram are been ploted (whole time, windowing and dynamic). The frequency for whole time is set to 5-8 and 30-50. Although, this range is reduced to 30-34 * 4-8 for dynamic plots. 
The results are saved in a subfolder of the data folder named PAC or ERP
