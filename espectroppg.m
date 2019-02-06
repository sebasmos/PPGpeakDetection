    ppg=load('DATA_01_TYPE01.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(2,(1:3750)); %Señal en REPOSO
    pfinal2 = ppgSignal(2,(3750:11250));%Señal CAMINANDO A 8km/h
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSIÓN A VARIABLES FÍSICAS
    s2 = (pfinal-128)/(255);
    s22=(pfinal2-128)/255;
   % s2 = (ppgSignal(2,:)+81)/161;
   % s3 = (ppgSignal(3,:)+41)/81;
% NORMALIZACIÓN POR MÁXIMOS Y MÍNIMOS
    s2Norm = (s2-min(s2))/(max(s2)-min(s2));
    s22Norm= (s22-min(s22))/(max(s22)-min(s22));
    t = (0:length(pfinal)-1);
% Resoluci�n deseada: 10 Hz
Res = 10; % Resolucion en frecuencia = 10 Hz
Npuntos = 2^nextpow2(Fs/2/Res);
w = hanning(Npuntos);
[P,F] = pwelch(s2Norm,w,Npuntos/2,Npuntos,Fs);
%% Grafica del espectro de potencia 
% %hold on
% %semilogx(F2*E1,Y2,'vr')
% xlabel(['Frequency in ' 'Hz'])
% ylabel('Power Spectrum ')
% grid on
% axis tight

s2filt=sgolayfilt(s2Norm,3,41);
[Pf,Ff]=pwelch(s2filt,w,Npuntos/2,Npuntos,Fs);

figure(1)
pwelch(s2Norm,w,Npuntos/2,Npuntos,Fs),
hold on,
pwelch(s2filt,w,Npuntos/2,Npuntos,Fs),
legend('normal','filtrado')
title('comparacion de potencia normal (arriba) y filtrado (abajo) ')

figure(2)
plot(t,s2Norm),hold on, plot(t,s2filt)
title('señal normal y filtrada con savitsky golay')

nueva=s2Norm-s2filt;
figure(3),plot(t,nueva);
title('ruido obtenido con Savitzky Golay')

figure(4)
pwelch(nueva,w,Npuntos/2,Npuntos,Fs),
title('potencia espectral del ruido')

espectroruido=fft(s2Norm);
L=length(espectroruido);
P2 = abs(espectroruido/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure(5)
plot(f,P1)
title('espectro unilateral en amplitud del ruido por savitzky golay')


