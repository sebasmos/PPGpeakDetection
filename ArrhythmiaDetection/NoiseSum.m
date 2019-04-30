%%Este script es para sumar el ruido a las señales PPG

%PRIMERO DEBEMOS INTERPOLAR LA SEÑAL QUE YA TENEMOS

a=load('TotalMA');
MANoise=a.TotalMA;
b=load('BRADPPGShort');
Bradycardia=b.BRADPPGShort;
BradycardiaS1=Bradycardia(1,:); %%escogemos esta como prueba

UpsampledMANoise=interp(MANoise,2);
%vamos a ver cuanto espacio de tiempo antes y despues necesitamos 

L=length(BradycardiaS1)-length(UpsampledMANoise);

if(mod(L,2)==0)
    SumMANoise=[zeros(1,L/2) UpsampledMANoise zeros(1,L/2)];
else 
    SumMANoise=[zeros(1,floor(L/2)) UpsampledMANoise zeros(1,ceil(L/2))];
end

% SEGUNDO TENEMOS QUE NORMALIZAR LA SEÑAL BRADY DADO QUE EL RUIDO ESTÁ
% NORMALIZADO

BradycardiaS1=(BradycardiaS1-min(BradycardiaS1))/(max(BradycardiaS1)-min(BradycardiaS1));
BradycardiaS2=detrend(BradycardiaS1);
BradycardiaNoisy=BradycardiaS2+SumMANoise;