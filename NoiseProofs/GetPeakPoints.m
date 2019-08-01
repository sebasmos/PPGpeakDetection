%% function [PPGPeaks,PPGLocs] = GetPeakPoints(s,Fs,minW,d)
% DESCRIPTION: this function allows to obtain PPG peak points by means of
% the findpeaks algorithm.
% INPUTS: s: PPG signal.
% Fs: Sampling frequency.
% minWidth: minimum width condition.
% maxWidth : maximum width condition.
% minProminence: minimum prominence condition.
% minDistance: minimum distance condition.
% OUTPUTS: PPGPeaks: values of PPG peaks.
        %  PPGLocs: locations of the PPG peaks.

function [PKS1ruido,LOCS1ruido] = GetPeakPoints(CorruptedSignal1,Fs,minPW,maxPW,minPP,minD)
[PKS1ruido,LOCS1ruido]=findpeaks(CorruptedSignal1,Fs,'MinPeakWidth',minPW,'MaxPeakWidth',maxPW, ...
              'Annotate','extents','MinPeakProminence',minPP,'MinPeakDistance',minD);
          % FOR VISUALIZATION PURPOSES AND DATA ANALYSIS.
% figure
% findpeaks(CorruptedSignal1,Fs,'MinPeakWidth',minPW,'MaxPeakWidth',maxPW, ...
%               'Annotate','extents','MinPeakProminence',minPP,'MinPeakDistance',minD)
% hold on
% plot(LOCS1ruido,PKS1ruido,'o')   
% xlabel('Tiempo');
% ylabel('Signal');
% hold on

end