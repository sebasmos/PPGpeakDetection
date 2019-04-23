clc
clear all
close all
%% Add Datasets
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\db');
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GeneralNoise');
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\NoiseProofs');
% AVERAGE MEAN
windowsizeRest = 25;
windowsizeRun = 65;
%% Find automatically window size for best noise performance
i=25;
j=65;

while i<200
 while j<300
    [sen,ecp] = GetSensitibityMA(i,j);
   % fprintf('(i,j)=(%d,%d)  ----   (Sen,esp)= (%d,%d)',i,j,sen,ecp)
    VectorSen(i,j) = sen;
    VectorEsp(i,j)= ecp;
    j=j+5;
 end
 i=i+5;
 j=65;
end
