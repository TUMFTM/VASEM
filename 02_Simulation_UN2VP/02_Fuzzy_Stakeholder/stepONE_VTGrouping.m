function [user_matrix_ID_Private, user_matrix_ID_Taxi, user_matrix_ID_Shuttle,user_matrix_ID_Shuttle_aid] = stepONE_VTGrouping(user_matrix)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff (FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Optimazation Step 1: Grouping User Secondary activities by vehicle type
%-----------------------
% Input:
% user
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4]
%-----------------------
% Output:
% user matrix ID
% [ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4]


%% Function
%Using Fuzzy for Estimating Vehicle Type
[user_matrix_VT] = VTforSecondaryActivity(user_matrix);

%Defining Boarders
boarder_private=3.5;
boarder_shuttle=6.5;

%Saving User ID
[n,m]=size(user_matrix_VT);
user_matrix_VT_ID=zeros(n,m+1);
user_matrix_VT_ID(:,1)=1:n;
user_matrix_VT_ID(:,2:m+1)=user_matrix_VT;
%Grouping by Vehicle Type
user_matrix_ID_Private=zeros(n,m-3);
user_matrix_ID_Private(:,1)=user_matrix_VT_ID(:,1);
user_matrix_ID_Private(:,11:m-3)=user_matrix(:,10:m-4);
user_matrix_ID_Taxi=zeros(n,m-3);
user_matrix_ID_Taxi(:,1)=user_matrix_VT_ID(:,1);
user_matrix_ID_Taxi(:,11:m-3)=user_matrix(:,10:m-4);
user_matrix_ID_Shuttle_aid=zeros(n,m-3);
user_matrix_ID_Shuttle_save=zeros(n,m-3);
user_matrix_ID_Shuttle_aid(:,1)=user_matrix_VT_ID(:,1);
user_matrix_ID_Shuttle_aid(:,11:m-3)=user_matrix(:,10:m-4);
number_shuttle=0;
%For all users n
for i=1:n
   %For Secondary Activities 1:4
   for j=1:4
      
      if(user_matrix_VT_ID(i,17+j)<=boarder_private) %Private
          user_matrix_ID_Private(i,1+j)=user_matrix_VT_ID(i,1+j); %Save Secondary Activity
          user_matrix_ID_Private(i,1+5+j)=user_matrix_VT_ID(i,1+5+j); %Save Number Passangers
      elseif(user_matrix_VT_ID(i,17+j)<boarder_shuttle) %Taxi
          user_matrix_ID_Taxi(i,1+j)=user_matrix_VT_ID(i,1+j); %Save Secondary Activity
          user_matrix_ID_Taxi(i,1+5+j)=user_matrix_VT_ID(i,1+5+j); %Save Number Passanger
      else
          user_matrix_ID_Shuttle_aid(i,1+j)=user_matrix_VT_ID(i,1+j);
          user_matrix_ID_Shuttle_aid(i,1+5+j)=user_matrix_VT_ID(i,1+5+j);
      end
   end
   %Transmit N5 Loading
   if(user_matrix_VT_ID(i,6)>5)
       user_matrix_ID_Private(i,6)=5;
       user_matrix_ID_Taxi(i,6)=5;
   else
       user_matrix_ID_Private(i,6)=user_matrix_VT_ID(i,6);
       user_matrix_ID_Taxi(i,6)=user_matrix_VT_ID(i,6);
   end
   user_matrix_ID_Shuttle_aid(i,6)=user_matrix_VT_ID(i,6);
   %Checking Shuttle matrix according to Secondary Activity Loading
   if(sum(user_matrix_ID_Shuttle_aid(i,2:5))>0 || user_matrix_ID_Shuttle_aid(i,6)>5)
       number_shuttle=number_shuttle+1;
       user_matrix_ID_Shuttle_save(number_shuttle,:)=user_matrix_ID_Shuttle_aid(i,:);
   end
   
end
user_matrix_ID_Shuttle=user_matrix_ID_Shuttle_save(1:number_shuttle,:);

end

