%  SISTEMA DETECTOR DE PICOS
%% The first row is a simultaneous recording of ECG, which is recorded from the chest 
% of each subject. The second row and the third row are two channels of PPG, 
% which are recorded from the wrist of each subject. The last three rows are 
% simultaneous recordings of acceleration data (in x-, y-, and z-axis)
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

    t = (0:length(pfinal)-1);

    plot(t,s2Norm), grid on
    hold on
 %% ENCONTRAR PICOS
% Se detectan picos con un ancho de mínimo 0.11 y máximo 0.5
% y con una altura mínimo de 0.15
  [PKS,LOCS]=findpeaks(s2Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15);
          
 %axis([0 20 0.2 1 ])
%% Graficar los puntos picos usando los valores almacenados en PKS, LOCS
 figure(2)
 findpeaks(s2Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15)
% plot(s2Norm),grid on
  hold on
  plot(LOCS,PKS,'o')   
  xlabel('Tiempo');
  ylabel('Señal PPG');
   
%% Señal PPG artificial centrada en picos

 PPG1 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,7.5);
 hold on 
 PPG2 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,17);
 hold on 
 PPG3 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,22);
 hold on 
 PPG4 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,26);
 hold on 
 PPG5 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,38);
 hold on 
 PPG6 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,59);
 hold on 
 PPG7 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,69);
 hold on 
 PPG8 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,78);
 hold on 
 PPG9 = ppgSignalModel(2,0.7,2.5,0.4,1,1.23,0.12,0,200,88);
 hold on 
 PPG10 = ppgSignalModel(2,0.7,2.5,0.4,1,1.23,0.12,0,200,98);
 hold on 
 PPG11 = ppgSignalModel(1.5,0.7,2.5,0.4,1,1.23,0.12,0,200,108);
 hold on 
 PPG12 = ppgSignalModel(1,0.7,2.5,0.4,1,1.23,0.12,0,200,117);
 hold on 
 PPG13 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,200,127);
 hold on 
 PPG14 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,200,136);
 hold on 
 PPG15 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,200,147);
 hold on 
 PPG16 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,200,157);
 hold on 
 PPG17 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,200,169);
 hold on 
 PPG18 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,200,179);
 hold on 
 PPG19 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,200,190);
 hold on 
 PPG20 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,200);
 hold on 
 PPG21 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,210);
 hold on 
 PPG22 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,220);
 hold on 
 PPG23 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,210);
 hold on 
 PPG24 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,220);
 hold on 
 PPG25 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,230);
 hold on 
 PPG26 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,240);
 hold on 
 PPG27 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,250);
 hold on 
 PPG28 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,260);
 hold on 
 PPG29 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,272);
 hold on 
 PPG30 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,282);
 hold on 
 PPG31 = ppgSignalModel(1.2,0.7,2.5,0.4,1,1.23,0.12,0,300,300);
 
 % Resta señal PPG pura con Señal con ruido
 f1 = s2Norm - [PPG1 zeros(1,length(s2Norm)-length(PPG1))]  - [PPG2 zeros(1,length(s2Norm)-length(PPG1))] - [PPG3 zeros(1,length(s2Norm)-length(PPG1))] - [PPG4 zeros(1,length(s2Norm)-length(PPG1))]-  [PPG5 zeros(1,length(s2Norm)-length(PPG1))] - [PPG6 zeros(1,length(s2Norm)-length(PPG1))] - [PPG7 zeros(1,length(s2Norm)-length(PPG1))] - [PPG8 zeros(1,length(s2Norm)-length(PPG1))]-  [PPG9 zeros(1,length(s2Norm)-length(PPG1))]- [PPG10 zeros(1,length(s2Norm)-length(PPG1))]-  [PPG11 zeros(1,length(s2Norm)-length(PPG1))]-  [PPG12 zeros(1,length(s2Norm)-length(PPG1))]- [PPG13 zeros(1,length(s2Norm)-length(PPG1))]- [PPG14 zeros(1,length(s2Norm)-length(PPG1))]- [PPG15 zeros(1,length(s2Norm)-length(PPG1))]- [PPG16 zeros(1,length(s2Norm)-length(PPG1))]- [PPG17 zeros(1,length(s2Norm)-length(PPG1))]- [PPG18 zeros(1,length(s2Norm)-length(PPG1))]-  [PPG19 zeros(1,length(s2Norm)-length(PPG1))]-[PPG20 zeros(1,length(s2Norm)-length(PPG20))]-  [PPG21 zeros(1,length(s2Norm)-length(PPG20))] - [PPG22 zeros(1,length(s2Norm)-length(PPG20))]- [PPG23 zeros(1,length(s2Norm)-length(PPG20))]- [PPG24 zeros(1,length(s2Norm)-length(PPG20))]- [PPG25 zeros(1,length(s2Norm)-length(PPG20))]- [PPG26 zeros(1,length(s2Norm)-length(PPG20))]- [PPG27 zeros(1,length(s2Norm)-length(PPG20))]- [PPG28 zeros(1,length(s2Norm)-length(PPG20))] - [PPG29 zeros(1,length(s2Norm)-length(PPG20))] - [PPG29 zeros(1,length(s2Norm)-length(PPG20))] - [PPG30 zeros(1,length(s2Norm)-length(PPG20))];
     
 %% Graficar señal de ruido
 figure(3)
 findpeaks(f1,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15)
% plot(s2Norm),grid on
  hold on
  plot(LOCS,PKS,'o')
  xlabel('Tiempo');
  ylabel('Señal PPG');