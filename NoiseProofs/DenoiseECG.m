
function [denoised]=DenoiseECG(ECGsignal)
    p = Detrending(ECGsignal,10);
    h = ECGSignal-p;
    denoised = h.^2;
end