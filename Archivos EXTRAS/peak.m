%% PROGRAM : 
% ECG PEAK DETECTION - MARK PEAKS WITH RED COLOUR 
%% TASK UNDER PROGRAM 4:
% (4-a) Plot HRV  using stairs function  & Poincare plot  
% (4-b) Calculate  stastical parameters 
% (4/1) Try using "comet" instead of plot for ecg plotting for 1st 1000
% samples
%% THINGS TO KNOW 
% 1. How Peak detection algorithm works -Theory
% 2. Smooth function is not absolute necessary
% 3. Also learn Pantompkins algorithm for peak detection 
% 4. Learn the concept of template matching and convolution
% 5. why variable 'time' and 'm' have zeros in them
%% SOLUTION 4:
clc; 
clear all;
close all;
set=load('DATA_01_TYPE01.mat');
variables = set.sig;
ecg = variables(1,(1:5000));
vmax = 0.6392;
vmin = -4.5176;
s1 = (ecg-128)/255;
s1Norm = (s1-vmin)/(vmax-vmin);
f_s=125;
N=length(s1Norm);
t=[0:N-1]/f_s; %time period(total sample/Fs )
figure
plot(t,s1Norm,'r'); title('Raw ECG Data plotting ')             
xlabel('time')
ylabel('amplitude')
w=50/(125/2);
bw=w;
[num,den]=iirnotch(w,bw); % notch filter implementation 
ecg_notch=filter(num,den,ecg);
[e,f]=wavedec(ecg_notch,10,'db6');% Wavelet implementation
g=wrcoef('a',e,f,'db6',8); 
ecg_wave=ecg_notch-g; % subtracting 10th level aproximation signal
                       %from original signal                  
ecg_smooth=smooth(ecg_wave); % using average filter to remove glitches
                             %to increase the performance of peak detection 
N1=length(ecg_smooth);
t1=(0:N1-1)/f_s;
figure,plot(t1,ecg_smooth),ylabel('amplitude'),xlabel('time')
title('Filtered ECG signal')
% Peak detection algorithm 
% For more detailsor detailed explanation on this look into 
% Matlab for beginers 
hh=ecg_smooth;
 j=[];           %loop initialing, having all the value zero in the array
time=0;          %loop initialing, having all the value zero in the array
th=0.45*max(hh);  %thresold setting at 45 percent of maximum value
 
for i=2:N1-1 % length selected for comparison  
    % deopping first ie i=1:N-1  point because hh(1-1) 
   % in the next line  will be zero which is not appreciable in matlab 
    if((hh(i)>hh(i+1))&&(hh(i)>hh(i-1))&&(hh(i)>th))  
% condition, i should be> then previous(i-1),next(i+1),thrsold point;
        j(i)=hh(i);                                   
%if condition satisfy store hh(i)in place of j(i)value whichis initially 0;
       
        time(i)=[i-1]/250;           %position stored where peak value met;              
      
    end
end
 j(j==0)=[];               % neglect all zeros from array;
 time(time==0)=[];     % neglect all zeros from array;
m=(time)';               % converting rows in column;
k=length(m);
figure;
plot(t,hh);            %x-axis time, y-smooth signal value;
hold on;                 % hold the plot and wait for next instruction;
plot(time,j,'*r'); title('PEAK POINTS DETECTED IN ECG SIGNAL')    
%x-axis time, yaxis-peak value,r=marker;
xlabel('time')
ylabel('amplitude')
hold off                 % instruction met;
%%  Task 4-a
% to remove unwanted zeros from variable j and time 
rr2=m(2:k);     %second array from 2nd to last point;
rr1=m(1:k-1);   %first array from 1st to 2nd last point;
% rr2 & rr1 is of equall length now;
rr3=rr2-rr1;
hr=60./rr3;         % computate heart rate variation ;
figure;
stairs(hr); title(' DISPLAY HRV') % stairs are used to show the variation 
rr33=(rr3)';
ki=length(rr33);
rr4=rr33(2:ki); 
rr5=rr33(1:ki-1);
figure(7);
plot(rr4,rr5,'r*') %plot  R-R(n)(X-Axis) vs R-R(n-1)(Y-Axis)
 title('POINCARE PLOT'), xlabel('RR(n+1)') ,ylabel('RR(n)')
 %% Task 4-b
ki=length(rr3) ;
ahr=mean(hr);       % mean heart rate;
disp(['mean hrv = ' num2str(ahr)]); 
% disp is used to display the value(s);
SDNN = std(rr3); 
% SDNN, standard deviation for RR interval used in statical analysis;
disp(['SDNN = ' num2str(SDNN)]);
sq = diff(rr3).^2;
rms = sqrt(mean(sq)); % RMSSD,
disp(['RMSSD = ' num2str(rms)]);  
% RMS difference for RR interval used in statical analysis;
 
NN50 = sum(abs(diff(rr3))>.05); 
% NN50 no. of pairs of RR that is more than 50, used in statical analysis;
disp(['NN50 = ' num2str(NN50)]);
%% Try 4/3
%figure,
%comet(ecg_smooth(1:1000))