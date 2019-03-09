
function [PKS1ruido,LOCS1ruido] = GetPeakPoints(CorruptedSignal1,Fs,minPW,maxPW,minPP)
[PKS1ruido,LOCS1ruido]=findpeaks(CorruptedSignal1,Fs,'MinPeakWidth',minPW,'MaxPeakWidth',maxPW, ...
              'Annotate','extents','MinPeakProminence',minPP);
figure
findpeaks(CorruptedSignal1,Fs,'MinPeakWidth',minPW,'MaxPeakWidth',maxPW, ...
              'Annotate','extents','MinPeakProminence',minPP)
hold on
plot(LOCS1ruido,PKS1ruido,'o')   
xlabel('Tiempo');
ylabel('Signal');
hold on

end