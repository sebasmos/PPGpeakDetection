%% function MA = Function_2_MA(Activity,windowsizeRest)
% Activity: input signal
% windowsizeReset: size of moving average window
function MA = Function_2_MA(Activity,windowsizeRest)

        % windowsize para actividades en reposo debe ser 40 y cuando es actividad
        % en movimiento debe estar entre 30 y 40, si es 30 sigue más la señal.
        %windowsizeRest = 30;
        b = 1/windowsizeRest*ones(1,windowsizeRest);
        MA = filter(b,1,Activity);
        %plot(MA,'r'),hold on
      
end