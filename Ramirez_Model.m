%% JOINT GAUSSIAN RANDOM VECTOR NOISE MODEL
clear all
close all
clc
%% Add GetAverageNoise function
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GeneralNoise')
% Add databases
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db')

%% PRUEBA RAPIDA: RESTAR DE SE�AL 1
j = 1; %IMPORTANT!!! change this parameter to obtain errors from 
          %different realizations
%% Get and save signals in 'Realizaciones'
% NOISE MODEL PARAMETERS
% LPC COEFFICIENTS
LPCActivity1 = 3500;
LPCActivity6 = 2200;
LPCActivity = 7000;
% AVERAGE MEAN
windowsizeRest = 40;
windowsizeRun = 30;
%% Parameters for findpeaks Function
% PARAMETERS FOR PPG SIGNAL
% MinPeakWidth
MinPeakWidthRest1 = 0.11;
MinPeakWidthRun_2 = 0.01;
MinPeakWidthRun_3 = 0.07;
MinPeakWidthRun_4 = 0.07;
MinPeakWidthRun_5 = 0.07;
MinPeakWidthRest6 = 0.05;
% MaxWidthPeak in PPG
MaxWidthRest1 = 0.5;
MaxWidthRun2 = 0.6;
MaxWidthRun3 = 0.5;
MaxWidthRun4 = 0.8;
MaxWidthRun5 = 0.8;
MaxWidthRest6 = 1.5;
% Prominence in PPG
ProminenceInRest1 = 0.009;
ProminenceRun2 = 0.049;
ProminenceRun3 = 0.038;
ProminenceRun4 = 0.04;
ProminenceRun5 = 0.04;
ProminenceInRest6 = 0.01;
% Min peak Distance in PPG
MinDistRest1 = 0.3;
MinDistRun2 = 0.1;
MinDistRun3 = 0.1;
MinDistRun4 = 0.15;
MinDistRun5 = 0.1;
MinDistRest6 = 0.2;
%% PARAMETERS IN ECG SIGNAL
% Min Height in ECG
MinHeightECGRest1 = 0.025;
MinHeightECGRun2  = 0.025;
MinHeightECGRun3  = 0.04;
MinHeightECGRun4  = 0.04;
MinHeightECGRun5  = 0.04;
MinHeightECGRest6 = 0.04;
%Min Dist in ECG
minDistRest1  = 0.6;
minDistRun2   = 0.5;
minDistRun3   = 0.2;
minDistRun4   = 0.2;
minDistRun5   = 0.2;
minDistRest6  = 0.2;
%Max Width in ECG
maxWidthRest1  = 0.05;
maxWidthRun2   = 0.05;
maxWidthRun3   = 0.05;
maxWidthRun4   = 0.05;
maxWidthRun5   = 0.05;
maxWidthRest6  = 0.05;

%% OBTAIN SAMPLES AND GENERALIZED SAVITZKY NOISE MODEL
[mediamuestral,TamRealizaciones,s,s1,s2,s3,s4,s5]=GetAveragedNoise();
%% UNBIASED VARIANZA
% The activities are separated according to each activity and its variance
% Add is extracted vertically, operating varianamuestral function per column
V=[s s1 s2 s3 s4 s5];
varianzamuestral= var(V);
% Sample frequency
Fs = 125;
%% AUTOCORRELATION AND Autocovariance MATRIX
% Covariance matrix, is a matrix whose element 
% in the i, j position is the covariance between the i-th and j-th elements 
% of a random vector.
values=[];
i=1;
j=1;
[a,b]=size(V);
for t1=1:100:b
    for t2=1:100:b
        values=V(:,t1)'*V(:,t2);
        Rxx(i,j)=values/a;
        Kxx(i,j)=Rxx(i,j)-(mediamuestral(t1).*mediamuestral(t2));
        j=j+1;
    end
    i=i+1;
    j=1;
end

% figure
% plot(W(1,:))
%% MODELO 2
% absD = abs(Kxx( 1:10:350, 1:10:350));
% detKxx = det(absD); 
% cov(X), if X is a vector, returns the variance.  For matrices, where 
%    each row is an observation, and each column a variable, cov(X) is the 
%    covariance matrix.  DIAG(cov(X)) is a vector of variances for each 
%    column, and SQRT(DIAG(cov(X))) is a vector of standard deviations. 
%    cov(X,Y), where X and Y are matrices with the same number of elements,
%    is equivalent to cov([X(:) Y(:)]). 
%CovarianceMatrix = (s);
% mu = [1 -1]; Sigma = [.9 .4; .4 .3];
% [X1,X2] = meshgrid(linspace(-1,3,25)', linspace(-3,1,25)');
% X = [X1(:) X2(:)];
% p = mvnpdf(X, mu, Sigma);
% surf(X1,X2,reshape(p,25,25));
  %%
% X =randn(3750,1)';
%  mu = mediamuestral(1:3750);
%  var = s(:,(1:3750));
% % %X = [X1(:) X2(:)];
% % F = mvnpdf(X,mu,var);
% % surf(X,reshape(p,25,25));
% D = length(mu);
% L = Kxx;
% X = randn(D,360);
% % Generate Z ~ N(mu,Sigma) in D dimensions (linearly dependent components) 
% Z = repmat(mu,1,360) + L*X;  % Matrix [D,M]
% Z = Z';                    % Matrix [M,D]
% dataLength = 5000;
% muData = [5 30];
% stdData = [4 10];
% X = [muData(1) + stdData(1)*randn(dataLength/2,1);  muData(2) + stdData(2)*randn(dataLength/2,1)];
% [counts,binLocations] = imhist(X);
% stem(binLocations, counts, 'MarkerSize', 1 );
% xlim([-1 1]); 
% % inital kmeans step used to initialize EM
% K = 2;               % number of mixtures/clusters
% rng('default');
% [~,cInd.mu] = kmeans(X(:), K,'MaxIter', 75536);
% % fit a GMM model
% gmInitialVariance = 0.1;
% initialSigma = cat(3,gmInitialVariance,gmInitialVariance)
% % cInd.mu=[0;0];            %%if you want to initialize the mu parameter to 0.
% cInd.Sigma=initialSigma;
% options = statset('MaxIter', 75536); 
% gmm = fitgmdist(X(:), K,'Start',cInd,'CovarianceType','diagonal','Regularize',1e-5,'Options',options);


%% MODELO GAUSIANO LIMITADO EN BANDA
x = randn(5,1);
W=zeros(5,length(mediamuestral));
for k=1:length(mediamuestral)
    W(:,k)=mediamuestral(k)+sqrt(varianzamuestral(k))*x;
end
% Detrend models
for x = 1:length(x)
 DetrendedW(x,:) = Detrending(W(x,:),10); 
 HFComponent(x,:) = W(x,:) -DetrendedW(x,:); 
end
% Comparacion de modelos: 
for i =1:5
   plot(HFComponent(i,:)),hold on
end
hold on
plot((mediamuestral-Detrending(mediamuestral,10)),'LineWidth',1.5),title('Normal Gaussian Noise vs '),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
legend('w1','w2','w3','w4','w5','mediamuestral')
% SPECTRAL ANALYSIS
s1 = GetSpectrum(HFComponent(1,:),Fs);
s2 = GetSpectrum(HFComponent(2,:),Fs);
s3 = GetSpectrum(HFComponent(3,:),Fs);
s4 = GetSpectrum(HFComponent(4,:),Fs);
s5 = GetSpectrum(HFComponent(5,:),Fs);
s6 = GetSpectrum(mediamuestral,Fs);
%% Caracter�sticas de frecuencia aplicadas: 0-10 hz, se dejan valores mayores 
% a 10 para capturar detalles de alta frecuencia del ruido de alta
% frecuencia
ShortedBP = bandpass(mediamuestral,[3 30],125);
plot(mediamuestral(1:3750)-Detrending(mediamuestral(1:3750),10)), hold on
plot(ShortedBP(1:3750)),title('Activity RESTING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
legend('Mediamuestral','Senal Gaussiana Limitada en banda')
figure
plot(mediamuestral(3750:11250)-Detrending(mediamuestral(3750:11250),10)),hold on
plot(ShortedBP(3750:11250)),title('Activity RUNNING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
legend('Mediamuestral','Senal Gaussiana Limitada en banda')
%% Espectro de se�al modelo 1 limitada en banda
    [~,~,f,dP1] = centerfreq(Fs,mediamuestral); 
    [~,~,f2,dP2] = centerfreq(Fs,ShortedBP); 
    [PS,NN] = PowSpecs(mediamuestral);
    [PS,NN] = PowSpecs(ShortedBP);
    figure
    plot(f,dP1,f2,dP2),grid on, axis([0 50 -10 100 ])
    legend('Savitzky','Band-limited Gaussian Noise')
    title('SPECTRUM, BOTH CASES')
% [~,peakBP ] = findpeaks(dP2,'MinPeakHeight',10,'MinPeakDistance',40);
%  findpeaks(dP2,'MinPeakHeight',0.5,'MinPeakDistance',40);


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
Noise1 = ShortedBP(1:3750);
Noise2 = ShortedBP(3751:11250);
Noise3 = ShortedBP(11251:18750);
Noise4 = ShortedBP(18751:26250);
Noise5 = ShortedBP(26251:33750);
Noise6 = ShortedBP(33751:end);
%% Detrend noise by activities.
nRest = 10;
nRun = 10;
WandererBaseline1=Detrending(Noise1,nRest);
WandererBaseline2=Detrending(Noise2,nRun);
WandererBaseline3=Detrending(Noise3,nRun);
WandererBaseline4=Detrending(Noise4,nRun);
WandererBaseline5=Detrending(Noise5,nRun);
WandererBaseline6=Detrending(Noise6,nRest);
% Zero centered noise extraction
ZeroCenteredNoise1=Noise1-WandererBaseline1;
ZeroCenteredNoise2=Noise2-WandererBaseline2;
ZeroCenteredNoise3=Noise3-WandererBaseline3;
ZeroCenteredNoise4=Noise4-WandererBaseline4;
ZeroCenteredNoise5=Noise5-WandererBaseline5;
ZeroCenteredNoise6=Noise6-WandererBaseline6;
% Cleaning signal with model R
    Cleaneds1 = Activity1 - ShortedBP(1:3750);
    Cleaneds2 = Activity2 - ShortedBP(3751:11250);
    Cleaneds3 = Activity3 - ShortedBP(11251:18750);
    Cleaneds4 = Activity4 - ShortedBP(18751:26250);
    Cleaneds5 = Activity5 - ShortedBP(26251:33750);
    Cleaneds6 = Activity6 - ShortedBP(33751:35989);
        %% ERROR FOR SAVITZKY
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

