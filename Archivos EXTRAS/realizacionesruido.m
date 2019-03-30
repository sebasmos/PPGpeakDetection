W=zeros(5,length(mediamuestral));
for k=1:length(mediamuestral)
    W(:,k)=mediamuestral(k)+sqrt(varianzamuestral(k))*randn(5,1);
end