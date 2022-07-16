function [fullfilment_per_VT] = VT_fullfilment(user_matrix,derivat_partGA,weights)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-26
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
%Calculation of user fullfilment for one Vehicle Type and the correspond
%secondary activity
%-----------------------
% Input:

%Derivat_partGA
%[D1 D2 D3 D3 D4 D5 D6 C2 C3] Derivat 1
%[D1 ....

% user_matrix

% weigths

%-----------------------
% Output:

% fullfilment_per_VT


%% Function:

[m,n]=size(user_matrix);
[number_derivat,p]=size(derivat_partGA);
%Initializing Output
fullfilment_per_VT=zeros(m,2);
user_fullfilment=zeros(m,8);
%Save User ID
fullfilment_per_VT(:,1)=user_matrix(:,1);
%Get relevant user part
%[N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C2 C3]
rel_user_matrix=zeros(m,11);
rel_user_matrix(:,1:9)=user_matrix(:,2:10);
rel_user_matrix(:,10:11)=user_matrix(:,12:13);
%For each user
for i=1:m
   %Check if there should be derivat for user i in this VT
   if(sum(user_matrix(i,2:5))>0)
      %For each derivat
      fullfilment_per_derivat=zeros(number_derivat,8);
      fullfilment_per_oneuser=zeros(1,8);
      for j=1:number_derivat
          %User Wish minus derivat
          fullfilment_per_derivat(j,1:5)=rel_user_matrix(i,1:5)-derivat_partGA(j,1:5); %N
          %Welche Nebentätigkeit deckt das Derivat am besten ab, Anzahl der
          %Personen wird danach gewählt
          [Dmax,number]=max(derivat_partGA(j,1:4));
          fullfilment_per_derivat(j,6)=rel_user_matrix(i,5+number)-derivat_partGA(j,6); %P 
          
          fullfilment_per_derivat(j,7:8)=rel_user_matrix(i,10:11)-derivat_partGA(j,7:8); %C
      end
      %Which derivat fullfils user wish most 
      for j=1:8
          fullfilment_per_oneuser(1,j)=min(abs(fullfilment_per_derivat(:,j)));
      end
      %Calculation of User Fullfilment in %
      user_fullfilment(i,1:5)=weights(1)*abs(-(fullfilment_per_oneuser(1,1:5)./rel_user_matrix(i,1:5))+1);
      user_fullfilment(i,6)=weights(2)*abs(-(fullfilment_per_oneuser(1,6)./rel_user_matrix(i,5+number))+1);
      user_fullfilment(i,7:8)=weights(3)*abs(-(fullfilment_per_oneuser(1,7:8)./rel_user_matrix(i,7:8))+1);
      k=0;
      for j=1:8
          if(user_fullfilment(i,j) < 100)
              fullfilment_per_VT(i,2)=fullfilment_per_VT(i,2)+user_fullfilment(i,j);
              if(j<6)
                k=k+weights(1);
              elseif(j<7)
                  k=k+weights(2);
              else
                  k=k+weights(3);
              end
          end
      end
      fullfilment_per_VT(i,2)=fullfilment_per_VT(i,2)/k;
   end
end


end

