function [] = show_user_derivat(user_matrix_ID_VT,derivat_partGA,user,derivat, user_fullfilment_VT)
%Shows user and derivat in spider plot

%user_matrix
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2

%Relevant User matrix part
[number_user,n]=size(user_matrix_ID_VT);
[number_derivat,p]=size(derivat_partGA);
[x,number2showD]=size(derivat);

%[N1 N2 N3 N4 N5 AMN(min(N-D)) C2 C3]
getAMN=user_matrix_ID_VT(user,2:5)-derivat_partGA(derivat,1:4);
minAMN=10;
for i=1:4
    if(user_matrix_ID_VT(user,i+1)>0 && minAMN>getAMN(i))
        minAMN=getAMN(i);
    end
end   
for i=1:4
   if(getAMN(i)==minAMN)
       minAMN=user_matrix_ID_VT(user,i+6);
   end
end
show_user=zeros(1,8);
show_user(1,1:5)=user_matrix_ID_VT(user,2:6);
show_user(1,6)=minAMN;
show_user(1,7:8)=user_matrix_ID_VT(user,12:13);

%Set P matrix for spider plot
P=[show_user;derivat_partGA(derivat(1):derivat(number2showD),:)];
figure;
spider_plot(P,'AxesLabels',{'Drive','Relax','Work','Sleep','Usage','People','Invest','Safety'},'AxesLimits',[0,0,0,0,0,1,0,0;10,10,10,10,10,9,10,10]);

legendstrings = cell(1, 1+number2showD); %arrayfun automatically constructs a cell array the right size
legendstrings{1}=sprintf('User %d',user);
i=1;
for mode = 2:1+number2showD  %this is the second input of arrayfun
   legendstrings{mode} = sprintf('Derivat %d', derivat(i)); %1st input of arrayfun, sort of
   i=i+1;
end
legend(legendstrings);
titlestring = cell(1,1);
titlestring{1}=sprintf('Nutzererfüllung: %d ',user_fullfilment_VT(user,2));
title(titlestring);
end

