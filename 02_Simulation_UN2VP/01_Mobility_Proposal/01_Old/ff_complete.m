function [ff] = ff_complete(user_reduced,x,number_derivat,weights)
%Complete Fitness Function

%User_reduced
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2

[m,n]=size(user_reduced);
%Prepare Inputs for different FF Inputs
%FF_secondActiv
user_partN=user_reduced(:,2:6);
weight_N=weights(1);
%FF_numberP
user_partAMN_1=user_reduced(:,2:5);
user_partAMN_2=user_reduced(:,7:10);
user_partAMN=[user_partAMN_1 user_partAMN_2];
weight_P=weights(2);
%%FF_character
user_partC=zeros(m,7);
user_partC(:,1:5)=user_reduced(:,2:6);
user_partC(:,6:7)=user_reduced(:,12:13);
weight_C=weights(3);

%Get FF Parts
[ff_N] = ff_secondactiv(user_partN,number_derivat,x,weight_N,user_reduced);
[ff_P] = ff_numberP(user_partAMN,x,number_derivat,weight_P);
[ff_C] = ff_character(user_partC,x,number_derivat,weight_C);
%Sum Up FF
ff=ff_N+ff_P+ff_C;

%%
%Test mit reiner Nutzererfüllung
% [derivat_partGA] = outline_partD(x,number_derivat);
% [fullfilment_per_VT] = VT_fullfilment(user_reduced,derivat_partGA,weights);
% f=abs(ones(m,1)-fullfilment_per_VT(:,2));
% ff=sum(f);
end

