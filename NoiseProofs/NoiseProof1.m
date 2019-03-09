clear all
clc
%% RUIDO EN REPOSO PRIMEROS 30 SEGUNDOS
k=0;
sm0=0;
sm1=0;
sm2=0;
sm3=0;
sm4=0;
sm5=0;

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
    % Cï¿½lculo de Media Muestral
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s1(k,:);
    sm2 = sm2 + s2(k,:);
    sm3 = sm3 + s3(k,:);
    sm4 = sm4 + s4(k,:);
    sm5 = sm5 + s5(k,:);

end

%% MEDIA MUESTRAL
%ORGANIZAMOS LOS RUIDOS EN UNA MATRIZ PARA LUEGO PODER SACAR LAS MEDIAS 
%MUESTRALES DIVIDIENDO TODA LA MATRIZ ENTRE EL NUMERO DE REALIZACIONES.

% M representa la suma de las 12 realizaciones para los 6 tipos diferentes
% de ruido; Por tanto tiene la forma de 6 filas de ruidos y cada uno con un
% tamaño seleccionado de 7500 muestras cada uno.

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;

% Al realizar un promedio vertical, la suma también es vertical, por tanto
% la media corresponde al promedio plano de cada una de las filas.
Media0 = M./Realizaciones;
% Reorganizamos las filas en una sola fila y le quitamos los ceros.
v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];
mediamuestral=nonzeros(v);
% De manera que media muestral tiene una señal promedio de todas las
% señales unidas en una sola fila.
mediamuestral=mediamuestral';

%SEÑAL MUESTRA
ppg = load('DATA_10_TYPE02.mat');
ppgSig = ppg.sig;
ppgFullSignal = ppgSig(2,(1:length(mediamuestral)));%Emparejamos tamaños 
%FRECUENCIA MUESTREO:
Fs = 125;
%NORMALIZACIONES
ppgFullSignal = (ppgFullSignal-128)./255;
ppgFullSignal = (ppgFullSignal-min(ppgFullSignal))./(max(ppgFullSignal)-min(ppgFullSignal));
t = (0:length(ppgFullSignal)-1);   
%AÑADIR RUIDO
ruido1 = mediamuestral(1,(1:3750));
ruido2 = mediamuestral(1,(3751:11250));
ruido3 = mediamuestral(1,(11251:18750));
ruido4 = mediamuestral(1,(18751:26250));
ruido5 = mediamuestral(1,(26251:33750));

CorruptedSignal1 = ppgFullSignal(1,(1:3750))-ruido1;
CorruptedSignal2 = ppgFullSignal(1,(3751:11250))-ruido2;
CorruptedSignal3 = ppgFullSignal(1,(11251:18750))-ruido3;
CorruptedSignal4 = ppgFullSignal(1,(18751:26250))-ruido4;
CorruptedSignal5 = ppgFullSignal(1,(26251:33750))-ruido5;

% ORIGINAL en reposo vs con ruido
[PKS1Original,LOCS1Original] = GetPeakPoints(ppgFullSignal(1,(1:3750)),Fs,0.11,0.5,0.05);
[PKS1ruido,LOCS1ruido] = GetPeakPoints(CorruptedSignal1,Fs,0.11,0.5,0.05);
% CORRIENDO 1min señal original vs con ruido
[PKS2Original,LOCS2Original] = GetPeakPoints(ppgFullSignal(1,(3751:11250)),Fs,0.11,0.5,0.15);
[PKS2ruido,LOCS2ruido] = GetPeakPoints(CorruptedSignal2,Fs,0.11,0.5,0.15);
% CORRIENDO 1min señal original vs con ruido
[PKS3Original,LOCS3Original] = GetPeakPoints(ppgFullSignal(1,(11251:18750)),Fs,0.11,0.5,0.15);
[PKS3ruido,LOCS3ruido] = GetPeakPoints(CorruptedSignal3,Fs,0.11,0.5,0.15);
% CORRIENDO 1min señal original vs con ruido
[PKS4Original,LOCS4Original] = GetPeakPoints(ppgFullSignal(1,(18751:26250)),Fs,0.11,0.5,0.15);
[PKS4ruido,LOCS4ruido] = GetPeakPoints(CorruptedSignal4,Fs,0.11,0.5,0.15);
% CORRIENDO 1min señal original vs con ruido
[PKS5Original,LOCS5Original] = GetPeakPoints(ppgFullSignal(1,(26251:33750)),Fs,0.11,0.5,0.15);
[PKS5ruido,LOCS5ruido] = GetPeakPoints(CorruptedSignal5,Fs,0.11,0.5,0.15);
