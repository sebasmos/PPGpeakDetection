
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
