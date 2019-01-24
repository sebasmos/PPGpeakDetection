function salida = caract(x,Fs)
% Entradas: x -> señal de voz, 
%           Fs -> Frecuencia de muestreo
% Se asume que la señal de voz ya ha sido preprocesada

%% Caracterìsticas del espectro completo de la señal
% Frecuencia promedio y Mediana del espectro completo de la señal
[mediaF,medianF,~,~] = centerfreq(Fs,x); % Calcula la frecuencia media donde el espectro de la señal completa tiene su mayor potencia
%% Caracterìsticas de las frecuencias melòdicas de la voz
% Estas caracterìsticas se obtienen luego de aplicar la FFT a un conjunto
% de ventanas mòviles sobre la señal de voz, para detectar los "tonos" en
% la señal de voz
[Frequency_amp,Frequency,FunFrequency] = PreProcessing(x,Fs); % Realiza el ventaneo de Haming, devuelve las frecuencias centrales,
%                                                               potencia de promedio y frecuencias fundamentales de cada espectro de una ventana
%% Desviaciòn estàndar
sd = std(Frequency);
%% Primer cuantil
Q25 = quantile(Frequency,0.25);
%% Cuarto cuantil
Q75 = quantile(Frequency,0.75);
%% Rango intercuantil
IQR = iqr(Frequency);
%% Asimetrìa
skew = skewness(Frequency);
%% Kurtosis
kurt = kurtosis(Frequency);
%% Entropìa espectral
spent = -sum(Frequency_amp.*log(Frequency_amp))./log(length(Frequency));
%% Achatamiento del espectro
sfm = geomean(Frequency)/mean(Frequency);
%% Moda de la frecuancia
modfrec = mode(Frequency);
%% Las siguientes caracterìsticas se extraen con base en las frecuencias fundamentales (tonos) de la voz
%% Frecuancia fundamental promedio
meanfun = mean(FunFrequency);
%% Frecuencia fundamental mìnima
minfun = min(FunFrequency);
%% Frecuancia fundamental màxima
maxfun = max(FunFrequency);

salida = [mediaF,medianF,sd,Q25,Q75,IQR,skew,kurt,spent,sfm,modfrec,meanfun,minfun,maxfun];


