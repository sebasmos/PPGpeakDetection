%% LP = Function_1_LP(Activity,LPCActivity)
% Activity: input signal
% LPCActivity: order of linear predictor
function LP = Function_1_LP(Activity,LPCActivity)

        LinearPredictor = lpc(Activity,LPCActivity);
        LP = filter([0 -LinearPredictor(2:end)],1,Activity);
       % plot(LP,'b'),hold on
end