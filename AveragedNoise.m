
clear all
clc
%% RUIDO EN REPOSO PRIMEROS 30 SEGUNDOS
k=0;
sm0=0;
sm1=0;
sm2=0;
sm3=0;
sm4=0;
sm5=0;
Fs=125;
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    end
end

for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    else       
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    end
    % C�lculo de Media Muestral
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s1(k,:);
    sm2 = sm2 + s2(k,:);
    sm3 = sm3 + s3(k,:);
    sm4 = sm4 + s4(k,:);
    sm5 = sm5 + s5(k,:);

end

%% MEDIA MUESTRAL
%ORGANIZAMOS LOS RUIDOS EN UNA MATRIZ PARA LUEGO PODER SACAR LAS MEDIAS 
%MUESTRALES DIVIDIENDO TODA LA MATRIZ ENTRE EL NUMERO DE REALIZACIONES.

% M representa la suma de las 12 realizaciones para los 6 tipos diferentes
% de ruido; Por tanto tiene la forma de 6 filas de ruidos y cada uno con un
% tama�o seleccionado de 7500 muestras cada uno.

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;

% Al realizar un promedio vertical, la suma tambi�n es vertical, por tanto
% la media corresponde al promedio plano de cada una de las filas.
Media0 = M./Realizaciones;
% Reorganizamos las filas en una sola fila y le quitamos los ceros.
v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];
mediamuestral=nonzeros(v);
% De manera que media muestral tiene una se�al promedio de todas las
% se�ales unidas en una sola fila.
mediamuestral=mediamuestral';
h=hampel(mediamuestral,5,2); %Este sería nuestro ruido sin valores extremos
t=(0:length(h)-1)/Fs;
figure(1), plot(t,h),title('Total Averaged Noise'),xlabel('Time(s)'),ylabel('V'),axis tight,grid on
%% VARIANZA INSESGADA

% Se toman las 6 se�ales de 6 tipos diferentes de ruido y se sit�an en una
% sola fila.
V=[s s1 s2 s3 s4 s5];
varianzamuestral= var(V);

%% MATRIZ DE AUTOCORRELACION Y AUTOCOVARIANZA


% val=[];
% i=1;
% j=1;
% [a,b]=size(V);
% for t1=1:12
%     val(t1,:) = xcorr(V(t1,:));
% end
% mesh(val)

values=[];
i=1;
j=1;
[a,b]=size(V);
for t1=1:10:b
    for t2=1:10:b
        for k=1:12
            values(k)=V(k,t1).*V(k,t2);
        end
        Rxx(i,j)=mean(values);
        Kxx(i,j)=Rxx(i,j)-(h(t1).*h(t2));
        j=j+1;
        values=[];
    end
    i=i+1;
    j=1;
end

%% DENSIDAD ESPECTRAL DE POTENCIA

for i=1:length(Rxx)
    tf(i,:)=fft(Rxx(i,:));
end

tf=(abs(tf)).^2;
PSD=tf./2;
%% ANALISIS SECCIONAL
%Graficos
figure(1)
subplot(3,1,1)
plot(h),grid on,title('Ruido por mediamuestral')
subplot(3,1,2)
plot(varianzamuestral),grid on,title('Ruido por varianzamuestral')
subplot(3,1,3)

x = randn(1,1000);
[MX,MY] = Distribucion(h,varianzamuestral);

%  for i=1:100:length(mediamuestral)
%     y(i) = normpdf(x,MX,MY);
%  end
%plot(),grid on,title('Ruido mediamuestral')
figure(2)
%ANALISIS EN EL ESPECTRO DE FRECUENCIA
% 1.Espectro:
%%
Fs = 125;
 EspectroSenal = fft(mediamuestral);
 N = length(mediamuestral);
 X_mag = abs(EspectroSenal/N);
 X_mag2 = X_mag(1:N/2+1);
 X_mag2(2:end-1) = 2*X_mag2(2:end-1);
 Freq = Fs*(0:(N/2))/N;
 figure(3)
 plot(Freq,log(X_mag2))
 title('ESPECTRO DE FRECUENCIA DE LA SEÑAL ORIGINAL')
 grid on, axis tight

%% Grafica del espectro de potencia EMG

Npuntos = 2^nextpow2(length(mediamuestral));
[P,F] = pwelch(mediamuestral,ones(Npuntos/16,1),Npuntos/32,Npuntos,2,'power');
figure
semilogx(F,10*log10(P))
xlabel(['Frequency in ' 'Hz'])
ylabel('Power Spectrum (dB)')
grid on
axis tight
ax= axis;
axis([F(2) ax(2:4)])
