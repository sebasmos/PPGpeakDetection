%% rnoise = GetLPCNoise(activity,sactivity,params,Fs)
% This function allows us to obtain noise, product of an auto linear
% regresion process, first we obtain a model of the signal and then feed
% the linear predictor with it.  
% INPUTS
% DetrendedActivity: Vector containing the signal of a determined
%                       activity in a determined realization without
%                       drift baseline
% Activity: Vector containing the signal of a determined
%                       activity in a determined realization without
%                       driftbaseline
% params: Vector containing the next parameters:
% 1. param(1): MinPeakWidth
% 2. param(2): MaxPeakWidth
% 3. param(3): Prominence
% 4. param(4): MinPeakDistance
function arnoise = GetLPCNoise(DetrendedActivity,Activity,params,Fs)

    addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\Training_data\NoiseProofs');
 
    % Get peaks values and location over sample values
    [PKS,LOCS]=GetPeakPoints(DetrendedActivity,Fs,params(1),params(2),params(3),params(4));
    
    % Get total amount of peaks in the signal
    peaks=length(PKS);
    
    % Get MM interval duration in number of samples (vector)
    intMM=diff((LOCS)); 
    MeanMMInterval=round(mean(intMM),1); %Average MM interval duration in number of samples
%     fprintf('El intervalo MM promedio es %d segundos',MeanMMInterval);
%     fprintf('\n es decir que el ciclo PPG comienza aproximadamente %d segundos antes del pico \n',MeanMMInterval/2);
    samPP=round(intMM*Fs,0); % We obtain the durations of the peaks in samples number
    newlocs=round(LOCS*Fs,0); %Positions of the peaks in samples number
    delay=round(round(MeanMMInterval/2,1)*Fs); %And delay time before the peak in samples number
    M=length(diff(newlocs));   % Found MM intervals
    offset=max(PKS);     % To deploy MM peaks above the signal
    meanduration=round(MeanMMInterval*Fs,0);
    stack=zeros(M,meanduration); % Sets apart memory for storing the matrix M (cardiac cycles)
    qrs=zeros(M,2); % Sets apart memory for the PP peaks curve in 3D

    % Then we stores a cardiac cycle, since 'delay' seconds before PP peak
    % until the duration, given by the minimum duration of all PP found
    % intervals
            
    for m=1:M
    switch(m)
        case 1
            first=DetrendedActivity(1:newlocs(m)-delay+meanduration);
            L=length(first);
            if(meanduration>=L)
                stack(m,:)=[first zeros(1,meanduration-L)];
                qrs(m,:)=[delay+1 DetrendedActivity(newlocs(m))];
            else
                sobra=L-meanduration;
                stack(m,:)=DetrendedActivity(1:newlocs(m)-delay+meanduration-sobra);
                qrs(m,:)=[delay+1 DetrendedActivity(newlocs(m))];
            end
        case M
            if(length(DetrendedActivity)-newlocs(m))>0
                stack(m,:)=DetrendedActivity(newlocs(m)-delay:newlocs(m)+meanduration-delay-1);
                qrs(m,:)=[delay+1 DetrendedActivity(newlocs(m))];
            else
                stack(m,:)=DetrendedActivity(newlocs(m)-delay:end);
                qrs(m,:)=[delay+1 DetrendedActivity(newlocs(m))];
            end
        otherwise
            stack(m,:)=DetrendedActivity(newlocs(m)-delay:newlocs(m)+meanduration-delay-1);
            
            qrs(m,:)=[delay+1 DetrendedActivity(newlocs(m))]; 
            % Saves P peaks to deploy above 3D P peak
    end     
    end
    
%     figure(9)
%     [X,Y] = meshgrid(1:meanduration,1:M); % Generates a mesh in x-y for drawing the 3D surface
%     surf(Y,X,stack);hold on;grid on; % Draws all cycles in 3D
%     shading interp
%     % Draws the curve of PP peaks above 3D PPG
%     plot3(1:M,qrs(:,1),qrs(:,2)+offset,'go-','MarkerFaceColor','g')
%     title('Mean PPG signal in stack')
%     view(120, 30);%vision of the signal in 120 degrees

    %Get mean PPG
    ppg_prom = mean(stack);

%     figure(10)
%     plot((0:length(stack)-1)/Fs,ppg_prom),grid on, axis tight
%     title('Average PPG signal'),xlabel('Tiempo(seg)')

    % Modelo de la señal PPG para la actividad
    % Get PPG model
    a = lpc(ppg_prom,2);
    est_PPG1 = filter([0 -a(2:end)],1,DetrendedActivity);
%     figure(11)
%     plot((0:length(DetrendedActivity)-1)/Fs, DetrendedActivity,'LineWidth',2),hold on,
%     plot((0:length(DetrendedActivity)-1)/Fs,est_PPG1),grid on, axis tight
%     legend('PPG','PPG predicted'),
%     title('Estimación de la onda PPG a partir de los coeficientes de autoregresión')
%     xlabel('Tiempo (seg)')
   
    arnoise=Activity-est_PPG1;
end