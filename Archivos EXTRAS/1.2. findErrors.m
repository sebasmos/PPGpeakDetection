
function [ErroresTotales] = findErrors(Activity1,Activity2,Activity3,Activity4,Activity5,Activity6,...
    CleanedSignal1,CleanedSignal2,CleanedSignal3,CleanedSignal4,CleanedSignal5,CleanedSignal6,Fs,...
    MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1,CleanedActivityECG2,CleanedActivityECG3,CleanedActivityECG4,CleanedActivityECG5,CleanedActivityECG6,...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6)
%% EXTRACCION DE LOS PICOS DE PPG CON RUIDO Y SIN RUIDO
    % 1. ORIGINAL en reposo vs sin ruido
    [~,LOCS1Original] = GetPeakPoints(Activity1,Fs,MinPeakWidthRest1,MaxWidthRest1,ProminenceInRest1,MinDistRest1);
    [~,LOCS1Cleaned] = GetPeakPoints(CleanedSignal1,Fs,MinPeakWidthRest1,MaxWidthRest1,ProminenceInRest1,MinDistRest1);
    % 2. CORRIENDO 1min se�al original vs sin ruido
    [~,LOCS2Original] = GetPeakPoints(Activity2,Fs,MinPeakWidthRun_2,MaxWidthRun2,ProminenceRun2,MinDistRun2);
    [~,LOCS2Cleaned] = GetPeakPoints(CleanedSignal2,Fs,MinPeakWidthRun_2,MaxWidthRun2,ProminenceRun2,MinDistRun2);
    % 3. CORRIENDO 1min se�al original vs sin ruido
    [~,LOCS3Original] = GetPeakPoints(Activity3,Fs,MinPeakWidthRun_3,MaxWidthRun3,ProminenceRun3,MinDistRun3);
    [~,LOCS3Cleaned] = GetPeakPoints(CleanedSignal3,Fs,MinPeakWidthRun_3,MaxWidthRun3,ProminenceRun3,MinDistRun3);
    % 4. CORRIENDO 1min se�al original vs sin ruido
    [~,LOCS4Original] = GetPeakPoints(Activity4,Fs,MinPeakWidthRun_4,MaxWidthRun4,ProminenceRun4,MinDistRun4);
    [~,LOCS4Cleaned] = GetPeakPoints(CleanedSignal4,Fs,MinPeakWidthRun_4,MaxWidthRun4,ProminenceRun4,MinDistRun4);
    % 5. CORRIENDO 1min se�al original vs sin ruido
    [~,LOCS5Original] = GetPeakPoints(Activity5,Fs,MinPeakWidthRun_5,MaxWidthRun5,ProminenceRun5,MinDistRun5);
    [~,LOCS5Cleaned] = GetPeakPoints(CleanedSignal5,Fs,MinPeakWidthRun_5,MaxWidthRun5,ProminenceRun5,MinDistRun5);
    % 6. REST 30s se�al original vs sin ruido
    [~,LOCS6Original] = GetPeakPoints(Activity6,Fs,MinPeakWidthRest6,MaxWidthRest6,ProminenceInRest6,MinDistRest6);
    [~,LOCS6Cleaned] = GetPeakPoints(CleanedSignal6,Fs,MinPeakWidthRest6,MaxWidthRest6,ProminenceInRest6,MinDistRest6);

%% PPG WITH NOISE VS. PPG WITHOUT NOISE ERROR
    ErrorFindP1 = 100*abs(length(LOCS1Cleaned)-length(LOCS1Original))./length(LOCS1Original);
    ErrorFindP2 = 100*abs(length(LOCS2Cleaned)-length(LOCS2Original))./length(LOCS2Original);
    ErrorFindP3 = 100*abs(length(LOCS3Cleaned)-length(LOCS3Original))./length(LOCS3Original);
    ErrorFindP4 = 100*abs(length(LOCS4Cleaned)-length(LOCS4Original))./length(LOCS4Original);
    ErrorFindP5 = 100*abs(length(LOCS5Cleaned)-length(LOCS5Original))./length(LOCS5Original);
    ErrorFindP6 = 100*abs(length(LOCS6Cleaned)-length(LOCS6Original))./length(LOCS6Original);
    ErrorFromFindPeaks = [ErrorFindP1 ErrorFindP2 ErrorFindP3 ErrorFindP4 ErrorFindP5 ErrorFindP6];

%% ECG PEAKS EXRACTION 
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
    [~,ECG1Locs] = GetECGPeakPoints(CleanedActivityECG1,MinHeightECGRest1,minDistRest1,maxWidthRest1);
    [~,ECG2Locs] = GetECGPeakPoints(CleanedActivityECG2,MinHeightECGRun2,minDistRun2,maxWidthRun2);
    [~,ECG3Locs] = GetECGPeakPoints(CleanedActivityECG3,MinHeightECGRun3,minDistRun3,maxWidthRun3);
    [~,ECG4Locs] = GetECGPeakPoints(CleanedActivityECG4,MinHeightECGRun4,minDistRun4,maxWidthRun4);
    [~,ECG5Locs] = GetECGPeakPoints(CleanedActivityECG5,MinHeightECGRun5,minDistRun5,maxWidthRun5);
    [~,ECG6Locs] = GetECGPeakPoints(CleanedActivityECG6,MinHeightECGRest6,minDistRest6,maxWidthRest6);

%% ECG VS. PPG WITHOUT NOISE ERROR
    ECGDPPG1 = 100*abs(length(LOCS1Cleaned)-length(ECG1Locs))./length(ECG1Locs);
    ECGDPPG2 = 100*abs(length(LOCS2Cleaned)-length(ECG2Locs))./length(ECG2Locs);
    ECGDPPG3 = 100*abs(length(LOCS3Cleaned)-length(ECG3Locs))./length(ECG3Locs);
    ECGDPPG4 = 100*abs(length(LOCS4Cleaned)-length(ECG4Locs))./length(ECG4Locs);
    ECGDPPG5 = 100*abs(length(LOCS5Cleaned)-length(ECG5Locs))./length(ECG5Locs);
    ECGDPPG6 = 100*abs(length(LOCS6Cleaned)-length(ECG6Locs))./length(ECG6Locs);
    ErrorECGDPPG = [ECGDPPG1 ECGDPPG2 ECGDPPG3 ECGDPPG4 ECGDPPG5 ECGDPPG6];

%% ECG VS. PPG WITH NOISE ERROR
    
    ECGPPG1 = 100*abs(length(LOCS1Original)-length(ECG1Locs))./length(ECG1Locs);
    ECGPPG2 = 100*abs(length(LOCS2Original)-length(ECG2Locs))./length(ECG2Locs);
    ECGPPG3 = 100*abs(length(LOCS3Original)-length(ECG3Locs))./length(ECG3Locs);
    ECGPPG4 = 100*abs(length(LOCS4Original)-length(ECG4Locs))./length(ECG4Locs);
    ECGPPG5 = 100*abs(length(LOCS5Original)-length(ECG5Locs))./length(ECG5Locs);
    ECGPPG6 = 100*abs(length(LOCS6Original)-length(ECG6Locs))./length(ECG6Locs);
    ErrorECGPPG = [ECGPPG1 ECGPPG2 ECGPPG3 ECGPPG4 ECGPPG5 ECGPPG6];
    
    disp('CALCULO % ERRORES: Fila 1 (PPGvsDPPG), Fila 2 (PPGvsECG), Fila 3 (DPPGvsECG)')
ErroresTotales = [ErrorFromFindPeaks;ErrorECGPPG;ErrorECGDPPG]
end