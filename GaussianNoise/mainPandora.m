clc
clear all
close all
%% Add Datasets
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db');
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GeneralNoise');
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs');
% AVERAGE MEAN
windowsizeRest = 30;
windowsizeRun = 40;
%% La idea de este script es encontrar los mejores par�metros para el modelo gaussiano
%% Encontrar mejor modelo automaticamente
i=30;
j=70;
while i<200
 while j<200
    [sen,ecp] = Pandora(i,j);
   % fprintf('(i,j)=(%d,%d)  ----   (Sen,esp)= (%d,%d)',i,j,sen,ecp)
    VectorSen(i,j) = sen;
    VectorEsp(i,j)= ecp;
    j=j+5;
 end
 i=i+5;
 j=0;
end