clc
clear all
close all
%% Add Datasets
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\Training_data\db');

[mediamuestral,TamRealizaciones]=GetAveragedNoise();

%% Initial Conditions

% For ECG analysis, please update ECG name
ecgName = 'DATA_01_TYPE02.mat';
% K represents the number of realization to extract error individually
k = 1;
%% W values according the realization: P(k,W)
% Realization 1: W = 4
W = 4;
% Get and save signals in 'Realizaciones'
% NOISE MODEL PARAMETERS
% LPC COEFFICIENTS
LPCActivity1 = 3500;
LPCActivity6 = 2200;
LPCActivity = 7500;
% AVERAGE MEAN
windowsizeRest = 40;
windowsizeRun = 30;
% PARAMETERS SAVITZKY SMOOTHING FILTER
OrdenSavitzky=70;
FramesSavitzky=1001;

%% Parameters for findpeaks Function
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
ProminenceInRest1 = 0.005;
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
minDistRest1  = 0.1;
minDistRun2   = 0.3;
minDistRun3   = 0.3;
minDistRun4   = 0.3;
minDistRun5   = 0.2;
minDistRest6  = 0.2;

for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    end
end

% Sample Frequency
    Fs = 125;
% Convert to physical values: According to timesheet of the used wearable
    s2 = (Realizaciones-128)/(255);
% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
end
    
%% Separate Activities
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end));
% Separate noise with its correspondent activity.
Noise1 = mediamuestral(1,(1:3750));
Noise2 = mediamuestral(1,(3751:11250));
Noise3 = mediamuestral(1,(11251:18750));
Noise4 = mediamuestral(1,(18751:26250));
Noise5 = mediamuestral(1,(26251:33750));
Noise6 = mediamuestral(1,(33751:min(TamRealizaciones)));

%% Detrend noise by activities.
nRest = 10;
nRun = 10;
DetrendedNoise1=Detrending(Noise1(1,:),nRest);
DetrendedNoise2=Detrending(Noise2(1,:),nRun);
DetrendedNoise3=Detrending(Noise3(1,:),nRun);
DetrendedNoise4=Detrending(Noise4(1,:),nRun);
DetrendedNoise5=Detrending(Noise5(1,:),nRun);
DetrendedNoise6=Detrending(Noise6(1,:),nRest);
% Wandering baseline extraction
WandererBaseline1=Noise1-DetrendedNoise1;
WandererBaseline2=Noise2-DetrendedNoise2;
WandererBaseline3=Noise3-DetrendedNoise3;
WandererBaseline4=Noise4-DetrendedNoise4;
WandererBaseline5=Noise5-DetrendedNoise5;
WandererBaseline6=Noise6-DetrendedNoise6;

%% WE ESTABLISH THE MATRIX THAT WILL ALLOW TO PARAMETRIZE FINDPEAKS
P=[0.11 0.5 0.005 0.4 0.11 0.5 0.01 0.4 0.1 0.5 0.03 0.35 0.07 0.8 0.05 0.3 0.07 0.8 0.07 0.3 0.11 1 0.01 0.3;
   0.11 0.5 0.005 0.4 0.11 0.5 0.07 0.45 0.07 0.8 0.094 0.28 0.05 0.8 0.04 0.3 0.07 0.8 0.08 0.35 0.07 1 0.05 0.32;
   0.1 0.5 0.005 0.4 0.07 0.5 0.05 0.45 0.1 0.8 0.05 0.35 0.05 0.8 0.04 0.3 0.07 0.8 0.05 0.35 0.07 0.5 0.005 0.35;
   0.07 0.3 0.06 0.4 0.05 0.5 0.01 0.45 0.1 0.5 0.05 0.35 0.07 0.8 0.04 0.3 0.07 0.5 0.09 0.3 0.07 0.5 0.005 0.35;
   0.07 0.3 0.06 0.4 0.07 0.5 0.05 0.45 0.07 0.3 0.05 0.35 0.07 0.3 0.05 0.3 0.07 0.3 0.05 0.3 0.11 0.5 0.05 0.3;
   0.11 0.5 0.05 0.4 0.07 0.5 0.04 0.4 0.09 0.5 0.05 0.35 0.07 0.3 0.05 0.3 0.07 0.5 0.05 0.3 0.11 0.5 0.05 0.3;
   0.13 0.5 0.005 0.45 0.07 0.5 0.04 0.4 0.05 0.5 0.04 0.3 0.07 0.3 0.04 0.35 0.1 1 0.04 0.3 0.11 0.5 0.04 0.3;
   0.13 0.5 0.005 0.45 0.05 0.5 0.05 0.45 0.05 0.5 0.04 0.36 0.07 0.5 0.04 0.38 0.05 1 0.062 0.3 0.1 0.5 0.04 0.35;
   0.1 0.5 0.005 0.45 0.01 0.5 0.04 0.47 0.05 0.5 0.04 0.3 0.07 0.3 0.05 0.3 0.05 1 0.04 0.3 0.11 0.5 0.05 0.3;
   0.1 0.5 0.02 0.4 0.07 0.5 0.05 0.47 0.05 0.3 0.05 0.3 0.07 0.3 0.05 0.25 0.05 1 0.065 0.3 0.11 0.5 0.04 0.2;
   0.1 0.5 0.005 0.4 0.01 0.5 0.025 0.35 0.05 0.3 0.04 0.3 0.07 0.3 0.04 0.3 0.05 1 0.051 0.3 0.11 0.5 0.04 0.3;
   0.12 0.5 0.005 0.4 0.01 0.3 0.04 0.35 0.1 0.3 0.04 0.3 0.07 0.3 0.07 0.25 0.05 1 0.055 0.3 0.11 0.5 0.04 0.3];
% Just plotting it to check the detrended signal
t = (0:length(mediamuestral)-1)/Fs;
t30s=(0:length(DetrendedNoise1)-1)/Fs;
t60s=(0:length(DetrendedNoise2)-1)/Fs;
tfin=(0:length(DetrendedNoise6)-1)/Fs;

%% 1. Linear Predictor Artificial noise Model
% High frequency component
     LP(1,(1:3750)) = Function_1_LP(DetrendedNoise1,LPCActivity1);  
     LP(1,(3751:11250)) = Function_1_LP(DetrendedNoise2,LPCActivity);    
     LP(1,(11251:18750)) = Function_1_LP(DetrendedNoise3,LPCActivity);   
     LP(1,(18751:26250)) = Function_1_LP(DetrendedNoise4,LPCActivity);   
     LP(1,(26251:33750)) = Function_1_LP(DetrendedNoise5,LPCActivity);   
     LP(1,(33751:35989)) = Function_1_LP(DetrendedNoise6,LPCActivity6); 
% TOTAL LINEAR PREDICTOR ARTIFITIAL NOISE 
% Ruido total 1: o(t) = n(t)+w(t)
% **Wanderer baseline is added
% This noise includes lpc linear predictor with the described orders
% also includes filter for modeling average noise extracted from signal.
    TotalLP(1,(1:3750))      = WandererBaseline1 + LP(1,(1:3750));
    TotalLP(1,(3751:11250))  = WandererBaseline2 + LP(1,(3751:11250));
    TotalLP(1,(11251:18750)) = WandererBaseline3 + LP(1,(11251:18750));
    TotalLP(1,(18751:26250)) = WandererBaseline4 + LP(1,(18751:26250));
    TotalLP(1,(26251:33750)) = WandererBaseline5 + LP(1,(26251:33750));
    TotalLP(1,(33751:35989)) = WandererBaseline6 + LP(1,(33751:35989));
% Cleaning signal with LP
    CleanedLP1 = Activity1 - TotalLP(1,(1:3750));
    CleanedLP2 = Activity2 - TotalLP(1,(3751:11250));
    CleanedLP3 = Activity3 - TotalLP(1,(11251:18750));
    CleanedLP4 = Activity4 - TotalLP(1,(18751:26250));
    CleanedLP5 = Activity5 - TotalLP(1,(26251:33750));
    CleanedLP6 = Activity6 - TotalLP(1,(33751:35989));
    %% ERROR FOR LP
disp('ERRORES CALCULADOS POR LINEAR PREDICTOR')
findErrors(sNorm(k,:),Activity1(k,:),Activity2(k,:),Activity3(k,:),Activity4(k,:),Activity5(k,:),Activity6(k,:),...
    CleanedLP1(k,:),CleanedLP2(k,:),CleanedLP3(k,:),CleanedLP4(k,:),CleanedLP5(k,:),CleanedLP6(k,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    ecgName,MinHeightECGRest1,MinHeightECGRest6,...
    MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,minDistRest1,minDistRest6,...
    minDistRun2,minDistRun3,minDistRun4,minDistRun5,P(12,W))
%% 2. Moving average for artifitial noise modeling
    MA(1,(1:3750))      = Function_2_MA(DetrendedNoise1,windowsizeRest);
    MA(1,(3751:11250))  = Function_2_MA(DetrendedNoise2,windowsizeRun);
    MA(1,(11251:18750)) = Function_2_MA(DetrendedNoise3,windowsizeRun);
    MA(1,(18751:26250)) = Function_2_MA(DetrendedNoise4,windowsizeRun);
    MA(1,(26251:33750)) = Function_2_MA(DetrendedNoise5,windowsizeRun);
    MA(1,(33751:35989)) = Function_2_MA(DetrendedNoise6,windowsizeRest);
%   Ruido total 2: o(t) = n(t)+w(t)
    TotalMA(1,(1:3750))      = WandererBaseline1 + MA(1,(1:3750));
    TotalMA(1,(3751:11250))  = WandererBaseline2 + MA(1,(3751:11250));
    TotalMA(1,(11251:18750)) = WandererBaseline3 + MA(1,(11251:18750));
    TotalMA(1,(18751:26250)) = WandererBaseline4 + MA(1,(18751:26250));
    TotalMA(1,(26251:33750)) = WandererBaseline5 + MA(1,(26251:33750));
    TotalMA(1,(33751:35989)) = WandererBaseline6 + MA(1,(33751:35989));
    % Cleaning signal with MA
    CleanedMA1 = Activity1 - TotalMA(1,(1:3750));
    CleanedMA2 = Activity2 - TotalMA(1,(3751:11250));
    CleanedMA3 = Activity3 - TotalMA(1,(11251:18750));
    CleanedMA4 = Activity4 - TotalMA(1,(18751:26250));
    CleanedMA5 = Activity5 - TotalMA(1,(26251:33750));
    CleanedMA6 = Activity6 - TotalMA(1,(33751:35989));
        %% ERROR FOR LP
    disp('ERRORES CALCULADOS POR MEDIAS MOVILES')
findErrors(sNorm(k,:),Activity1(k,:),Activity2(k,:),Activity3(k,:),Activity4(k,:),Activity5(k,:),Activity6(k,:),...
    CleanedLP1(k,:),CleanedLP2(k,:),CleanedLP3(k,:),CleanedLP4(k,:),CleanedLP5(k,:),CleanedLP6(k,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    ecgName,MinHeightECGRest1,MinHeightECGRest6,...
    MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,minDistRest1,minDistRest6,...
    minDistRun2,minDistRun3,minDistRun4,minDistRun5,P(12,W))
%% 3. Savitzky smoothing filter.
    s(1,(1:3750))      = sgolayfilt(DetrendedNoise1,OrdenSavitzky,FramesSavitzky); 
    s(1,(3751:11250))  = sgolayfilt(DetrendedNoise2,OrdenSavitzky,FramesSavitzky); 
    s(1,(11251:18750)) = sgolayfilt(DetrendedNoise3,OrdenSavitzky,FramesSavitzky); 
    s(1,(18751:26250)) = sgolayfilt(DetrendedNoise4,OrdenSavitzky,FramesSavitzky); 
    s(1,(26251:33750)) = sgolayfilt(DetrendedNoise5,OrdenSavitzky,FramesSavitzky); 
    s(1,(33751:35989)) = sgolayfilt(DetrendedNoise6,OrdenSavitzky,FramesSavitzky); 
%   Ruido total 2: o(t) = n(t)+w(t)
    TotalS(1,(1:3750))      = WandererBaseline1 + s(1,(1:3750));
    TotalS(1,(3751:11250))  = WandererBaseline2 + s(1,(3751:11250));
    TotalS(1,(11251:18750)) = WandererBaseline3 + s(1,(11251:18750));
    TotalS(1,(18751:26250)) = WandererBaseline4 + s(1,(18751:26250));
    TotalS(1,(26251:33750)) = WandererBaseline5 + s(1,(26251:33750));
    TotalS(1,(33751:35989)) = WandererBaseline6 + s(1,(33751:35989));
      % Cleaning signal with MA
    Cleaneds1 = Activity1 - TotalS(1,(1:3750));
    Cleaneds2 = Activity2 - TotalS(1,(3751:11250));
    Cleaneds3 = Activity3 - TotalS(1,(11251:18750));
    Cleaneds4 = Activity4 - TotalS(1,(18751:26250));
    Cleaneds5 = Activity5 - TotalS(1,(26251:33750));
    Cleaneds6 = Activity6 - TotalS(1,(33751:35989));
        %% ERROR FOR SAVITZKY
disp('ERRORES CALCULADOS POR SAVITZKY')
findErrors(sNorm(k,:),Activity1(k,:),Activity2(k,:),Activity3(k,:),Activity4(k,:),Activity5(k,:),Activity6(k,:),...
    CleanedLP1(k,:),CleanedLP2(k,:),CleanedLP3(k,:),CleanedLP4(k,:),CleanedLP5(k,:),CleanedLP6(k,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    ecgName,MinHeightECGRest1,MinHeightECGRest6,...
    MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,minDistRest1,minDistRest6,...
    minDistRun2,minDistRun3,minDistRun4,minDistRun5,P(12,W))
 % Plotting noise models
 figure
 plot(t,TotalLP,t,TotalMA,t,TotalS),title('Final Artificial Noise Models'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight,
legend('Linear Predictor LPC + filtering Model','Moving Average model','Savitzky smoothing Model')