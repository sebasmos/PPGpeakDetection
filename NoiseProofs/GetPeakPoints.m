%% function [ECGPeaks,ECGLocs] = GetPeakPoints(s,Fs,minW,d)
% s: signal name
% Fs: Freq muestreo
% minW: Ancho min
% dist min : d

function [PKS1ruido,LOCS1ruido] = GetPeakPoints(CorruptedSignal1,Fs,minPW,maxPW,minPP,minD)
[PKS1ruido,LOCS1ruido]=findpeaks(CorruptedSignal1,Fs,'MinPeakWidth',minPW,'MaxPeakWidth',maxPW, ...
              'Annotate','extents','MinPeakProminence',minPP,'MinPeakDistance',minD);
figure
findpeaks(CorruptedSignal1,Fs,'MinPeakWidth',minPW,'MaxPeakWidth',maxPW, ...
              'Annotate','extents','MinPeakProminence',minPP,'MinPeakDistance',minD)
hold on
plot(LOCS1ruido,PKS1ruido,'o')   
xlabel('Tiempo');
ylabel('Signal');
hold on

end