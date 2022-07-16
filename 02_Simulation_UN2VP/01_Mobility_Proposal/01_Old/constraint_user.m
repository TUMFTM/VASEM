function [c,ceq] = constraint_user(x,user,number_derivat,m)
%Nebenbedingungen für Genetischen Algorithmus

%User addieren 
user_sum=zeros(1,5);
for i=1:m
    user_sum=user_sum+user(i,:);
end
%Ungleichheits Constraint festlegen
c_1=zeros(number_derivat,5);
j=1;
for i=1:number_derivat
    c_1(i,:)=x(j:j+4)-user_sum;
    j=j+5;
end
c_2=zeros(number_derivat,5);
k=1;
for i=1:number_derivat
    %Ausprägung Fahrzeugraum in einem Fahrzeug begrenzt
    c_2(i,1)=sum(x(k:k+4))-10;
    k=k+5;
end
c=[c_1;c_2];
%Gleichheits Constraints festlegen
ceq=zeros(m-1,1);
k=1;
w=1;
%Derivat auslesen
derivat=zeros(number_derivat,5);
for i=1:number_derivat
    derivat(i,:)=x(w:w+4);
    w=w+5;
end

% for i=1:number_derivat
%     %Ausprägung Fahrzeugraum in einem Fahrzeug begrenzt
%     ceq(i,1)=sum(x(k:k+4))-10;
%     k=k+5;
% 
% end
for i=1:m-1
    %Alle Nutzer sollen druch die number_derivate gleich erfüllt werden.
    [mean_user_fullfilment] = calculate_user_fullfilment(user,derivat,m,number_derivat);
    ceq(i,1) = mean_user_fullfilment(1,1)-mean_user_fullfilment(i+1,1);
end

end

