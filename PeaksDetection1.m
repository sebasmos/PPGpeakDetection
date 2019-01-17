%  SISTEMA DETECTOR DE PICOS
%% The first row is a simultaneous recording of ECG, which is recorded from the chest 
% of each subject. The second row and the third row are two channels of PPG, 
% which are recorded from the wrist of each subject. The last three rows are 
% simultaneous recordings of acceleration data (in x-, y-, and z-axis)
%% ACTIVIDADES TIPO 1
    figure(1)
    ppg=load('DATA_01_TYPE01.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(3,(1:2000));
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSI�N A VARIABLES F�SICAS
    s2 = (pfinal-128)/(255);
   % s2 = (ppgSignal(2,:)+81)/161;
    s3 = (ppgSignal(3,:)+41)/81;
% NORMALIZACI�N POR M�XIMOS Y M�NIMOS
    s2Norm = (s2-min(s2))/(max(s2)-min(s2));

    t = (0:length(ppgSignal)-1)/Fs;

    plot(s2Norm), grid on
     
% ENCONTRAR PICOS
  [PKS,LOCS]=findpeaks(s2Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15)
          
    axis([0 20 0.2 1 ])

 figure(2)
 findpeaks(s2Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15)
%  plot(s2Norm),grid on
  hold on
  plot(LOCS,PKS,'o')
% Example 3:
    %   Plot all peaks of a chirp signal whose widths are between .5 and 1 
    %   milliseconds.
%     Fs = 44.1e3; N = 1000;
%     x = sin(2*pi*(1:N)/N + (10*(1:N)/N).^2);
%     findpeaks(x,Fs,'MinPeakWidth',.5e-3,'MaxPeakWidth',1e-3, ...
%               'Annotate','extents')
%     p
 %% HeartRate Detection alg using ECG Signals
% La se�al cuenta con 3.7 e 4 
% uncomment for octave under windows
% 
% h = fir1(1000,1/1000*2,'high');
% %% filter out DC
% 
% 
% h = fir1(1000,1/125*2,'high');
% 
% % filter out DC
% %figure(1)
% y_filt=filter(h,1,s2Norm);
% %plot(y_filt);
% 
% % square it
% detsq = y_filt .^ 2;
% figure(2)
% plot(detsq),grid on
% % % thresholded output
%  detthres = zeros(length(detsq),1);
% % 
% % % let's detect the momentary heart rate in beats per min
%  last=0;
%  upflag=0;
%  pulse=zeros(length(detsq),1);
%  p=0;
%  
%  for i = 1:length(detsq)
%     if (detsq(i) > 0.1)
%         if (upflag == 0)
%             if (last > 0)
%                 t = i - last;
%                 p = 1000/t;
%             end
%             last = i;
%         end
%         upflag = 10;
%     else
%         if (upflag>0)
%             upflag = upflag - 1;
%         end
%     end
%     pulse(i)=p;
% end
% % 
% % % plot it
% figure(3)
% plot (pulse);
% aux2 = 1;
% for j=1:length(pulse)-1
%     if(pulse(j)~= pulse(j+1))
%         aux2 = aux2+1;
%     end
% end
% 