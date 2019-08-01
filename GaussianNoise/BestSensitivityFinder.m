%% This code helped to find automatically the best window sizes for MA model
% This code also helped to find automatically the best F factor values for
% DVMA model.
clc
clear all
close all
%% Add Datasets
% addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db');
% addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GeneralNoise');
% addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs');
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GeneralNoise')
%% Find automatically window size for best noise performance.
% Initially uses a wnindow size of 25 and 65 and it goes in steps of 5,
% until it reaches 300.
% i=25;
% j=65;
% 
% while i<200
%  while j<300
%     [sen,ecp] = Function_Gaussian(i,j);
%    fprintf('(i,j)=(%d,%d)  ----   (Sen,esp)= (%d,%d)',i,j,sen,ecp)
%     VectorSen(i,j) = sen;
%     VectorEsp(i,j)= ecp;
%     j=j+5;
%  end
%  i=i+5;
%  j=65;
% end
%% Find best seed values automatically for DVMA model.
i = -3;
k = 1;
while i<3
    [sen,ecp] = Function_GMA(i);   
    fprintf('(i)= %d ----(Sen,esp)= (%d,%d)',i,sen,ecp)
    VectorSen(k) = sen;
    VectorEsp(k)= ecp;
     i = i + 0.01;
     k = k+1;
end
