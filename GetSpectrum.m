function  P1 = GetSpectrum(OriginalSignal,Fs)
    %FORMA 1
    signal = fft(OriginalSignal);
    L = length(OriginalSignal);
    P2 = abs(signal/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    figure
    plot(f,P1)
    legend('ruido')
    title('FORMA 1: FOURIER');
    grid on, axis([-1 10 -0 0.5 ]) 
    % FORMA 2
    Res = 10; 
    Npuntos = 2^nextpow2(Fs/2/Res);
    w = hanning(Npuntos);
    [Pf,Ff]=pwelch(OriginalSignal,w,Npuntos/2,Npuntos,Fs); 
    figure
    pwelch(OriginalSignal,w,Npuntos/2,Npuntos,Fs),
    legend('Signal')
    title('FORMA 2: pwelch')
    %FORMA 3
    [~,~,f,dP] = centerfreq(Fs,OriginalSignal); %SEÑAL NORMAL
    [PS,NN] = PowSpecs(OriginalSignal);
    figure
    plot(f,dP); 
    legend('ruido')
    title('FORMA 3: PowSpect');
    grid on, axis([0 50 -10 100 ])
end