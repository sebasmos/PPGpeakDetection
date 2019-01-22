%  SISTEMA DETECTOR DE PICOS
%% The first row is a simultaneous recording of ECG, which is recorded from the chest 
% of each subject. The second row and the third row are two channels of PPG, 
% which are recorded from the wrist of each subject. The last three rows are 
% simultaneous recordings of acceleration data (in x-, y-, and z-axis)
%% ACTIVIDADES TIPO 1
    figure(1) 
    ppg=load('DATA_01_TYPE01.mat');
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
     
%% ENCONTRAR PICOS
% Se detectan picos con un ancho de mínimo 0.11 y máximo 0.5
% y con una altura mínimo de 0.15
  [PKS,LOCS]=findpeaks(s2Norm,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15)
          
 %axis([0 20 0.2 1 ])
%% Graficar los puntos picos usando los valores almacenados en PKS, LOCS
 figure(2)
 findpeaks(s2Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15)
% plot(s2Norm),grid on
  hold on
  plot(LOCS,PKS,'o')
   
%% Modelo pulso PPG

%% Función Gaussiana
Sigma = 0.4;
mu = 2.5;
AmplitudGaussiana = 0.12;
a = AmplitudGaussiana/sqrt(2*pi*Sigma.^2);
x = 0:1:20
g = ((x-mu)/Sigma).^2;
f = a*exp(-0.5*g);
 
y = gaussmf(x,[2 5]);

%% Función LogNormal
% Y = lognpdf(X,mu,sigma) returns values at X of the 
% lognormal pdf with distribution parameters mu and 
% sigma. mu and sigma are the mean and standard deviation,
% respectively, of the associated normal distribution
sigma2 = 1;
mu2 = 0.7;
x2 = 0:1:20;
% a1 = x1.*sqrt(2*pi*c1.^2);
% g1 = log(((x1-b1)/2*c1).^2);2% f1 = a1*exp(-0.5*g1);
% plot(f1)
% Amplitud LogNormal
 AmplLogNormal = 1.23;
 y2 = AmplLogNormal.*lognpdf(x2,mu2,sigma2);
 
 hold on
 PPGSignal1 = y2+f;
 plot(PPGSignal1), grid on
  
 %% HeartRate Detection alg using ECG Signals
% La señal cuenta con 3.7 e 4 
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