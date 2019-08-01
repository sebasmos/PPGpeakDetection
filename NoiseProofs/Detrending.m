%% function valoresmedia = Detrending(signal,n)
%Description: Determines the DC component of a signal by finding
% the linear functions that joins the breakpoints stablished.
% INPUTS: signal: Input signal
%        n: Number of evenly spaced breakpoints for calculating DC linear
%        level.
% OUTPUTS: valoresmedia: vector containing the approximate DC level of the
% signal.
function valoresmedia = Detrending(signal,n)
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