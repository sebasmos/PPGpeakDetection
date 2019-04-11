
clc
clear all
close all
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
% Get and save signals in 'Realizaciones'
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    end
end

% Sample Frequency
    Fs = 125;
% Convert to physical values: According to timesheet of the used wearable
    s2 = (Realizaciones-128)/(255);
% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
end
    
%% Separate Activities
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end)); 

% An�lisis para DATA_01_TYPE02.mat actividad1 rest 30s
    t = (0:length(Activity1(1,:))-1);
    figure(1) 
    plot(t,Activity1(1,:),'r')
s2Norm = Activity1(1,:);  
 
%% RUIDO A PARTIR DE WAVELETS 
%CREACION DE LA WAVELET
wname  = 'sym4';               % Wavelet for analysis.
level  = 5;                    % Level for wavelet decomposition.
sorh   = 's';                  % Type of thresholding.
nb_Int = 3;                    % Number of intervals for thresholding.

%FILTRADO CON WAVELET
[sigden,coefs,thrParams,int_DepThr_Cell,BestNbOfInt] = ...
            cmddenoise(s2Norm,wname,level,sorh,nb_Int); 
 
%ANALISIS GRAFICO
 hold on,   
 plot(sigden,'k','linewidth',2)
 axis tight
 title('Señales con y sin ruido')
 legend('Original Signal','Denoised Signal','Location','NorthWest');
 
 %OBTENCION DEL RUIDO A PARTIR DE WAVELETS
 figure(2)
 Ruido = s2Norm - sigden;
 plot(Ruido)
 title('RUIDO A PARTIR DE WAVELETS')
 axis tight
 
%ANALISIS EN EL ESPECTRO DE FRECUENCIA
% 1.Espectro:
 EspectroSenal = fft(s2Norm);
 N = length(s2Norm);
 X_mag = abs(EspectroSenal/N);
 X_mag2 = X_mag(1:N/2+1);
 X_mag2(2:end-1) = 2*X_mag2(2:end-1);
 Freq = Fs*(0:(N/2))/N;
 figure(3)
 plot(Freq,X_mag2)
 title('ESPECTRO DE FRECUENCIA DE LA SEÑAL ORIGINAL')
 grid on, axis tight

% 2.Comparación:
[~,~,f,dP] = centerfreq(Fs,s2Norm); %SEÑAL NORMAL
[PS,NN] = PowSpecs(s2Norm);
[~,~,f2,dP2] = centerfreq(Fs,sigden); %SEÑAL FILTRADA
[PS2,NN2] = PowSpecs(sigden);
figure(4)
plot(f,dP); 
hold on 
plot(f2,dP2)
legend('Senal con ruido','Senal sin ruido')
title('ESPECTRO CON Y SIN RUIDO total en reposo, primeros 30 segundos');
grid on, axis([0 50 -10 100 ])
 
%% RUIDO A PARTIR DE SAVITZKY
%CREACIÓN DEL FILTRO SAVITZKY Y FILTRADO.
s2filt=sgolayfilt(s2Norm,3,41); 

%OBTENCION DEL RUIDO A PARTIR DE SAVIZTKY:
nueva=s2Norm-s2filt; 

%ANALISIS EN EL TIEMPO (Comparación)
figure(6)
plot(t,s2Norm),hold on, plot(t,s2filt)
title('Señal normal y con Savitzky');

%ANALISIS GRAFICO DEL RUIDO
figure(7)
subplot(2,1,1)
plot(t,nueva);
title('RUIDO POR SAVITZKY')

%ANALISIS EN EL ESPECTRO DE FRECUENCIA
% 1.Potencia espectral: (comparación)
Res = 10; 
Npuntos = 2^nextpow2(Fs/2/Res);
w = hanning(Npuntos);
[Pf,Ff]=pwelch(s2filt,w,Npuntos/2,Npuntos,Fs); 
figure(8)
pwelch(s2Norm,w,Npuntos/2,Npuntos,Fs),
hold on,
title('Potencia espectral de la señal filtrada con S.Golay');
pwelch(s2filt,w,Npuntos/2,Npuntos,Fs),
legend('normal','filtrado')

% 2.Densidad espectral (ruido):
figure(9) 
title('Densidad espectral de ruido Savitzky');
pwelch(nueva,w,Npuntos/2,Npuntos,Fs),

% 3. Espectro del ruido:
espectroruido=fft(nueva);
L=length(espectroruido);
P2 = abs(espectroruido/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure(10)
plot(f,P1)
title('Espectro (transf.de Fourier) del ruido Savitzky');

%% COMPARACIÓN ENTRE LOS DOS RUIDOS:
%En frecuencia:
figure(11)
subplot(2,1,2)
[~,~,f3,dP3] = centerfreq(Fs,nueva);
[~,~,f4,dP4] = centerfreq(Fs,Ruido);
hold on
plot(f3,dP3)
hold on
plot(f4,dP4)
title('POTENCIA ESPECTRAL: RUIDO SAVITZKY VS RUIDO WAVELETS')
legend('Savitzky','Wavelet')

%En tiempo:
figure(12)
plot(Ruido)
title('COMPARACION DE RUIDOS EN EL TIEMPO')
hold on
plot(nueva)
legend('WAVELETS','SAVITZKY')

%% CREACIÓN DEL RUIDO DEFINITIVO
% Ahora que se ha decidido que se utilizará el ruido S.G para generar los
% ruidos de cada pedazo de la señal, necesitamos hacer el siguiente
% procedimiento.
% Tomamos la resta obtenida a partir de la resta de la señal original con 
% el la señal filtrada a partir del filtro Savitzky-Golay. Ahora, en el
% siguiente paso vamos a hacer una estimación de los cambios en el valor
% medio de la señal, pues no todos los artefactos de ruido han sido
% generados a partir del filtrado y posterior resta. Para esto hacemos la
% función que nos permite detectar grandes cambios en el nivel de dc o
% media de la señal, generando una funcion escalonada dependiente de estos
% cambios, como se puede apreciar a continuación.

vmedias=ValoresMedia(s2Norm);
figure(13)
plot(vmedias,'r'), title('Cambio de nivel de DC a lo largo de la señal')
grid on

%El ruido final, adaptado a los cambios de DC sería el siguiente:

RuidoSav=nueva+vmedias;

figure(14)
plot(RuidoSav,'b'),hold on, plot(vmedias,'r--'),grid on, title('Ruido final')
legend('Ruido SavitzkyGolay','Nivel de DC')

%% Comparacion savitzky

act1 = mediamuestral(3751:11250);
sfilt=sgolayfilt(act1 ,70,1001);
% X must be a vector with length greater or equal to the prediction order.
%If X is a matrix, the length of each column must be greater or equal to
%the prediction order.
%%%% NO BORRAR COMENTARIOS PLEASE
%% Para que LPC siga mejor la se�al, debe ser peque�o, de lo contrario para
% calcular un estimativo general, debe ser similar al tama�o total de �a
% se�al
close all
LinearPredictor = lpc(act1,7000);
LP = filter([0 -LinearPredictor(2:end)],1,act1);
% M�todo de verificaci�n para determinar ventaneo es el sgte:
% close all
% t = linspace(-0.1,0.1,3750);
%  x = 0.005*rand(size(t));
% y = filter(b,a,x);
%  figure
% plot(act1+x)
% hold on
% plot(act1)
% windowsize para actividades en reposo debe ser 40
windowsize = 30;
b = 1/windowsize*ones(1,windowsize);
y = filter(b,1,act1)
% Al graficar las 3 formas nos damos cuenta que el m�todo de medias m�viles 
% representa mejor la se�al
plot(y,'r'),hold on
plot(act1,'b'),hold on
plot(sfilt,'g'),hold on
plot(LP,'y'),hold on
%legend('act1','lp')
 legend('Medias moviles','Senal original rest 30s','savitzky','Linear Predictor')