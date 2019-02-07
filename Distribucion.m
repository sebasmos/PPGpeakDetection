function [MX,MY]=Distribucion(vmedia,vvarianza)

j=1;
for i=1:100:length(vmedia)
    mu=vmedia(i);
    sigma=sqrt(vvarianza(i));
    x=randn(1,37000);
    y=sigma*x+mu;
    fig=figure;
    set(fig,'visible','off');
    H=histfit(y);
    hx=H(2).XData;
    hy=H(2).YData;
    MX(j,:)=hx;
    MY(j,:)=hy;
    j=j+1;
end
end