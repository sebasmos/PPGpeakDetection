
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
        TamRealizaciones(k,:) = length(a.sig);
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k,:) = length(a.sig);
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
    % Cálculo de Media Muestral
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s(k,:);
    sm2 = sm2 + s(k,:);
    sm3 = sm3 + s(k,:);
    sm4 = sm4 + s(k,:);
    sm5 = sm5 + s(k,:);
       
end
%% MEDIA MUESTRAL
Realizaciones = 12;
Media0 = sm0./Realizaciones;
%% VARIANZA INSESGADA: Cálculo de varianza insesgada: divide entre (n-1)
%the standard deviation var is normalized by N-1, where N is the number of observations.
Varianza0 = VarianzaMuestral(Realizaciones,s);
x = 0:0.1:10; 
%% FUNCIONES DE DENSIDAD DE PROBABILIDAD LOCALES
y = normpdf(x,Media0(1,1),Varianza0(1,1));
for i=1:10:3750
   % x =0.01:0.01:37.5;
  % x = 0:0.1:10; 
   %y0(i) = normpdf(x,Media0(1,i),Varianza0(1,i));
    %plot(y0(i)), hold on
end

