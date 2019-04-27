%% function [denoised]=DenoiseECG(ECGsignal)
% Description: This function allows determining ECGsignal without low frequency noise
% components.
% INPUT: Ecg signal
% OUTPUT: Zero-centered and squared signal.
function [denoised]=DenoiseECG(ECGsignal)
    p = Detrending(ECGsignal,10);
    h = ECGsignal-p;
    denoised = h.^2;
end