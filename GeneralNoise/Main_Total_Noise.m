clc
clear all
close all
%% Add Datasets
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db');
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs');
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
%% Parameters for findpeaks Function
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
MinHeightECGRest6 = 0.03;
%Min Dist in ECG
minDistRest1  = 0.6;
minDistRun2   = 0.5;
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

mediamuestral=nonzeros(v);
mediamuestral=mediamuestral';
%% ECG PEAKS EXTRACTION
% Sample Frequency
Fs = 125;
%Convert to physical values: According to timesheet of the used wearable
ecgFullSignal = (ECGdatasetSignals-128)./255;
FinalSignal = (PPGdatasetSignals-128)/(255);

% Normalize the entire signal of all realizations.
for k=1:12
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

% %% 1. Savitzky smoothing filter.
% %   Ruido total 1: o(t) = n(t)+w(t)
%     TotalS=mediamuestral;
% % Cleaning signal with MA
%     Cleaneds1 = Activity1 - TotalS(1:3750);
%     Cleaneds2 = Activity2 - TotalS(3751:11250);
%     Cleaneds3 = Activity3 - TotalS(11251:18750);
%     Cleaneds4 = Activity4 - TotalS(18751:26250);
%     Cleaneds5 = Activity5 - TotalS(26251:33750);
%     Cleaneds6 = Activity6 - TotalS(33751:35989);
%     %% ERROR FOR SAVITZKY
% disp('ERRORES CALCULADOS POR SAVITZKY')
% findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
%     Cleaneds1(j,:),Cleaneds2(j,:),Cleaneds3(j,:),Cleaneds4(j,:),Cleaneds5(j,:),Cleaneds6(j,:), ...
%     Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
%     MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
%     ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
%     MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
%     CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
%     CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
%     MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
%     minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
%     maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);
% 
% %% 2. Linear Predictor Artificial noise Model
% %1 High frequency component
%      LP(1:3750)      = Function_1_LP(ZeroCenteredNoise1,LPCActivity1);  
%      LP(3751:11250)  = Function_1_LP(ZeroCenteredNoise2,LPCActivity);    
%      LP(11251:18750) = Function_1_LP(ZeroCenteredNoise3,LPCActivity);   
%      LP(18751:26250) = Function_1_LP(ZeroCenteredNoise4,LPCActivity);   
%      LP(26251:33750) = Function_1_LP(ZeroCenteredNoise5,LPCActivity);   
%      LP(33751:35989) = Function_1_LP(ZeroCenteredNoise6,LPCActivity6); 
% % TOTAL LINEAR PREDICTOR ARTIFITIAL NOISE 
% % Ruido total 1: o(t) = n(t)+w(t)
% % **Wanderer baseline is added
% % This noise includes lpc linear predictor with the described orders
% % also includes filter for modeling average noise extracted from signal.
%     TotalLP(1:3750)      = WandererBaseline1 + LP(1:3750);
%     TotalLP(3751:11250)  = WandererBaseline2 + LP(3751:11250);
%     TotalLP(11251:18750) = WandererBaseline3 + LP(11251:18750);
%     TotalLP(18751:26250) = WandererBaseline4 + LP(18751:26250);
%     TotalLP(26251:33750) = WandererBaseline5 + LP(26251:33750);
%     TotalLP(33751:35989) = WandererBaseline6 + LP(33751:35989);
% % Cleaning signal with LP
%     CleanedLP1 = Activity1 - TotalLP(1:3750);
%     CleanedLP2 = Activity2 - TotalLP(3751:11250);
%     CleanedLP3 = Activity3 - TotalLP(11251:18750);
%     CleanedLP4 = Activity4 - TotalLP(18751:26250);
%     CleanedLP5 = Activity5 - TotalLP(26251:33750);
%     CleanedLP6 = Activity6 - TotalLP(33751:35989);
%     %% ERROR FOR LP
% disp('ERRORES CALCULADOS POR LINEAR PREDICTOR')
% findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
%     CleanedLP1(j,:),CleanedLP2(j,:),CleanedLP3(j,:),CleanedLP4(j,:),CleanedLP5(j,:),CleanedLP6(j,:), ...
%     Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
%     MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
%     ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
%     MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
%     CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
%     CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
%     MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
%     minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
%     maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);
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
%% 4. FINAL MODEL: Band-Limited Gaussian noise model
    h=hampel(MA,500); %% ARREGLAR
    media=ValoresMedia(h);
    MAHF=MA;
    V=[s-WandererBaseline1 s1-WandererBaseline2 s2-WandererBaseline3 s3-WandererBaseline4 s4-WandererBaseline5 s5-WandererBaseline6];
    varianzamuestralMA= var(V);
    XMA = [0.05 0.001 0.1 0.2 0.4 ];
    GaussianModelsMA=zeros(length(XMA),length(MAHF));
    for k=1:length(MAHF)
        GaussianModelsMA(:,k)=MAHF(k)+sqrt(varianzamuestralMA(k))*XMA;
    end
    PBF = designfilt('bandpassiir','PassbandFrequency1',2.5,...
    'StopbandFrequency1',2,'StopbandFrequency2',26.5,...
    'PassbandFrequency2',26,...
    'StopbandAttenuation1',10,'StopbandAttenuation2',10,...
    'SampleRate',Fs,'DesignMethod','ellip');

    TotalMAHF = filtfilt(PBF,GaussianModelsMA(1,:));
    
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
        %% ERROR FOR GAUSSIAN MODEL
    disp('ERRORES CALCULADOS POR MODELO GAUSSIANO')
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

 %% Plotting noise models
%figure
%t=(0:length(TotalLP)-1/Fs);
%plot(t,TotalLP,t,TotalS),hold on,plot(t,TotalMA,'LineWidth',3),title('Final Artificial Noise Models'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight,
%legend('Linear Predictor LPC + filtering Model','Savitzky smoothing Model','Moving Average model')
