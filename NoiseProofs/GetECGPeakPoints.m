%% function [ECGPeaks,ECGLocs] = GetPeakPoints(s,Fs,minW,d)
% DESCRIPTION: this function allows to obtain ECG peak points by means of
% the findpeaks algorithm.
% INPUTS: s: ECG signal.
% minHeight: minimum height condition.
% minDistance : minimum distance condition.
% maxWidth: maximum width condition.
% OUTPUTS: ECGPeaks: values of ECG peaks.
        %   ECGLocs: locations of the ECG peaks.

function [ECGPeaks,ECGLocs] = GetECGPeakPoints(signal,minHeight,MinDistance,MaxWidth)
        
[ECGPeaks,ECGLocs] = findpeaks(signal,125,'MinPeakHeight',minHeight,'MinPeakDistance',MinDistance,...
        'MaxPeakWidth',MaxWidth,'Annotate','extents');
    % FOR VISUALIZATION PURPOSES AND DATA ANALYSIS.
%         figure
%         findpeaks(signal,125,'MinPeakHeight',minHeight,'MinPeakDistance',MinDistance,...
%             'MaxPeakWidth',MaxWidth,'Annotate','extents');
%         hold on
%         plot(ECGLocs,ECGPeaks,'o')   
%         xlabel('Tiempo');
%         ylabel('Signal');
%         hold on
end