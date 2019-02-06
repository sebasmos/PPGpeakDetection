<<<<<<< HEAD
function [Frequency_amp,Frequency] = PreProcessing(x,Fs)
=======
function [Frequency_amp,Frequency,FunFrequency] = PreProcessing(x,Fs)
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
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
<<<<<<< HEAD
%FunFrequency=getF0(x,Fs);


=======
FunFrequency=getF0(x,Fs);
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
