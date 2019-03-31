%% PROOF 2: ECG peaks detection

%% Add Datasets
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\Training_data\db');
%% Get Noise from Savitzky method
% Random sample signal: 
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
ecg = load('DATA_01_TYPE02.mat');
ecgSig = ecg.sig;
ecgFullSignal = ecgSig(1,(1:length(mediamuestral)));% match sizes 
% Normalize with min-max method
ecgFullSignal = (ecgFullSignal-128)./255;
ecgFullSignal = (ecgFullSignal-min(ecgFullSignal))./(max(ecgFullSignal)-min(ecgFullSignal));
% Squared signal to 
seccion1 = ecgFullSignal(33750:35989);
seccion1a = seccion1.^2;
ecgF = (abs(26251:33750)).^2;
t = (0:length(ecgFullSignal)-1)/125;   
p = Detrending(seccion1,10);
h = seccion1-p;
seccion1b = h.^2;
%%
close all
[ECG5Peaks,ECG5Locs] = GetECGPeakPoints(seccion1a,0.55, 0.1);

[a,b] = GetECGPeakPoints(seccion1b,0.0, 0.3);
%%
%close all
figure
plot(seccion1a,'r'),hold on
sfilt=sgolayfilt(seccion1,18,41);
sindc = sfilt - p;
seccion1c = sindc.^2;
plot(seccion1c,'b')
[x,y] = GetECGPeakPoints(seccion1c,0.05, 0.3);
%%   
    [C,L] = wavedec(seccion1,9,'db8'); 
    A3 = wrcoef('a',C,L,'db8',6); % mejor linea base
    X = waverec(C,L,'db8'); 
    figure
    plot(seccion1, 'c'); hold on;
    plot(A3, 'b'); hold on;
    Corr_Terr = seccion1-A3;

[x1,y1] = GetECGPeakPoints(seccion1c,0.05, 0.3);
%     nov = detrend(Corr_Terr);
%     ecgmodwt = modwt(nov,'sym4',3);
%     ecgmra = modwtmra(ecgmodwt,'sym4');
%     ecgmra= detrend(ecgmra(4,1:1:end));
%     
%     lev = 5;
%     wname = 'sym8';
%     xd = wden(ecgmra,'sqtwolog','h','mln',lev,wname);
% 
%     plot(xd,'r')
%     title('EKG con ruido');grid on;
%     legend('Señal original','Linea base', 'Señal filtrada'); 
%     pause;
%     hold off;
%     datasetFiltrado = [datasetFiltrado,xd'];
