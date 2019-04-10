function [TP,FP,TN,FN]=GetConfussionValues(window,LOCSECG,LOCSPPG,L,Fs)
    limiteinf=0;
    limitesup=window;
    i=1;
    ECGIND=zeros(1,floor(L/(Fs*window)));
    PPGIND=zeros(1,floor(L/(Fs*window)));
    while(limitesup<=(L/Fs))
        for j=1:length(LOCSECG)
          if(LOCSECG(j)>limiteinf && LOCSECG(j)<limitesup)
                ECGIND(i)=ECGIND(i)+1;
          end  
        end
        for j=1:length(LOCSPPG)
          if(LOCSPPG(j)>limiteinf && LOCSPPG(j)<limitesup)
                PPGIND(i)=PPGIND(i)+1;
          end  
        end
        limiteinf=limiteinf+window;
        limitesup=limitesup+window;
        i=i+1;
    end
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
end

