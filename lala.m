%%METODO 1 ES CON EL SPLINE


x=1:25:1875;
y=[];
for i=1:length(x)
y(i)=media(x(i));
end
xq1 = 1:0.01:1875;
s = spline(x,y,xq1);
plot(x,y,'o',xq1,s,'-.'),
hold on,
plot(media(1:1875));

%%
 