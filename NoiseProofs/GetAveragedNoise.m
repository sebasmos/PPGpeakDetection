%% function [h,TamRealizaciones,s,s1,s2,s3,s4,s5] = GetAveragedNoise()
% DESCRIPTION: % This code provides with the process followed to generate
% the savitzky Golay noise model. First it makes the low and high frequency
% noise sum inside GetSavitzkyNoise.
% Because of the joints irregular values, this has to be passed through
% hampelization to avoid these extrema values.
% INPUTS: none
% OUTPUTS:
%   h: Savitzky Golay noise model
%   TamRealizaciones: vector containing the lengths of each realization.
%   s..s5: refer to the twelve realizations separated by each activity. In
%   this way, each one of these variables is a matrix of size 12xlength of
%   the activity in samples.

function [h,TamRealizaciones,s,s1,s2,s3,s4,s5] = GetAveragedNoise()
% Initial Conditions
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

%% Obtain Savitzky noise as a subtraction of filtered signals from the original signals.
% This is obtained separately for each activity, making use of the sample
% interval known for each activity. Then, the savitzky golay noise model is
% saved into each s...s5.
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    else       
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    end
    % In this part, after the noise has been obtained for each activity, we
    % proceed to make a vertical sum of them.
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s1(k,:);
    sm2 = sm2 + s2(k,:);
    sm3 = sm3 + s3(k,:);
    sm4 = sm4 + s4(k,:);
    sm5 = sm5 + s5(k,:);

end

%% SAMPLE MEAN
% Summed noise is organized in a matrix M with size 6x3750. In other words,
% the sums of noise are stacked into a matrix that contains in each row one
% activity.
% For the signals in the samples 0-3750 (30s activity), 3750
% zeros are added in order to fit the matrix with the right dimension.

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;

% Here, we finally divide the sum between the total set of realizations
% contributing to the noise model. In this way, the Savitzky Golay model
% is obtained. However, it is still in a matrix form.

Media0 = M./Realizaciones;

% Re-set the sampled mean on a single vector linking the 6 activity signals
% one by one with the adjacent

v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];

% Delete extra zeros and delete extrema values caused by joints of each 
%activity with the adjacent.

mediamuestral=nonzeros(v);
mediamuestral=mediamuestral';
h=hampel(mediamuestral,5,2);
end