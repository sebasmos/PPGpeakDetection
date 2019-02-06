function salida = caract(x,Fs)
<<<<<<< HEAD
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
[Frequency_amp,Frequency] = PreProcessing(x,Fs); % Realiza el ventaneo de Haming, devuelve las frecuencias centrales,
%                                                               potencia de promedio y frecuencias fundamentales de cada espectro de una ventana
%% Desviaciòn estàndar
=======
% Entradas: x -> seÃ±al de voz, 
%           Fs -> Frecuencia de muestreo
% Se asume que la seÃ±al de voz ya ha sido preprocesada

%% CaracterÃ¬sticas del espectro completo de la seÃ±al
% Frecuencia promedio y Mediana del espectro completo de la seÃ±al
[mediaF,medianF,~,~] = centerfreq(Fs,x); % Calcula la frecuencia media donde el espectro de la seÃ±al completa tiene su mayor potencia
%% CaracterÃ¬sticas de las frecuencias melÃ²dicas de la voz
% Estas caracterÃ¬sticas se obtienen luego de aplicar la FFT a un conjunto
% de ventanas mÃ²viles sobre la seÃ±al de voz, para detectar los "tonos" en
% la seÃ±al de voz
[Frequency_amp,Frequency,FunFrequency] = PreProcessing(x,Fs); % Realiza el ventaneo de Haming, devuelve las frecuencias centrales,
%                                                               potencia de promedio y frecuencias fundamentales de cada espectro de una ventana
%% DesviaciÃ²n estÃ ndar
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
sd = std(Frequency);
%% Primer cuantil
Q25 = quantile(Frequency,0.25);
%% Cuarto cuantil
Q75 = quantile(Frequency,0.75);
%% Rango intercuantil
IQR = iqr(Frequency);
<<<<<<< HEAD
%% Asimetrìa
skew = skewness(Frequency);
%% Kurtosis
kurt = kurtosis(Frequency);
%% Entropìa espectral
=======
%% AsimetrÃ¬a
skew = skewness(Frequency);
%% Kurtosis
kurt = kurtosis(Frequency);
%% EntropÃ¬a espectral
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
spent = -sum(Frequency_amp.*log(Frequency_amp))./log(length(Frequency));
%% Achatamiento del espectro
sfm = geomean(Frequency)/mean(Frequency);
%% Moda de la frecuancia
modfrec = mode(Frequency);
<<<<<<< HEAD
%% Las siguientes caracterìsticas se extraen con base en las frecuencias fundamentales (tonos) de la voz
%% Frecuancia fundamental promedio
%meanfun = mean(FunFrequency);
%% Frecuencia fundamental mìnima
%minfun = min(FunFrequency);
%% Frecuancia fundamental màxima
%maxfun = max(FunFrequency);

salida = [mediaF,medianF,sd,Q25,Q75,IQR,skew,kurt,spent,sfm,modfrec];


=======
%% Las siguientes caracterÃ¬sticas se extraen con base en las frecuencias fundamentales (tonos) de la voz
%% Frecuancia fundamental promedio
meanfun = mean(FunFrequency);
%% Frecuencia fundamental mÃ¬nima
minfun = min(FunFrequency);
%% Frecuancia fundamental mÃ xima
maxfun = max(FunFrequency);

salida = [mediaF,medianF,sd,Q25,Q75,IQR,skew,kurt,spent,sfm,modfrec,meanfun,minfun,maxfun];
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
