clc;
clear all;

data=load('DATA_01_TYPE01.mat');
cuad=data.sig;
ppg1=cuad(2,(1:5000));
ppg2=cuad(3,(1:5000));
accx=cuad(4,:);
Fs=125;

maxp1=max(ppg1);
maxp2=max(ppg2);
minp1=min(ppg1);
minp2=min(ppg2);

norm1=(ppg1-minp1)/(maxp1-minp1);
norm2=(ppg2-minp2)/(maxp2-minp2);

t=(0:length(norm1)-1)/Fs;



Npuntosds = 2^nextpow2(Fs/2/10);
wds = hanning(Npuntosds);

[Pds,Fds] = pwelch(norm1,wds,Npuntosds/2,Npuntosds,Fs);
df = designfilt('bandstopiir','PassbandFrequency1',1,...
'StopbandFrequency1',5,'StopbandFrequency2',40,...
'PassbandFrequency2',45,'PassbandRipple1',0.01,...
'StopbandAttenuation',60,'PassbandRipple2',0.01,...
'SampleRate',Fs,'DesignMethod','ellip');
% Analyze the magnitude response
% hfvt = fvtool(df,'Fs',Fs,'FrequencyScale','log',...
% 'FrequencyRange','Specify freq. vector','FrequencyVector',Fds(Fds>F(2)));
ybs = filtfilt(df,norm1);

figure
subplot(2,1,2)
plot(norm1),grid on
hold on
plot(norm1(1:200))
subplot(2,2,2)
plot(norm1),grid on, hold on, plot(ybs)


%[pks,locs]=findpeaks(norm1(1:200));
%plot (locs,pks,'o')

% figure(1)
% plot(t,norm1), grid on
% 
%  figure(2)
%  plot(t,norm2), grid on
% [Pxx2,Fx2]=pwelch(norm2,hanning(length(norm1)),0,length(norm1),Fs);
% figure(3)
% plot(Fx2,10*log10(Pxx2))

%% ALGORITMO ADAPTATIVO
minhr=69;
maxhr=166;
first_value=Fs*60/(maxhr/3);
second_value=Fs*60/(minhr/3);
ii=0;
x=length(ppg1);
critation=0;

if(ii==0)
    ii=0;
    critation=critation+0.1;
    segment=first_value;1
   
else
    
end