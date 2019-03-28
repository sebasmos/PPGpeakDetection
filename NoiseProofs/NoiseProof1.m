clear all
close all
clc

[mediamuestral,TamRealizaciones]=GetAveragedNoise();

%% PROOF 1: Cleaning corrupted signal with Savitzky-Golay filter.
% Random sample signal: 
ppg = load('DATA_02_TYPE02.mat');
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
[PKS1Original,LOCS1Original] = GetPeakPoints(ppgFullSignal(1,(1:3750)),Fs,0.11,0.5,0.05);
[PKS1Cleaned,LOCS1Cleaned] = GetPeakPoints(CleanedSignal1,Fs,0.11,0.5,0.05);
% 2. CORRIENDO 1min se�al original vs sin ruido
[PKS2Original,LOCS2Original] = GetPeakPoints(ppgFullSignal(1,(3751:11250)),Fs,0.11,0.5,0.07);
[PKS2Cleaned,LOCS2Cleaned] = GetPeakPoints(CleanedSignal2,Fs,0.11,0.5,0.07);
% 3. CORRIENDO 1min se�al original vs sin ruido
[PKS3Original,LOCS3Original] = GetPeakPoints(ppgFullSignal(1,(11251:18750)),Fs,0.07,0.3,0.05);
[PKS3Cleaned,LOCS3Cleaned] = GetPeakPoints(CleanedSignal3,Fs,0.07,0.3,0.05);
% 4. CORRIENDO 1min se�al original vs sin ruido
[PKS4Original,LOCS4Original] = GetPeakPoints(ppgFullSignal(1,(18751:26250)),Fs,0.05,0.3,0.05);
[PKS4Cleaned,LOCS4Cleaned] = GetPeakPoints(CleanedSignal4,Fs,0.05,0.3,0.05);
% 5. CORRIENDO 1min se�al original vs sin ruido
[PKS5Original,LOCS5Original] = GetPeakPoints(ppgFullSignal(1,(26251:33750)),Fs,0.07,0.3,0.08);
[PKS5Cleaned,LOCS5Cleaned] = GetPeakPoints(CleanedSignal5,Fs,0.07,0.3,0.08);
% 6. REST 30s se�al original vs sin ruido
[PKS6Original,LOCS6Original] = GetPeakPoints(ppgFullSignal(1,(33751:end)),Fs,0.07,0.5,0.04);
[PKS6Cleaned,LOCS6Cleaned] = GetPeakPoints(CleanedSignal6,Fs,0.07,0.5,0.04);

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
realizacion = 2;
% Separate peaks from findpeaks detection 
FindPeaks1 = length(LOCS1Cleaned);
FindPeaks2 = length(LOCS2Cleaned);
FindPeaks3 = length(LOCS3Cleaned);
FindPeaks4 = length(LOCS4Cleaned);
FindPeaks5 = length(LOCS5Cleaned);
FindPeaks6 = length(LOCS6Cleaned);
% For computational reasons, we separate the 30s-activities
bpm1 = bpm(1,realizacion)./2;
bpm6 = bpm(6,realizacion)./2;
% %
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

[ECG1Peaks,ECG1Locs] = GetECGPeakPoints(ecgF(1,(1:3750)),0.5,30);
[ECG2Peaks,ECG2Locs] = GetECGPeakPoints(ecgF(1,(3751:11250)),0.53,15);
[ECG3Peaks,ECG3Locs] = GetECGPeakPoints(ecgF(1,(11251:18750)),0.5,33);
[ECG4Peaks,ECG4Locs] = GetECGPeakPoints(ecgF(1,(18751:26250)),0.5,25);
[ECG5Peaks,ECG5Locs] = GetECGPeakPoints(ecgF(1,(26251:33750)),0.45,30);
[ECG6Peaks,ECG6Locs] = GetECGPeakPoints(ecgF(1,(33751:end)),0.5,35);

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

disp('CALCULO % ERRORES: Fila 1 (FindPeaks), Fila 2 (BPM), Fila 3 (ECG)')
ErroresTotales = [ErrorFromFindPeaks;ErrorFromBPM;ErrorFromECG]