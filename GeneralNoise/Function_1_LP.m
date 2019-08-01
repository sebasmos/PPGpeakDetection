%% LP = Function_1_LP(Activity,LPCActivity)
%DESCRIPTION: This function calculates the LPC filtered signal.
% INPUTS: Activity: input signal
%       LPCActivity: order of linear predictor
% OUTPUTS: LP: LPC filtered signal.
function LP = Function_1_LP(Activity,LPCActivity)
        LinearPredictor = lpc(Activity,LPCActivity);
        LP = filter([0 -LinearPredictor(2:end)],1,Activity);
       % plot(LP,'b'),hold on
end