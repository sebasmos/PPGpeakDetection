function [vecdistrib]=Distribucion(media,varianza)

x=randn(1,50000);
y=3*x-2;
figure(1)
    stem(y,'.')
    grid on;
figure(2)
    histogram(y)
    grid on; 

end