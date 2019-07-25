% This code is aimed at determine 4 different noise models, 1) Using
% Savizky-Golay Smoothing filter, 2) Using Linear Predictor with its 
% respective coefficientsfiltering LPC, 3)Using Moving Average (MA)
% filtering and using the Dynamic Moving Average Model.
clc
clear all
close all
%% Add Datasets
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GaussianNoise')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db')
% addpath('C:\MATLAB2018\MATLAB\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db');
% addpath('C:\MATLAB2018\MATLAB\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GaussianNoise');
% addpath('C:\MATLAB2018\MATLAB\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs');
%
%Obtain high-frequency noise base by Savitzky with GetAveragedNoise
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
% Set realization as desired.
j = 1; 

%% Get and save signals in 'Realizaciones'
% NOISE MODEL PARAMETERS    
% LPC COEFFICIENTS
LPCActivity1 = 3500;
LPCActivity6 = 2200;
LPCActivity = 7000;
% AVERAGE MEAN
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

%% PARAMETRIZE FINDPEAKS FOR CLASSIFICATION ERROR COMPUTING
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
%% Parameters for findpeaks Function
% PARAMETERS FOR PPG SIGNAL

% MinPeakWidth
MinPeakWidthRest1 = 0.09;
MinPeakWidthRun_2 = 0.11;
MinPeakWidthRun_3 = 0.05;
MinPeakWidthRun_4 = 0.07;
MinPeakWidthRun_5 = 0.07;
MinPeakWidthRest6 = 0.05;
% MaxWidthPeak in PPG
MaxWidthRest1 = 0.45;
MaxWidthRun2 = 0.5;
MaxWidthRun3 = 0.45;
MaxWidthRun4 = 1.5;
MaxWidthRun5 = 0.8;
MaxWidthRest6 = 1.5;
% Prominence in PPG
ProminenceInRest1 = 0.009;
ProminenceRun2 = 0.05;
ProminenceRun3 = 0.01;
ProminenceRun4 = 0.067;
ProminenceRun5 = 0.04;
ProminenceInRest6 = 0.01;
% Min peak Distance in PPG
MinDistRest1 = 0.4;
MinDistRun2 = 0.1;
MinDistRun3 = 0.28;
MinDistRun4 = 0.1;
MinDistRun5 = 0.22;
MinDistRest6 = 0.2;
%% PARAMETERS IN ECG SIGNAL
% Min Height in ECG
MinHeightECGRest1 = 0.025;
MinHeightECGRun2  = 0.025;
MinHeightECGRun3  = 0.03;
MinHeightECGRun4  = 0.03;
MinHeightECGRun5  = 0.04;
MinHeightECGRest6 = 0.03;
%Min Dist in ECG
minDistRest1  = 0.5;
minDistRun2   = 0.4;
minDistRun3   = 0.2;
minDistRun4   = 0.2;
minDistRun5   = 0.2;
minDistRest6  = 0.2;
%Max Width in ECG
maxWidthRest1  = 0.05;
maxWidthRun2   = 0.05;
maxWidthRun3   = 0.05;
maxWidthRun4   = 0.05;
maxWidthRun5   = 0.05;
maxWidthRest6  = 0.05;


%% EXTRACT THE SIGNALS
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
    % In this part, after the noise has been obtained for each activity, we
    % proceed to make a sum for each one of the activities.
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s1(k,:);
    sm2 = sm2 + s2(k,:);
    sm3 = sm3 + s3(k,:);
    sm4 = sm4 + s4(k,:);
    sm5 = sm5 + s5(k,:);

end


%% ECG PEAKS EXTRACTION
% Sample Frequency
Fs = 125;
%Convert to physical values: According to timesheet of the used wearable
ecgFullSignal = (ECGdatasetSignals-128)./255;
FinalSignal = (PPGdatasetSignals-128)/(255);

% Normalize the entire signal of all realizations.
for k=1:12
    vectormaximosppg(k)=max(FinalSignal(k,:));
    vectorminimosppg(k)=min(FinalSignal(k,:));
    sNorm(k,:) = (FinalSignal(k,:)-min(FinalSignal(k,:)))/(max(FinalSignal(k,:))-min(FinalSignal(k,:)));
    ecgNorm(k,:) = (ecgFullSignal(k,:)-min(ecgFullSignal(k,:)))./(max(ecgFullSignal(k,:))-min(ecgFullSignal(k,:)));
end
    
%% Separate Activities
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end));
ActivityECG1=ecgNorm(:,(1:3750));
ActivityECG2=ecgNorm(:,(3751:11250));
ActivityECG3=ecgNorm(:,(11251:18750));
ActivityECG4=ecgNorm(:,(18751:26250));
ActivityECG5=ecgNorm(:,(26251:33750));
ActivityECG6=ecgNorm(:,(33751:end));

%% Clean each ECG activity

for k=1:12
    CleanedActivityECG1(k,:)=DenoiseECG(ActivityECG1(k,:));
    CleanedActivityECG2(k,:)=DenoiseECG(ActivityECG2(k,:));
    CleanedActivityECG3(k,:)=DenoiseECG(ActivityECG3(k,:));
    CleanedActivityECG4(k,:)=DenoiseECG(ActivityECG4(k,:));
    CleanedActivityECG5(k,:)=DenoiseECG(ActivityECG5(k,:));
    CleanedActivityECG6(k,:)=DenoiseECG(ActivityECG6(k,:));
end
%% Separate noise for PPG with its correspondent activity.
Noise1 = mediamuestral(1:3750);
Noise2 = mediamuestral(3751:11250);
Noise3 = mediamuestral(11251:18750);
Noise4 = mediamuestral(18751:26250);
Noise5 = mediamuestral(26251:33750);
Noise6 = mediamuestral(33751:end);

%% Detrend noise by activities.
nRest = 10;
nRun = 10;
WandererBaseline1=Detrending(Noise1,nRest);
WandererBaseline2=Detrending(Noise2,nRun);
WandererBaseline3=Detrending(Noise3,nRun);
WandererBaseline4=Detrending(Noise4,nRun);
WandererBaseline5=Detrending(Noise5,nRun);
WandererBaseline6=Detrending(Noise6,nRest);
% Zero centered noise extraction
ZeroCenteredNoise1=Noise1-WandererBaseline1;
ZeroCenteredNoise2=Noise2-WandererBaseline2;
ZeroCenteredNoise3=Noise3-WandererBaseline3;
ZeroCenteredNoise4=Noise4-WandererBaseline4;
ZeroCenteredNoise5=Noise5-WandererBaseline5;
ZeroCenteredNoise6=Noise6-WandererBaseline6;

%% 1. Savitzky smoothing filter.
%   Ruido total 1: o(t) = n(t)+w(t)
    TotalS=mediamuestral;
% Cleaning signal with MA
    Cleaneds1 = Activity1 - TotalS(1:3750);
    Cleaneds2 = Activity2 - TotalS(3751:11250);
    Cleaneds3 = Activity3 - TotalS(11251:18750);
    Cleaneds4 = Activity4 - TotalS(18751:26250);
    Cleaneds5 = Activity5 - TotalS(26251:33750);
    Cleaneds6 = Activity6 - TotalS(33751:35989);
    %% ERROR FOR SAVITZKY
    
    % 1. REGRESSION ERRORS
disp('ERRORES CALCULADOS POR SAVITZKY')
findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
    Cleaneds1(j,:),Cleaneds2(j,:),Cleaneds3(j,:),Cleaneds4(j,:),Cleaneds5(j,:),Cleaneds6(j,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
    CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);

%       2. CLASIFICATION ERRORS (PERFORMANCE PARAMS: Se, sc and Acc is
%       determined)
TP = 0; 
FP = 0;
TN = 0;
FN = 0;
   for i=1:12
    metrics(i,(1:4))  = GetMetrics(CleanedActivityECG1(i,:),Activity1(i,:),Cleaneds1(i,:),P(i,(1:7)),Fs);
    metrics(i,(5:8))  = GetMetrics(CleanedActivityECG2(i,:),Activity2(i,:),Cleaneds2(i,:),P(i,(8:14)),Fs);
    metrics(i,(9:12)) = GetMetrics(CleanedActivityECG3(i,:),Activity3(i,:),Cleaneds3(i,:),P(i,(15:21)),Fs);
    metrics(i,(13:16))= GetMetrics(CleanedActivityECG4(i,:),Activity4(i,:),Cleaneds4(i,:),P(i,(22:28)),Fs);  
    metrics(i,(17:20))= GetMetrics(CleanedActivityECG5(i,:),Activity5(i,:),Cleaneds5(i,:),P(i,(29:35)),Fs);
    metrics(i,(21:24))= GetMetrics(CleanedActivityECG6(i,:),Activity6(i,:),Cleaneds6(i,:),P(i,(36:42)),Fs);

      TP = [TP metrics(i,1) metrics(i,5) metrics(i,9)  metrics(i,13)  metrics(i,17)  metrics(i,21)];
      FP = [FP metrics(i,2) metrics(i,6) metrics(i,10) metrics(i,14)  metrics(i,18)  metrics(i,22)];
      TN = [TN metrics(i,3) metrics(i,7) metrics(i,11) metrics(i,15)  metrics(i,19)  metrics(i,23)];
      FN = [FN metrics(i,4) metrics(i,8) metrics(i,12) metrics(i,16)  metrics(i,20)  metrics(i,24)];     
   end
   
   Accuracy     = (sum(TP)+sum(TN))./(sum(TP)+sum(FP)+sum(FN)+sum(TN))
   Especificity  = sum(TN)./(sum(TN)+sum(FP))
   Sensitivity   = sum(TP)./(sum(TP)+sum(FN))

%% 2. Linear Predictor Artificial noise Model
%1 High frequency component
     LP(1:3750)      = Function_1_LP(ZeroCenteredNoise1,LPCActivity1);  
     LP(3751:11250)  = Function_1_LP(ZeroCenteredNoise2,LPCActivity);    
     LP(11251:18750) = Function_1_LP(ZeroCenteredNoise3,LPCActivity);   
     LP(18751:26250) = Function_1_LP(ZeroCenteredNoise4,LPCActivity);   
     LP(26251:33750) = Function_1_LP(ZeroCenteredNoise5,LPCActivity);   
     LP(33751:35989) = Function_1_LP(ZeroCenteredNoise6,LPCActivity6); 
% TOTAL LINEAR PREDICTOR ARTIFITIAL NOISE 
% Ruido total 1: o(t) = n(t)+w(t)
% **Baseline drift is added
% This noise includes lpc linear predictor with the described orders
% also includes filter for modeling average noise extracted from signal.
    TotalLP(1:3750)      = WandererBaseline1 + LP(1:3750);
    TotalLP(3751:11250)  = WandererBaseline2 + LP(3751:11250);
    TotalLP(11251:18750) = WandererBaseline3 + LP(11251:18750);
    TotalLP(18751:26250) = WandererBaseline4 + LP(18751:26250);
    TotalLP(26251:33750) = WandererBaseline5 + LP(26251:33750);
    TotalLP(33751:35989) = WandererBaseline6 + LP(33751:35989);
% Cleaning signal with LP
    CleanedLP1 = Activity1 - TotalLP(1:3750);
    CleanedLP2 = Activity2 - TotalLP(3751:11250);
    CleanedLP3 = Activity3 - TotalLP(11251:18750);
    CleanedLP4 = Activity4 - TotalLP(18751:26250);
    CleanedLP5 = Activity5 - TotalLP(26251:33750);
    CleanedLP6 = Activity6 - TotalLP(33751:35989);
    %% ERROR FOR LP
    
    % 1. REGRESSION ERRORS
disp('ERRORES CALCULADOS POR LINEAR PREDICTOR')
findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
    CleanedLP1(j,:),CleanedLP2(j,:),CleanedLP3(j,:),CleanedLP4(j,:),CleanedLP5(j,:),CleanedLP6(j,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
    CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);

%       2. CLASIFICATION ERRORS (PERFORMANCE PARAMS: Se, sc and Acc is
%       determined)
TP = 0; 
FP = 0;
TN = 0;
FN = 0;
   for i=1:12
    metrics(i,(1:4))  = GetMetrics(CleanedActivityECG1(i,:),Activity1(i,:),CleanedLP1(i,:),P(i,(1:7)),Fs);
    metrics(i,(5:8))  = GetMetrics(CleanedActivityECG2(i,:),Activity2(i,:),CleanedLP2(i,:),P(i,(8:14)),Fs);
    metrics(i,(9:12)) = GetMetrics(CleanedActivityECG3(i,:),Activity3(i,:),CleanedLP3(i,:),P(i,(15:21)),Fs);
    metrics(i,(13:16))= GetMetrics(CleanedActivityECG4(i,:),Activity4(i,:),CleanedLP4(i,:),P(i,(22:28)),Fs);  
    metrics(i,(17:20))= GetMetrics(CleanedActivityECG5(i,:),Activity5(i,:),CleanedLP5(i,:),P(i,(29:35)),Fs);
    metrics(i,(21:24))= GetMetrics(CleanedActivityECG6(i,:),Activity6(i,:),CleanedLP6(i,:),P(i,(36:42)),Fs);

      TP = [TP metrics(i,1) metrics(i,5) metrics(i,9)  metrics(i,13)  metrics(i,17)  metrics(i,21)];
      FP = [FP metrics(i,2) metrics(i,6) metrics(i,10) metrics(i,14)  metrics(i,18)  metrics(i,22)];
      TN = [TN metrics(i,3) metrics(i,7) metrics(i,11) metrics(i,15)  metrics(i,19)  metrics(i,23)];
      FN = [FN metrics(i,4) metrics(i,8) metrics(i,12) metrics(i,16)  metrics(i,20)  metrics(i,24)];     
   end
   
   Accuracy     = (sum(TP)+sum(TN))./(sum(TP)+sum(FP)+sum(FN)+sum(TN))
   Especificity  = sum(TN)./(sum(TN)+sum(FP))
   Sensitivity   = sum(TP)./(sum(TP)+sum(FN))
%% 3. Moving average for artifitial noise modeling
    MA(1:3750)      = Function_2_MA(ZeroCenteredNoise1,windowsizeRest);
    MA(3751:11250)  = Function_2_MA(ZeroCenteredNoise2,windowsizeRun);
    MA(11251:18750) = Function_2_MA(ZeroCenteredNoise3,windowsizeRun);
    MA(18751:26250) = Function_2_MA(ZeroCenteredNoise4,windowsizeRun);
    MA(26251:33750) = Function_2_MA(ZeroCenteredNoise5,windowsizeRun);
    MA(33751:35989) = Function_2_MA(ZeroCenteredNoise6,windowsizeRest);
%   Ruido total 2: o(t) = n(t)+w(t)
    TotalMA(1:3750)      = WandererBaseline1 + MA(1:3750);
    TotalMA(3751:11250)  = WandererBaseline2 + MA(3751:11250);
    TotalMA(11251:18750) = WandererBaseline3 + MA(11251:18750);
    TotalMA(18751:26250) = WandererBaseline4 + MA(18751:26250);
    TotalMA(26251:33750) = WandererBaseline5 + MA(26251:33750);
    TotalMA(33751:35989) = WandererBaseline6 + MA(33751:35989);
    % Cleaning signal with MA
    CleanedMA1 = Activity1 - TotalMA(1:3750);
    CleanedMA2 = Activity2 - TotalMA(3751:11250);
    CleanedMA3 = Activity3 - TotalMA(11251:18750);
    CleanedMA4 = Activity4 - TotalMA(18751:26250);
    CleanedMA5 = Activity5 - TotalMA(26251:33750);
    CleanedMA6 = Activity6 - TotalMA(33751:35989);
        %% ERROR FOR MOVING AVERAGE
        
    % 1.    REGRESSION ERROR
    disp('ERRORES CALCULADOS POR MOVING AVERAGE')
    findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
    CleanedMA1(j,:),CleanedMA2(j,:),CleanedMA3(j,:),CleanedMA4(j,:),CleanedMA5(j,:),CleanedMA6(j,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
    CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);

%       2. CLASIFICATION ERROR (PERFORMANCE PARAMS: Se, sc and Acc is
%       determined)
TP = 0; 
FP = 0;
TN = 0;
FN = 0;
   for i=1:12
    metrics(i,(1:4))  = GetMetrics(CleanedActivityECG1(i,:),Activity1(i,:),CleanedMA1(i,:),P(i,(1:7)),Fs);
    metrics(i,(5:8))  = GetMetrics(CleanedActivityECG2(i,:),Activity2(i,:),CleanedMA2(i,:),P(i,(8:14)),Fs);
    metrics(i,(9:12)) = GetMetrics(CleanedActivityECG3(i,:),Activity3(i,:),CleanedMA3(i,:),P(i,(15:21)),Fs);
    metrics(i,(13:16))= GetMetrics(CleanedActivityECG4(i,:),Activity4(i,:),CleanedMA4(i,:),P(i,(22:28)),Fs);  
    metrics(i,(17:20))= GetMetrics(CleanedActivityECG5(i,:),Activity5(i,:),CleanedMA5(i,:),P(i,(29:35)),Fs);
    metrics(i,(21:24))= GetMetrics(CleanedActivityECG6(i,:),Activity6(i,:),CleanedMA6(i,:),P(i,(36:42)),Fs);

      TP = [TP metrics(i,1) metrics(i,5) metrics(i,9)  metrics(i,13)  metrics(i,17)  metrics(i,21)];
      FP = [FP metrics(i,2) metrics(i,6) metrics(i,10) metrics(i,14)  metrics(i,18)  metrics(i,22)];
      TN = [TN metrics(i,3) metrics(i,7) metrics(i,11) metrics(i,15)  metrics(i,19)  metrics(i,23)];
      FN = [FN metrics(i,4) metrics(i,8) metrics(i,12) metrics(i,16)  metrics(i,20)  metrics(i,24)];     
   end
   
   Accuracy     = (sum(TP)+sum(TN))./(sum(TP)+sum(FP)+sum(FN)+sum(TN))
   Especificity  = sum(TN)./(sum(TN)+sum(FP))
   Sensitivity   = sum(TP)./(sum(TP)+sum(FN))
%% 4. DYNAMIC VARIANCE MOVING AVERAGE NOISE MODEL
% Seed-pool is created, in order to set different deviations around baseline
% drift. When XMA  = 0, model sets to MA performance parameters, for this, 
% conditional for passband filtering is created to avoid unexpected signal
% distortion
 V=[s-WandererBaseline1 s1-WandererBaseline2 s2-WandererBaseline3 s3-WandererBaseline4 s4-WandererBaseline5 s5-WandererBaseline6];
 varianzamuestralMA= var(V);
% Save memory for XMA band-limited Gaussian noise models
    GaussianModelsMA=zeros(1,length(MA));
% The seed-value is selected as -0.53 using the automatic algorithm
% detection
windowSize = -0.53;
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
%%
    GaussianTotalMA(1:3750)      = WandererBaseline1 + TotalMAHF(1:3750);
    GaussianTotalMA(3751:11250)  = WandererBaseline2 + TotalMAHF(3751:11250);
    GaussianTotalMA(11251:18750) = WandererBaseline3 + TotalMAHF(11251:18750);
    GaussianTotalMA(18751:26250) = WandererBaseline4 + TotalMAHF(18751:26250);
    GaussianTotalMA(26251:33750) = WandererBaseline5 + TotalMAHF(26251:33750);
    GaussianTotalMA(33751:35989) = WandererBaseline6 + TotalMAHF(33751:35989);
% Cleaning signal with MA
    CleanedGMA1 = Activity1 - GaussianTotalMA(1:3750);
    CleanedGMA2 = Activity2 - GaussianTotalMA(3751:11250);
    CleanedGMA3 = Activity3 - GaussianTotalMA(11251:18750);
    CleanedGMA4 = Activity4 - GaussianTotalMA(18751:26250);
    CleanedGMA5 = Activity5 - GaussianTotalMA(26251:33750);
    CleanedGMA6 = Activity6 - GaussianTotalMA(33751:35989);
   
        %% ERROR FOR DYNAMIC VARIANCE MOVING AVERAGE MODEL WITH OPTIMAL VALUE (-0.53)
    
    %   1. REGRESSION ERRORS
    disp('ERRORES CALCULADOS POR MODELO DYNAMIC MOVING AVERAGE WITH OPTIMAL VALUE (-0.53)')
    findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
    CleanedGMA1(j,:),CleanedGMA2(j,:),CleanedGMA3(j,:),CleanedGMA4(j,:),CleanedGMA5(j,:),CleanedGMA6(j,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
    CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);
%%
%       2. ERRORES DE CLASIFICACION (PERFORMANCE PARAMS: Se, sc and Acc is
%       determined)
TP = 0; 
FP = 0;
TN = 0;
FN = 0;
   for i=1:12
    metrics(i,(1:4))  = GetMetrics(CleanedActivityECG1(i,:),Activity1(i,:),CleanedGMA1(i,:),P(i,(1:7)),Fs);
    metrics(i,(5:8))  = GetMetrics(CleanedActivityECG2(i,:),Activity2(i,:),CleanedGMA2(i,:),P(i,(8:14)),Fs);
    metrics(i,(9:12)) = GetMetrics(CleanedActivityECG3(i,:),Activity3(i,:),CleanedGMA3(i,:),P(i,(15:21)),Fs);
    metrics(i,(13:16))= GetMetrics(CleanedActivityECG4(i,:),Activity4(i,:),CleanedGMA4(i,:),P(i,(22:28)),Fs);  
    metrics(i,(17:20))= GetMetrics(CleanedActivityECG5(i,:),Activity5(i,:),CleanedGMA5(i,:),P(i,(29:35)),Fs);
    metrics(i,(21:24))= GetMetrics(CleanedActivityECG6(i,:),Activity6(i,:),CleanedGMA6(i,:),P(i,(36:42)),Fs);

      TP = [TP metrics(i,1) metrics(i,5) metrics(i,9)  metrics(i,13)  metrics(i,17)  metrics(i,21)];
      FP = [FP metrics(i,2) metrics(i,6) metrics(i,10) metrics(i,14)  metrics(i,18)  metrics(i,22)];
      TN = [TN metrics(i,3) metrics(i,7) metrics(i,11) metrics(i,15)  metrics(i,19)  metrics(i,23)];
      FN = [FN metrics(i,4) metrics(i,8) metrics(i,12) metrics(i,16)  metrics(i,20)  metrics(i,24)];     
   end
   
   Accuracy     = (sum(TP)+sum(TN))./(sum(TP)+sum(FP)+sum(FN)+sum(TN))
   Especificity  = sum(TN)./(sum(TN)+sum(FP))
   Sensitivity   = sum(TP)./(sum(TP)+sum(FN))

 %% Plotting noise models
figure
t=(0:length(TotalLP)-1/Fs);
plot(t,TotalLP,t,TotalS,t,TotalMA,t,GaussianTotalMA),hold on,title('Final Artificial Noise Models'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight,
legend('Linear Predictor model','Savitzky Golay model','Moving Average model','Dynamic Variance Moving Average model')
