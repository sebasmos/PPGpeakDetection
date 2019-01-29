function [Frequency_amp,Frequency] = PreProcessing(x,Fs)
[PS,NN,nFrames] = PowSpecs(x);
f = Fs/2*linspace(0,1,NN-1);
Frequency = zeros(NN-1,1);
Frequency_amp = zeros(NN-1,1);
for i = 1:nFrames
    P = PS(:,i);
    Pmax = max(P);
    abovecutoff = find(P==Pmax,1,'first');
    Frequency(i) = f(abovecutoff);
    Frequency_amp(i) = P(abovecutoff);
end
%FunFrequency=getF0(x,Fs);


