%% function FinalParameters=GetConfussionValues(window,LOCSECG,LOCSPPG,L,Fs)
% DESCRIPTION: Determine the confussion matrix values through the use of a
% sliding window. Inside each window, the classification task is performed
% and then one value is retrieved, either TP, TN, FN or FP.
% INPUTS: window: window size equivalent to the half of an average R-R
% interval. 
%          LOCSECG: locations of the ECG peaks
%          LOCSPPG: locations of the PPG peaks
%          L: signal's length
%          Fs: Sampling Frequency
function FinalParameters=GetConfussionValues(window,LOCSECG,LOCSPPG,L,Fs)
    % Set lower limit for window size
    limiteinf=0; 
    % Set upper window size
    limitesup=window; 
    i=1; 
    % Set the number of windows within the input signal for ECG and PPG.
    ECGIND=zeros(1,floor(L/(Fs*window)));
    PPGIND=zeros(1,floor(L/(Fs*window)));
    % Wait until window drifts along the entire input signal
    % This for each one of the W windows:
    while(limitesup<=(L/Fs)) 
        % See if the occurence of an ECG peak is within this window
        for j=1:length(LOCSECG) 
          if(LOCSECG(j)>limiteinf && LOCSECG(j)<limitesup) 
                ECGIND(i)=ECGIND(i)+1;
          end  
        end
        % See if the occurence of a PPG peak is within this window
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
    % the same window. If there is, then it is set as one.
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
%% Determine Metrics taking into account the indicators from the sliding window
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

