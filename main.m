%% ACTIVIDADES TIPO 1
    figure(1) 
    ppg=load('DATA_01_TYPE01.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(3,(3000:18050));
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSIÓN A VARIABLES FÍSICAS
    s2 = (pfinal-128)/(255);
   % s2 = (ppgSignal(2,:)+81)/161;
    s3 = (ppgSignal(3,:)+41)/81;
% NORMALIZACIÓN POR MÁXIMOS Y MÍNIMOS
    s2Norm = (s2-min(s2))/(max(s2)-min(s2));
    plot(s2Norm,'r')

    t = (0:length(pfinal)-1);
    
wname  = 'sym4';               % Wavelet for analysis.
level  = 5;                    % Level for wavelet decomposition.
sorh   = 's';                  % Type of thresholding.
nb_Int = 3;                    % Number of intervals for thresholding.

[sigden,coefs,thrParams,int_DepThr_Cell,BestNbOfInt] = ...
            cmddenoise(s2Norm,wname,level,sorh,nb_Int);
 hold on,   
 plot(sigden,'k','linewidth',2)
 axis tight
 title('Señales con y sin ruido')
 legend('Original Signal','Denoised Signal','Location','NorthWest');
 figure(2)
 Ruido = s2Norm - sigden;
 plot(Ruido)
 title('RUIDO A PARTIR DE WAVELETS')
 axis tight
 
 figure(3)
 EspectroSenal = fft(s2Norm);
 X_mag = abs(EspectroSenal);
 X_fase = angle(EspectroSenal);
 N = length(s2Norm);
 Freq = (0:1/N:1-1/N)*Fs;
 plot(Freq,EspectroSenal)
 axis([0 10 -200 200 ])

%% Anàlisis de los espectros
[~,~,f,dP] = centerfreq(Fs,pfinal);
[PS,NN] = PowSpecs(pfinal);
[~,~,f2,dP2] = centerfreq(Fs,sigden);
[PS2,NN2] = PowSpecs(sigden);
figure(4)
plot(f,dP);
hold on 
plot(f2,dP2)
legend('Senal con ruido','Senal sin ruido')
title('Espectro de la señal CON Y SIN RUIDO total en reposo, primeros 30 segundos');
 %plot(Fs/2*linspace(0,1,NN-1),PS)
 title('Espectro de Potencia')
 axis([0 50 -10 100 ])
 Var_EstadisticasRuidoDeWavelets = caract(Ruido,Fs);
 
 figure(5)
 histogram(Ruido,100)
 
 % RUIDO A PARTIR DE SAVINTSKY
Res = 10; % Resolucion en frecuencia = 10 Hz
Npuntos = 2^nextpow2(Fs/2/Res);
w = hanning(Npuntos);
%% Grafica del espectro de potencia
s2filt=sgolayfilt(s2Norm,3,41);
[Pf,Ff]=pwelch(s2filt,w,Npuntos/2,Npuntos,Fs);
figure(6)
pwelch(s2Norm,w,Npuntos/2,Npuntos,Fs),
hold on,
title('Savitzky Potencia Espectral');
pwelch(s2filt,w,Npuntos/2,Npuntos,Fs),
legend('normal','filtrado')
figure(7)

title('SENAL NORMAL Y CON Savitzky ');
plot(t,s2Norm),hold on, plot(t,s2filt)
nueva=s2Norm-s2filt;
figure(3),

title('ruido savitzky');
plot(t,nueva);

figure(8)

title('Densidad espectral de ruido');
pwelch(nueva,w,Npuntos/2,Npuntos,Fs),
espectroruido=fft(nueva);
L=length(espectroruido);
P2 = abs(espectroruido/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;

figure(9)

title('fft ruido');
plot(f,P1)

figure(10)
histogram(nueva,100),grid on;
%helperFFT(Freq,X_mag,'Magnitude Response')
 figure(11)
 title('comparacion ruidos')
 plot(Ruido)
 hold on
 plot(nueva)
 legend('WAVELETS','SAVITZKY')
 Caract_savitzky=caract(nueva,125);
 
%figure(12)
%ppgArr=load('a103l.mat');
%ppgSignalArr = ppgArr.sig;