%% SPECTRA ANALYSIS FOR APPENDIX A.
clc
clear all
close all
%% ADD DATASETS, LOAD THEM AND CONVERT TO PHYSICAL VARIABLES IN ORDER TO
% OBTAIN THE SIGNAL'S SPECTRA.
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');

    for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
    end
    end

	%Sample Frequency
    Fs=125;
    %Convert to physical values.
    s2 = (PPGdatasetSignals-128)/(255);
    % Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
end
    
% Separate Activities
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end));
t30s=(0:length(Activity1)-1)/Fs;
t60s=(0:length(Activity2)-1)/Fs;
tend=(0:length(Activity6)-1)/Fs;
ftotal = (0:length(sNorm)-1)/Fs;

%% THIS CODE IS COMMENTED SINCE IT CAN BE RUN IN DIFFERENT WAYS, FOR SPACE
% AND BETTER VISUALIZATION OF THE FIGURES.
% 1.FOURIER TRANSFORM OF THE ENTIRETY OF THE SIGNALS.
% 
% for i=1:12
%     Y(i,:)=fft(sNorm(i,:));
% end
%
% Frquency domain for the plotting.
%
% ftotal = Fs*(0:(length(sNorm)/2))/length(sNorm);
%
% Get the unilateral amplitude spectra.
%
% P1=abs(Y/length(sNorm));
% EspectroTotal=P1(:,(1:length(sNorm)/2+1));
% EspectroTotal(:,2:end-1) = 2*EspectroTotal(:,2:end-1);
% 
% figure(1),
% plot(ftotal,EspectroTotal(1,:)),hold on,
% plot(ftotal,EspectroTotal(2,:)),hold on,
% plot(ftotal,EspectroTotal(3,:)),hold on,
% plot(ftotal,EspectroTotal(4,:)),hold on,
% plot(ftotal,EspectroTotal(5,:)),hold on,
% plot(ftotal,EspectroTotal(6,:)),hold on,
% plot(ftotal,EspectroTotal(7,:)),hold on,
% plot(ftotal,EspectroTotal(8,:)),hold on,
% plot(ftotal,EspectroTotal(9,:)),hold on,
% plot(ftotal,EspectroTotal(10,:)),hold on,
% plot(ftotal,EspectroTotal(11,:)),hold on,
% plot(ftotal,EspectroTotal(12,:)),hold on,grid on, axis ([0 8 0 0.05]),xlabel('Frequency (Hz)'),
% legend('Realization 1','Realization 2','Realization 3','Realization 4','Realization 5',...
%     'Realization 6','Realization 7','Realization 8','Realization 9','Realization 10',...
%     'Realization 11','Realization 12'),
% title('Fourier Transform for all of the PPG signals')

%% FOURIER TRANSFORM FOR EACH ONE OF THE ACTIVITIES WITHIN ONE REALIZATION.

% Realization=3;
% Y1=fft(Activity1(Realization,:));
% Y2=fft(Activity2(Realization,:));
% Y3=fft(Activity3(Realization,:));
% Y4=fft(Activity4(Realization,:));
% Y5=fft(Activity5(Realization,:));
% Y6=fft(Activity6(Realization,:));
% 
% %Frequency domain for the plotting.
% f30s = Fs*(0:(length(Activity1)/2))/length(Activity1);
% f1min= Fs*(0:(length(Activity2)/2))/length(Activity2);
% fend= Fs*(0:length(Activity6)/2)/length(Activity6);
% % Find unilateral amplitude spectra.
% P1=abs(Y1/length(Activity1));
% EspectroActividad1=P1(:,(1:length(Activity1)/2+1));
% EspectroActividad1(:,2:end-1) = 2*EspectroActividad1(:,2:end-1);
% 
% P1=abs(Y2/length(Activity2));
% EspectroActividad2=P1(:,(1:length(Activity2)/2+1));
% EspectroActividad2(:,2:end-1) = 2*EspectroActividad2(:,2:end-1);
% 
% P1=abs(Y3/length(Activity3));
% EspectroActividad3=P1(:,(1:length(Activity3)/2+1));
% EspectroActividad3(:,2:end-1) = 2*EspectroActividad3(:,2:end-1);
% 
% P1=abs(Y4/length(Activity4));
% EspectroActividad4=P1(:,(1:length(Activity4)/2+1));
% EspectroActividad4(:,2:end-1) = 2*EspectroActividad4(:,2:end-1);
% 
% P1=abs(Y5/length(Activity5));
% EspectroActividad5=P1(:,(1:length(Activity5)/2+1));
% EspectroActividad5(:,2:end-1) = 2*EspectroActividad5(:,2:end-1);
% 
% P1=abs(Y6/length(Activity6));
% EspectroActividad6=P1(:,(1:length(Activity6)/2+1));
% EspectroActividad6(:,2:end-1) = 2*EspectroActividad6(:,2:end-1);
% 
% figure(2)
% subplot(2,3,1),plot(f30s,EspectroActividad1),grid on, xlabel('Frequency (Hz)'),axis ([0 8 0 0.05]),title('Activity 1'),
% subplot(2,3,2),plot(f1min,EspectroActividad2),grid on, xlabel('Frequency (Hz)'),axis ([0 8 0 0.05]),title('Activity 2'),
% subplot(2,3,3),plot(f1min,EspectroActividad3),grid on, xlabel('Frequency (Hz)'),axis ([0 8 0 0.05]),title('Activity 3'),
% subplot(2,3,4),plot(f1min,EspectroActividad4),grid on, xlabel('Frequency (Hz)'),axis ([0 8 0 0.05]),title('Activity 4'),
% subplot(2,3,5),plot(f1min,EspectroActividad5),grid on, xlabel('Frequency (Hz)'),axis ([0 8 0 0.05]),title('Activity 5'),
% subplot(2,3,6),plot(fend,EspectroActividad6),grid on, xlabel('Frequency (Hz)'),axis ([0 8 0 0.05]),title('Activity 6'),

%% FOURIER TRANSFORM FOR AN ENTIRE REALIZATION, FILTERED IN HIGH-FREQUENCY
Realization=6;
YRealization1=fft(sNorm(Realization,:));
%Frequency domain for the plotting
P1=abs(YRealization1/length(sNorm));
EspectroRealizacion1=P1(1:length(sNorm)/2+1);
EspectroRealizacion1(2:end-1) = 2*EspectroRealizacion1(2:end-1);

% High-frequency noise from the realization is filtered.
sfilt=sgolayfilt(sNorm(Realization,:),3,41);
RealizacionFiltrada=hampel(sfilt,5,2);

% Fourier transform for the filtered signal
YRealizacionFiltrada=fft(RealizacionFiltrada);
% Frequency domain for the plotting
P2=abs(YRealizacionFiltrada/length(sNorm));
EspectroRealizacion1Filtrado=P2(1:length(sNorm)/2+1);
EspectroRealizacion1Filtrado(2:end-1) = 2*EspectroRealizacion1Filtrado(2:end-1);

% Subtract clean signal from the noisy one.
RuidoRealizacion1=sNorm(Realization,:)-RealizacionFiltrada;

% Fourier transform for the high-frequency noise.
YRuidoRealizacion1=fft(RuidoRealizacion1);
P3=abs(YRuidoRealizacion1/length(sNorm));
EspectroRuidoRealizacion1=P3(1:length(sNorm)/2+1);
EspectroRuidoRealizacion1(2:end-1) = 2*EspectroRuidoRealizacion1(2:end-1);

% FIGURES:
% figure(3), plot(ftotal,EspectroRealizacion1),grid on, xlabel('Frequency(Hz)'),axis([0 8 0 0.01]), title('Frequency spectrum of realization 1'),hold on,
% plot(ftotal,EspectroRealizacion1Filtrado),legend('Realización 1 unfiltered','Realización 1 filtered w/Saviztky-Golay')
% 
% figure(4),plot(ftotal,EspectroRealizacion1),grid on, xlabel('Frequency(Hz)'),axis([ 0 8 0 0.01]), title('Frequency spectrum comparation'), hold on,
% plot(ftotal,EspectroRuidoRealizacion1),legend('Realizacion 1 unfiltered ','High-frequency noise spectrum')

%% FOURIER TRANSFORM PLOTTING FOR THE ENTIRETY OF THE NOISE (HIGH AND LOW FREQ)
% 
% Realization=1;
% YRealization1=fft(sNorm(Realization,:));
% %Dominio de la frecuencia para la gráfica
% P1=abs(YRealization1/length(sNorm));
% EspectroRealizacion1=P1(1:length(sNorm)/2+1);
% EspectroRealizacion1(2:end-1) = 2*EspectroRealizacion1(2:end-1);
% 
% %We obtain the total noise of the realization
%
% [mediamuestral,TamRealizaciones]=GetAveragedNoise();
% RealizacionFiltrada=sNorm(Realization,:)-mediamuestral;
% 
% %Fourier transform for the filtered signal.
%
% YRealizacionFiltrada=fft(RealizacionFiltrada);
% %Frequency domain for the plotting
% P2=abs(YRealizacionFiltrada/length(sNorm));
% EspectroRealizacion1Filtrado=P2(1:length(sNorm)/2+1);
% EspectroRealizacion1Filtrado(2:end-1) = 2*EspectroRealizacion1Filtrado(2:end-1);
% 
% %We get just the noise of the realization for a posterior FFT
% RuidoRealizacion1=mediamuestral;
% 
% %Fourier transform for the entire noise.
%
% YRuidoRealizacion1=fft(RuidoRealizacion1);
% P3=abs(YRuidoRealizacion1/length(sNorm));
% EspectroRuidoRealizacion1=P3(1:length(sNorm)/2+1);
% EspectroRuidoRealizacion1(2:end-1) = 2*EspectroRuidoRealizacion1(2:end-1);
% N = length(sNorm);
% 
% ftotal = Fs*(0:(N/2))/N;
% 
% figure(3), plot(ftotal,EspectroRealizacion1),grid on, xlabel('Frequency(Hz)'),axis([0 8 0 0.01]), title('Frequency spectrum of realization 1'),hold on,
% plot(ftotal,EspectroRealizacion1Filtrado),legend('Realización 1 unfiltered','Realización 1 filtered')
% 
% figure(4),plot(ftotal,EspectroRealizacion1),grid on, xlabel('Frequency(Hz)'),axis([ 0 8 0 0.01]), title('Frequency spectrum comparation'), hold on,
% plot(ftotal,EspectroRuidoRealizacion1),legend('Realizacion 1 unfiltered ','Entire artifact noise spectrum')




%% WAVELET ANALYSIS.
% This analysis makes part of what was stated in the first part of appendix
% A. However, wavelets were not chosen, not only because of their high
% fidelity to the signal, but because there is a wide set of possibilities
% and this just for extracting high-frequency noise. This would overcome
% the scope and waste the time for a simple process that has already been
% achieved by Savitzky Golay means.
N = length(sNorm);
ftotal = Fs*(0:(N/2))/N;
wname  = 'sym4';               % Wavelet for analysis.
level  = 5;                    % Level for wavelet decomposition.
sorh   = 's';                  % Type of thresholding.
nb_Int = 3;                    % Number of intervals for thresholding.

Realization=1;
%% FILTERING USING WAVELETS
[sigden,coefs,thrParams,int_DepThr_Cell,BestNbOfInt] = cmddenoise(sNorm(1,:),wname,level,sorh,nb_Int);        
 WaveletsNoise = sNorm(1,:) - sigden;
%% Spectrum
YRealization1=fft(WaveletsNoise(Realization,:));
P1=abs(YRealization1/length(sNorm));
EspectroRealizacion1=P1(1:length(sNorm)/2+1);
EspectroRealizacion1(2:end-1) = 2*EspectroRealizacion1(2:end-1);
% REMOVE BASELINE DRIFT
%WNoise = detrend(WaveletsNoise,'linear',10);
%% Savitzky: 
sfilt=sgolayfilt(sNorm(Realization,:),3,41);
RealizacionFiltrada=hampel(sfilt,5,2);
SavitzkyNoise=sNorm(Realization,:)-RealizacionFiltrada;
% Spectrum
SavitzkyNoiseF=fft(SavitzkyNoise);
P2=abs(SavitzkyNoiseF/length(sNorm));
FinalSavitzky=P2(1:length(sNorm)/2+1);
FinalSavitzky(2:end-1) = 2*FinalSavitzky(2:end-1);
%ANALISIS GRAFICO
 plot(WaveletsNoise),hold on
 plot(SavitzkyNoise)
 axis tight
 title('Filtered signal using wavelets')
 legend('Wavelet Noise Model','Savitzky Noise Model','Location','NorthWest');
 xlabel('Frequency(Hz)')
 ylabel('Magnitude')
 