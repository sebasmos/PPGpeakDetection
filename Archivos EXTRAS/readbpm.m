function [segundos]=readbpm(movimiento)
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
    for k = 1:12
        if k >= 10
            labelstring = int2str(k);
            word = strcat({'DATA_'},labelstring,{'_TYPE02_BPMtrace.mat'});
            a = load(char(word));
            vbpm=a.BPM0(1:min(TamRealizaciones));
            mbpm(k,:)=vbpm;
        else
            labelstring = int2str(k);
            word = strcat({'DATA_0'},labelstring,{'_TYPE02_BPMtrace.mat'});
            a = load(char(word));
            vbpm=a.BPM0(1:min(TamRealizaciones));
            mbpm(k,:)=vbpm;
        end
    end
    
    switch(movimiento)
        case 1
            segundos=mean(mbpm(:,(1:15)),2);
        case 2
            segundos=mean(mbpm(:,(15:45)),2);
        case 3
            segundos=mean(mbpm(:,(45:75)),2);
        case 4
            segundos=mean(mbpm(:,(75:105)),2);
        case 5
            segundos=mean(mbpm(:,(105:135)),2);
        case 6
            segundos=mean(mbpm(:,(135:end)),2);
    end
end