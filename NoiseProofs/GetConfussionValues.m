function FinalParameters=GetConfussionValues(window,LOCSECG,LOCSPPG,L,Fs)
    limiteinf=0; %fijo el limite superior de la ventana
    limitesup=window; %fijo el limite inferior de la ventana
    i=1; %vector para posicionamiento de picos 
    ECGIND=zeros(1,floor(L/(Fs*window))); %calculo cuantas mediciones habrá en esta actividad
    PPGIND=zeros(1,floor(L/(Fs*window))); %tanto para ECG como para PPG, deben dar lo mismo pues ambas tienen la misma duración
    while(limitesup<=(L/Fs)) %hasta que la ventana se desplace a lo largo de toda la duración de la actividad
        for j=1:length(LOCSECG) 
          if(LOCSECG(j)>limiteinf && LOCSECG(j)<limitesup) %busco si hay algun pico ECG dentro de esta ventana de tiempo
                ECGIND(i)=ECGIND(i)+1;
          end  
        end
        for j=1:length(LOCSPPG)
          if(LOCSPPG(j)>limiteinf && LOCSPPG(j)<limitesup) %busco si hay algun pico PPG dentro de esta ventana de tiempo
                PPGIND(i)=PPGIND(i)+1;
          end  
        end
        limiteinf=limiteinf+window; %muevo la ventana
        limitesup=limitesup+window;
        i=i+1; 
    end
    
    for j=1:length(ECGIND) %me aseguro de que no hayan 2 en el vector, solo en el       
        if(ECGIND(j)~=0 && ECGIND(j)~=1) %muy improbable caso de que hayan dos picos
            ECGIND(j)=1;                %en un mismo intervalo de la ventana
        end
    end
    for j=1:length(PPGIND)  %lo mismo en PPG
        if(PPGIND(j)~=0 && PPGIND(j)~=1)
            PPGIND(j)=1;
        end
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
   FinalParameters=[TP FP TN FN];
end

