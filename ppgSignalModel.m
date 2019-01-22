% % Modelo pulso PPG

%% Función Gaussiana
Sigma = 0.4;
mu = 2.5;
AmplitudGaussiana = 0.12;
a = AmplitudGaussiana/sqrt(2*pi*Sigma.^2);
x = 0:0.1:10
g = ((x-mu)/Sigma).^2;
f = a*exp(-0.5*g);
 
x = 0:0.1:10;
y = gaussmf(x,[2 5]);

%% Función LogNormal
% Y = lognpdf(X,mu,sigma) returns values at X of the 
% lognormal pdf with distribution parameters mu and 
% sigma. mu and sigma are the mean and standard deviation,
% respectively, of the associated normal distribution
sigma2 = 1;
mu2 = 0.7;
x2 = 0:0.1:10;
% a1 = x1.*sqrt(2*pi*c1.^2);
% g1 = log(((x1-b1)/2*c1).^2);2% f1 = a1*exp(-0.5*g1);
% plot(f1)
% Amplitud LogNormal
 AmplLogNormal = 1.23;
 y2 = AmplLogNormal.*lognpdf(x2,mu2,sigma2);
 
 figure(1)
 PPGSignal1 = y2+f;
 plot(PPGSignal1), grid on
 %plot(x1,y2)
 

%  h2 = f + y;
 