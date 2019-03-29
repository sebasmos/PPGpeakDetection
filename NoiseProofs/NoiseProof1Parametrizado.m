clear all
close all
clc
%% Add Datasets
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\Training_data\db');
%% Get Noise from Savitzky method
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
%% Initial Conditions
% PARAMETERS FOR PPG SIGNAL
% MinPeakWidth
MinPeakWidthRest1 = 0.11;
MinPeakWidthRun_2 = 0.07;
MinPeakWidthRun_3 = 0.07;
MinPeakWidthRun_4 = 0.07;
MinPeakWidthRun_5 = 0.07;
MinPeakWidthRest6 = 0.05;
% MaxWidthPeak in PPG
MaxWidthRest1 = 0.5;
MaxWidthRun2 = 0.5;
MaxWidthRun3 = 0.5;
MaxWidthRun4 = 0.5;
MaxWidthRun5 = 0.8;
MaxWidthRest6 = 1.3;
% Prominence in PPG
ProminenceInRest1 = 0.009;
ProminenceRun2 = 0.04;
ProminenceRun3 = 0.04;
ProminenceRun4 = 0.03;
ProminenceRun5 = 0.04;
ProminenceInRest6 = 0.01;
% Min peak Distance in PPG
MinDistRest1 = 0.3;
MinDistRun2 = 0.3;
MinDistRun3 = 0.1;
MinDistRun4 = 0.15;
MinDistRun5 = 0.1;
MinDistRest6 = 0.2;
%% PARAMETERS IN ECG SIGNAL
% Min Height in ECG
MinHeightECGRest1 = 0.5;
MinHeightECGRun2  = 0.5;
MinHeightECGRun3  = 0.55;
MinHeightECGRun4  = 0.55;
MinHeightECGRun5  = 0.55;
MinHeightECGRest6 = 0.55;
%Min Dist in ECG
minDistRest1 = 0.1;
minDistRun2 = 0.3;
minDistRun3 = 0.3;
minDistRun4 = 0.3;
minDistRun5 = 0.2;
minDistRest6 = 0.2;
%% PROOF 1: Cleaning corrupted signal with Savitzky-Golay filter.
% Random sample signal: 
ppg = load('DATA_01_TYPE02.mat');
ppgSig = ppg.sig;
ppgFullSignal = ppgSig(2,(1:length(mediamuestral)));% match sizes 
% Sample Frequency
Fs = 125;
% Normalize with min-max method
ppgFullSignal = (ppgFullSignal-128)./255;
ppgFullSignal = (ppgFullSignal-min(ppgFullSignal))./(max(ppgFullSignal)-min(ppgFullSignal));
t = (0:length(ppgFullSignal)-1);   
% Separate noise with its correspondent activity.
ruido1 = mediamuestral(1,(1:3750));
ruido2 = mediamuestral(1,(3751:11250));
ruido3 = mediamuestral(1,(11251:18750));
ruido4 = mediamuestral(1,(18751:26250));
ruido5 = mediamuestral(1,(26251:33750));
ruido6 = mediamuestral(1,(33751:min(TamRealizaciones)));

% Sectionally take off noise from each correspondent activity.
CleanedSignal1 = ppgFullSignal(1,(1:3750))-ruido1;
CleanedSignal2 = ppgFullSignal(1,(3751:11250))-ruido2;
CleanedSignal3 = ppgFullSignal(1,(11251:18750))-ruido3;
CleanedSignal4 = ppgFullSignal(1,(18751:26250))-ruido4;
CleanedSignal5 = ppgFullSignal(1,(26251:33750))-ruido5;
CleanedSignal6 = ppgFullSignal(1,(33751:min(TamRealizaciones)))-ruido6;

% 1. ORIGINAL en reposo vs sin ruido
[PKS1Original,LOCS1Original] = GetPeakPoints(ppgFullSignal(1,(1:3750)),...
    Fs,MinPeakWidthRest1,MaxWidthRest1,ProminenceInRest1,MinDistRest1);
[PKS1Cleaned,LOCS1Cleaned] = GetPeakPoints(CleanedSignal1,Fs,MinPeakWidthRest1,...
    MaxWidthRest1,ProminenceInRest1,MinDistRest1);
% 2. CORRIENDO 1min señal original vs sin ruido
[PKS2Original,LOCS2Original] = GetPeakPoints(ppgFullSignal(1,(3751:11250)),...
    Fs,MinPeakWidthRun_2,MaxWidthRun2,ProminenceRun2,MinDistRun2);
[PKS2Cleaned,LOCS2Cleaned] = GetPeakPoints(CleanedSignal2,Fs,MinPeakWidthRun_2,...
    MaxWidthRun2,ProminenceRun2,MinDistRun2);
% 3. CORRIENDO 1min señal original vs sin ruido
[PKS3Original,LOCS3Original] = GetPeakPoints(ppgFullSignal(1,(11251:18750)),...
    Fs,MinPeakWidthRun_3,MaxWidthRun3,ProminenceRun3,MinDistRun3);
[PKS3Cleaned,LOCS3Cleaned] = GetPeakPoints(CleanedSignal3,Fs,MinPeakWidthRun_3,...
    MaxWidthRun3,ProminenceRun3,MinDistRun3);
% 4. CORRIENDO 1min señal original vs sin ruido
[PKS4Original,LOCS4Original] = GetPeakPoints(ppgFullSignal(1,(18751:26250)),...
    Fs,MinPeakWidthRun_4,MaxWidthRun4,ProminenceRun4,MinDistRun4);
[PKS4Cleaned,LOCS4Cleaned] = GetPeakPoints(CleanedSignal4,Fs,MinPeakWidthRun_4,...
    MaxWidthRun4,ProminenceRun4,MinDistRun4);
% 5. CORRIENDO 1min señal original vs sin ruido
[PKS5Original,LOCS5Original] = GetPeakPoints(ppgFullSignal(1,(26251:33750)),...
    Fs,MinPeakWidthRun_5,MaxWidthRun5,ProminenceRun5,MinDistRun5);
[PKS5Cleaned,LOCS5Cleaned] = GetPeakPoints(CleanedSignal5,Fs,MinPeakWidthRun_5,...
    MaxWidthRun5,ProminenceRun5,MinDistRun5);
% 6. REST 30s señal original vs sin ruido
[PKS6Original,LOCS6Original] = GetPeakPoints(ppgFullSignal(1,(33751:end)),...
    Fs,MinPeakWidthRest6,MaxWidthRest6,ProminenceInRest6,MinDistRest6);
[PKS6Cleaned,LOCS6Cleaned] = GetPeakPoints(CleanedSignal6,Fs,MinPeakWidthRest6,...
    MaxWidthRest6,ProminenceInRest6,MinDistRest6);

%% Error using HeartBeats from findpeaks
ErrorFindP1 = 100*abs(length(LOCS1Cleaned)-length(LOCS1Original))./length(LOCS1Original);
ErrorFindP2 = 100*abs(length(LOCS2Cleaned)-length(LOCS2Original))./length(LOCS2Original);
ErrorFindP3 = 100*abs(length(LOCS3Cleaned)-length(LOCS3Original))./length(LOCS3Original);
ErrorFindP4 = 100*abs(length(LOCS4Cleaned)-length(LOCS4Original))./length(LOCS4Original);
ErrorFindP5 = 100*abs(length(LOCS5Cleaned)-length(LOCS5Original))./length(LOCS5Original);
ErrorFindP6 = 100*abs(length(LOCS6Cleaned)-length(LOCS6Original))./length(LOCS6Original);
ErrorFromFindPeaks = [ErrorFindP1 ErrorFindP2 ErrorFindP3 ErrorFindP4 ErrorFindP5 ErrorFindP6];
%% Error from BPM 
% bpm stores the bpm in the matrix 6x12, where 1-6 represents the type of
% activity and 1-12 represents the number of realizations. Since the bpm is
% taken from 8 windows size and is overlapping every 6s, there are 2
% effective seconds and therefore, the activity 1 (Rest per 30s)
% corresponds to 15 effective seconds
bpm = CompareBPM();
realizacion = 1;
% PEAKS IN PPG SIGNAL Separate peaks from findpeaks detection 
FindPeaks1 = length(LOCS1Cleaned);
FindPeaks2 = length(LOCS2Cleaned);
FindPeaks3 = length(LOCS3Cleaned);
FindPeaks4 = length(LOCS4Cleaned);
FindPeaks5 = length(LOCS5Cleaned);
FindPeaks6 = length(LOCS6Cleaned);
% For computational reasons, we separate the 30s-activities
bpm1 = bpm(1,realizacion)./2;
bpm6 = bpm(6,realizacion)./2;
%
EBPM1 = 100*abs(FindPeaks1-bpm1)./bpm1;
EBPM2 = 100*abs(FindPeaks2-bpm(2,realizacion))./bpm(2,realizacion);
EBPM3 = 100*abs(FindPeaks3-bpm(3,realizacion))./bpm(3,realizacion);
EBPM4 = 100*abs(FindPeaks4-bpm(4,realizacion))./bpm(4,realizacion);
EBPM5 = 100*abs(FindPeaks5-bpm(5,realizacion))./bpm(5,realizacion);
EBPM6 = 100*abs(FindPeaks6-bpm6)./bpm6;


ErrorFromBPM = [EBPM1 EBPM2 EBPM3 EBPM4 EBPM5 EBPM6];


%% PROOF 2: ECG peaks detection
% Random sample signal: 
ecg = load('DATA_01_TYPE02.mat');
ecgSig = ecg.sig;
ecgFullSignal = ecgSig(1,(1:length(mediamuestral)));% match sizes 
% Normalize with min-max method
ecgFullSignal = (ecgFullSignal-128)./255;
ecgFullSignal = (ecgFullSignal-min(ecgFullSignal))./(max(ecgFullSignal)-min(ecgFullSignal));
% Squared signal to 
ecgF = (abs(ecgFullSignal)).^2;
t = (0:length(ecgFullSignal)-1)/Fs;   

[ECG1Peaks,ECG1Locs] = GetECGPeakPoints(ecgF(1,(1:3750)),MinHeightECGRest1,minDistRest1);
[ECG2Peaks,ECG2Locs] = GetECGPeakPoints(ecgF(1,(3751:11250)),MinHeightECGRun2,minDistRun2);
[ECG3Peaks,ECG3Locs] = GetECGPeakPoints(ecgF(1,(11251:18750)),MinHeightECGRun3,minDistRun3);
[ECG4Peaks,ECG4Locs] = GetECGPeakPoints(ecgF(1,(18751:26250)),MinHeightECGRun4,minDistRun4);
[ECG5Peaks,ECG5Locs] = GetECGPeakPoints(ecgF(1,(26251:33750)),MinHeightECGRun5,minDistRun5);
[ECG6Peaks,ECG6Locs] = GetECGPeakPoints(ecgF(1,(33751:end)),MinHeightECGRest6,minDistRest6);

peaksECG1 = length(ECG1Locs);
peaksECG2 = length(ECG2Locs);
peaksECG3 = length(ECG3Locs);
peaksECG4 = length(ECG4Locs);
peaksECG5 = length(ECG5Locs);
peaksECG6 = length(ECG6Locs);

ECGERROR1 = 100*abs(FindPeaks1-peaksECG1)./peaksECG1;
ECGERROR2 = 100*abs(FindPeaks2-peaksECG2)./peaksECG2;
ECGERROR3 = 100*abs(FindPeaks3-peaksECG3)./peaksECG3;
ECGERROR4 = 100*abs(FindPeaks4-peaksECG4)./peaksECG4;
ECGERROR5 = 100*abs(FindPeaks5-peaksECG5)./peaksECG5;
ECGERROR6 = 100*abs(FindPeaks6-peaksECG6)./peaksECG6;
ErrorFromECG = [ECGERROR1 ECGERROR2 ECGERROR3 ECGERROR4 ECGERROR5 ECGERROR6];

FindPeaksOriginalPeaks = [length(LOCS1Original) length(LOCS2Original) length(LOCS3Original) length(LOCS4Original) length(LOCS5Original) length(LOCS6Original)]

FindPeakDenoisedPeaks = [length(PKS1Cleaned) length(PKS2Cleaned) length(PKS3Cleaned) length(PKS4Cleaned) length(PKS5Cleaned) length(PKS6Cleaned)] 

showBPMPeaks = [bpm1 bpm(2,realizacion) bpm(3,realizacion) bpm(4,realizacion) bpm(5,realizacion) bpm6]

showECGPeaks = [peaksECG1 peaksECG2 peaksECG3 peaksECG4 peaksECG5 peaksECG6  ]
disp('CALCULO % ERRORES: Fila 1 (FindPeaks), Fila 2 (BPM), Fila 3 (ECG)')
ErroresTotales = [ErrorFromFindPeaks;ErrorFromBPM;ErrorFromECG]