clear all
close all
clc
%% ARTIFITIAL NOISE DESIGN 

% This code intends to proof the viability of the obtained noise from the
% substraction of the signal minus the Savitzky-golay's filter through the
% function findpeaks as demonstrated below
% Activities type 1 from type 2 differ only from the 2nd activities ahead,
% where the set speeds for the trendmill in activities type2 are under 6
% and 12 km/h:
% 1. Rest (30s)
% 2. Running 8km/h (1min) corresponds to 6 km/h in activity type 2
% 3. Running 15km/h (1min) corresponds to 12 km/h in activity type 2
% 4. Running 8km/h (1min)  corresponds to 6 km/h in activity type 2
% 5. Running 15km/h (1min) corresponds to 12 km/h in activity type 2
% 6. Rest (30 min)

% Initial Conditions

k=0;
prom=0;
sm0=0;
sm1=0;
sm2=0;
sm3=0;
sm4=0;
sm5=0;

% Lecture of datasets
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    end
end


for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    else       
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    end
    % Sample mean
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s1(k,:);
    sm2 = sm2 + s2(k,:);
    sm3 = sm3 + s3(k,:);
    sm4 = sm4 + s4(k,:);
    sm5 = sm5 + s5(k,:);

end

%% SAMPLE MEAN
% Noise is organized in a single matrix M with size 6x7500, where the rows
% represent the type of activity and the columns represent the samples of
% each dataset. For the signals in the samples 0-3750 (30s activity), 3750
% zeros are added in order to fit the matrix with the right dimen.

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;

% As a vertical mean has been done, so the sampled mean has also been done and
% therefore this procedure is equivalent to use the function mean

Media0 = M./Realizaciones;

% Re-set the sampled mean on a single line linking the 6 activity signals
% one with the next.

v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];

% Delete extra zeros.

mediamuestral=nonzeros(v);
mediamuestral=mediamuestral';

%% PROOF 1: Cleaning corrupted signal with Savitzky-Golay filter.
% Random sample signal: 
ppg = load('DATA_10_TYPE02.mat');
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
CorruptedSignal1 = ppgFullSignal(1,(1:3750))-ruido1;
CorruptedSignal2 = ppgFullSignal(1,(3751:11250))-ruido2;
CorruptedSignal3 = ppgFullSignal(1,(11251:18750))-ruido3;
CorruptedSignal4 = ppgFullSignal(1,(18751:26250))-ruido4;
CorruptedSignal5 = ppgFullSignal(1,(26251:33750))-ruido5;
CorruptedSignal6 = ppgFullSignal(1,(33751:min(TamRealizaciones)))-ruido6;

% 1. ORIGINAL en reposo vs con ruido
[PKS1Original,LOCS1Original] = GetPeakPoints(ppgFullSignal(1,(1:3750)),Fs,0.11,0.5,0.05);
[PKS1ruido,LOCS1ruido] = GetPeakPoints(CorruptedSignal1,Fs,0.11,0.5,0.05);
% 2. CORRIENDO 1min señal original vs con ruido
[PKS2Original,LOCS2Original] = GetPeakPoints(ppgFullSignal(1,(3751:11250)),Fs,0.11,0.5,0.15);
[PKS2ruido,LOCS2ruido] = GetPeakPoints(CorruptedSignal2,Fs,0.11,0.5,0.15);
% 3. CORRIENDO 1min señal original vs con ruido
[PKS3Original,LOCS3Original] = GetPeakPoints(ppgFullSignal(1,(11251:18750)),Fs,0.11,0.5,0.15);
[PKS3ruido,LOCS3ruido] = GetPeakPoints(CorruptedSignal3,Fs,0.11,0.5,0.15);
% 4. CORRIENDO 1min señal original vs con ruido
[PKS4Original,LOCS4Original] = GetPeakPoints(ppgFullSignal(1,(18751:26250)),Fs,0.11,0.5,0.15);
[PKS4ruido,LOCS4ruido] = GetPeakPoints(CorruptedSignal4,Fs,0.11,0.5,0.15);
% 5. CORRIENDO 1min señal original vs con ruido
[PKS5Original,LOCS5Original] = GetPeakPoints(ppgFullSignal(1,(26251:33750)),Fs,0.11,1,0.15);
[PKS5ruido,LOCS5ruido] = GetPeakPoints(CorruptedSignal5,Fs,0.11,1,0.15);
% 6. REST 30s señal original vs con ruido
[PKS6Original,LOCS6Original] = GetPeakPoints(ppgFullSignal(1,(33751:end)),Fs,0.11,0.5,0.05);
[PKS6ruido,LOCS6ruido] = GetPeakPoints(CorruptedSignal6,Fs,0.11,0.5,0.05);
%% Error using HeartBeats from findpeaks
Error1 = 100*abs(size(LOCS1ruido(1,:))-size(LOCS1Original(1,:)))./size(LOCS1Original(1,:));
Error2 = 100*abs(size(LOCS2ruido(1,:))-size(LOCS2Original(1,:)))./size(LOCS2Original(1,:));
Error3 = 100*abs(size(LOCS3ruido(1,:))-size(LOCS3Original(1,:)))./size(LOCS3Original(1,:));
Error4 = 100*abs(size(LOCS4ruido(1,:))-size(LOCS4Original(1,:)))./size(LOCS4Original(1,:));
Error5 = 100*abs(size(LOCS5ruido(1,:))-size(LOCS5Original(1,:)))./size(LOCS5Original(1,:));
Error6 = 100*abs(size(LOCS6ruido(1,:))-size(LOCS6Original(1,:)))./size(LOCS6Original(1,:));
ErrorFromFindPeaks = [Error1(2) Error2(2) Error3(2) Error4(2) Error5(2) Error6(2)];
%% Error from BPM 
% bpm stores the bpm in the matrix 6x12, where 1-6 represents the type of
% activity and 1-12 represents the number of realizations. Since the bpm is
% taken from 8 windows size and is overlapping every 6s, there are 2
% effective seconds and therefore, the activity 1 (Rest per 30s)
% corresponds to 15 effective seconds
bpm = CompareBPM();
realizacion = 10;
Er1 = size(LOCS1ruido(1,:));
Er2 = size(LOCS2ruido(1,:));
Er3 = size(LOCS3ruido(1,:));
Er4 = size(LOCS4ruido(1,:));
Er5 = size(LOCS5ruido(1,:));
Er6 = size(LOCS6ruido(1,:));
E1 = 100*abs(Er1(2)-bpm(1,realizacion)./2)./bpm(1,realizacion);
E2 = 100*abs(Er2(2)-bpm(2,realizacion))./bpm(2,realizacion);
E3 = 100*abs(Er3(2)-bpm(3,realizacion))./bpm(3,realizacion);
E4 = 100*abs(Er4(2)-bpm(4,realizacion))./bpm(4,realizacion);
E5 = 100*abs(Er5(2)-bpm(5,realizacion))./bpm(5,realizacion);
E6 = 100*abs(Er6(2)-bpm(6,realizacion)./2)./bpm(6,realizacion);
ErrorFromBPM = [E1 E2 E3 E4 E5 E6];