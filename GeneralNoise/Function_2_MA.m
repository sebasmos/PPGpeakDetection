%% function MA = Function_2_MA(Activity,windowsizeRest)
% DESCRIPTION: this function returns the MA filtered signal.
% INPUTS: Activity: input signal
%         windowsizeReset: size of moving average window
% OUTPUTS: MA: filtered signal.
function MA = Function_2_MA(Activity,windowsizeRest)
        b = 1/windowsizeRest*ones(1,windowsizeRest);
        MA = filter(b,1,Activity);
        %plot(MA,'r'),hold on
      
end