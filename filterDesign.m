% clear all
% close all
% clc
%% Add GetAverageNoise function
%%IMPORTANTE!!!! SACAR MEDIAMUESTRAL DEL SCRIPT DE GETAVERAGEDNOISE
%%QUITANDO LA PARTE EN LA QUE SE LE SUMA VALORESMEDIA
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs')
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GeneralNoise')
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\SpectrumAnalysis')
% Add databases
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db')
%SampleFrequency
Fs=125;
%% OBTAIN SAMPLES AND GENERALIZED SAVITZKY NOISE MODEL
[mediamuestral,TamRealizaciones,s,s1,s2,s3,s4,s5]=GetAveragedNoise();
%% UNBIASED VARIANZA
% The activities are separated according to each activity and its variance
% Add is extracted vertically, operating varianamuestral function per column
media=ValoresMedia(mediamuestral);
mediamuestral = mediamuestral-media;
V=[s-media(1:3750) s1-media(3751:11250) s2-media(11251:18750) s3-media(18751:26250) s4-media(26251:33750) s5-media(33751:end)];
varianzamuestral= var(V);

X = randn(5,1);
GaussianModels=zeros(5,length(mediamuestral));
for k=1:length(mediamuestral)
    GaussianModels(:,k)=mediamuestral(k)+sqrt(varianzamuestral(k))*0.3;
end

 %% Modelo MA:
windowsizeRest = 40;
windowsizeRun = 30;
   b = 1/windowsizeRest*ones(1,windowsizeRest);
   MA = filter(b,1,mediamuestral(1:3750));
%% FILTER
PBF = designfilt('bandpassiir','PassbandFrequency1',2.5,...
'StopbandFrequency1',2,'StopbandFrequency2',26.5,...
'PassbandFrequency2',26,...
'StopbandAttenuation1',30,'StopbandAttenuation2',30,...
'SampleRate',Fs,'DesignMethod','ellip');
%% VEAMOS COMO SE COMPARA CON EL SAVITZKY
close all
ShortedBP = filtfilt(PBF,GaussianModels(5,:));
 plot(mediamuestral(1:3750)), hold on
 plot(MA),hold on
 plot(0.5*ShortedBP(1:3750)),title('Activity RESTING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
 legend('Mediamuestral','MA','Senal Gaussiana Limitada en banda')
 
% figure
% plot(mediamuestral(3750:11250)),hold on
% plot(ShortedBP(3750:11250)),title('Activity RUNNING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
% legend('Mediamuestral','Senal Gaussiana Limitada en banda')
fvtool(ShortedBP)

fvtool(PBF)
%% FILTER 2

% VEAMOS COMO SE COMPARA CON EL SAVITZKY
close all
PBF2 = designfilt('bandpassfir','FilterOrder',300,...
'CutoffFrequency1',3,'CutoffFrequency2',26,'SampleRate',125,...
'StopbandAttenuation1',90,'StopbandAttenuation2',90);

ShortedBP2 = filtfilt(PBF2,GaussianModels(5,:));
 plot(mediamuestral(1:3750)), hold on
 plot(MA),hold on
 plot(ShortedBP2(1:3750)),title('Activity RESTING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
 legend('Mediamuestral','MA','Senal Gaussiana Limitada en banda')
 
% figure
% plot(mediamuestral(3750:11250)),hold on
% plot(ShortedBP(3750:11250)),title('Activity RUNNING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
% legend('Mediamuestral','Senal Gaussiana Limitada en banda')
fvtool(ShortedBP2)

fvtool(PBF2)
%% FILTER 3
close all
hFilt = designfilt('hilbertfir','FilterOrder',30,'TransitionWidth',46,'SampleRate',Fs);
fvtool(hFilt,'MagnitudeDisplay','magnitude')
%% FILTER 4
close all
b = cfirpm(100,[0 0.5 0.55 1],{'lowpass',-16});
fvtool(b)

%% FILTER 5: PARA MODELO CON MEJOR SENSIBILIDAD
close all
[mediamuestralMA,TamRealizaciones,s,s1,s2,s3,s4,s5]=GetAveragedNoise2();
mediaMA=ValoresMedia(mediamuestralMA);
mediamuestralMA = mediamuestralMA-mediaMA;
VMA=[s-mediaMA(1:3750) s1-mediaMA(3751:11250) s2-mediaMA(11251:18750) s3-mediaMA(18751:26250) s4-mediaMA(26251:33750) s5-mediaMA(33751:end)];
varianzamuestralMA= var(VMA);
% Modelos optimos para XMA entre 0 y 0.3 aprox, crear rand en dicho interv
XMA = [0.05 0.001 0.0002 0.1 0.2 0.3 0.4];
GaussianModelsMA=zeros(length(XMA),length(mediamuestralMA));
for k=1:length(mediamuestralMA)
    GaussianModelsMA(:,k)=mediamuestralMA(k)+sqrt(varianzamuestralMA(k))*XMA;
end
for u = 1:length(XMA)
   plot(GaussianModelsMA(u,:)),hold on
end
legend('0.05','0.001', '0.0002','0.1', '0.2', '0.3', '0.4')
figure
plot(mediamuestral(1:3750)),hold on
plot(GaussianModelsMA(2,1:3750)),hold on
plot(MA)
legend('mediamuestral','GaussianModel','MA')