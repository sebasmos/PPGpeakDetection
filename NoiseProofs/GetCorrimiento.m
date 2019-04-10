
function [NewLOCSPPG]= GetCorrimiento(LOCSECG,LOCSPPG,sPPG,sECG,Fs)
L=length(sPPG);
t=(0:L-1)/Fs;
if(LOCSPPG(1)<LOCSECG(1))
    corrimiento=abs((LOCSECG(2)-LOCSPPG(2))*Fs);
    %si el LOCSECG es mayor que LOCS PPG es porque ocurrio primero PPG, entonces
    %debemos atrasar la PPG
    ShiftedSignal=[zeros(1,L-(L-corrimiento)) sPPG(1:end-corrimiento)];
    NewLOCSPPG=((LOCSPPG*Fs)+corrimiento)/Fs;
    figure
    plot(t,sECG,t,ShiftedSignal);
else 
    corrimiento=(LOCSECG(1)-LOCSPPG(1))*Fs;
    %si el LOCSECG es menor que LOCS PPG es porque ocurrio primero ECG, entonces
    %debemos adelantar la PPG
    ShiftedSignal=[sPPG(abs(corrimiento)+1:end) zeros(1,L-(L+corrimiento)) ];
    NewLOCSPPG=((LOCSPPG*Fs)+corrimiento)/Fs;
    figure
    plot(t,sECG,t,ShiftedSignal);     
end
end