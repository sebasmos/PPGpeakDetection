%% Get and save signals in 'Realizaciones'

%% PRUEBA RAPIDA: RESTAR DE SE�AL 1
j = 12; %IMPORTANT!!! change this parameter to obtain errors from 
          %different realizations

%% Parameters for findpeaks Function
% PARAMETERS FOR PPG SIGNAL
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
minDistRest1  = 0.5;
minDistRun2   = 0.44;
minDistRun3   = 0.3;
minDistRun4   = 0.3;
minDistRun5   = 0.3;
minDistRest6  = 0.3;
%Max Width in ECG
maxWidthRest1  = 0.05;
maxWidthRun2   = 0.05;
maxWidthRun3   = 0.05;
maxWidthRun4   = 0.04;
maxWidthRun5   = 0.04;
maxWidthRest6  = 0.04;


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
%% EXTRACT THE SIGNAL TO OBTAIN LOWFREQUENCY COMPONENTS
%%PONERLE +media EN SAVITZKY
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
%% ECG PEAKS EXTRACTION
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

%% Separate noise for PPG with its correspondent activity.
%SACAMOS EL MODELO DE RAMIREZ, RECUERDA QUITARLE EL +media EN SAVITZKY
ShortedBP=Ramirez_Model();
Noise1 = ShortedBP(1:3750);
Noise2 = ShortedBP(3751:11250);
Noise3 = ShortedBP(11251:18750);
Noise4 = ShortedBP(18751:26250);
Noise5 = ShortedBP(26251:33750);
Noise6 = ShortedBP(33751:end);
%% Detrend noise by activities.
nRest = 10;
nRun = 10;
WandererBaseline1=Detrending(mediamuestral(1:3750),nRest);
WandererBaseline2=Detrending(mediamuestral(3751:11250),nRun);
WandererBaseline3=Detrending(mediamuestral(11251:18750),nRun);
WandererBaseline4=Detrending(mediamuestral(18751:26250),nRun);
WandererBaseline5=Detrending(mediamuestral(26251:33750),nRun);
WandererBaseline6=Detrending(mediamuestral(33751:end),nRest);
%%
% Zero centered noise extraction
TotalGaussianNoise1=Noise1+WandererBaseline1;
TotalGaussianNoise2=Noise2+WandererBaseline2;
TotalGaussianNoise3=Noise3+WandererBaseline3;
TotalGaussianNoise4=Noise4+WandererBaseline4;
TotalGaussianNoise5=Noise5+WandererBaseline5;
TotalGaussianNoise6=Noise6+WandererBaseline6;

% Cleaning signal with model R
    Cleaneds1 = Activity1 - TotalGaussianNoise1;
    Cleaneds2 = Activity2 - TotalGaussianNoise2;
    Cleaneds3 = Activity3 - TotalGaussianNoise3;
    Cleaneds4 = Activity4 - TotalGaussianNoise4;
    Cleaneds5 = Activity5 - TotalGaussianNoise5;
    Cleaneds6 = Activity6 - TotalGaussianNoise6;
        %% ERROR FOR RAMIREZ MODEL
disp('ERRORES CALCULADOS POR MODEL R')
findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
    Cleaneds1(j,:),Cleaneds2(j,:),Cleaneds3(j,:),Cleaneds4(j,:),Cleaneds5(j,:),Cleaneds6(j,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
    CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);

