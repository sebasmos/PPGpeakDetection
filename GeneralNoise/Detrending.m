function y = Detrending(signal,n)
    L=length(signal);
    bp=[];
    if(mod(L,n)==0)
        incremento=L/n;
        aumento=L/incremento;
        aux=0;
        for i=1:aumento-1
            bp(i)=aux+incremento;
            aux=aux+incremento;
        end
        y=detrend(signal,'linear',bp);
        valoresmedia=signal-y;
    else
        incremento=450;
        j=1;
        aux=0;
        while(aux<L)
            bp(j)=aux+incremento;
            aux=aux+incremento;
            j=j+1;
        end
        y=detrend(signal,'linear',bp);
        valoresmedia=signal-y;
    end
end