
figure(1)

ppg=load('DATA_02_TYPE02.mat');
ppgSignal = ppg.sig;
pfinal = ppgSignal(1,:);
%Frecuencia de Muestreo
s2 = (pfinal(1,:)-128)/255;
s2Norm = (s2-min(s2))/(max(s2)-min(s2));
%s2 = (ppgSignal(2,:)+81)/161;
%s3 = (ppgSignal(3,:)+41)/81;
t = (0:length(ppgSignal)-1)/Fs;
plot(s2Norm), grid on
axis([0 1000 -0.1 1 ])
%axis([0 1000 -0.1 1 ])

figure(2)


