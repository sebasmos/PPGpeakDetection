addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');


%% WE READ THE DATASETS
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
%% OBTAIN HIGH FREQUENCY NOISE 
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
end
%% STACK THEM IN ONE BIG MATRIX
V=[s s1 s2 s3 s4 s5];
MediaMuestral=mean(V);
%% OBTAIN CORRELATION AND COVARIANCE MATRIX
[L,A]=size(V);
i=1;
j=1;
for t1=1:100:A
    for t2=1:100:A
        values=V(:,t1)'*V(:,t2);
        Rxx(i,j)=values/L;
        Kxx(i,j)=Rxx(i,j)-(MediaMuestral(t1).*MediaMuestral(t2));
        j=j+1;
    end
    i=i+1;
    j=1;
end
%% PLOT THEM
t1=1:length(Kxx);
t2=1:length(Kxx);
[t1,t2]=meshgrid(t1,t2);
figure(1),waterfall(t1,t2,Rxx),xlabel('t1'),ylabel('t2'),zlabel('Rxx(t1,t2)'),title('Funcion de autocorrelación');
figure(2),waterfall(t1,t2,Kxx),xlabel('t1'),ylabel('t2'),zlabel('Kxx(t1,t2)'),title('Funcion de autocovarianza');

%% COMPUTE SPECTRUM OF THE NOISES
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