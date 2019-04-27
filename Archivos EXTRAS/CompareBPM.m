%% function [segundos] = CompareBPM(movimiento,n)
% movimiento: Specify the movement from 1-6 from the selected activities
% n: Chose the realizacion to deploy from 1-12
function [bpm] = CompareBPM()
%% RUIDO EN REPOSO PRIMEROS 30 SEGUNDOS
k=0;
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
%% Save in matrix with activities (rows) vs testing sample (Columns)
for i = 1:12
        mov1(i) = mean(s((1:15),i));
        mov2(i) = mean(s((15:45),i));
        mov3(i) = mean(s((45:75),i));
        mov4(i) = mean(s((75:105),i));
        mov5(i) = mean(s((105:135),i));
        mov6(i) = mean(s((135:end),i));
end
bpm  = [mov1; mov2; mov3; mov4; mov5; mov6 ];
end