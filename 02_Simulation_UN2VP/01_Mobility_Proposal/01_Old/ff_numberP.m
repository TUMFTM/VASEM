function [ff_P] = ff_numberP(user_partAMN,x,number_derivat,weight_P)
%Part of fitness function for number of passengers

%User_partAMN
%[N1 N2 N3 N4 AMN1 AMN2 AMN3 AMN4] User 1
%[N1 N2 N3 N4 AMN1 AMN2 AMN3 AMN4] User 2
%...
%x
%[D1 D2 D3 D4 D5 D6 C2 C3 D1 D2 D3 D4 D5 ...] für jedes Derivat
%Anzahl der User
[m,n]=size(user_partAMN);
%For each user
fullfilment_user=zeros(m,1);
for i=1:m
    %For each vehicle
    l=1;
    for j=1:number_derivat
       %For each secondary activity 1 to 4
       z=0;
       %Which secondary actvity is fulfilled most
       maxN_in_derivat=max(x(l:l+3));
       for k=1:4
          %If derivat j fullfills users secondary activity check number
          %passengers
          if(x(l+z)==maxN_in_derivat && user_partAMN(k)>0)
              fullfilment=((user_partAMN(i,k+4)-x(l+5))^2);
          else
              fullfilment=0;
          end
          z=z+1;
          fullfilment_user(i,1)=fullfilment_user(i,1)+fullfilment;
       end
       l=l+8;
    end
end
%Sum up for all users and weight
ff_P=sum(fullfilment_user)*weight_P;

end

