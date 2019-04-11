
clear all
clc
%% ACTIVIDADES TIPO 1
    figure(1) 
    ppg=load('DATA_01_TYPE02.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(3,(1:3050));
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
 title('ESPECTRO DE FRECUENCIA DE LA SEÑAL ORIGINAL')
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
% CONVERSIÓN A VARIABLES FÍSICAS
    s22 = (pfinal2-128)/(255);
   % s2 = (ppgSignal(2,:)+81)/161;
    s33 = (ppgSignal2(3,:)+41)/81;
% NORMALIZACIÓN POR MÁXIMOS Y MÍNIMOS
    s2Norm2 = (s22-min(s22))/(max(s22)-min(s22));
%     S2WithWaveletNoise = s2Norm2 + Ruido+mean(s2Norm);
%     S2WithSavitzkyNoise= s2Norm2 + nueva+mean(s2Norm);
%     subplot(2,1,1)
%     plot(S2WithWaveletNoise)
%     title('SEÑAL CON RUIDO ARTIFICIAL WAVELET ADICIONADO ACTIVIDAD TIPO 2')
%     subplot(2,1,2)
%     hold on
%     plot(S2WithSavitzkyNoise)
%     title('SEÑAL CON RUIDO ARTIFICIAL SAVITZKY ADICIONADO ACTIVIDAD TIPO 2')

% CREACIÓN DEL RUIDO 
% Tomamos la resta obtenida a partir de la resta de la señal original con 
% el la señal filtrada a partir del filtro Savitzky-Golay. Ahora en el
% siguiente paso vamos a crear una señal promedio de este ruido obtenido,
% de manera que podamos modelar de manera general, su distribución,
% utilizando la media de la distribución, la desviación estándar etc.. Y
% finalmente buscamos añadir un nivel de dc a través de una envolvente de
% la señal, que se componga de la suma de señales sinoidales, como el sin y
% el cos, de manera que podamos generar una wanderer baseline de manera
% artificial que modele el nivel de ruido de DC.
subplot(3,1,1)
plot(s2Norm), grid on
title('SEÑAL ORIGINAL, 30 SEGUNDOS DE REPOSO')
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

 p = (s1+s2+s3+s4+s5+s6+s7+s8+s9+s10)./10;
 PT = [p p p p p p p p p p];

%  
  n = 10; % Numero de ventanas
  j = 1;
  i=1;
  aux = zeros(1,length(Ruido)./10);
  aux2 = 0;
  sum = 0;
  for  i = 1:n % n ventanas para promediar muestras n veces
      aux(i,:)=Ruido(1,(1:length(Ruido)./n));
      aux2 = length(Ruido)./n + 1 ;
      j = aux2;      
      sum = aux(i,:) + sum;
  end
MeanSignal = sum/n;
  PT2 = [MeanSignal MeanSignal MeanSignal MeanSignal MeanSignal MeanSignal MeanSignal MeanSignal MeanSignal MeanSignal MeanSignal] 
 subplot(3,1,3)
 plot(PT2) 

 %SavitzkyMean = mean(nueva);
 %d = ones(1,length(nueva)).*SavitzkyMean;
 %subplot(3,1,3)
 %plot(d)
 title('RUIDO PROMEDIO DE SAVITZKY')
%     figure(15)
%     
%      p = fit(s2Norm)
%      plot(p)
=======
clc
clear all

%% CONVERSION A VARIABLES Fï¿½SICAS: (Signal-base)/Gain



ppg=load('DATA_01_TYPE01.mat');
ppgSignal = ppg.sig;
pfinal = ppgSignal(2,(1:5000));
pfinal2= ppgSignal(3,(1:5000));
%Frecuencia de Muestreo
Fs = 125;
vmax = 0.6392;
vmin = -4.5176;
s1 = (pfinal-128)/255;
s1Norm = (s1-vmin)/(vmax-vmin);
s2 = (pfinal2-128)/255;
%s2 = (ppgSignal(2,:)+81)/161;
%s3 = (ppgSignal(3,:)+41)/81;

t = (0:length(pfinal)-1)/Fs;
figure(1)
plot(s1Norm), grid on
%axis([0 100000 -0.1 1 ])
%% HeartRate Detection alg using ECG Signals
% La seï¿½al cuenta con 3.7 e 4 
% uncomment for octave under windows


h = fir1(1000,1/1000*2,'high');
%% filter out DC


h = fir1(1000,1/125*2,'high');

% filter out DC
figure(2)
y_filt=filter(h,1,s1Norm);
plot(y_filt);

% square it
detsq = y_filt .^ 2;
figure(3)
plot(detsq),grid on
% % thresholded output
 detthres = zeros(length(detsq),1);
% 
% % let's detect the momentary heart rate in beats per min
 last=0;
 upflag=0;
 pulse=zeros(length(detsq),1);
 p=0;
 
 for i = 1:length(detsq)
    if (detsq(i) > 0.06)
        if (upflag == 0)
            if (last > 0)
                t = i - last;
                p = 1000/t;
            end
            last = i;
        end
        upflag = 10;
    else
        if (upflag>0)
            upflag = upflag - 1;
        end
    end
    pulse(i)=p;
end
% 
% % plot it
figure(2)
plot (pulse);
aux = 1;
for j=1:length(pulse)-1
    if(pulse(j)~= pulse(j+1))
        aux = aux+1;
    end
end

%% TIPO 2 ACTIVIDADES M[AS INTENSAS
figure(3)

ppg=load('DATA_02_TYPE02.mat');
ppgSignal = ppg.sig;
pfinal = ppgSignal(5000:10000)
%Frecuencia de Muestreo
s2 = (pfinal(1,:)-128)/255;
s2Norm = (s2-vmin)/(vmax-vmin);
%s2 = (ppgSignal(2,:)+81)/161;
%s3 = (ppgSignal(3,:)+41)/81;

t = (0:length(ppgSignal)-1)/Fs;
plot(s2Norm), grid on
axis([0 100000 -0.1 1 ])
%% HeartRate Detection alg using ECG Signals
% La seï¿½al cuenta con 3.7 e 4 
% uncomment for octave under windows

h = fir1(1000,100/1000*2,'high');
%% filter out DC


h = fir1(1000,1/125*2,'high');

% filter out DC
figure(4)
y_filt=filter(h,1,s2Norm);
plot(y_filt);

% square it
detsq = y_filt .^ 2;
figure(5)
plot(detsq),grid on
% % thresholded output
 detthres = zeros(length(detsq),1);
% 
% % let's detect the momentary heart rate in beats per min
 last=0;
 upflag=0;
 pulse=zeros(length(detsq),1);
 p=0;
 
 for i = 1:length(detsq)
    if (detsq(i) > 0.1)
        if (upflag == 0)
            if (last > 0)
                t = i - last;
                p = 1000/t;
            end
            last = i;
        end
        upflag = 10;
    else
        if (upflag>0)
            upflag = upflag - 1;
        end
    end
    pulse(i)=p;
end
% 
% % plot it
figure(6)
plot (pulse);
aux2 = 1;
for j=1:length(pulse)-1
    if(pulse(j)~= pulse(j+1))
        aux2 = aux2+1;
    end
end
