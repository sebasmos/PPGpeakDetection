function [s] = ReadBPM()
%% RUIDO EN REPOSO PRIMEROS 30 SEGUNDOS
k=0;
prom=0;
sm0=0;
sm1=0;
sm2=0;
sm3=0;
sm4=0;
sm5=0;

for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02_BPMtrace.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.BPM0);
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02_BPMtrace.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.BPM0);
    end
end
%%
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02_BPMtrace.mat'});
        Trunk =  GetBPM(char(word));
        Trunk = Trunk((1:140),1);
        s(:,k) =  Trunk;
    else       
         labelstring = int2str(k);
         word = strcat({'DATA_0'},labelstring,{'_TYPE02_BPMtrace.mat'});
         Trunk =  GetBPM(char(word));
         Trunk = Trunk(1:min(TamRealizaciones),1);
         s(:,k) =  Trunk;
    end
end

 
end