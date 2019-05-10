
% function [Sensibity,Especificity] = Function_GMA(windowsizeRest,windowsizeRun)
% DESCRIPTION: This function determines the band-limited gaussian noise
% model using a range of seed-values for determining an noise model fed with
% MA noise.
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
% INPUT:     windowsizeReset: Window size for MA window for rest activities
%           windowsizeRun: Window size for MA window for running activities
% OUTPUT:    Sensivility: Performance parameter for ECGPeaks = 0 and PPGPeaks = 0 

function [Sensivility,Especificity,TotalMAHF] = Function_GMA(windowSize)
% addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs')
% addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GaussianNoise')
% addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db')
addpath('C:\MATLAB2018\MATLAB\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db');
addpath('C:\MATLAB2018\MATLAB\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GeneralNoise');
addpath('C:\MATLAB2018\MATLAB\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs');
addpath('C:\MATLAB2018\MATLAB\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GaussianNoise');
% Initial Conditions
windowsizeRest = 45;
windowsizeRun = 70;
k=0;
prom=0;
sm0=0;
sm1=0;
sm2=0;
sm3=0;
sm4=0;
sm5=0;

%% PARAMETRIZE FINDPEAKS
%  ---------ACTIVIDAD 1------                 -------ACTIVIDAD 2---------             -------ACTIVIDAD 3---------            -------ACTIVIDAD 4---------            -------ACTIVIDAD 5---------          -------ACTIVIDAD 6---------                 
%  MinW|MW   |PROM|MinD| MH    |MD  |MW     MinW|MW |PROM| MinD| MH |MD |MW          MinW|MW |PROM| MinD| MH |MD |MW  
P=[0.11 0.5  0.009 0.3  0.025  0.6  0.05    0.01  0.6  0.049  0.1   0.025 0.5 0.05   0.07  0.5 0.038  0.1  0.04  0.2 0.05   0.07 0.8 0.04  0.15  0.04 0.2 0.05     0.07 0.8 0.04  0.1  0.04 0.2 0.05    0.05 1.5 0.01  0.2  0.04 0.2 0.05;
   0.09 0.45 0.009 0.4  0.025  0.6  0.05    0.05  0.45 0.05   0.35  0.025 0.5 0.05   0.07  0.5 0.038  0.1  0.04  0.2 0.05   0.07 0.8 0.04  0.15  0.04 0.2 0.05     0.07 0.8 0.04  0.3  0.04 0.2 0.05    0.05 1.5 0.01  0.2  0.04 0.2 0.05;
   0.09 0.45 0.009 0.4  0.025  0.5  0.05    0.05  0.45 0.05   0.2   0.025 0.5 0.05   0.07  0.5 0.038  0.1  0.04  0.2 0.05   0.07 1.5 0.038 0.12  0.04 0.2 0.05     0.07 0.8 0.04  0.3  0.04 0.2 0.05    0.05 1.5 0.01  0.2  0.04 0.2 0.05;
   0.09 0.45 0.009 0.4  0.025  0.5  0.05    0.028 0.9  0.077  0.28  0.025 0.4 0.05   0.08  0.5 0.05   0.2  0.03  0.2 0.05   0.07 1.5 0.067 0.1   0.03 0.2 0.05     0.07 0.8 0.04  0.3  0.04 0.2 0.05    0.05 1.5 0.01  0.2  0.03 0.2 0.05;
   0.09 0.45 0.009 0.4  0.025  0.5  0.05    0.11  0.5  0.05   0.1   0.025 0.4 0.05   0.05  0.4 0.01   0.22 0.03  0.2 0.05   0.07 1.5 0.067 0.1   0.03 0.2 0.05     0.07 0.8 0.04  0.3  0.04 0.2 0.05    0.05 1.5 0.01  0.2  0.03 0.2 0.05;
   0.09 0.45 0.009 0.4  0.025  0.5  0.05    0.11  0.5  0.05   0.1   0.025 0.4 0.05   0.05  0.45 0.01  0.28 0.03  0.2 0.05   0.07 1.5 0.067 0.1   0.03 0.2 0.05     0.07 0.8 0.04  0.22 0.04 0.2 0.05    0.05 1.5 0.01  0.2  0.03 0.2 0.05;
   0.07 0.5  0.05  0.4  0.15   0.5  0.05    0.07  0.5  0.04   0.35  0.15  0.4 0.05   0.05  0.3 0.04   0.3  0.15  0.35 0.05  0.05 0.7 0.03  0.29  0.2  0.35 0.05    0.05  1  0.03  0.29 0.2  0.35 0.05   0.05 0.5 0.04  0.3  0.2  0.35 0.05;
   0.1  0.5  0.03  0.35 0.025  0.6  0.05    0.05  0.5  0.05   0.17  0.019 0.4 0.05   0.03  0.5 0.03   0.1  0.035 0.35 0.05  0.07 0.7 0.02  0.15  0.02 0.35 0.05    0.05  1  0.04  0.15 0.02 0.35 0.05   0.01 0.5 0.07  0.2  0.02 0.35 0.05;
   0.1  0.5  0.005 0.45 0.04   0.65 0.05    0.01  0.5  0.05   0.35  0.025 0.4 0.05   0.05  0.6 0.04   0.32 0.02  0.35 0.05  0.07 0.6 0.04  0.3   0.02 0.35 0.05    0.05  1  0.04  0.3  0.02 0.35 0.05   0.1  0.8 0.03  0.2  0.03 0.35 0.05;
   0.05 0.7  0.004 0.35 0.06   0.4  0.05    0.03  0.7  0.008  0.25  0.06  0.35 0.05  0.02  0.7 0.009  0.23 0.06  0.3  0.05  0.02 0.9 0.02  0.2   0.04 0.3  0.05    0.03  1  0.03  0.175 0.04 0.3 0.05   0.03 0.7 0.03  0.2  0.04 0.3  0.05;
   0.1  0.5  0.005 0.4  0.05   0.48 0.05    0.01  0.5  0.05   0.25  0.06  0.35 0.05  0.05  0.7 0.05   0.23 0.05  0.25 0.05  0.07 0.3 0.04  0.2   0.05 0.25 0.05    0.07 0.7 0.04  0.2   0.05 0.2 0.05   0.09 0.5 0.04  0.2  0.05 0.2  0.05;
   0.07 1    0.03  0.4  0.02   0.5  0.05    0.05  0.8  0.04   0.35  0.02  0.44 0.05  0.1   0.8 0.12   0.28 0.02  0.3  0.05  0.07 0.8 0.04  0.25  0.017 0.3 0.04    0.05 1   0.12  0.28  0.017 0.3 0.04  0.1  0.5 0.04  0.2  0.014 0.3 0.04
   ];

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
%% Obtain Savitzky noise as a subtraction of filtered signals from the original signals.
% Each 's' drifts each activities in different arrays, in order to save its
% information separately.
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
    % A vertical and sample summation is made, thus saving each in separate
    % arrrays. End: Obtain sample mean
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
% zeros are added in order to fit the matrix with the right dimension.

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;

% Here, we divide the beforehand mentioned sum of noises organized in a 
% matrix and divide it between the number of realizations, so in the final 
% we obtain the mean value for the high-frequency noise.

Media0 = M./Realizaciones;

% Re-set the sampled mean on a single line linking the 6 activity signals
% one by one with the adjacent

v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];

% Delete extra zeros and make the output fit the right format.
    mediamuestralCleared=nonzeros(v);
    mediamuestralCleared=mediamuestralCleared';
%% In order to delete big peaks between activities, use hampel to find the 
% 3 or more standard deviation around N adjacent samples and replace large
% peaks.
% This model won't obtain similar results as 
 
    mediamuestral=hampel(mediamuestralCleared,5,2);

%% EXTRACT 2 ECG AND PPG CHANNELS AND SAVE THEM IN ARRAYS.
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
        ECGdatasetSignals(k,:)=a.sig(1,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
        ECGdatasetSignals(k,:)=a.sig(1,(1:35989));
    end
end
% Sample Frequency
    Fs = 125;
%Convert to physical values: According to timesheet of the used wearable
ecgFullSignal = (ECGdatasetSignals-128)./255;
signal2 = (PPGdatasetSignals-128)/(255);

% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (signal2(k,:)-min(signal2(k,:)))/(max(signal2(k,:))-min(signal2(k,:)));
    ecgNorm(k,:) = (ecgFullSignal(k,:)-min(ecgFullSignal(k,:)))./(max(ecgFullSignal(k,:))-min(ecgFullSignal(k,:)));
end
%% Separate signals in its corresponding activities 
% PPG channel
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end));
% ECG channel
ActivityECG1=ecgNorm(:,(1:3750));
ActivityECG2=ecgNorm(:,(3751:11250));
ActivityECG3=ecgNorm(:,(11251:18750));
ActivityECG4=ecgNorm(:,(18751:26250));
ActivityECG5=ecgNorm(:,(26251:33750));
ActivityECG6=ecgNorm(:,(33751:end));

%% Detrend and square each ECG activity

for k=1:12
    CleanedActivityECG1(k,:)=DenoiseECG(ActivityECG1(k,:));
    CleanedActivityECG2(k,:)=DenoiseECG(ActivityECG2(k,:));
    CleanedActivityECG3(k,:)=DenoiseECG(ActivityECG3(k,:));
    CleanedActivityECG4(k,:)=DenoiseECG(ActivityECG4(k,:));
    CleanedActivityECG5(k,:)=DenoiseECG(ActivityECG5(k,:));
    CleanedActivityECG6(k,:)=DenoiseECG(ActivityECG6(k,:));
end
%% Separate Savitzky noise for PPG with its correspondent activity.
Noise1 = mediamuestral(1:3750);
Noise2 = mediamuestral(3751:11250);
Noise3 = mediamuestral(11251:18750);
Noise4 = mediamuestral(18751:26250);
Noise5 = mediamuestral(26251:33750);
Noise6 = mediamuestral(33751:end);
%% Center all activities to zero using detrend function.
nRest = 10;
nRun = 10;
WandererBaseline1=Detrending(Noise1,nRest);
WandererBaseline2=Detrending(Noise2,nRun);
WandererBaseline3=Detrending(Noise3,nRun);
WandererBaseline4=Detrending(Noise4,nRun);
WandererBaseline5=Detrending(Noise5,nRun);
WandererBaseline6=Detrending(Noise6,nRest);
% Zero centered Savitzky noise extraction
ZeroCenteredNoise1=Noise1-WandererBaseline1;
ZeroCenteredNoise2=Noise2-WandererBaseline2;
ZeroCenteredNoise3=Noise3-WandererBaseline3;
ZeroCenteredNoise4=Noise4-WandererBaseline4;
ZeroCenteredNoise5=Noise5-WandererBaseline5;
ZeroCenteredNoise6=Noise6-WandererBaseline6;
%% MOVING AVERAGE MODEL
    MA(1:3750)      = Function_2_MA(ZeroCenteredNoise1,windowsizeRest);
    MA(3751:11250)  = Function_2_MA(ZeroCenteredNoise2,windowsizeRun);
    MA(11251:18750) = Function_2_MA(ZeroCenteredNoise3,windowsizeRun);
    MA(18751:26250) = Function_2_MA(ZeroCenteredNoise4,windowsizeRun);
    MA(26251:33750) = Function_2_MA(ZeroCenteredNoise5,windowsizeRun);
    MA(33751:35989) = Function_2_MA(ZeroCenteredNoise6,windowsizeRest);
%% As the high-frequency noise components have been zero-centered using 
% detrending function, similarly unbiased sample variance are
    V=[s-WandererBaseline1 s1-WandererBaseline2 s2-WandererBaseline3 s3-WandererBaseline4 s4-WandererBaseline5 s5-WandererBaseline6];
    varianzamuestralMA= var(V);
    
%% Seed-pool is created, in order to set different deviations around baseline
% drift. When XMA  = 0, model sets to MA performance parameters, for this, 
% conditional for passband filtering is created to avoid unexpected signal
% distortion
% Save memory for XMA band-limited Gaussian noise models
    GaussianModelsMA=zeros(1,length(MA));
% Create Gaussian Noise Models varying variance for each seed-value
    for k=1:length(MA)
        GaussianModelsMA(:,k) = MA(k) + sqrt(varianzamuestralMA(k))*windowSize;
    end

if windowSize == 0
     TotalMAHF = GaussianModelsMA(1,:);
else
    % Passband filtering for supressing frequencies above 26 hz and below 3hz.
     PBF = designfilt('bandpassiir','PassbandFrequency1',2.5,...
    'StopbandFrequency1',2,'StopbandFrequency2',26.5,...
    'PassbandFrequency2',26,...
    'StopbandAttenuation1',10,'StopbandAttenuation2',10,...
    'SampleRate',Fs,'DesignMethod','ellip');
%    Apply filter with filtfilt
     TotalMAHF = filtfilt(PBF,GaussianModelsMA(1,:));
end
%%   Ruido total 2: o(t) = n(t)+w(t)
    TotalGaussianNoise(1:3750)      = WandererBaseline1 + TotalMAHF(1:3750);
    TotalGaussianNoise(3751:11250)  = WandererBaseline2 + TotalMAHF(3751:11250);
    TotalGaussianNoise(11251:18750) = WandererBaseline3 + TotalMAHF(11251:18750);
    TotalGaussianNoise(18751:26250) = WandererBaseline4 + TotalMAHF(18751:26250);
    TotalGaussianNoise(26251:33750) = WandererBaseline5 + TotalMAHF(26251:33750);
    TotalGaussianNoise(33751:35989) = WandererBaseline6 + TotalMAHF(33751:35989);
% Cleaning signal with MA
    CleanedGaussianNoise1 = Activity1 - TotalGaussianNoise(1:3750);
    CleanedGaussianNoise2 = Activity2 - TotalGaussianNoise(3751:11250);
    CleanedGaussianNoise3 = Activity3 - TotalGaussianNoise(11251:18750);
    CleanedGaussianNoise4 = Activity4 - TotalGaussianNoise(18751:26250);
    CleanedGaussianNoise5 = Activity5 - TotalGaussianNoise(26251:33750);
    CleanedGaussianNoise6 = Activity6 - TotalGaussianNoise(33751:35989);

%% PERFORMANCE PARAMS: Se, sc and Acc is determined.
TP = 0; 
FP = 0;
TN = 0;
FN = 0;
   for i=1:12
    metrics(i,(1:4))  = GetMetrics(CleanedActivityECG1(i,:),Activity1(i,:),CleanedGaussianNoise1(i,:),P(i,(1:7)),Fs);
    metrics(i,(5:8))  = GetMetrics(CleanedActivityECG2(i,:),Activity2(i,:),CleanedGaussianNoise2(i,:),P(i,(8:14)),Fs);
    metrics(i,(9:12)) = GetMetrics(CleanedActivityECG3(i,:),Activity3(i,:),CleanedGaussianNoise3(i,:),P(i,(15:21)),Fs);
    metrics(i,(13:16))= GetMetrics(CleanedActivityECG4(i,:),Activity4(i,:),CleanedGaussianNoise4(i,:),P(i,(22:28)),Fs);  
    metrics(i,(17:20))= GetMetrics(CleanedActivityECG5(i,:),Activity5(i,:),CleanedGaussianNoise5(i,:),P(i,(29:35)),Fs);
    metrics(i,(21:24))= GetMetrics(CleanedActivityECG6(i,:),Activity6(i,:),CleanedGaussianNoise6(i,:),P(i,(36:42)),Fs);

      TP = [TP metrics(i,1) metrics(i,5) metrics(i,9)  metrics(i,13)  metrics(i,17)  metrics(i,21)];
      FP = [FP metrics(i,2) metrics(i,6) metrics(i,10) metrics(i,14)  metrics(i,18)  metrics(i,22)];
      TN = [TN metrics(i,3) metrics(i,7) metrics(i,11) metrics(i,15)  metrics(i,19)  metrics(i,23)];
      FN = [FN metrics(i,4) metrics(i,8) metrics(i,12) metrics(i,16)  metrics(i,20)  metrics(i,24)];     
   end
   
   Presicion     = sum(TP)./(sum(TP)+sum(FP))
   Especificity  = sum(TN)./(sum(TN)+sum(FP))
   Sensivility   = sum(TP)./(sum(TP)+sum(FN))
end