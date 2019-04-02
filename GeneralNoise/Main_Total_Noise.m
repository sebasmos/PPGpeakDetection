clc
clear all
close all
%% Add Datasets
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
[mediamuestral,TamRealizaciones]=GetAveragedNoise();

%% Get and save signals in 'Realizaciones'
% NOISE MODEL PARAMETERS
% LPC COEFFICIENTS
LPCActivity1 = 3500;
LPCActivity6 = 2200;
LPCActivity = 7500;
% AVERAGE MEAN
windowsizeRest = 40;
windowsizeRun = 30;

%% Parameters for findpeaks Function
% PARAMETERS FOR PPG SIGNAL
% MinPeakWidth
MinPeakWidthRest1 = 0.07;
MinPeakWidthRun_2 = 0.05;
MinPeakWidthRun_3 = 0.1;
MinPeakWidthRun_4 = 0.07;
MinPeakWidthRun_5 = 0.05;
MinPeakWidthRest6 = 0.1;
% MaxWidthPeak in PPG
MaxWidthRest1 = 1;
MaxWidthRun2 = 0.8;
MaxWidthRun3 = 0.8;
MaxWidthRun4 = 0.8;
MaxWidthRun5 = 1;
MaxWidthRest6 = 0.5;
% Prominence in PPG
ProminenceInRest1 = 0.03;
ProminenceRun2 = 0.04;
ProminenceRun3 = 0.12;
ProminenceRun4 = 0.04;
ProminenceRun5 = 0.12;
ProminenceInRest6 = 0.04;
% Min peak Distance in PPG
MinDistRest1 = 0.4;
MinDistRun2 = 0.35;
MinDistRun3 = 0.28;
MinDistRun4 = 0.25;
MinDistRun5 = 0.28;
MinDistRest6 = 0.2;
%% PARAMETERS IN ECG SIGNAL
% Min Height in ECG
MinHeightECGRest1 = 0.02;
MinHeightECGRun2  = 0.02;
MinHeightECGRun3  = 0.02;
MinHeightECGRun4  = 0.017;
MinHeightECGRun5  = 0.017;
MinHeightECGRest6 = 0.014;
%Min Dist in ECG
minDistRest1  = 0.5;
minDistRun2   = 0.44;
minDistRun3   = 0.3;
minDistRun4   = 0.3;
minDistRun5   = 0.3;
minDistRest6  = 0.3;
%Max Width in ECG
maxWidthRest1  = 0.05;
maxWidthRun2   = 0.05;
maxWidthRun3   = 0.05;
maxWidthRun4   = 0.04;
maxWidthRun5   = 0.04;
maxWidthRest6  = 0.04;

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
%% ECG PEAKS EXTRACTION
% Sample Frequency
    Fs = 125;
%Convert to physical values: According to timesheet of the used wearable
ecgFullSignal = (ECGdatasetSignals-128)./255;
s2 = (PPGdatasetSignals-128)/(255);

% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
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
nRest = 5;
nRun = 10;
DetrendedNoise1=Detrending(Noise1,nRest);
DetrendedNoise2=Detrending(Noise2,nRun);
DetrendedNoise3=Detrending(Noise3,nRun);
DetrendedNoise4=Detrending(Noise4,nRun);
DetrendedNoise5=Detrending(Noise5,nRun);
DetrendedNoise6=Detrending(Noise6,nRest);
% Wandering baseline extraction
WandererBaseline1=Noise1-DetrendedNoise1;
WandererBaseline2=Noise2-DetrendedNoise2;
WandererBaseline3=Noise3-DetrendedNoise3;
WandererBaseline4=Noise4-DetrendedNoise4;
WandererBaseline5=Noise5-DetrendedNoise5;
WandererBaseline6=Noise6-DetrendedNoise6;

%% 1. Savitzky smoothing filter.

    k=12; %IMPORTANT!!! change this parameter to obtain errors from 
          %different realizations
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
disp('ERRORES CALCULADOS POR SAVITZKY')
findErrors(Activity1(k,:),Activity2(k,:),Activity3(k,:),Activity4(k,:),Activity5(k,:),Activity6(k,:),...
    Cleaneds1(k,:),Cleaneds2(k,:),Cleaneds3(k,:),Cleaneds4(k,:),Cleaneds5(k,:),Cleaneds6(k,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(k,:),CleanedActivityECG2(k,:),CleanedActivityECG3(k,:),...
    CleanedActivityECG4(k,:),CleanedActivityECG5(k,:),CleanedActivityECG6(k,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6)

%% 2. Linear Predictor Artificial noise Model
%1 High frequency component
     LP(1:3750) = Function_1_LP(DetrendedNoise1,LPCActivity1);  
     LP(3751:11250) = Function_1_LP(DetrendedNoise2,LPCActivity);    
     LP(11251:18750) = Function_1_LP(DetrendedNoise3,LPCActivity);   
     LP(18751:26250) = Function_1_LP(DetrendedNoise4,LPCActivity);   
     LP(26251:33750) = Function_1_LP(DetrendedNoise5,LPCActivity);   
     LP(33751:35989) = Function_1_LP(DetrendedNoise6,LPCActivity6); 
% TOTAL LINEAR PREDICTOR ARTIFITIAL NOISE 
% Ruido total 1: o(t) = n(t)+w(t)
% **Wanderer baseline is added
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
disp('ERRORES CALCULADOS POR LINEAR PREDICTOR')
findErrors(Activity1(k,:),Activity2(k,:),Activity3(k,:),Activity4(k,:),Activity5(k,:),Activity6(k,:),...
    CleanedLP1(k,:),CleanedLP2(k,:),CleanedLP3(k,:),CleanedLP4(k,:),CleanedLP5(k,:),CleanedLP6(k,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(k,:),CleanedActivityECG2(k,:),CleanedActivityECG3(k,:),...
    CleanedActivityECG4(k,:),CleanedActivityECG5(k,:),CleanedActivityECG6(k,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);

%% 3. Moving average for artifitial noise modeling
    MA(1:3750)      = Function_2_MA(DetrendedNoise1,windowsizeRest);
    MA(3751:11250)  = Function_2_MA(DetrendedNoise2,windowsizeRun);
    MA(11251:18750) = Function_2_MA(DetrendedNoise3,windowsizeRun);
    MA(18751:26250) = Function_2_MA(DetrendedNoise4,windowsizeRun);
    MA(26251:33750) = Function_2_MA(DetrendedNoise5,windowsizeRun);
    MA(33751:35989) = Function_2_MA(DetrendedNoise6,windowsizeRest);
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
    disp('ERRORES CALCULADOS POR MOVING AVERAGE')
findErrors(Activity1(k,:),Activity2(k,:),Activity3(k,:),Activity4(k,:),Activity5(k,:),Activity6(k,:),...
    CleanedMA1(k,:),CleanedMA2(k,:),CleanedMA3(k,:),CleanedMA4(k,:),CleanedMA5(k,:),CleanedMA6(k,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(k,:),CleanedActivityECG2(k,:),CleanedActivityECG3(k,:),...
    CleanedActivityECG4(k,:),CleanedActivityECG5(k,:),CleanedActivityECG6(k,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);

%% Plotting noise models
figure
t=(0:length(TotalLP)-1/Fs);
plot(t,TotalLP,t,TotalMA,t,TotalS),title('Final Artificial Noise Models'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight,
legend('Linear Predictor LPC + filtering Model','Moving Average model','Savitzky smoothing Model')