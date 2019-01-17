% % Modelo pulso PPG

c = 0.4;
b = 2.5;
a = 0.05/sqrt(2*pi*c.^2);
x = 0:0.1:10
g = ((x-b)/c).^2;
f = a*exp(-0.5*g);
 
x = 0:0.1:10;
y = gaussmf(x,[2 5]);

c1 = 1;
b1 = 0.7;
x1 = 0:0.1:10;
% a1 = x1.*sqrt(2*pi*c1.^2);
% g1 = log(((x1-b1)/2*c1).^2);
% f1 = a1*exp(-0.5*g1);
% plot(f1)
 y2 = 1.*lognpdf(x1,b1,c1);
 
 figure(1)
 h1 = y2+f;
 plot(h1)
 %plot(x1,y2)
 

%  hold on
%  h2 = f + y;
 