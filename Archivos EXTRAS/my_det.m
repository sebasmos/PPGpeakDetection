function [result] = my_det(A)
[n,~] = size(A);
     if n==1
        result = A(n,n);
     else
         for k = 1:n
             for i= 2:n
                 counter=0;
                 for j = 1:n
                     if k~=j %k does not = j 
                        counterBk(i-1,counter) = counter + 1;  
                         counterBk(i-1,counter)= A(i,j);
                       end
                   end
               end
           end
       end
                       result = result + (-1)^(1+k)*A(1,k)*my_det(Bk);
end