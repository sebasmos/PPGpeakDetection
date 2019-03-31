clear all
close all
clc
%% Add Datasets
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GeneralNoise');
%% Get Noise from Savitzky method
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
%% Initial Conditions
% K represents the number of realization to extract error individually
j = 1;
% PARAMETERS FOR PPG SIGNAL
% MinPeakWidth
MinPeakWidthRest1 = 0.11;
MinPeakWidthRun_2 = 0.01;
MinPeakWidthRun_3 = 0.07;
MinPeakWidthRun_4 = 0.07;
MinPeakWidthRun_5 = 0.07;
MinPeakWidthRest6 = 0.05;
% MaxWidthPeak in PPG
MaxWidthRest1 = 0.5;
MaxWidthRun2 = 0.6;
MaxWidthRun3 = 0.5;
MaxWidthRun4 = 0.8;
MaxWidthRun5 = 0.8;
MaxWidthRest6 = 1.5;
% Prominence in PPG
ProminenceInRest1 = 0.009;
ProminenceRun2 = 0.049;
ProminenceRun3 = 0.038;
ProminenceRun4 = 0.04;
ProminenceRun5 = 0.04;
ProminenceInRest6 = 0.01;
% Min peak Distance in PPG
MinDistRest1 = 0.3;
MinDistRun2 = 0.1;
MinDistRun3 = 0.1;
MinDistRun4 = 0.15;
MinDistRun5 = 0.1;
MinDistRest6 = 0.2;
%% PARAMETERS IN ECG SIGNAL
% Min Height in ECG
MinHeightECGRest1 = 0.025;
MinHeightECGRun2  = 0.025;
MinHeightECGRun3  = 0.04;
MinHeightECGRun4  = 0.04;
MinHeightECGRun5  = 0.04;
MinHeightECGRest6 = 0.04;
%Min Dist in ECG
minDistRest1 = 0.6;
minDistRun2 = 0.5;
minDistRun3 = 0.2;
minDistRun4 = 0.2;
minDistRun5 = 0.2;
minDistRest6 = 0.2;
% MaxPeakWidth
MaxPeakWidthECG1 = 0.05;
MaxPeakWidthECG2 = 0.05;
MaxPeakWidthECG3 = 0.05;
MaxPeakWidthECG4 = 0.05;
MaxPeakWidthECG5 = 0.05;
MaxPeakWidthECG6 = 0.05;
%% PROOF 1: Cleaning corrupted signal with Savitzky-Golay filter.
% EXTRACT PPG & ECG SIGNALS FROM IEEE PROCESSING CUP DATASET
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:length(mediamuestral)));
        ECGdatasetSignals(k,:)=a.sig(1,(1:length(mediamuestral)));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:length(mediamuestral)));
        ECGdatasetSignals(k,:)=a.sig(1,(1:length(mediamuestral)));
    end
end
%% ECG PEAKS EXTRACTION
% Sample Frequency
    Fs = 125;
    
%% CONVERSION TO PHYSICAL SIGNALS: According to timesheet of the used wearable
ECGFullSignals = (ECGdatasetSignals-128)./255;
PPGFullSignals = (PPGdatasetSignals-128)/(255);

%% NORMALIZE ENTIRE DATASET
for k=1:12
    PPGFullNorm(k,:) = (PPGFullSignals(k,:)-min(PPGFullSignals(k,:)))/(max(PPGFullSignals(k,:))-min(PPGFullSignals(k,:)));
    ECGFullNorm(k,:) = (ECGFullSignals(k,:)-min(ECGFullSignals(k,:)))./(max(ECGFullSignals(k,:))-min(ECGFullSignals(k,:)));
end
%% Separate Activities
% PPG Signal activities
Activity1=PPGFullNorm(:,(1:3750));
Activity2=PPGFullNorm(:,(3751:11250));
Activity3=PPGFullNorm(:,(11251:18750));
Activity4=PPGFullNorm(:,(18751:26250));
Activity5=PPGFullNorm(:,(26251:33750));
Activity6=PPGFullNorm(:,(33751:min(TamRealizaciones)));
% ECG signal activities
ActivityECG1=ECGFullNorm(:,(1:3750));
ActivityECG2=ECGFullNorm(:,(3751:11250));
ActivityECG3=ECGFullNorm(:,(11251:18750));
ActivityECG4=ECGFullNorm(:,(18751:26250));
ActivityECG5=ECGFullNorm(:,(26251:33750));
ActivityECG6=ECGFullNorm(:,(33751:min(TamRealizaciones)));
%% CLEAN ECG SIGNAL'S DATASET FROM DRIFT BASELINE NOISE COMPONENT
for k=1:12
    CleanedActivityECG1(k,:)=DenoiseECG(ActivityECG1(k,:));
    CleanedActivityECG2(k,:)=DenoiseECG(ActivityECG2(k,:));
    CleanedActivityECG3(k,:)=DenoiseECG(ActivityECG3(k,:));
    CleanedActivityECG4(k,:)=DenoiseECG(ActivityECG4(k,:));
    CleanedActivityECG5(k,:)=DenoiseECG(ActivityECG5(k,:));
    CleanedActivityECG6(k,:)=DenoiseECG(ActivityECG6(k,:));
end
% Separate noise with its correspondent activity.
ruido1 = mediamuestral(1,(1:3750));
ruido2 = mediamuestral(1,(3751:11250));
ruido3 = mediamuestral(1,(11251:18750));
ruido4 = mediamuestral(1,(18751:26250));
ruido5 = mediamuestral(1,(26251:33750));
ruido6 = mediamuestral(1,(33751:min(TamRealizaciones)));

% Sectionally take off noise from each correspondent activity.
CleanedSignal1 = Activity1-ruido1;
CleanedSignal2 = Activity2-ruido2;
CleanedSignal3 = Activity3-ruido3;
CleanedSignal4 = Activity4-ruido4;
CleanedSignal5 = Activity5-ruido5;
CleanedSignal6 = Activity6-ruido6;
    %% ERROR FOR LP
disp('ERRORES CALCULADOS POR LINEAR PREDICTOR')
findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
    CleanedSignal1(j,:),CleanedSignal2(j,:),CleanedSignal3(j,:),CleanedSignal4(j,:),CleanedSignal5(j,:),CleanedSignal6(j,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
    CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    MaxPeakWidthECG1,MaxPeakWidthECG2,MaxPeakWidthECG3,MaxPeakWidthECG4,MaxPeakWidthECG5,MaxPeakWidthECG6);
