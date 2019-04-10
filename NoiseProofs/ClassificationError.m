%% IN THIS SCRIPT, THE CLASSIFICATION ERRORS ARE COMPUTED, LIKEWISE IN A 
% CONFUSSION MATRIX. THE ECG AND PPG SIGNALS (ORIGINAL AND DENOISED) ARE 
% ANALYZED IN AN INTERVAL MUCH SMALLER THAN THE RR INTERVAL.
%PPG SIGNAL WILL BE SHIFTED AROUND AN SPECIFIC VALUE FOR EACH ACTIVITY. IN
%THIS WAY, WE ARE HAVING IN ACCOUNT THE HEART RATE CHANGES IN EACH ACTIVITY
clc
clear all
close all
%% Add Datasets
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GeneralNoise');
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
j = 12; %IMPORTANT!!! change this parameter to obtain errors from 
          %different realizations
%% PARAMETERS FOR PPG SIGNAL
% MinPeakWidth
MinPeakWidthRest1 = 0.07;
MinPeakWidthRun_2 = 0.05;
MinPeakWidthRun_3 = 0.1;
MinPeakWidthRun_4 = 0.07;
MinPeakWidthRun_5 = 0.05;
MinPeakWidthRest6 = 0.1;
% MaxWidthPeak in PPG
MaxWidthRest1 = 1;
MaxWidthRun2 = 0.8;
MaxWidthRun3 = 0.8;
MaxWidthRun4 = 0.8;
MaxWidthRun5 = 1;
MaxWidthRest6 = 0.5;
% Prominence in PPG
ProminenceInRest1 = 0.03;
ProminenceRun2 = 0.04;
ProminenceRun3 = 0.12;
ProminenceRun4 = 0.04;
ProminenceRun5 = 0.12;
ProminenceInRest6 = 0.04;
% Min peak Distance in PPG
MinDistRest1 = 0.4;
MinDistRun2 = 0.35;
MinDistRun3 = 0.28;
MinDistRun4 = 0.25;
MinDistRun5 = 0.28;
MinDistRest6 = 0.2;
%% PARAMETERS IN ECG SIGNAL
% Min Height in ECG
MinHeightECGRest1 = 0.02;
MinHeightECGRun2  = 0.02;
MinHeightECGRun3  = 0.02;
MinHeightECGRun4  = 0.017;
MinHeightECGRun5  = 0.017;
MinHeightECGRest6 = 0.014;
%Min Dist in ECG
minDistECGRest1  = 0.5;
minDistECGRun2   = 0.44;
minDistECGRun3   = 0.3;
minDistECGRun4   = 0.3;
minDistECGRun5   = 0.3;
minDistECGRest6  = 0.3;
%Max Width in ECG
MaxPeakWidthECG1  = 0.05;
MaxPeakWidthECG2   = 0.05;
MaxPeakWidthECG3   = 0.05;
MaxPeakWidthECG4   = 0.04;
MaxPeakWidthECG5   = 0.04;
MaxPeakWidthECG6  = 0.04;

%% EXTRACT THE SIGNALS
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
        ECGdatasetSignals(k,:)=a.sig(1,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
        ECGdatasetSignals(k,:)=a.sig(1,(1:35989));
    end
end

% Sample Frequency
    Fs = 125;
%Convert to physical values: According to timesheet of the used wearable
ecgFullSignal = (ECGdatasetSignals-128)./255;
s2 = (PPGdatasetSignals-128)/(255);

% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
    ecgNorm(k,:) = (ecgFullSignal(k,:)-min(ecgFullSignal(k,:)))./(max(ecgFullSignal(k,:))-min(ecgFullSignal(k,:)));
end
    
%% Separate Activities
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end));
ActivityECG1=ecgNorm(:,(1:3750));
ActivityECG2=ecgNorm(:,(3751:11250));
ActivityECG3=ecgNorm(:,(11251:18750));
ActivityECG4=ecgNorm(:,(18751:26250));
ActivityECG5=ecgNorm(:,(26251:33750));
ActivityECG6=ecgNorm(:,(33751:end));

%% Clean each ECG activity

for k=1:12
    CleanedActivityECG1(k,:)=DenoiseECG(ActivityECG1(k,:));
    CleanedActivityECG2(k,:)=DenoiseECG(ActivityECG2(k,:));
    CleanedActivityECG3(k,:)=DenoiseECG(ActivityECG3(k,:));
    CleanedActivityECG4(k,:)=DenoiseECG(ActivityECG4(k,:));
    CleanedActivityECG5(k,:)=DenoiseECG(ActivityECG5(k,:));
    CleanedActivityECG6(k,:)=DenoiseECG(ActivityECG6(k,:));
end

%% ECG PEAKS EXRACTION 
    [~,ECG1Locs] = GetECGPeakPoints(CleanedActivityECG1(j,:),MinHeightECGRest1,minDistECGRest1,MaxPeakWidthECG1);
    [~,ECG2Locs] = GetECGPeakPoints(CleanedActivityECG2(j,:),MinHeightECGRun2,minDistECGRun2,MaxPeakWidthECG2);
    [~,ECG3Locs] = GetECGPeakPoints(CleanedActivityECG3(j,:),MinHeightECGRun3,minDistECGRun3,MaxPeakWidthECG3);
    [~,ECG4Locs] = GetECGPeakPoints(CleanedActivityECG4(j,:),MinHeightECGRun4,minDistECGRun4,MaxPeakWidthECG4);
    [~,ECG5Locs] = GetECGPeakPoints(CleanedActivityECG5(j,:),MinHeightECGRun5,minDistECGRun5,MaxPeakWidthECG5);
    [~,ECG6Locs] = GetECGPeakPoints(CleanedActivityECG6(j,:),MinHeightECGRest6,minDistECGRest6,MaxPeakWidthECG6);

%% Separate noise for PPG with its correspondent activity.
Noise1 = mediamuestral(1:3750);
Noise2 = mediamuestral(3751:11250);
Noise3 = mediamuestral(11251:18750);
Noise4 = mediamuestral(18751:26250);
Noise5 = mediamuestral(26251:33750);
Noise6 = mediamuestral(33751:end);

%% 1. Savitzky smoothing filter.
%   Ruido total 1: o(t) = n(t)+w(t)
    TotalS=mediamuestral;
% Cleaning signal with MA
    CleanedSignal1 = Activity1 - TotalS(1:3750);
    CleanedSignal2 = Activity2 - TotalS(3751:11250);
    CleanedSignal3 = Activity3 - TotalS(11251:18750);
    CleanedSignal4 = Activity4 - TotalS(18751:26250);
    CleanedSignal5 = Activity5 - TotalS(26251:33750);
    CleanedSignal6 = Activity6 - TotalS(33751:35989);
    
 %% EXTRACCION DE LOS PICOS DE PPG CON RUIDO Y SIN RUIDO
    % 1. ORIGINAL en reposo vs sin ruido
    [~,LOCS1Original] = GetPeakPoints(Activity1(j,:),Fs,MinPeakWidthRest1,MaxWidthRest1,ProminenceInRest1,MinDistRest1);
    [~,LOCS1Cleaned] = GetPeakPoints(CleanedSignal1(j,:),Fs,MinPeakWidthRest1,MaxWidthRest1,ProminenceInRest1,MinDistRest1);
    % 2. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS2Original] = GetPeakPoints(Activity2(j,:),Fs,MinPeakWidthRun_2,MaxWidthRun2,ProminenceRun2,MinDistRun2);
    [~,LOCS2Cleaned] = GetPeakPoints(CleanedSignal2(j,:),Fs,MinPeakWidthRun_2,MaxWidthRun2,ProminenceRun2,MinDistRun2);
    % 3. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS3Original] = GetPeakPoints(Activity3(j,:),Fs,MinPeakWidthRun_3,MaxWidthRun3,ProminenceRun3,MinDistRun3);
    [~,LOCS3Cleaned] = GetPeakPoints(CleanedSignal3(j,:),Fs,MinPeakWidthRun_3,MaxWidthRun3,ProminenceRun3,MinDistRun3);
    % 4. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS4Original] = GetPeakPoints(Activity4(j,:),Fs,MinPeakWidthRun_4,MaxWidthRun4,ProminenceRun4,MinDistRun4);
    [~,LOCS4Cleaned] = GetPeakPoints(CleanedSignal4(j,:),Fs,MinPeakWidthRun_4,MaxWidthRun4,ProminenceRun4,MinDistRun4);
    % 5. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS5Original] = GetPeakPoints(Activity5(j,:),Fs,MinPeakWidthRun_5,MaxWidthRun5,ProminenceRun5,MinDistRun5);
    [~,LOCS5Cleaned] = GetPeakPoints(CleanedSignal5(j,:),Fs,MinPeakWidthRun_5,MaxWidthRun5,ProminenceRun5,MinDistRun5);
    % 6. REST 30s se?al original vs sin ruido
    [~,LOCS6Original] = GetPeakPoints(Activity6(j,:),Fs,MinPeakWidthRest6,MaxWidthRest6,ProminenceInRest6,MinDistRest6);
    [~,LOCS6Cleaned] = GetPeakPoints(CleanedSignal6(j,:),Fs,MinPeakWidthRest6,MaxWidthRest6,ProminenceInRest6,MinDistRest6);

%% VEAMOS EL CORRIMIENTO 
%Actividad1
NewLOCSPPG1Original=GetCorrimiento(ECG1Locs,LOCS1Original,Activity1(j,:),CleanedActivityECG1(j,:),Fs);
NewLOCSPPG1Cleaned=GetCorrimiento(ECG1Locs,LOCS1Cleaned,CleanedSignal1(j,:),CleanedActivityECG1(j,:),Fs);
%Actividad2
NewLOCSPPG2Original=GetCorrimiento(ECG2Locs,LOCS2Original,Activity2(j,:),CleanedActivityECG2(j,:),Fs);
NewLOCSPPG2Cleaned=GetCorrimiento(ECG2Locs,LOCS2Cleaned,CleanedSignal2(j,:),CleanedActivityECG2(j,:),Fs);
%Actividad3
NewLOCSPPG3Original=GetCorrimiento(ECG3Locs,LOCS3Original,Activity3(j,:),CleanedActivityECG3(j,:),Fs);
NewLOCSPPG3Cleaned=GetCorrimiento(ECG3Locs,LOCS3Cleaned,CleanedSignal3(j,:),CleanedActivityECG3(j,:),Fs);
%Actividad4
NewLOCSPPG4Original=GetCorrimiento(ECG4Locs,LOCS4Original,Activity4(j,:),CleanedActivityECG4(j,:),Fs);
NewLOCSPPG4Cleaned=GetCorrimiento(ECG4Locs,LOCS4Cleaned,CleanedSignal4(j,:),CleanedActivityECG4(j,:),Fs);
%Actividad5
NewLOCSPPG5Original=GetCorrimiento(ECG5Locs,LOCS5Original,Activity5(j,:),CleanedActivityECG5(j,:),Fs);
NewLOCSPPG5Cleaned=GetCorrimiento(ECG5Locs,LOCS5Cleaned,CleanedSignal5(j,:),CleanedActivityECG5(j,:),Fs);
%Actividad6
NewLOCSPPG6Original=GetCorrimiento(ECG6Locs,LOCS6Original,Activity6(j,:),CleanedActivityECG6(j,:),Fs);
NewLOCSPPG6Cleaned=GetCorrimiento(ECG6Locs,LOCS6Cleaned,CleanedSignal6(j,:),CleanedActivityECG6(j,:),Fs);

%% CALCULAMOS LAS VENTANAS PARA EVALUACION
%Vamos a calcular el intervalo RR para poder partirlo en 2 y mirar cuantas
%unidades tiene cada ventana de corrimiento. Por lo tanto, cada ventana
%será una medición. Cada actividad poseerá floor(L/W) mediciones donde L es la
%longitud del intervalo en tiempo y W es la longitud de la ventana en
%tiempo.
W1=(mean(diff(ECG1Locs)))/2;
W2=(mean(diff(ECG2Locs)))/2;
W3=(mean(diff(ECG3Locs)))/2;
W4=(mean(diff(ECG4Locs)))/2;
W5=(mean(diff(ECG5Locs)))/2;
W6=(mean(diff(ECG6Locs)))/2;

%% CALCULAMOS LOS PARAMETROS PARA CADA UNO

%Para la señal Original
ParametersMatrixOriginal=[];
ParametersMatrixOriginal(1,(1:4))=GetConfussionValues(W1,ECG1Locs,NewLOCSPPG1Original,length(Activity1(j,:)),Fs);
ParametersMatrixOriginal(2,(1:4))=GetConfussionValues(W2,ECG2Locs,NewLOCSPPG2Original,length(Activity2(j,:)),Fs);
ParametersMatrixOriginal(3,(1:4))=GetConfussionValues(W3,ECG3Locs,NewLOCSPPG3Original,length(Activity3(j,:)),Fs);
ParametersMatrixOriginal(4,(1:4))=GetConfussionValues(W4,ECG4Locs,NewLOCSPPG4Original,length(Activity4(j,:)),Fs);
ParametersMatrixOriginal(5,(1:4))=GetConfussionValues(W5,ECG5Locs,NewLOCSPPG5Original,length(Activity5(j,:)),Fs);
ParametersMatrixOriginal(6,(1:4))=GetConfussionValues(W6,ECG6Locs,NewLOCSPPG6Original,length(Activity6(j,:)),Fs);

%Para la señal Cleaned
ParametersMatrixCleaned=[];
ParametersMatrixCleaned(1,(1:4))=GetConfussionValues(W1,ECG1Locs,NewLOCSPPG1Cleaned,length(Activity1(j,:)),Fs);
ParametersMatrixCleaned(2,(1:4))=GetConfussionValues(W2,ECG2Locs,NewLOCSPPG2Cleaned,length(Activity2(j,:)),Fs);
ParametersMatrixCleaned(3,(1:4))=GetConfussionValues(W3,ECG3Locs,NewLOCSPPG3Cleaned,length(Activity3(j,:)),Fs);
ParametersMatrixCleaned(4,(1:4))=GetConfussionValues(W4,ECG4Locs,NewLOCSPPG4Cleaned,length(Activity4(j,:)),Fs);
ParametersMatrixCleaned(5,(1:4))=GetConfussionValues(W5,ECG5Locs,NewLOCSPPG5Cleaned,length(Activity5(j,:)),Fs);
ParametersMatrixCleaned(6,(1:4))=GetConfussionValues(W6,ECG6Locs,NewLOCSPPG6Cleaned,length(Activity6(j,:)),Fs);

%% MOSTRAMOS LOS RESULTADOS
fprintf('Actividad %d',j);
disp('Parametros de la matriz de confusión para la señal PPGOriginal vs. ECG')
disp('TP     FP     TN     FN')
disp(ParametersMatrixOriginal)

disp('Parametros de la matriz de confusión para la señal PPGCleaned vs. ECG')
disp('TP     FP     TN     FN')
disp(ParametersMatrixCleaned)

