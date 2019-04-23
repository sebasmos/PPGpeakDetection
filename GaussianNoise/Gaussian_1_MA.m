function [Sensibity,Especificity] = Gaussian_1_MA(windowsizeRest,windowsizeRun)
% clc
% clear all
% close all
%% Add Datasets
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db');
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GeneralNoise');
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs');
[mediamuestral,TamRealizaciones,s,s1,s2,s3,s4,s5]=GetAveragedNoise();
% UNBIASED VARIANZA
%The activities are separated according to each activity and its variance
%Add is extracted vertically, operating varianamuestral function per column
media=ValoresMedia(mediamuestral);
mediamuestral = mediamuestral-media;
V=[s-media(1:3750) s1-media(3751:11250) s2-media(11251:18750) s3-media(18751:26250) s4-media(26251:33750) s5-media(33751:end)];
varianzamuestral= var(V);
[mediamuestralMA,TamRealizaciones2,sa,sa1,sa2,sa3,sa4,sa5]=GetAveragedNoise2();

mediaMA=ValoresMedia(mediamuestralMA);
mediamuestralMA = mediamuestralMA-mediaMA;
mediamuestralMA = hampel(mediamuestralMA,4000,2);
VMA=[sa-mediaMA(1:3750) sa1-mediaMA(3751:11250) sa2-mediaMA(11251:18750) sa3-mediaMA(18751:26250) sa4-mediaMA(26251:33750) sa5-mediaMA(33751:end)];
varianzamuestralMA= var(VMA);
% LPC COEFFICIENTS
LPCActivity1 = 3500;
LPCActivity6 = 2200;
LPCActivity = 7000;
% % AVERAGE MEAN
% windowsizeRest = 90;
% windowsizeRun = 70;
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
    CleanedSignal1 = Activity1 - TotalS(1:3750);
    CleanedSignal2 = Activity2 - TotalS(3751:11250);
    CleanedSignal3 = Activity3 - TotalS(11251:18750);
    CleanedSignal4 = Activity4 - TotalS(18751:26250);
    CleanedSignal5 = Activity5 - TotalS(26251:33750);
    CleanedSignal6 = Activity6 - TotalS(33751:35989);
%% MODELO MEDIAS MOVILES
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
      % MODELO GAUSIANO LIMITADO EN BANDA, 
    % Anadimos varianza de Savitzky a modelo Gaussiano para alterar la
    % señal con mayor intensidad
%   X = randn(5,1);
    XMA = [0.05 0.001 0.1 0.2 0.4 ];
    GaussianModelsMA=zeros(length(XMA),length(mediamuestralMA));
    for k=1:length(mediamuestralMA)
        GaussianModelsMA(:,k)=mediamuestralMA(k)+sqrt(varianzamuestralMA(k))*XMA;
    end
    PBF = designfilt('bandpassiir','PassbandFrequency1',2.5,...
    'StopbandFrequency1',2,'StopbandFrequency2',26.5,...
    'PassbandFrequency2',26,...
    'StopbandAttenuation1',10,'StopbandAttenuation2',10,...
    'SampleRate',Fs,'DesignMethod','ellip');
%    Modelo final:
    TotalMA = filtfilt(PBF,GaussianModelsMA(1,:));
    
    % Cleaning signal with MA
    CleanedMA1 = Activity1 - TotalMA(1:3750);
    CleanedMA2 = Activity2 - TotalMA(3751:11250);
    CleanedMA3 = Activity3 - TotalMA(11251:18750);
    CleanedMA4 = Activity4 - TotalMA(18751:26250);
    CleanedMA5 = Activity5 - TotalMA(26251:33750);
    CleanedMA6 = Activity6 - TotalMA(33751:35989);
    
    
%% PERFORMANCE PARAMS
close all
TP = 0; 
FP = 0;
TN = 0;
FN = 0;
   for i=1:12
    alfa(i,(1:4))  = GetPandoraA(CleanedActivityECG1(i,:),Activity1(i,:),CleanedMA1(i,:),P(i,(1:7)),Fs);
    alfa(i,(5:8))  = GetPandoraA(CleanedActivityECG2(i,:),Activity2(i,:),CleanedMA2(i,:),P(i,(8:14)),Fs);
    alfa(i,(9:12)) = GetPandoraA(CleanedActivityECG3(i,:),Activity3(i,:),CleanedMA3(i,:),P(i,(15:21)),Fs);
    alfa(i,(13:16))= GetPandoraA(CleanedActivityECG4(i,:),Activity4(i,:),CleanedMA4(i,:),P(i,(22:28)),Fs);  
    alfa(i,(17:20))= GetPandoraA(CleanedActivityECG5(i,:),Activity5(i,:),CleanedMA5(i,:),P(i,(29:35)),Fs);
    alfa(i,(21:24))= GetPandoraA(CleanedActivityECG6(i,:),Activity6(i,:),CleanedMA6(i,:),P(i,(36:42)),Fs);

      TP = [TP alfa(i,1) alfa(i,5) alfa(i,9)  alfa(i,13)  alfa(i,17)  alfa(i,21)];
      FP = [FP alfa(i,2) alfa(i,6) alfa(i,10) alfa(i,14)  alfa(i,18)  alfa(i,22)];
      TN = [TN alfa(i,3) alfa(i,7) alfa(i,11) alfa(i,15)  alfa(i,19)  alfa(i,23)];
      FN = [FN alfa(i,4) alfa(i,8) alfa(i,12) alfa(i,16)  alfa(i,20)  alfa(i,24)];     
   end
   %%
   Especificity  = sum(TN)./(sum(TN)+sum(FP));
   Sensibity    = sum(TP)./(sum(TP)+sum(FN));
end