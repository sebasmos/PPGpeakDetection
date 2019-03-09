for i=1:length(MY)
    maximo=max(MY(i,:));
    minimo=min(MY(i,:));
    nuevoMY(i,:)=(MY(i,:)-minimo)./(maximo-minimo);
end