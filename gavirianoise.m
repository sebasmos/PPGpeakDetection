%% GAVIRIA'S APPROACH:
%In the third approach to a signal's noise we have as a tool a linear
%predictor, which is fed with the mean signal, in the case of the example
%with the ECG. What we have to do is, for each activity, establish which y
%the approximate period of a single cycle of the signal and, in this way,
%obtain a mean signal for every movement (given that the heart rate varies
%over time with each activity). Finally, in this first step we'll fed the
%linear predictor with the PPG average signal and substract this from the
%original, obtaining a first approach of the 'noise'.

%We get the signals.

for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    end
end

%We determine sample frequency
    Fs = 125;
% And convert to physical variables according to the literature.
    s2 = (Realizaciones-128)/(255);
% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
end

% Just plotting it, this can be commented.
    [a,b]=size(sNorm);
    t=(0:b-1)/Fs;
    hax=axes;
    SP1=3750/Fs;
    SP2=SP1+7500/Fs;
    SP3=SP2+7500/Fs;
    SP4=SP3+7500/Fs;
    SP5=SP4+7500/Fs;
    SP6=SP5+3750/Fs;
    figure(1),plot(t,sNorm(1,:))
    grid on, axis tight, xlabel('Tiempo'),ylabel('PPGsignal'),hold on,
    line([SP1 SP1],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP2 SP2],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP3 SP3],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP4 SP4],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP5 SP5],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP6 SP6],get(hax,'YLim'),'Color',[1 0 0]);
    
    
%% FOR EVERY ACTIVITY, WE SHOULD DETREND THE SIGNAL SO IT'S EASIER TO GET 
%THE PEAKS

sactivity1=sNorm(:,(1:3750));
sactivity2=sNorm(:,(3751:11250));
sactivity3=sNorm(:,(11251:18750));
sactivity4=sNorm(:,(18751:26250));
sactivity5=sNorm(:,(26251:33750));
sactivity6=sNorm(:,(33751:end));

for k=1:12
    activity1(k,:)=Detrending(sactivity1(k,:),5);
    activity2(k,:)=Detrending(sactivity2(k,:),5);
    activity3(k,:)=Detrending(sactivity3(k,:),5);
    activity4(k,:)=Detrending(sactivity4(k,:),5);
    activity5(k,:)=Detrending(sactivity5(k,:),5);
    activity6(k,:)=Detrending(sactivity6(k,:),5);
end

% Just plotting it to check the detrended signal
t30s=(0:length(activity1)-1)/Fs;
t60s=(0:length(activity2)-1)/Fs;
tfin=(0:length(activity6)-1)/Fs;
realization=1; %change this value to update realization.
figure(2)
plot(t30s,activity1(realization,:)),title('Detrended signal for activity 1'), xlabel('Time (s)'),grid on, axis tight,
figure(3)
plot(t60s,activity2(realization,:)),title('Detrended signal for activity 2'), xlabel('Time (s)'),grid on, axis tight,
figure(4)
plot(t60s,activity3(realization,:)),title('Detrended signal for activity 3'), xlabel('Time (s)'),grid on, axis tight,
figure(5)
plot(t60s,activity4(realization,:)),title('Detrended signal for activity 4'), xlabel('Time (s)'),grid on, axis tight,
figure(6)
plot(t60s,activity5(realization,:)),title('Detrended signal for activity 5'), xlabel('Time (s)'),grid on, axis tight,
figure(7)
plot(tfin,activity6(realization,:)),title('Detrended signal for activity 6'), xlabel('Time (s)'),grid on, axis tight,

%% WE ESTABLISH THE MATRIX THAT WILL ALLOW TO PARAMETRIZE FINDPEAKS
% P=[0.11 0.5 0.005 0.4 0.11 0.5 0.01 0.4 0.1 0.5 0.03 0.35
%    0.11 0.5 0.005 0.4 0.11 0.5 0.07 0.45 0.07 0.8 0.094 0.28 
%    0.1 0.5 0.005 0.4 0.07	0.5	0.05 0.45 0.1 0.8 0.05 0.35
%    0.07 0.3 0.06 0.4 0.05	0.5	0.01 0.45 0.1 0.5 0.05 FALTA
%    0.07 0.3 0.06 0.4 0.07	0.5	0.05 0.45 0.1 0.3 0.05 FALTA
%    0.11 0.5 0.05 0.4 0.07	0.5	0.04 0.4 0.1 0.3 0.05 FALTA
%    0.13 0.5 0.005 0.45 0.07 0.5 0.04 0.4 0.05 0.3 0.04 FALTA
%    0.13 0.5 0.005 0.45 0.5 0.5 0.05 0.45 0.05 0.3 0.04 FALTA
%    0.1 0.5 0.005 0.45 0.01 0.5 0.04 0.47 0.05 0.3 0.04 FALTA
%    0.1 0.5 0.02 0.4 0.07 0.5 0.05 0.47 0.05 0.3 0.05 FALTA
%    0.1 0.5 0.005 0.4 0.01 0.5 0.025 0.35 0.05 0.3 0.04 FALTA
%    0.12 0.5 0.005 0.4 0.01 0.3 0.04 0.35 0.1 0.3 0.04 FALTA

%% FOR ACTIVITY 1 (INITIAL 30 SECONDS):
 addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
 
 %for k=1:12 
 [PKS1,LOCS1]=GetPeakPoints(activity3(3,:),Fs,0.1,0.8,0.05,0.35);
 peaks=length(PKS1);
 %end

 
%% IN THIS SECTION WE GENERATE THE AVERAGE PPG FORM FOR EACH ACTIVITY

%% APPROXIMATION 1: minimum PP interval
% 
% intPP=diff(LOCS1); % PP interval duration
% medintPP=mean(diff(LOCS1)); %Average PP interval duration
% fprintf('El intervalo PP promedio es %d ',medintPP);
% fprintf('\n es decir que el ciclo PPG comienza aproximadamente %d segundos antes del pico \n',round(medintPP/2,1));
% samPP=round(intPP*Fs,0); % We obtain the durations of the peaks in samples number
% newlocs=LOCS1*Fs; %Positions of the peaks in samples number
% delay=round(round(medintPP/2,1)*Fs); %And delay time before the peak in samples number
% M=length(diff(newlocs));   % Found PP intervals
% offset=max(PKS1);     % To deploy PP peaks above the signal
% meanduration=round(medintPP*Fs,0);
% stack=zeros(M,min(samPP)); % Sets apart memory for storing the matrix M (cardiac cycles)
% qrs=zeros(M,2); % Sets apart memory for the PP peaks curve in 3D
% 
% for m=1:M
%     switch(m)
%         case 1
%             first=activity1(1,(1:newlocs(m)-delay+min(samPP)));
%             L=length(first);
%             stack(m,:)=[first zeros(1,min(samPP)-L)];
%             qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
%         case M
%             if(length(activity1)-newlocs(m))>0
%                 stack(m,:)=activity1(1,(newlocs(m)-delay:newlocs(m)+min(samPP)-delay-1));
%                 qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
%             else
%                 stack(m,:)=activity1(1,(newlocs(m)-delay:end));
%                 qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
%             end
%         otherwise
%             stack(m,:)=activity1(1,(newlocs(m)-delay:newlocs(m)+min(samPP)-delay-1));
%             % Stores a cardiac cycle, since 0.4*Fs seconds before PP peak
%             % until the duration, given by the minimum duration of all PP
%             % found intervals 
%             qrs(m,:)=[delay+1 activity1(1,newlocs(m))]; 
%             % Saves P peaks to deploy above 3D P peak
%     end     
% end
% 
% figure(8)
% [X,Y] = meshgrid(1:min(samPP),1:M); % Generates a mesh in x-y for drawing the 3D surface
% surf(Y,X,stack);hold on;grid on; % Draws all cycles in 3D
% shading interp
% % Draws the curve of PP peaks above 3D PPG
% plot3(1:M,qrs(:,1),qrs(:,2)+offset,'go-','MarkerFaceColor','g')
% view(120, 30);%vision of the signal in 120 degrees
% 
% % Obtencion de la onda PPG promedio
% 
% ppg_prom = mean(stack);
% figure(9)
% plot((0:length(stack)-1)/Fs,ppg_prom);


%% APPROXIMATION 2: mean PP interval duration

intPP=diff(LOCS1); % PP interval duration
medintPP=mean(diff(LOCS1)); %Average PP interval duration
fprintf('El intervalo PP promedio es %d ',medintPP);
fprintf('\n es decir que el ciclo PPG comienza aproximadamente %d segundos antes del pico \n',round(medintPP/2,1));
samPP=round(intPP*Fs,0); % We obtain the durations of the peaks in samples number
newlocs=LOCS1*Fs; %Positions of the peaks in samples number
delay=round(round(medintPP/2,1)*Fs); %And delay time before the peak in samples number
M=length(diff(newlocs));   % Found PP intervals
offset=max(PKS1);     % To deploy PP peaks above the signal
meanduration=round(medintPP*Fs,0);
stack=zeros(M,meanduration); % Sets apart memory for storing the matrix M (cardiac cycles)
qrs=zeros(M,2); % Sets apart memory for the PP peaks curve in 3D

for m=1:M
    switch(m)
        case 1
            first=activity1(1,(1:newlocs(m)-delay+meanduration));
            L=length(first);
            stack(m,:)=[first zeros(1,meanduration-L)];
            qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
        case M
            if(length(activity1)-newlocs(m))>0
                stack(m,:)=activity1(1,(newlocs(m)-delay:newlocs(m)+meanduration-delay-1));
                qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
            else
                stack(m,:)=activity1(1,(newlocs(m)-delay:end));
                qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
            end
        otherwise
            stack(m,:)=activity1(1,(newlocs(m)-delay:newlocs(m)+meanduration-delay-1));
            % Stores a cardiac cycle, since 0.4*Fs seconds before PP peak
            % until the duration, given by the minimum duration of all PP
            % found intervals 
            qrs(m,:)=[delay+1 activity1(1,newlocs(m))]; 
            % Saves P peaks to deploy above 3D P peak
    end     
end

figure(9)
[X,Y] = meshgrid(1:meanduration,1:M); % Generates a mesh in x-y for drawing the 3D surface
surf(Y,X,stack);hold on;grid on; % Draws all cycles in 3D
shading interp
% Draws the curve of PP peaks above 3D PPG
plot3(1:M,qrs(:,1),qrs(:,2)+offset,'go-','MarkerFaceColor','g')
title('Ondas PPG intervalo promedio en stack')
view(120, 30);%vision of the signal in 120 degrees

%Obtención de la onda PPG promedio
ppg_prom = mean(stack);
figure(10)
plot((0:length(stack)-1)/Fs,ppg_prom),grid on, axis tight
title('Onda PPG promedio'),xlabel('Tiempo(seg)')

% Modelo del pulso PPG

a = lpc(ppg_prom,2);
est_PPG1 = filter([0 -a(2:end)],1,activity1(1,:));
figure(11)
%plot([0:length(stack)-1]/Fs,ECG_prom,[0:length(stack)-1]/Fs,est_ECG)
plot((0:length(activity1)-1)/Fs, activity1(1,:),'LineWidth',2),hold on,
plot((0:length(activity1)-1)/Fs,est_PPG1),grid on, axis tight
legend('PPG','PPG Estimada'),
title('Estimación de la onda PPG a partir de los coeficientes de autoregresión')
xlabel('Tiempo (seg)')

%% SACAMOS EL RUIDO PARA LA ACTIVIDAD 1 EN LA X REALIZACIÓN

noise1=sactivity1(1,:)-est_PPG1;