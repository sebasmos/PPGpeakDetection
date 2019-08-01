%% function vectormedias = ValoresMedia(signal)
% DESCRIPTION: Determines the six most important changes in the mean of the
% signal and then links them up as step functions. Of course this six is
% configurable, but we decided to maintain this value, since 8 or superior
% would take unwanted values (changes in the mean for very little time)
% INPUT: Segment of the signal. It normally is an activity.
% OUTPUT: Low-frequency noise component
function vectormedias = ValoresMedia(signal)
    L=length(signal);
    [A B]=findchangepts(signal,'Statistic','mean','MaxNumChanges',6);
    newA=[0 A L];
    j=1;
    vim=[];
    %Use the mean change points to calculate these means and then ...
    for i=1:length(newA)-1
        while(j<newA(i+1))
            vim=[vim signal(j+1)];
            j=j+1;
        end
        med=mean(vim);
        means(i)=med;
        vim=[];
    end
    %link them up in one vector.
    vectormedias=zeros(1,length(signal));
    j=1;
    for i=1:length(newA)-1
        while(j<newA(i+1))
            vectormedias(j)=means(i);
            j=j+1;
        end
    end
  
end