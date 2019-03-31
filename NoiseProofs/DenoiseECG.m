
function [denoised]=DenoiseECG(ECGsignal)
    p = Detrending(ECGsignal,10);
    h = ECGsignal-p;
    denoised = h.^2;
end