%% function [ECGPeaks,ECGLocs] = GetPeakPoints(s,Fs,minW,d)
% s: signal name
% Fs: Freq muestreo
% minW: Ancho min
% dist min : d

function [ECGPeaks,ECGLocs] = GetECGPeakPoints(s,minW,d)

[ECGPeaks,ECGLocs] = findpeaks(s,'MinPeakHeight',minW,...
    'MinPeakDistance',d);
figure
findpeaks(s,'MinPeakHeight',minW,...
    'MinPeakDistance',d);
hold on
plot(ECGLocs,ECGPeaks,'o')   
xlabel('Tiempo');
ylabel('Signal');
hold on
end