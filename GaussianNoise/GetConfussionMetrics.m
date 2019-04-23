%% ParametersMatrixCleaned = GetPandoraA(ecgCleaned,ppgOriginal,ppgCleaned,params,Fs)
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
% 5. param(5): Prominence
% 6. param(6): MinPeakDistance
% 7. param(7): MinPeakDistance
function ParametersMatrixCleaned = GetConfussionMetrics(ecgCleaned,ppgOriginal,ppgCleaned,params,Fs)
     % EXTRACCION DE LOS PICOS DE ECG CON RUIDO Y SIN RUIDO
    % 1. ECG
   [~,ECG1Locs] = GetECGPeakPoints(ecgCleaned,params(5),params(6),params(7));
      % EXTRACCION DE LOS PICOS DE PPG CON RUIDO Y SIN RUIDO
    % 1. PPG
    [~,LOCS1Original] = GetPeakPoints(ppgOriginal,Fs,params(1),params(2),params(3),params(4));
    [~,LOCS1Cleaned] = GetPeakPoints(ppgCleaned,Fs,params(1),params(2),params(3),params(4));
    noise = 0;
    % CORRIMIENTO 
    NewLOCSPPGOriginal=GetCorrimiento(ECG1Locs,LOCS1Original,ppgOriginal,ecgCleaned,Fs);
    NewLOCSPPGCleaned=GetCorrimiento(ECG1Locs,LOCS1Cleaned,ppgCleaned,ecgCleaned,Fs);
    % Windows
    W1=(mean(diff(ECG1Locs)))/2;
    ParametersMatrixCleaned=[];
    ParametersMatrixCleaned(1:4)=GetConfussionValues(W1,ECG1Locs,NewLOCSPPGCleaned,length(ppgOriginal),Fs);
end