
function Noise = GetSavitzkyNoise(name,n,m,s)
    ppg=load(name);
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(n,(m:s));
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSI�N A VARIABLES F�SICAS
    s2 = (pfinal-128)/(255);
% NORMALIZACI�N POR M�XIMOS Y M�NIMOS
    sNorm = (s2-min(s2))/(max(s2)-min(s2));
%% Grafica del espectro de potencia
    sfilt=sgolayfilt(sNorm,3,41);
    %media = ValoresMedia(sNorm);
    Noise=sNorm-sfilt;
    

end