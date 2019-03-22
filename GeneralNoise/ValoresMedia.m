function vectormedias = ValoresMedia(signal)
    L=length(signal);
    [A B]=findchangepts(signal,'Statistic','mean','MaxNumChanges',6);
    newA=[0 A L];
    j=1;
    vim=[];
    for i=1:length(newA)-1
        while(j<newA(i+1))
            vim=[vim signal(j+1)];
            j=j+1;
        end
        med=mean(vim);
        means(i)=med;
        vim=[];
    end

    vectormedias=zeros(1,length(signal));
    j=1;
    for i=1:length(newA)-1
        while(j<newA(i+1))
            vectormedias(j)=means(i);
            j=j+1;
        end
    end
     
  
end