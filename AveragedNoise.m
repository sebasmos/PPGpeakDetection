
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
    % C�lculo de Media Muestral
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

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;
Media0 = M./Realizaciones;
v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];
mediamuestral=nonzeros(v);
mediamuestral=mediamuestral';

%% VARIANZA INSESGADA

V1=[s s1 s2 s3 s4 s5];
varianzamuestral= var(V1);

%% MATRIZ DE AUTOCORRELACION Y AUTOCOVARIANZA


% val=[];
% i=1;
% j=1;
% [a,b]=size(V);
% for t1=1:12
%     val(t1,:) = xcorr(V(t1,:));
% end
% mesh(val)

values=[];
i=1;
j=1;
[a,b]=size(V1);
for t1=1:10:b
    for t2=1:10:b
        for k=1:12

            values(k)=V(k,t1).*V(k,t2);

        end
        Rxx(i,j)=mean(values);
        Kxx(i,j)=Rxx(i,j)-(mediamuestral(t1).*mediamuestral(t2));
        j=j+1;
        values=[];
    end
    i=i+1;
    j=1;
end

%% DENSIDAD ESPECTRAL DE POTENCIA

for i=1:length(Rxx)
    tf(i,:)=fft(Rxx(i,:));
end

tf=(abs(tf)).^2;
PSD=tf./2;

