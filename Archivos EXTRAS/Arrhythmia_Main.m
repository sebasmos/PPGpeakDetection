close all
clc
%% Dataset with bradycardia and Tachycardia
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db');
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
% Get artificial noise with savitzky
%[mediamuestral,TamRealizaciones]=GetAveragedNoise();
Signal = load("a103l");
Signal = Signal.val;
%% Size sample to analyse
m = 3750;
% Sample Frequency
Fs = 250;
% Physical Conversion and Normalization
for i=1:3
    Signal1(i,:) = (Signal(i,:)-125)/255;
    SignalTotal(i,:) = (Signal1(i,:)-min(Signal1(i,:)))/(max(Signal1(i,:)-min(Signal1(i,:))));
    figure
    plot(SignalTotal(i,:)),hold on, grid on, title('Signals Normalized'),xlabel('samples')
end
%  Width of 0.2 from 0-1
%% CLEAN SIGNALS for peak detection purposes ONLY, 
% Denoise ECGs and PPG s.
% Baselinedrift removal
Signal1 = DenoiseECG(SignalTotal(1,:));
Signal2 = DenoiseECG(SignalTotal(2,:));
Signal3 = SignalTotal(3,:)-Detrending(SignalTotal(3,:),10);
% high freq remov.
s1 = sgolayfilt(Signal1,40,41);
s2 = sgolayfilt(Signal2,40,41);
s3 = sgolayfilt(Signal3,3,41);
% Peaks
[a1,b1] = GetPeakPoints(s2(1,:),Fs,0.01,0.6,0.006,0.48);
[a2,b2] = GetPeakPoints(s2(1,:),Fs,0.01,0.6,0.006,0.48);
[a3,b3] = GetPeakPoints(s3(1,:),Fs,0.11,0.6,0.001,0.46);
%% Add artificial noise, we contaminate original datasets since they were 
% measured without or almost zero noise. We take detrended noise
%% Activity 1 is taken since the whole dataset is in rest
Act1Noise = mediamuestral(1:3750);
Act2Noise = mediamuestral(3751:11250);
DetrendedECG1 = SignalTotal(1,:)-Detrending(SignalTotal(1,:),10);
DetrendedECG2 = SignalTotal(2,:)-Detrending(SignalTotal(2,:),10);
DetrendedPPG = Signal3;
% Corrupt Signals
CorruptedECG1 = DetrendedECG1(1:3750) + Act1Noise;
CorruptedECG2 = DetrendedECG2(1:7500) + Act2Noise;
CorruptedPPG  = DetrendedPPG(1:3750)  + Act1Noise;
%% Peaks detection in corrupted signal
[CorruptedA1,CorruptedA2] = GetPeakPoints(CorruptedECG1(1,:),Fs,0.01,0.6,0.006,0.48);
[CorruptedB1,CorruptedB2] = GetPeakPoints(CorruptedECG2(1,:),Fs,0.01,0.6,0.006,0.48);
[CorruptedC1,CorruptedC2] = GetPeakPoints(s3(1,:),Fs,0.11,0.6,0.001,0.46);
 %% Plotting articial dataset
figure
t=(0:length(mediamuestral(1:3750))-1)/Fs;
plot(t,SignalTotal(1,(1:3750)),t,CorruptedECG1(1:3750)),hold on,title('ACTIVITY 1 (Resting): ECG Final Artificial dataset with arrhythmia'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight,
legend('Original Signal','Corrupted Signal')
figure
t=(0:length(mediamuestral(1:3750))-1)/Fs;
plot(t,SignalTotal(3,(1:3750)),t,CorruptedPPG(1:3750)),hold on,title('ACTIVITY 1 (Resting): PPG Final Artificial dataset with arrhythmia'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight,
legend('Original Signal','Corrupted Signal')
figure
t=(0:length(mediamuestral(1:7500))-1)/Fs;
plot(t,SignalTotal(1,(1:7500)),t,CorruptedECG2(1:7500)),hold on,title('ACTIVITY 2 (Running): Final Artificial dataset with arrhythmia'),ylabel('Magnitude'), xlabel('Time (s)'),grid on, axis tight,
legend('Original Signal','Corrupted Signal')

