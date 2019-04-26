%% JOINT GAUSSIAN RANDOM VECTOR NOISE MODEL
function [final]=GetGaussianNoise()
 clear all
 close all
 clc
%% Add GetAverageNoise function
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GeneralNoise')
% Add databases
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db')
%SampleFrequency
Fs=125;
 [mediamuestral,TamRealizaciones,s,s1,s2,s3,s4,s5]=GetAveragedNoise();
%% UNBIASED VARIANZA
%The activities are separated according to each activity and its variance
%Add is extracted vertically, operating varianamuestral function per column
media=ValoresMedia(mediamuestral);
mediamuestral = mediamuestral-media;
V=[s-media(1:3750) s1-media(3751:11250) s2-media(11251:18750) s3-media(18751:26250) s4-media(26251:33750) s5-media(33751:end)];
varianzamuestral= var(V);
%% OBTAIN SAMPLES AND GENERALIZED SAVITZKY NOISE MODEL

[mediamuestralMA,TamRealizaciones2,sa,sa1,sa2,sa3,sa4,sa5]=GetAveragedNoise2();

mediaMA=ValoresMedia(mediamuestralMA);
mediamuestralMA = mediamuestralMA-mediaMA;
mediamuestralMA = hampel(mediamuestralMA,4000,2);
VMA=[sa-mediaMA(1:3750) sa1-mediaMA(3751:11250) sa2-mediaMA(11251:18750) sa3-mediaMA(18751:26250) sa4-mediaMA(26251:33750) sa5-mediaMA(33751:end)];
varianzamuestralMA= var(VMA);
% Modelos optimos para XMA entre 0 y 0.15 aprox, crear rand en dicho
% interv. Mejor Valor: 0.05, ver gr�fica
 %% Modelo MA general por analisis comparatorio
windowsizeRest = 40;
windowsizeRun = 30;
   b = 1/windowsizeRest*ones(1,windowsizeRest);
   MA = filter(b,1,mediamuestral);
   MArun = filter(b,1,mediamuestral);
%% MODELO GAUSIANO LIMITADO EN BANDA: ELEGIR 0.05
XMA = [0.05 0.001 0.1 0.2 0.4 ];
GaussianModelsMA=zeros(length(XMA),length(mediamuestralMA));
for k=1:length(mediamuestralMA)
    GaussianModelsMA(:,k)=mediamuestralMA(k)+sqrt(varianzamuestralMA(k))*XMA;
end
for u = 1:length(XMA)
   plot(GaussianModelsMA(u,:)),hold on
end

plot(MArun,'LineWidth',1.5),grid on, title('Best seed values under max-Amplitud in MA model')
legend('0.05','0.001', '0.1','0.2','0.4','MA')
figure
plot(mediamuestral),hold on
plot(GaussianModelsMA(1,:)),hold on
plot(MA)
legend('mediamuestral','GaussianModel','MA')
%% FILTER DESIGN
close all
at = 5;
PBF = designfilt('bandpassiir','PassbandFrequency1',3.5,...
'StopbandFrequency1',3,'StopbandFrequency2',26.5,...
'PassbandFrequency2',26,...
'StopbandAttenuation1',at,'StopbandAttenuation2',at,...
'SampleRate',Fs,'DesignMethod','ellip','PassbandRipple',0.5);
fvtool(PBF)
ShortedBP = filtfilt(PBF,GaussianModelsMA(1,:));
% ShortedBP = bandpass(GaussianModelsMA(1,:),[3 26],Fs);
 plot(MA(1:3750),'b'), hold on
 plot(GaussianModelsMA(1,:),'r'),hold on
 plot(ShortedBP(1:3750),'g'),title('Activity RESTING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
 legend('MA','Senal Gaussiana','filtrada')
%% Espectro de se�al modelo 1 limitada en banda
    [~,~,f,dP1] = centerfreq(Fs,mediamuestral); 
    [~,~,f2,dP2] = centerfreq(Fs,ShortedBP); 
    [PS,NN] = PowSpecs(mediamuestral);
    [PS,NN] = PowSpecs(ShortedBP);
    figure
    plot(f,dP1,f2,dP2),grid on, axis([0 50 -10 100 ])
    legend('Savitzky','Band-limited Gaussian Noise')
    title('SPECTRUM, BOTH CASES') 
%final = GaussianModelsMA(1,:);
final = ShortedBP;
end
