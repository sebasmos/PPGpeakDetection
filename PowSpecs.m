function [PS,NN,nbFrames] = PowSpecs(data)
%% Computing MFCC Co-efficients..
    %% (1) Frame Blocking..
    N = 256;   % N point FFT
    M = 100;   % Overlapping

    NN = floor(N/2+1); %N/2
    nbFrames = ceil((length(data)-N)/M);
    Frames = zeros(nbFrames+1,N);
    for i = 0:nbFrames-1
        temp = data(i*M+1:i*M+N);
        Frames(i+1,1:N) = temp; 
    end

    % Last Frame..
    temp = zeros(1,N); 
    lastLength = length(data)- nbFrames*M;
    temp(1:lastLength) = data(nbFrames*M+1:(nbFrames*M +1 + lastLength-1));  
    Frames(nbFrames+1, 1:N) = temp;
    %% (2) Windowing..
    frameSize = size(Frames); 
    nbFrames = frameSize(1); 
    nbSamples = frameSize(2); 
 
    % Hamming window.. 
    w = hamming(nbSamples); 
    Windows = zeros(nbFrames,nbSamples);
    for i = 1:nbFrames
        temp = Frames(i,1:nbSamples); 
        Windows(i, 1:nbSamples) = w'.*temp; 
    end
    %% (3) Fourier Transform..
    ffts = fft(Windows');
    %% (4) Mel-frequency Wrapping..
    % (a) Calculate Power spectrum..
    PS = abs(ffts).^2;
    PS = PS(1:NN-1,:);
