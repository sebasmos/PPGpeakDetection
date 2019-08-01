%% function Noise = GetSavitzkyNoise(name,n,m,s)
% DESCRIPTION:  This code allows to obtain the high and low frequency noise
% summed in a single noise, which is called Savitzky Golay.
% INPUTS: name: dataset's name
% n: Number of channel for PPG signal according to the dataset
% m: Initial sample
% s: Final Sample
% OUTPUTS:
%   Noise: noise for each set of twelve signals
%   TamRealizaciones: vector containing the lengths of each realization.
%   s..s5: refer to the twelve realizations separated by each activity. In
%   this way, each one of these variables is a matrix of size 12xlength of
%   the activity in samples.
function Noise = GetSavitzkyNoise(name,n,m,s)
%% Add Datasets
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
% Get the desired records from the chosen channel, initial and final
% samples.
    ppg=load(name);
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(n,(m:s));
% Conversion to physical variables according to the consulted literature.
    s2 = (pfinal-128)/(255);
% Minima and maxima normalization process
    sNorm = (s2-min(s2))/(max(s2)-min(s2));
% Get the high frequency components with sgolayfilt and the low frequency
% with ValoresMedia function. Then sum them up and return.
    sfilt=sgolayfilt(sNorm,3,41);
    media=ValoresMedia(sNorm);
    Noise=sNorm-sfilt+media;

end