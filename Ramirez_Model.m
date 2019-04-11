%% JOINT GAUSSIAN RANDOM VECTOR NOISE MODEL
clear all
clc
%% Add GetAverageNoise function
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs')
% Add databases
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db')
% OBTAIN SAMPLES AND GENERALIZED SAVITZKY NOISE MODEL
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
plot(mediamuestral-Detrending(mediamuestral,10))
legend('w1','w2','w3','w4','w5','mediamuestral')
% SPECTRAL ANALYSIS
s1 = GetSpectrum(HFComponent(1,:),Fs);
s2 = GetSpectrum(HFComponent(2,:),Fs);
s3 = GetSpectrum(HFComponent(3,:),Fs);
s4 = GetSpectrum(HFComponent(4,:),Fs);
s5 = GetSpectrum(HFComponent(5,:),Fs);
s6 = GetSpectrum(mediamuestral,Fs);
% Características de frecuencia
ShortedBP = bandpass(mediamuestral,[1 10],125);



