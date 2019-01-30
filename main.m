%% ACTIVIDADES TIPO 1
    figure(1) 
    ppg=load('DATA_01_TYPE01.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(3,(1:3050));
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSI�N A VARIABLES F�SICAS
    s2 = (pfinal-128)/(255);
   % s2 = (ppgSignal(2,:)+81)/161;
    s3 = (ppgSignal(3,:)+41)/81;
% NORMALIZACI�N POR M�XIMOS Y M�NIMOS
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
 title('Se�ales con y sin ruido')
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
 title('ESPECTRO DE FRECUENCIA DE LA SE�AL ORIGINAL')
 axis([0 10 -200 200 ])

%% An�lisis de los espectros
[~,~,f,dP] = centerfreq(Fs,pfinal);
[PS,NN] = PowSpecs(pfinal);
[~,~,f2,dP2] = centerfreq(Fs,sigden);
[PS2,NN2] = PowSpecs(sigden);
figure(4)
plot(f,dP);
hold on 
plot(f2,dP2)
legend('Senal con ruido','Senal sin ruido')
title('Espectro de la se�al CON Y SIN RUIDO total en reposo, primeros 30 segundos');
 %plot(Fs/2*linspace(0,1,NN-1),PS)
 axis([0 50 -10 100 ])
 Var_EstadisticasRuidoDeWavelets = caract(Ruido,Fs);
 
 figure(5)
 histogram(Ruido,100)
 title('Histograma del ruido creado por wavelets') 
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
plot(t,s2Norm),hold on, plot(t,s2filt)
title('SENAL NORMAL Y CON Savitzky ');
nueva=s2Norm-s2filt;

figure(8)

subplot(2,1,1)
plot(t,nueva);
title('RUIDO POR SAVITZKY')

subplot(2,1,2)
[~,~,f3,dP3] = centerfreq(Fs,nueva);
[~,~,f4,dP4] = centerfreq(Fs,Ruido);
hold on
plot(f3,dP3)
title('ESPECTRO: RUIDO SAVITZKY VS RUIDO WAVELETS ')
hold on
plot(f4,dP4)
legend('Savitzky Noise','Wavelet Noise')

figure(9) 
title('Densidad espectral de ruido POR PWELCH SAVITZKY');
pwelch(nueva,w,Npuntos/2,Npuntos,Fs),
espectroruido=fft(nueva);
L=length(espectroruido);
P2 = abs(espectroruido/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;

figure(10)
plot(f,P1)
title('fft ruido Savitzky');

figure(11)
histogram(nueva,100),grid on;
title('HISTOGRAMA RUIDO SAVITZKY')
%helperFFT(Freq,X_mag,'Magnitude Response')

 figure(12)
 plot(Ruido)
 title('COMPARACION DE RUIDOS EN EL TIEMPO')
 hold on
 plot(nueva)
 legend('WAVELETS','SAVITZKY')
 Caract_savitzky=caract(nueva,125);
 
figure(13)
subplot(2,1,1)
plot(nueva+mean(s2Norm),'k')
title('FINAL SAVITZKY NOISE')
subplot(2,1,2)
plot(Ruido+mean(s2Norm))
title('FINAL WAVELET NOISE')
%ppgArr=load('a103l.mat');
%ppgSignalArr = ppgArr.sig;

figure(14)
    ppg2=load('DATA_02_TYPE02.mat');
    ppgSignal2 = ppg2.sig;
    pfinal2 = ppgSignal2(3,(3000:18050));
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSI�N A VARIABLES F�SICAS
    s22 = (pfinal2-128)/(255);
   % s2 = (ppgSignal(2,:)+81)/161;
    s33 = (ppgSignal2(3,:)+41)/81;
% NORMALIZACI�N POR M�XIMOS Y M�NIMOS
    s2Norm2 = (s22-min(s22))/(max(s22)-min(s22));
%     S2WithWaveletNoise = s2Norm2 + Ruido+mean(s2Norm);
%     S2WithSavitzkyNoise= s2Norm2 + nueva+mean(s2Norm);
%     subplot(2,1,1)
%     plot(S2WithWaveletNoise)
%     title('SE�AL CON RUIDO ARTIFICIAL WAVELET ADICIONADO ACTIVIDAD TIPO 2')
%     subplot(2,1,2)
%     hold on
%     plot(S2WithSavitzkyNoise)
%     title('SE�AL CON RUIDO ARTIFICIAL SAVITZKY ADICIONADO ACTIVIDAD TIPO 2')

% CREACI�N DEL RUIDO 
% Tomamos la resta obtenida a partir de la resta de la se�al original con 
% el la se�al filtrada a partir del filtro Savitzky-Golay. Ahora en el
% siguiente paso vamos a crear una se�al promedio de este ruido obtenido,
% de manera que podamos modelar de manera general, su distribuci�n,
% utilizando la media de la distribuci�n, la desviaci�n est�ndar etc.. Y
% finalmente buscamos a�adir un nivel de dc a trav�s de una envolvente de
% la se�al, que se componga de la suma de se�ales sinoidales, como el sin y
% el cos, de manera que podamos generar una wanderer baseline de manera
% artificial que modele el nivel de ruido de DC.
subplot(3,1,1)
plot(s2Norm), grid on
title('SE�AL ORIGINAL, 30 SEGUNDOS DE REPOSO')
t = linspace(0,10,3050);
f = 0.2;
amplitudEnvolvente = 0.009;
 SEnvolvente = amplitudEnvolvente * (sin(2*pi*t*f)+cos(2*pi*t*f))+nueva;
 subplot(3,1,2)
 plot(SEnvolvente+mean(s2Norm))
 title('RUIDO CON ENVOLVENTE SINUSAL+NIVEL DC + RUIDO SAVITZKY')
 
 %aux = zeros(1,3050);
 s1 = nueva(1:300);
 s2 = nueva(301:600);
 s3 = nueva(601:900); 
 s4 = nueva(901:1200); 
 s5 = nueva(1201:1500); 
 s6 = nueva(1501:1800); 
 s7 = nueva(1801:2100); 
 s8 = nueva(2101:2400); 
 s9 = nueva(2401:2700); 
 s10 = nueva(2701:3000); 

 p = (s1+s2+s3+s4+s5+s6+s7+s8+s9+s10)./length(nueva);
 PT = [p p p p p p p p p p];
%  n = 10; % Numero de ventanas
%  j = 1;
%  for  i = 1:n % n ventanas para promediar muestras n veces
%      aux(1,i)=aux(1,i)+nueva(j:length(nueva).*i./10);
%      j = j+length(nueva)./10;
%  end
 subplot(3,1,3)
 plot(PT) 


 %SavitzkyMean = mean(nueva);
 %d = ones(1,length(nueva)).*SavitzkyMean;
 %subplot(3,1,3)
 %plot(d)
 title('RUIDO PROMEDIO DE SAVITZKY')
%     figure(15)
%     
%      p = fit(s2Norm)
%      plot(p)