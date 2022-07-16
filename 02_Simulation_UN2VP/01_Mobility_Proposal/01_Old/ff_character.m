function [ff_C] = ff_character(user_partC,x,number_derivat,weight_C)
%Part of fitness function for character 

%User_partC
%[N1 N2 N3 N4 N5 C2 C3] User 1
%[N1 N2 N3 N4 N5 C2 C3] User 2
%...
%x
%[D1 D2 D3 D4 D5 D6 C2 C3 D1 D2 D3 D4 D5 ...] für jedes Derivat

%Anzahl der User
[m,n]=size(user_partC);

%For each user
fullfilment_user=zeros(m,1);
for i=1:m
    %For each vehicle
    l=1;
    for j=1:number_derivat
       %For each charcter 2:3
       for k=1:2
          %If derivat j fullfills one of users secondary activity
          if((x(l:l+4)*user_partC(i,1:5)')>0)
              fullfilment=((user_partC(i,5+k)-x(l+k+5))^2);
          else
              fullfilment=0;
          end
          fullfilment_user(i,1)=fullfilment_user(i,1)+fullfilment;
       end
       l=l+8;
    end
end
%Sum up for all users and weight
ff_C=sum(fullfilment_user)*weight_C;

end

