%% BASIC CODE BY ABHIJITH BAILUR
%% 9945757753 - BAILURABHIJITH@GMAIL.COM
clc;
clear all;
close all;
x=load('day2_0917.txt');
%% ECG signal
y=x(1:95000,1); % ECG signal
figure,plot(y);
title('ECG signal');
xlabel('time');
ylabel('amplitude');
hold on

%% PPG signal

z=x(200:95000,2); % PPG signal
figure,plot(z,'r');
title('PPG signal');
xlabel('time');
ylabel('amplitude');
hold on
%% peak detection of ECG
j=1;
n=length(y);
for i=2:n-1
    if y(i)> y(i-1) && y(i)>= y(i+1) && y(i)> 0.45*max(y)
       val(j)= y(i);
       pos(j)=i;
       j=j+1;
     end
end
ecg_peaks=j-1;
ecg_pos=pos./1000;
plot(pos,val,'*r');
title('ECG peak');
hold on
%% peak detection of PPG
m=1;
n=length(z);
for i=2:n-1
    if z(i)> z(i-1) && z(i)>= z(i+1) && z(i)> 0.45*max(z)
       val(m)= z(i);
       pos1(m)=i;
       m=m+1;
     end
end
ppg_peaks=m-1;
ppg_pos=pos1./1000;
ppg_val=val;
plot(pos1,val,'*g');
title('ECG & PPG signal');
legend('ECG signal','PPG signal');

%% HRV
j=1;
for i=1:ecg_peaks-1
    e(j)= ecg_pos(i+1)-ecg_pos(i);% gives RR interval
    j=j+1;
    
end 
hr=60./mean(e); % 60/ mean of RR interval

hrv= (60./e); % 60/ each RR interval
figure,stairs(hrv);
title('HRV');
xlabel('samples');
ylabel('hrv');

%% PRV
k=1;
for i=1:ppg_peaks-1
    f(k)= ppg_pos(i+1)-ppg_pos(i); 
    k=k+1;
end 
pr=60./mean(f); 
prv= 60./f; 
figure,stairs(prv);
title('PRV');
xlabel('samples');
ylabel('prv');
%% PTT
ptt=(ppg_pos-ecg_pos);
figure,stairs(ptt);
title('PTT');
xlabel('ptt');
ylabel('time');

%% notch detection

%%moving average filter
av=smooth(z,150);

%%differentiation
p=100*diff(av,1); % (signal,order of differentiation), 100 to amplify the signal

%%finding peak of the notch on the differentiated signal
np=1;  % notch peak
m=length(p); 
for i=2:m-1
    if p(i)> p(i-1) && p(i)>= p(i+1) 
       val(np)= p(i);
       pos(np)=i;
       np=np+1;
    end
end
u=1;
for j=1:2:length(pos) 
    notch_pos(u)=pos(j);
    notch_val(u)=val(j);
    u=u+1;
end

n_val=z(notch_pos);

%% reflection index = b/a *100
%b=diff between notch and peak in y axis
%a=ppg peak value in y axis
nv=n_val(2,:)';
ri=((ppg_val-nv)./ppg_val)*100;
ref_index=mean(ri)

%% stiffness index = h/ptt; 
h=0.60;%h is the length from subject's finger tip to heart
si=(h./ptt);
stif_index=mean(si)

