%% ParametersMatrixCleaned = GetMetrics(ecgCleaned,ppgOriginal,ppgCleaned,params,Fs)
% This function allows us obtaining confusion matrix metrics 
% INPUTS
% ecgCleaned: Vector containing the signal of a determined
%                       activity in a determined realization without
%                       driftbaseline
% ppgCleaned: Vector containing the signal of a determined
%                       activity in a determined realization without
%                       driftbaseline
%
% params: Vector containing the next parameters:
% 1. param(1): MinPeakWidth
% 2. param(2): MaxPeakWidth
% 3. param(3): Prominence
% 4. param(4): MinPeakDistance
% 5. param(5): minWidth
% 6. param(6): MinPeakDistance
% 7. param(7): minHeight
%
% OUTPUTS
% You can change the output of this code by changing
% ParametersMatrixCleaned for ParametersMatrixOriginal
%The first will throw the performance parameters from cleaned signal
%The second will throw the performance parmeters from original (noisy)
%signal
function ParametersMatrixCleaned = GetMetrics(ecgCleaned,ppgOriginal,ppgCleaned,params,Fs)
     % ECGPeaks extration w/without noise
     % 1. ECG
   [~,ECG1Locs] = GetECGPeakPoints(ecgCleaned,params(5),params(6),params(7));
     % PPGPeaks extration w/without noise
     % 2. PPG
    [~,LOCS1Original] = GetPeakPoints(ppgOriginal,Fs,params(1),params(2),params(3),params(4));
    [~,LOCS1Cleaned] = GetPeakPoints(ppgCleaned,Fs,params(1),params(2),params(3),params(4));
    noise = 0;
    % Shifting
    NewLOCSPPGOriginal=GetCorrimiento(ECG1Locs,LOCS1Original,ppgOriginal,ecgCleaned,Fs);
    NewLOCSPPGCleaned=GetCorrimiento(ECG1Locs,LOCS1Cleaned,ppgCleaned,ecgCleaned,Fs);
    % Windows
    W1=(mean(diff(ECG1Locs)))/2;
    ParametersMatrixCleaned=[];
    ParametersMatrixCleaned(1:4)=GetConfussionValues(W1,ECG1Locs,NewLOCSPPGCleaned,length(ppgOriginal),Fs);
    %ParametersMatrixOriginal(1:4)=GetConfussionValues(W1,ECG1Locs,NewLOCSPPGOriginal,length(ppgOriginal),Fs);
end