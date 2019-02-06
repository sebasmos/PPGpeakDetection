function [mediaF,medianF,f,dP] = centerfreq(Fs,x)
% Entrada: Fs -> Frecuencia de muestreo
<<<<<<< HEAD
%          x -> Señal de voz preprocesada
% Salida: mF: Frecuencia media donde està el mayor contenido de potencia de
=======
%          x -> SeÃ±al de voz preprocesada
% Salida: mF: Frecuencia media donde estÃ  el mayor contenido de potencia de
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
% la voz
%         f -> vector de frecuencias del espectro
%         dP -> vector de Potencia en decibeles
L = max(size(x));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
dP = 20*log10(abs(fft(x,NFFT)));
f = Fs/2*linspace(0,1,NFFT/2+1);
dP = dP(1:NFFT/2+1);
dPmax = max(dP);
abovecutoff = dP > dPmax-3;   %3 dB is factor of 2
lowbin = find(abovecutoff, 1, 'first');
higbin = find(abovecutoff, 1, 'last');
mediaF = mean([f(lowbin),f(higbin)]);
<<<<<<< HEAD
medianF = median([f(lowbin),f(higbin)]);


=======
medianF = median([f(lowbin),f(higbin)]);
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
