clc;
close all;
%% ANALISIS DE ESPECTRO DE SEÑAL PPG SIN RUIDO
% Lectura de la señal
Fs = 125; % Sample rate
% Màxima frecuencia del espectro: Fs/2
ppg = load('DATA_01_TYPE01.mat');
ppgSignal = ppg.sig;
pfinal = ppgSignal(3,(1:3050));
%% Anàlisis de los espectros
[~,~,f,dP] = centerfreq(Fs,pfinal);
[PS,NN] = PowSpecs(pfinal);
figure(1)
plot(f,dP);
title('Espectro de la señal total en reposo, primeros 30 segundos');
 figure(2)
 plot(Fs/2*linspace(0,1,NN-1),PS)
 title('Espectro de Potencia')
 axis([0 50 -1 3000 ])
 
 pfinal2 = ppgSignal(3,(5000:18000));
%% Anàlisis de los espectros
[~,~,f,dP] = centerfreq(Fs,pfinal2);
[PS,NN] = PowSpecs(pfinal2);
figure(3)
plot(f,dP);
title('Espectro de la señal total CON RUIDO, primeros 30 segundos');
figure(4)
plot(Fs/2*linspace(0,1,NN-1),PS)
title('Espectro de Potencia')
axis([0 50 -1 3000 ])
%  %% Extracciòn de caracterìsticas
%  caract1 = caract(pfinal,Fs);
%  %% Despliegue de informaciòn de las caracterìsticas
%  DispCaract(caract1);