<<<<<<< HEAD
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
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11250,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18750,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26250,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33750,35989);
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k,:) = length(a.sig);
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11250,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18750,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26250,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33750,35989);
    end
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s(k,:);
    sm2 = sm2 + s(k,:);
    sm3 = sm3 + s(k,:);
    sm4 = sm4 + s(k,:);
    sm5 = sm5 + s(k,:);
end
%% PROMEDIO DE LOS RUIDOS
total1 = sm0./12;
plot(total1);
=======

clear all
clc
%% RUIDO EN REPOSO PRIMEROS 30 SEGUNDOS
k=0;
suma = 0;
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),3,1,3750);
    else
    labelstring = int2str(k);
    word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
    s(k,:) =  GetSavitzkyNoise(char(word),3,1,3750);
    end
    suma = suma + s(k,:);
end
%% PROMEDIO DE LOS RUIDOS
total1 = suma./12;
plot(total1);
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
