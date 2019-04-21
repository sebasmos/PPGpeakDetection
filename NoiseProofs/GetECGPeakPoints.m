%% function [ECGPeaks,ECGLocs] = GetPeakPoints(s,Fs,minW,d)
% s: signal name
% Fs: Freq muestreo
% minW: Ancho min
% dist min : d

function [ECGPeaks,ECGLocs] = GetECGPeakPoints(signal,minHeight,MinDistance,MaxWidth)
        
[ECGPeaks,ECGLocs] = findpeaks(signal,125,'MinPeakHeight',minHeight,'MinPeakDistance',MinDistance,...
        'MaxPeakWidth',MaxWidth,'Annotate','extents');
%         figure
%         findpeaks(signal,125,'MinPeakHeight',minHeight,'MinPeakDistance',MinDistance,...
%             'MaxPeakWidth',MaxWidth,'Annotate','extents');
%         hold on
%         plot(ECGLocs,ECGPeaks,'o')   
%         xlabel('Tiempo');
%         ylabel('Signal');
%         hold on
end