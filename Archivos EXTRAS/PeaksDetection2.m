%  SISTEMA DETECTOR DE PICOS
%% The first row is a simultaneous recording of ECG, which is recorded from the chest 
% of each subject. The second row and the third row are two channels of PPG, 
% which are recorded from the wrist of each subject. The last three rows are 
% simultaneous recordings of acceleration data (in x-, y-, and z-axis)
%% ACTIVIDADES TIPO 1
    ppg=load('DATA_01_TYPE01.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(2,(1:3793));
    pfinal2 = ppgSignal(2,(3793:11379));
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSI√ìN A VARIABLES F√?SICAS
    s2 = (pfinal-128)/(255);
    s22=(pfinal2-128)/255;
   % s2 = (ppgSignal(2,:)+81)/161;
    s3 = (ppgSignal(3,:)+41)/81;
% NORMALIZACI√ìN POR M√?XIMOS Y M√?NIMOS
    s2Norm = (s2-min(s2))/(max(s2)-min(s2));
    s22Norm= (s22-min(s22))/(max(s22)-min(s22));
    t = (0:length(pfinal)-1);
    t2=(0:length(pfinal2)-1);
    figure(1)
    subplot(2,1,1),plot(t,s2Norm), grid on,xlabel('muestras')
    subplot(2,1,2),plot(t2,s22Norm),grid on,xlabel('muestras')
    
% ENCONTRAR PICOS
  [PKS,LOCS]=findpeaks(s2Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents',...
              'MinPeakProminence',0.15);
  [PKS2,LOCS2]= findpeaks(s22Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.25,...
              'MinPeakDistance', 0.7723);
          
    

 figure(2)
 findpeaks(s2Norm,Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakHeight',0.25)
%  plot(s2Norm),grid on
  hold on
  plot(LOCS,PKS,'o')
  %%
  for i=1:length(LOCS)-1
      vecseparacion(i)=LOCS(i+1)-LOCS(i);
  end
  
  mediasep=mean(vecseparacion);
  
  minimadist=mediasep-(mediasep/2);
  maximadist=mediasep+(mediasep/2);
  aux=0;
  flag=0;
  for i=1:length(vecseparacion)
    if(flag~=1)
      if(vecseparacion(i)>maximadist)
          locmedia=(LOCS(i+1)+LOCS(i))/2;
          NEWLOCS(i+aux)=LOCS(i);
          NEWLOCS(i+1+aux)=locmedia;
          aux=aux+1;
      else
          if(vecseparacion(i)<maximadist && vecseparacion(i)>minimadist)
            NEWLOCS(i+aux)=LOCS(i);
          else
              NEWLOCS(i+aux)=LOCS(i);
              flag=1;
          end
      end
    else
        flag=0;
    end
  end
  
  NEWLOCS=[NEWLOCS LOCS(end)];
  NEWLOCS=nonzeros(NEWLOCS);
  
  %%
  figure(3)
  findpeaks(s22Norm,Fs,'MinPeakWidth',0.1,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.15)
  hold on
  plot(LOCS2,PKS2,'o')
  
  

%% Modelo pulso PPG

%% Funci√≥n Gaussiana
Sigma = 0.4;
mu = 2.5;
AmplitudGaussiana = 0.12;
a = AmplitudGaussiana/sqrt(2*pi*Sigma.^2);
x = 0:1:20;
g = ((x-mu)/Sigma).^2;
f = a*exp(-0.5*g);
 
y = gaussmf(x,[2 5]);

%% Funci√≥n LogNormal
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