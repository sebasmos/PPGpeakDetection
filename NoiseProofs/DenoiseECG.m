%% function [denoised]=DenoiseECG(ECGsignal)
% Description: This function allows to obtain more noticeable R peaks from
% ECG signal. To do so, DC level has to be deleted and then, the signal is
% ready for the peak enhancement. It should be remembered that as this ECG
% signals don't share the same morphology than PPG, they are easily
% manipulated for the better obtention of the R peak. Just by squaring the
% zero-centered signal, peaks are completely noticeable.
% INPUT: Ecg signal
% OUTPUT: Zero-centered and squared signal.
function [denoised]=DenoiseECG(ECGsignal)
    p = Detrending(ECGsignal,10);
    h = ECGsignal-p;
    denoised = h.^2;
end