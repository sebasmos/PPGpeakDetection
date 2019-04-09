%% ANALISIS DE ESPECTRO PARA EL APENDICE A
clc
close all
%% Add Datasets
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
%% LOAD DATASETS
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
%% CONVERSIÓN A VARIABLES FISICAS
	%Sample Frequency
    Fs=125;
    %Convert to physical values: According to timesheet of the used wearable
    s2 = (PPGdatasetSignals-128)/(255);
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
t30s=(0:length(Activity1)-1)/Fs;
t60s=(0:length(Activity2)-1)/Fs;
tend=(0:length(Activity6)-1)/Fs;

%% Transformada de Fourier de toda la señal PPG

% for i=1:12
%     Y(i,:)=fft(sNorm(i,:));
% end
% %Dominio de la frecuencia para la gráfica
% ftotal = Fs*(0:(length(sNorm)/2))/length(sNorm);
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

%% Transformada de Fourier para cada una de las actividades en una realización
% Realization=3;
% Y1=fft(Activity1(Realization,:));
% Y2=fft(Activity2(Realization,:));
% Y3=fft(Activity3(Realization,:));
% Y4=fft(Activity4(Realization,:));
% Y5=fft(Activity5(Realization,:));
% Y6=fft(Activity6(Realization,:));
% 
% %Dominio de la frecuencia para la gráfica
% f30s = Fs*(0:(length(Activity1)/2))/length(Activity1);
% f1min= Fs*(0:(length(Activity2)/2))/length(Activity2);
% fend= Fs*(0:length(Activity6)/2)/length(Activity6);
% 
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

%% Transformada de Fourier para la realizacion entera (R=1)
Realization=1;
YRealization1=fft(sNorm(Realization,:));
%Dominio de la frecuencia para la gráfica
P1=abs(YRealization1/length(sNorm));
EspectroRealizacion1=P1(1:length(sNorm)/2+1);
EspectroRealizacion1(2:end-1) = 2*EspectroRealizacion1(2:end-1);
figure(3), plot(ftotal,EspectroRealizacion1),grid on, xlabel('Frequency(Hz)'),axis([0 8 0 0.01]), title('Frequency spectrum of realization 1'),hold on
%Filtramos el ruido de altas frecuencias de la realización
RealizacionFiltrada=sgolayfilt(sNorm(Realization,:),3,41);
%Transformada de Fourier para la señal filtrada
P1=abs(RealizacionFiltrada/length(sNorm));
EspectroRealizacion1Filtrado=P1(1:length(sNorm)/2+1);
EspectroRealizacion1Filtrado(2:end-1) = 2*EspectroRealizacion1Filtrado(2:end-1);
plot(ftotal,EspectroRealizacion1Filtrado),legend('Realización 1 sin filtrar','Realización 1 filtrada con Saviztky-Golay')
%% Transformada de Fourier de las actividades tipo 1

for i=1:12
    Y(i,:)=fft(Activity1(i,:));
end
%Dominio de la frecuencia para la gráfica
f30s = Fs*(0:(length(Activity1)/2))/length(Activity1);

P1=abs(Y/length(Activity1));
EspectroActividad1=P1(:,(1:length(Activity1)/2+1));
EspectroActividad1(:,2:end-1) = 2*EspectroActividad1(:,2:end-1);

figure(2),
plot(f30s,EspectroActividad1(1,:)),hold on,
plot(f30s,EspectroActividad1(2,:)),hold on,
plot(f30s,EspectroActividad1(3,:)),hold on,
plot(f30s,EspectroActividad1(4,:)),hold on,
plot(f30s,EspectroActividad1(5,:)),hold on,
plot(f30s,EspectroActividad1(6,:)),hold on,
plot(f30s,EspectroActividad1(7,:)),hold on,
plot(f30s,EspectroActividad1(8,:)),hold on,
plot(f30s,EspectroActividad1(9,:)),hold on,
plot(f30s,EspectroActividad1(10,:)),hold on,
plot(f30s,EspectroActividad1(11,:)),hold on,
plot(f30s,EspectroActividad1(12,:)),hold on,grid on, axis ([0 8 0 0.1]),xlabel('Frequency (Hz)')
%% GRAFICA DE LA DENSIDAD ESPECTRAL DE POTENCIA

Res = 20; % Resolucion en frecuencia = 10 Hz
Npuntos = 2^nextpow2(Fs/2/Res);
w = hanning(Npuntos);
[P,F] = pwelch(sNorm',w,Npuntos/2,Npuntos,Fs);
figure(3)
pwelch(sNorm',w,Npuntos/2,Npuntos,Fs)
% %hold on
% %semilogx(F2*E1,Y2,'vr')
% xlabel(['Frequency in ' 'Hz'])
% ylabel('Power Spectrum ')
% grid on
% axis tight
%%
s2filt=sgolayfilt(sNorm,3,41);
[Pf,Ff]=pwelch(s2filt,w,Npuntos/2,Npuntos,Fs);


hold on,
pwelch(s2filt,w,Npuntos/2,Npuntos,Fs),
legend('normal','filtrado')
title('comparacion de potencia normal y filtrado up/down ')
%%
% figure(2)
% plot(t,sNorm),hold on, plot(t,s2filt)
% title('señal normal y filtrada con savitsky golay')
% 
% nueva=sNorm-s2filt;
% figure(3),plot(t,nueva);
% title('ruido obtenido con Savitzky Golay')
% 
% figure(4)
% pwelch(nueva,w,Npuntos/2,Npuntos,Fs),
% title('potencia espectral del ruido')
% 
% espectroruido=fft(sNorm-s2filt);
% L=length(espectroruido);
% P2 = abs(espectroruido/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% 
% figure(5)
% plot(f,P1)
% title('Espectro se�al')
