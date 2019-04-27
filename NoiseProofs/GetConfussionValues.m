%% function FinalParameters=GetConfussionValues(window,LOCSECG,LOCSPPG,L,Fs)
% DESCRITION: Determine performance parameters using set intervals
% INPUTS: window: window size quivalent to RR or MM interval or similar,
%                   this can change according to inspection. This
%                   particular case splits 2 sub intervals for each RR
%                   Interval.
%          LOCSECG: Ecg peaks
%          LOCSPPG: PPG peaks
%          L: Signal's lentgh
%          Fs: Sample Frequency
function FinalParameters=GetConfussionValues(window,LOCSECG,LOCSPPG,L,Fs)
    % Set lower limit for window size
    limiteinf=0; 
    % Set upper window size
    limitesup=window; 
    i=1; 
    % Set the number of measurements (windows) within the input signal, setting W:
    % L/winwsize. For ECG and PPG.
    ECGIND=zeros(1,floor(L/(Fs*window)));
    PPGIND=zeros(1,floor(L/(Fs*window)));
    % Wait until window drifts along the whole activity (the entire input signal)
    % This for each one of the W windows:
    while(limitesup<=(L/Fs)) 
        % Find the number of ECG peaks withing the windowsizes
        for j=1:length(LOCSECG) 
          if(LOCSECG(j)>limiteinf && LOCSECG(j)<limitesup) 
                ECGIND(i)=ECGIND(i)+1;
          end  
        end
        % Find the number of PPG peaks withing the windowsizes
        for j=1:length(LOCSPPG)
          if(LOCSPPG(j)>limiteinf && LOCSPPG(j)<limitesup) 
                PPGIND(i)=PPGIND(i)+1;
          end  
        end
        % Shift towards next window and so on until moving along the whole
        % signal.
        limiteinf=limiteinf+window; 
        limitesup=limitesup+window;
        i=i+1; 
    end
    
    %% OPCTIONAL: Proof tests to make sure there are no more than 2 peaks within
    % the same window. This  because if there is thirds or forth partition
    % the motion artifacts could set more than 1 peak within a single
    % window
    for j=1:length(ECGIND) 
        if(ECGIND(j)~=0 && ECGIND(j)~=1) 
            ECGIND(j)=1;               
        end
    end
    for j=1:length(PPGIND)          
        if(PPGIND(j)~=0 && PPGIND(j)~=1)
            PPGIND(j)=1;
        end
    end
%% Determine Metrics
  TP=0;
  FP=0;
  TN=0;
  FN=0;
   for j=1:length(ECGIND)
       if(ECGIND(j)==1 && PPGIND(j)==1)
           TP=TP+1;
       end
       if(ECGIND(j)==1 && PPGIND(j)==0)
           FN=FN+1;
       end
       if(ECGIND(j)==0 && PPGIND(j)==1)
           FP=FP+1;
       end
       if(ECGIND(j)==0 && PPGIND(j)==0)
           TN=TN+1;
       end
   end
   FinalParameters=[TP FP TN FN];   
end

