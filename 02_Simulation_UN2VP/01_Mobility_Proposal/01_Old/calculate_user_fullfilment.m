function [mean_user_fullfilment] = calculate_user_fullfilment(user,derivat,m,number_derivat)
%Berechnet die prozentuale Erfüllung der Nutzer user durch die
%Mobilitätsmittel derivat

user_fullfilment=zeros(m,5);
sum_fullfilment=zeros(m,1);
mean_user_fullfilment=zeros(m,1);
%Für jeden Nuztzer
for i=1:m
    fullfilment_per_derivat=zeros(number_derivat,5);
    for j=1:number_derivat
        fullfilment_per_derivat(j,:)=user(i,:)-derivat(j,:);
    end
    fullfilment_per_user=zeros(1,5);
    for j=1:5
        fullfilment_per_user(1,j)=min(abs(fullfilment_per_derivat(:,j)));
    end
    user_fullfilment(i,:)=abs(-(fullfilment_per_user./user(i,:))+1);
    k=0;
    for j=1:5
        if(user_fullfilment(i,j) < 100)
            sum_fullfilment(i,1)=sum_fullfilment(i)+user_fullfilment(i,j);
            k=k+1;
        end
    end
    mean_user_fullfilment(i,1)=sum_fullfilment(i,1)/k;
    
            
end

end

