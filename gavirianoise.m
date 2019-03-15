%% GAVIRIA'S APPROACH:
%In the third approach to a signal's noise we have as a tool a linear
%predictor, which is fed with the mean signal, in the case of the example
%with the ECG. What we have to do is, for each activity, establish which y
%the approximate period of a single cycle of the signal and, in this way,
%obtain a mean signal for every movement (given that the heart rate varies
%over time with each activity). Finally, in this first step we'll fed the
%linear predictor with the PPG average signal and substract this from the
%original, obtaining a first approach of the 'noise'.

%We get the signals.

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

%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSION A VARIABLES FISICAS
    s2 = (Realizaciones-128)/(255);
% NORMALIZACION POR MAXIMOS Y MINIMOS
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
end
    [a,b]=size(sNorm);
    t=(0:b-1)/Fs;
    hax=axes;
    SP1=3750/Fs;
    SP2=SP1+7500/Fs;
    SP3=SP2+7500/Fs;
    SP4=SP3+7500/Fs;
    SP5=SP4+7500/Fs;
    SP6=SP5+3750/Fs;
    figure(1),plot(t,sNorm(1,:))
    grid on, axis tight, xlabel('Tiempo'),ylabel('PPGsignal'),hold on,
    line([SP1 SP1],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP2 SP2],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP3 SP3],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP4 SP4],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP5 SP5],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP6 SP6],get(hax,'YLim'),'Color',[1 0 0]);
    
 %% PRIMEROS 30 SEGUNDOS:
 
 addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
 s30=sNorm(:,(1:3750));
 [PKS30,LOCS30]=findpeaks(s30(1,:),Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.03);
figure
findpeaks(s30(1,:),Fs,'MinPeakWidth',0.11,'MaxPeakWidth',0.5, ...
              'Annotate','extents','MinPeakProminence',0.05);
hold on
plot(LOCS30,PKS30,'o')   
xlabel('Tiempo');
ylabel('Signal');
hold on