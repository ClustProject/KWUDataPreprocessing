clear
clc

%Datasets
num_chf = {'chf01','chf02','chf03','chf05','chf06','chf07','chf08','chf09','chf10','chf11','chf12','chf13','chf14','chf15'};
num_af = { '04043', '04126', '04746', '04908', '04936', '05091', '05121', '07859', '07879', '07910',  '08378', '08405', '08434', '08455'};
num_healthy = {'f1o01','f1o03','f1o05','f1o06','f1o07','f1o08','f1o09','f1y01','f1y02','f1y03','f1y04','f1y05','f1y06','f1y07','f1y08','f1y09'};

%Initialize
Fs_CHF = 250;
Fs_AF = 250; 
Fs_HEALTHY = 250;
base = 0;
gain = 200;

%Set location of dataset
path_origin = '/Users/youngjunkim/Documents/MATLAB/Entropy';
path_chf = '/Users/youngjunkim/Documents/MATLAB/Entropy/CHF';
path_af = '/Users/youngjunkim/Documents/MATLAB/Entropy/AFDB';
path_healthy = '/Users/youngjunkim/Documents/MATLAB/Entropy/Healthy';

%% Load data
cd(path_chf)
for k=1:length(num_chf)
    fprintf('Load ann,sig _ subject %s..\n',num_chf{k});
    sub = num_chf{k};
    cd(path_origin)
    load([path_chf,'/', num_chf{k},'m'])
    eval(['raw = val(2,:);']);
    
    %To convert from raw units to physical units, 
    %subtract 'base' and divide by 'gain'
    rawCHF = (raw - base)/gain;
    sigCHF(k,:) = rawCHF(1:1000000);
end

cd(path_af)
for k=1:length(num_af)
    fprintf('Load ann,sig _ subject %s..\n',num_af{k});
    sub = num_af{k};
    cd(path_origin)
    load([path_af,'/', num_af{k},'m'])
    eval(['raw = val(2,:);']);
    
    %To convert from raw units to physical units, 
    %subtract 'base' and divide by 'gain'
    rawAF = (raw - base)/gain;
    sigAF(k,:) = rawAF(1:1000000);
end

cd(path_origin)
cd(path_healthy)
for k=1:length(num_healthy)
    fprintf('Load ann,sig _ subject %s..\n',num_healthy{k});
    sub = num_healthy{k};
    cd(path_origin)
    load([path_healthy,'/', num_healthy{k},'m'])
    eval(['raw = val(1,:);']);
    
    %To convert from raw units to physical units, 
    %subtract 'base' and divide by 'gain'
    rawHEALTHY = (raw - base)/gain;
    sigHEALTHY(k,:) = rawHEALTHY(1:1550000);
end

cd(path_origin)

%% Preprocessing and Extract RRIs

pts = 1000;

% CHF Data
for i=1:size(sigCHF,1)
    ecg = sigCHF(i,:);
    % Check data loss
    for k=1: length(ecg)
       if(isnan(ecg(k)))
           ecg(k) = (ecg(k-1)+ecg(k-2))/2;
       end
    end
    % Find R-Peaks using Pan and Tompkins Algorithm
    [~,qrs_i_raw,~]=pan_tompkin(ecg,Fs_CHF,0);
    % Convert interval of R peak into time unit
    tmp = (qrs_i_raw(2:end) - qrs_i_raw(1:end-1))./Fs_CHF;    
    % Remove abnormal RRI
    tmp(find((tmp > 1.9) | (tmp < 0.2)))=[];
    % Remove outliers
    procRRIs = preprocessRRIs(tmp);
    % Save predefined RRIs pts
    RRIs_CHF(i,:) = procRRIs(1:pts);
end

% AF Data
for i=1:size(sigAF,1)
    ecg = sigAF(i,:);
    % Check data loss
    for k=1: length(ecg)
       if(isnan(ecg(k)))
           ecg(k) = (ecg(k-1)+ecg(k-2))/2;
       end
    end
    % Find R-Peaks using Pan and Tompkins Algorithm
    [~,qrs_i_raw,~]=pan_tompkin(ecg,Fs_AF,0);
    % Convert interval of R peak into time unit
    tmp = (qrs_i_raw(2:end) - qrs_i_raw(1:end-1))./Fs_AF;
    % Remove abnormal RRI
    tmp(find((tmp > 1.9) | (tmp < 0.2)))=[];
    % Remove outliers
    procRRIs = preprocessRRIs(tmp);
    % Save predefined RRIs pts
    RRIs_AF(i,:) = procRRIs(1:pts);
end

% HEALTHY
for i=1:size(sigHEALTHY,1)
    ecg = sigHEALTHY(i,:);
    % Check data loss
    for k=1: length(ecg)
       if(isnan(ecg(k)))
           ecg(k) = (ecg(k-1)+ecg(k-2))/2;
       end
    end 
    % Find R-Peaks using Pan and Tompkins Algorithm
    [~,qrs_i_raw,~]=pan_tompkin(ecg,Fs_HEALTHY,0);
    % Convert interval of R peak into time unit
    tmp = (qrs_i_raw(2:end) - qrs_i_raw(1:end-1))./Fs_HEALTHY;
    % Remove abnormal RRI
    tmp(find((tmp > 1.9) | (tmp < 0.2)))=[];
    % Remove outliers
    procRRIs = preprocessRRIs(tmp);
    % Save predefined RRIs pts
    RRIs_HEALTHY(i,:) = procRRIs(1:pts);
end