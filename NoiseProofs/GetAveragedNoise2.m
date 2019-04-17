
function [MA,TamRealizaciones,s,s1,s2,s3,s4,s5] = GetAveragedNoise2()
%% ARTIFITIAL NOISE DESIGN 

% This code intends to proof the viability of the obtained noise from the
% substraction of the signal minus the Savitzky-golay's filter through the
% function findpeaks as demonstrated below
% Activities type 1 from type 2 differ only from the 2nd activities ahead,
% where the set speeds for the trendmill in activities type2 are under 6
% and 12 km/h:
% 1. Rest (30s)
% 2. Running 8km/h (1min) corresponds to 6 km/h in activity type 2
% 3. Running 15km/h (1min) corresponds to 12 km/h in activity type 2
% 4. Running 8km/h (1min)  corresponds to 6 km/h in activity type 2
% 5. Running 15km/h (1min) corresponds to 12 km/h in activity type 2
% 6. Rest (30 min)
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\PPGpeakDetection1\GeneralNoise')
% Initial Conditions

windowsizeRest = 100;
windowsizeRun = 80;
k=0;
prom=0;
sm0=0;
sm1=0;
sm2=0;
sm3=0;
sm4=0;
sm5=0;

% Lecture of datasets
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    end
end


for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise2(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise2(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise2(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise2(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise2(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise2(char(word),2,33751,min(TamRealizaciones));
    else       
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise2(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise2(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise2(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise2(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise2(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise2(char(word),2,33751,min(TamRealizaciones));
    end
    % In this part, after the noise has been obtained for each activity, we
    % proceed to make a sum for each one of the activities.
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s1(k,:);
    sm2 = sm2 + s2(k,:);
    sm3 = sm3 + s3(k,:);
    sm4 = sm4 + s4(k,:);
    sm5 = sm5 + s5(k,:);

end

%% SAMPLE MEAN
% Noise is organized in a single matrix M with size 6x7500, where the rows
% represent the type of activity and the columns represent the samples of
% each dataset. For the signals in the samples 0-3750 (30s activity), 3750
% zeros are added in order to fit the matrix with the right dimension.

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;

% Here, we divide the beforehand mentioned sum of noises organized in a 
% matrix and divide it between the number of realizations, so in the final 
% we obtain the mean value for the high-frequency noise.

Media0 = M./Realizaciones;

% Re-set the sampled mean on a single line linking the 6 activity signals
% one by one with the adjacent

v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];

% Delete extra zeros and make the output fit the right format.

    mediamuestral=nonzeros(v);
    mediamuestral=mediamuestral';
%% Separate noise for PPG with its correspondent activity.
Noise1 = mediamuestral(1:3750);
Noise2 = mediamuestral(3751:11250);
Noise3 = mediamuestral(11251:18750);
Noise4 = mediamuestral(18751:26250);
Noise5 = mediamuestral(26251:33750);
Noise6 = mediamuestral(33751:end);
%% Model MA
    MA(1:3750)      = Function_2_MA(Noise1,windowsizeRest); 
    MA(1:100)       = mean(Noise1); % Fixex with variance highter values
    MA(3751:11250)  = Function_2_MA(Noise2,windowsizeRun);
    MA(11251:18750) = Function_2_MA(Noise3,windowsizeRun);
    MA(18751:26250) = Function_2_MA(Noise4,windowsizeRun);
    MA(26251:33750) = Function_2_MA(Noise5,windowsizeRun);
    MA(33751:35989) = Function_2_MA(Noise6,windowsizeRest);

% h=hampel(MA,100,0.02);
% plot(h)
% hold on
% plot(MA)
end