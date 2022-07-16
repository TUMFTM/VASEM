function [y] = fitness_user(x,user,m,number_derivat)
%Fitnessfunktion für beliebige User und Derivate
% x_1=x(1:5); %Derivat 1
% x_2=x(6:10); %Derivat 2
% x_3=x(11:15); %Derivat 3
% x_4=x(16:20); %Derivat 4
% 
% 
% fullfilment_user_1=(user(1,:)-x_1).*(user(1,:)-x_2).*(user(1,:)-x_3);
% fullfilment_user_2=(user(2,:)-x_1).*(user(2,:)-x_2).*(user(2,:)-x_3);
% 
% 
% y=sum((fullfilment_user_1.^2)+(fullfilment_user_2.^2));

%Für jeden User
fullfilment_user=ones(m,5);
for i=1:m
    %für jedes Derivat
    k=1;
    for j=1:number_derivat
        fullfilment_user(i,:)=fullfilment_user(i,:).*(user(i,:)-x(k:k+4));
        k=k+5;
    end
end
square=fullfilment_user.^2;
sum_column=sum(square);

y=sum(sum_column);
    
       
end

