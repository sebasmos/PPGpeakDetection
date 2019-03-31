%% function [denoised]=DenoiseECG(ECGsignal)
% This function allows determining ECGsignal without low frequency noise
% components
% ECGSignal: input signal
% 10 R

function [denoised]=DenoiseECG(ECGsignal)
    p = Detrending(ECGsignal,10);
    h = ECGsignal-p;
    denoised = h.^2;
end