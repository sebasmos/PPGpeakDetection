%% function [NewLOCSPPG]= GetCorrimiento(LOCSECG,LOCSPPG,sPPG,sECG,Fs)
% DESCRIPTION: This function aligns PPG and ECG peaks.
% INPUT: LOCSECG :ECG peaks
%        LOCSPPG : PPG peaks
%        sPPG: PPG signal
%        sECG: ECG signal
% OUTPUTS: NewLOCSPPG: Aligned PPG peaks

function [NewLOCSPPG]= GetCorrimiento(LOCSECG,LOCSPPG,sPPG,sECG,Fs)
% Signal's length
L=length(sPPG);
t=(0:L-1)/Fs;
% If (LOCSPPG(1)<LOCSECG(1)) then ECG happened after the PPG peak, therefore 
% PPG locs must be delayed
    if(LOCSPPG(1)<LOCSECG(1))
        corrimiento=abs((LOCSECG(2)-LOCSPPG(2))*Fs);
        ShiftedSignal=[zeros(1,L-(L-corrimiento)) sPPG(1:end-corrimiento)];
        NewLOCSPPG=((LOCSPPG*Fs)+corrimiento)/Fs;
    else 
     % if (LOCSPPG(1)>LOCSECG(1)) then ECG happened first and then PPG must be 
     % run backwards
        corrimiento=(LOCSECG(1)-LOCSPPG(1))*Fs;
        ShiftedSignal=[sPPG(abs(corrimiento)+1:end) zeros(1,L-(L+corrimiento)) ];
        NewLOCSPPG=((LOCSPPG*Fs)+corrimiento)/Fs;  
    end
end