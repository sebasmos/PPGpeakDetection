addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
clc;
close all;
%% WE READ THE DATASETS
Fs=125;
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
%% OBTAIN HIGH FREQUENCY NOISE SINCE LOW FREQUENCY IS NOT IMPORTANT
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        s1(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s5(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s6(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    else       
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        s1(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s5(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s6(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    end
end
%% STACK THEM IN ONE BIG MATRIX
T=[s1 s2 s3 s4 s5 s6];
V=hampel(T',10,1);
V=V';
MediaMuestral=mean(V); %% Esta es la media para las 12 realizaciones.
MediaActividad1=MediaMuestral(1:3750);
MediaActividad2=MediaMuestral(3751:11250);
MediaActividad3=MediaMuestral(11251:18750);
MediaActividad4=MediaMuestral(18751:26250);
MediaActividad5=MediaMuestral(26251:33750);
MediaActividad6=MediaMuestral(33751:min(TamRealizaciones));

%% OBTAIN CORRELATION AND COVARIANCE MATRIX FOR EACH ACTIVITY
[L,A]=size(V);
i=1;
j=1;
s1=V(:,(1:3750));
s6=V(:,(33751:min(TamRealizaciones))); %redeclaramos los ruidos suavizados
%Para actividades de 30 segundos
for t1=1:10:length(s1)
    for t2=1:10:length(s1)
        if(t1<=length(s6) && t2<=length(s6))
            Rxx1(i,j)=(s1(:,t1)'*s1(:,t2))/L;
            Kxx1(i,j)=Rxx1(i,j)-(MediaActividad1(t1).*MediaActividad1(t2));
            Rxx6(i,j)=(s6(:,t1)'*s6(:,t2))/L;
            Kxx6(i,j)=Rxx6(i,j)-(MediaActividad6(t1).*MediaActividad6(t2));
        else
            Rxx1(i,j)=(s1(:,t1)'*s1(:,t2))/L;
            Kxx1(i,j)=Rxx1(i,j)-(MediaActividad1(t1).*MediaActividad1(t2));
        end
        j=j+1;
    end
    i=i+1;
    j=1;
end
%Para actividades de 1 minuto
i=1;
for t1=1:10:length(s2)
    for t2=1:10:length(s2)
        Rxx2(i,j)=(s2(:,t1)'*s2(:,t2))/L;
        Kxx2(i,j)=Rxx2(i,j)-(MediaActividad2(t1).*MediaActividad2(t2));
        Rxx3(i,j)=(s3(:,t1)'*s3(:,t2))/L;
        Kxx3(i,j)=Rxx3(i,j)-(MediaActividad3(t1).*MediaActividad3(t2));
        Rxx4(i,j)=(s4(:,t1)'*s4(:,t2))/L;
        Kxx4(i,j)=Rxx4(i,j)-(MediaActividad4(t1).*MediaActividad4(t2));
        Rxx5(i,j)=(s5(:,t1)'*s5(:,t2))/L;
        Kxx5(i,j)=Rxx5(i,j)-(MediaActividad5(t1).*MediaActividad5(t2));
        j=j+1;
    end
    i=i+1;
    j=1;
end

%Para todo el conjunto de datos
i=1;
for t1=1:100:length(V)
    for t2=1:100:length(V)
        RxxTotal(i,j)=(V(:,t1)'*V(:,t2))/L;
        KxxTotal(i,j)=RxxTotal(i,j)-(MediaMuestral(t1).*MediaMuestral(t2));
        j=j+1;
    end
    i=i+1;
    j=1;
end
%% PLOT THEM
t1=(0:length(KxxTotal)-1)/Fs;
t2=(0:length(KxxTotal)-1)/Fs;
[t1,t2]=meshgrid(t1,t2);
figure(1),waterfall(t1,t2,RxxTotal),xlabel('t1'),ylabel('t2'),zlabel('Rxx(t1,t2)'),title('Funcion de autocorrelación');
figure(2),waterfall(t1,t2,KxxTotal),xlabel('t1'),ylabel('t2'),zlabel('Kxx(t1,t2)'),title('Funcion de autocovarianza');

%% COMPUTE POWER SPECTRAL DENSITY

%% COMPUTE SPECTRUM OF THE NOISES AND PLOT IT
for i=1:12
    EspectroRuido(i,:)=fft(V(i,:),100);
end
EspectroRuido=abs(EspectroRuido);
figure(3),
plot(EspectroRuido(1,:)),hold on,
plot(EspectroRuido(2,:)),hold on,
plot(EspectroRuido(3,:)),hold on,
plot(EspectroRuido(4,:)),hold on,
plot(EspectroRuido(5,:)),hold on,
plot(EspectroRuido(6,:)),hold on,
plot(EspectroRuido(7,:)),hold on,
plot(EspectroRuido(8,:)),hold on,
plot(EspectroRuido(9,:)),hold on,
plot(EspectroRuido(10,:)),hold on,
plot(EspectroRuido(11,:)),hold on,
plot(EspectroRuido(12,:)),hold on,grid on, axis tight

%% LET'S SEE HOW MEAN AND VARIANCE EVOLVE IN TIME

t=(0:length(V)-1)/Fs;
t30s=(0:length(s1)-1)/Fs;
t1m=(0:length(s3)-1)/Fs;
tend=(0:length(s6)-1)/Fs;
VarianzaMuestral=var(V);
DesvEstandarMuestral=std(V);
figure(1),
plot(t30s,s1),hold on,plot(t30s,MediaActividad1,'-k','LineWidth',3),hold on,plot(t30s,DesvEstandarMuestral(1:3750),'-r','LineWidth',3)
grid on, axis tight,title('Evolución de la media y la stdev muestral (insesgada) para la Actividad 1'), xlabel('Tiempo (segundos)')
legend('','','','','','','','','','','','','MediaMuestral','Desviacion estandar')

figure(2),
plot(t1m,s2),hold on,plot(t1m,MediaActividad2,'-k','LineWidth',3),hold on,plot(t1m,DesvEstandarMuestral(3751:11250),'-r','LineWidth',3)
grid on, axis tight,title('Evolución de la media y la stdev muestral (insesgada) para la Actividad 2'), xlabel('Tiempo (segundos)')
legend('','','','','','','','','','','','','MediaMuestral','Desviacion estandar')

figure(3),
plot(t1m,s3),hold on,plot(t1m,MediaActividad3,'-k','LineWidth',3),hold on,plot(t1m,DesvEstandarMuestral(11251:18750),'-r','LineWidth',3)
grid on, axis tight,title('Evolución de la media y la stdev muestral (insesgada) para la Actividad 3'), xlabel('Tiempo (segundos)')
legend('','','','','','','','','','','','','MediaMuestral','Desviacion estandar')

figure(4),
plot(t1m,s4),hold on,plot(t1m,MediaActividad4,'-k','LineWidth',3),hold on,plot(t1m,DesvEstandarMuestral(18751:26250),'-r','LineWidth',3)
grid on, axis tight,title('Evolución de la media y la stdev muestral (insesgada) para la Actividad 4'), xlabel('Tiempo (segundos)')
legend('','','','','','','','','','','','','MediaMuestral','Desviacion estandar')

figure(5),
plot(t1m,s5),hold on,plot(t1m,MediaActividad5,'-k','LineWidth',3),hold on,plot(t1m,DesvEstandarMuestral(26251:33750),'-r','LineWidth',3)
grid on, axis tight,title('Evolución de la media y la stdev muestral (insesgada) para la Actividad 5'), xlabel('Tiempo (segundos)')
legend('','','','','','','','','','','','','MediaMuestral','Desviacion estandar')

figure(6),
plot(tend,s6),hold on,plot(tend,MediaActividad6,'-k','LineWidth',3),hold on,plot(tend,DesvEstandarMuestral(33751:end),'-r','LineWidth',3)
grid on, axis tight,title('Evolución de la media y la stdev muestral (insesgada) para la Actividad 6'), xlabel('Tiempo (segundos)')
legend('','','','','','','','','','','','','MediaMuestral','Desviacion estandar')
% subplot(2,1,1),plot(t,MediaMuestral),grid on, axis tight
% xlabel('Tiempo (segundos)'), title('Media y varianza muestral de las 12 realizaciones'),legend('Media'),
% subplot(2,1,2),plot(t,VarianzaMuestral,'-r'),grid on, axis tight
% xlabel('Tiempo (segundos)'),legend('Varianza')
