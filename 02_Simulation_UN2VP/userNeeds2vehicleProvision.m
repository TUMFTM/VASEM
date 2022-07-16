function [derivative_suggestion,derivative_suggestion_extend,user_fulfillment,user2derivative,user2derivative_extend] = userNeeds2vehicleProvision(userMatrix,userFulfillment,figureName)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff, David Fischer (FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-12-02
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% For a given user matrix this function create the required derivates with
% additional autonomes vehicle concept porperties from a user point of view
%-----------------------
% Input:
% User Needs in the following format:
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
% ...
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User n
%-----------------------
% Output:
% derivative_suggestion;        %derivative to satisfy the users' needs
% derivative_suggestion_extend; %extended number  to satisfy the users' needs and vary the mobility needs
% user_fulfillment;             %reached users_ fulfillement with suggested derivatives
% user2derivative;              %Which derivative satisfies which need of which user
% user2derivative_extend;       %Which derivative satisfies which need of which user in the extended number of derivatives
%-----------------------
% References:

% F. Schockenhoff, M. Zähringer, M. Brönner und M. Lienkamp, 
% „Combining a Genetic Algorithm and a Fuzzy System to Optimize User Centricity in Autonomous Vehicle Concept Development“, 
% Systems, Jg. 9, Nr. 2, S. 25, 2021, doi: 10.3390/systems9020025.

%% Preparing processing window
fig = figureName;
d = uiprogressdlg(fig,'Title','Please Wait - Optimization is running','Message',sprintf('Step 1: \nInitialization of used Variables'));
pause(1)
%% Initialization of used variables
user_matrix = userMatrix;
user_wish = userFulfillment;
[number_user,~]=size(user_matrix);
%User Fulfillment
user_fulfillment=zeros(number_user,4);
user_fulfillment(:,1)=(1:number_user)';
%Matching User 2 Derivat
user2derivative=zeros(number_user,5);
user2derivative_extend=zeros(number_user,5);

%Updating processing window
d.Value = 0.2; 
d.Message = sprintf('Step 2: \nFuzzy Logic: Determinating the Derivative Types');
pause(1)

%% Step One: Fuzzy Stakeholder System
[user_matrix_ID_Private, user_matrix_ID_Taxi, user_matrix_ID_Shuttle,user_matrix_ID_Shuttle_aid] = stepONE_VTGrouping(user_matrix);
%Updating processing window
d.Value = 0.4; 
d.Message = sprintf('Step 3: \nDeterminate minimal Number of Derivatives \n\n(This step can take some minutes up to hours, depending on the Number of Users and degree of User Fulfillment!)');
d.Cancelable = 'on';
pause(1)

%% Step Two: Genetic Algorithm for Optimazation of derivat suggestion
%Private Vehicle (3rd input 1 == 'Private')
[derivative_VT_Private,derivative_VT_Private_extend,user_fulfillment_VT_Private,user2derivative_VT_Private,user2derivative_VT_Private_extend,number_Private,number_Private_extend] = mobility_prop_VT(user_matrix_ID_Private,user_wish,1);
% [noPrivate,~] = size(derivative_VT_Private);
%Taxi Vehicle
if d.CancelRequested == false
    [derivative_VT_Taxi,derivative_VT_Taxi_extend,user_fulfillment_VT_Taxi,user2derivative_VT_Taxi,user2derivative_VT_Taxi_extend,number_Taxi,number_Taxi_extend] = mobility_prop_VT(user_matrix_ID_Taxi,user_wish,2);
%     [noTaxi,~] = size(derivative_VT_Taxi);
else
    derivative_VT_Taxi = zeros(1,17);
    derivative_VT_Taxi_extend = zeros(1,17);
    user_fulfillment_VT_Taxi = zeros(number_user,1);
    user2derivative_VT_Taxi = zeros(number_user,5);
    user2derivative_VT_Taxi_extend = zeros(number_user,5);
    number_Taxi = 0;
    number_Taxi_extend = 0;
    trueFulfillmentTaxi = 0;
end
%Shuttle Vehicle
if d.CancelRequested == false
    [derivative_VT_Shuttle,derivative_VT_Shuttle_extend,user_fulfillment_VT_Shuttle,user2derivative_VT_Shuttle,user2derivative_VT_Shuttle_extend,number_Shuttle,number_shuttle_extend] = mobility_prop_VT(user_matrix_ID_Shuttle,user_wish,3);
else
    derivative_VT_Shuttle = zeros(1,17);
    derivative_VT_Shuttle_extend = zeros(1,17);
    user_fulfillment_VT_Shuttle = zeros(number_user,1);
    user2derivative_VT_Shuttle = zeros(number_user,5);
    user2derivative_VT_Shuttle_extend = zeros(number_user,5);
    number_Shuttle = 0;
    number_shuttle_extend = 0;
end
%Updating processing window
d.Value = 0.6; 
d.Message = sprintf('Step 4: \nSave first Output');
d.Cancelable = 'off';
pause(1)

%% Save first Output
%Derivat Suggestion
if(sum(derivative_VT_Private(1,1:6))>0 && sum(derivative_VT_Taxi(1,1:6))>0)
    derivative_suggestion_pre=[derivative_VT_Private;derivative_VT_Taxi;derivative_VT_Shuttle];
elseif(sum(derivative_VT_Private(1,1:6))==0 && sum(derivative_VT_Taxi(1,1:6))>0)
    derivative_suggestion_pre=[derivative_VT_Taxi;derivative_VT_Shuttle];
    number_Private=0;
else
    derivative_suggestion_pre=[derivative_VT_Private;derivative_VT_Shuttle];
    number_Taxi=0;
end
%User Fulfillment
user_fulfillment(:,2)=user_fulfillment_VT_Private;
user_fulfillment(:,3)=user_fulfillment_VT_Taxi;
k=1;
[q,~]=size(user_matrix_ID_Shuttle);
for i=1:number_user 
   if(isempty(user_matrix_ID_Shuttle_aid)==0)
       if(k<=q)
        if(user_matrix_ID_Shuttle(k,1)==i)
            user_fulfillment(i,4)=user_fulfillment_VT_Shuttle(k);
            k=k+1;
        end
       end
   end
end
%Matching User and Derivat Whole vehicle fleet
k=1;
l=1;
m=1;
for j=1:number_user
    z=0;
    x=0;
    y=0;
    for p=1:5
        if(user_matrix_ID_Private(j,p+1)>0 && user_matrix(j,p)>0 && user_fulfillment_VT_Private(j)>0 )
            user2derivative(j,p)=user2derivative_VT_Private(l,p);
            x=1;
        elseif(user_matrix_ID_Taxi(j,p+1)>0 && user_matrix(j,p)>0 && user_fulfillment_VT_Taxi(j)>0)
            user2derivative(j,p)=user2derivative_VT_Taxi(m,p)+number_Private;
            y=1;
        end
        if(isempty(user_matrix_ID_Shuttle)==0)
            if(k<=q)
                if( user_matrix_ID_Shuttle(k,1)==j && user_matrix_ID_Shuttle(k,p+1)>0 && user_matrix(j,p)>0 )
                    user2derivative(j,p)=user2derivative_VT_Shuttle(k,p)+number_Private+number_Taxi;
                    z=1;
                end
            end
        end
    end
    if(z==1)
        k=k+1;
    end
    if(x==1)
        l=l+1;
    end
    if(y==1)
        m=m+1;
    end
end

%Delete Zero Derivat
[number_derivative,char]=size(derivative_suggestion_pre);
derivative_suggestion_pre2=zeros(number_derivative,char+1);
%Save Derivat ID
derivative_suggestion_pre=[(1:number_derivative)' derivative_suggestion_pre];
k=0;
for i=1:number_derivative
    if(sum(derivative_suggestion_pre(i,2:6))>0)
        k=k+1;
        derivative_suggestion_pre2(k,:)=derivative_suggestion_pre(i,:);
    end
end
derivative_suggestion=derivative_suggestion_pre2(1:k,:);
%Updating processing window
d.Value = 0.8; 
d.Message = sprintf('Step 5: \nCalculation for additional Derivatives');
pause(1)

%% Calcualtion for extended Version
%Derivat Suggestion
if(sum(derivative_VT_Private_extend(1,1:6))>0 && sum(derivative_VT_Taxi_extend(1,1:6))>0)
    derivative_suggestion_pre=[derivative_VT_Private_extend;derivative_VT_Taxi_extend;derivative_VT_Shuttle_extend];
elseif(sum(derivative_VT_Private_extend(1,1:6))==0 && sum(derivative_VT_Taxi_extend(1,1:6))>0)
    derivative_suggestion_pre=[derivative_VT_Taxi_extend;derivative_VT_Shuttle_extend];
    number_Private_extend=0;
else
    derivative_suggestion_pre=[derivative_VT_Private_extend;derivative_VT_Shuttle_extend];
    number_Taxi_extend=0;
end
%User Fulfillment
user_fulfillment(:,2)=user_fulfillment_VT_Private;
user_fulfillment(:,3)=user_fulfillment_VT_Taxi;
k=1;
for i=1:number_user 
   if(isempty(user_matrix_ID_Shuttle_aid)==0)
       if(k<=q)
        if(user_matrix_ID_Shuttle(k,1)==i)
            user_fulfillment(i,4)=user_fulfillment_VT_Shuttle(k);
            k=k+1;
        end
       end
   end
end
%Matching User and Derivat Whole vehicle fleet
k=1;
l=1;
m=1;
for j=1:number_user
    z=0;
    x=0;
    y=0;
    for p=1:5
        if(user_matrix_ID_Private(j,p+1)>0 && user_matrix(j,p)>0 && user_fulfillment_VT_Private(j)>0 )
            user2derivative_extend(j,p)=user2derivative_VT_Private_extend(l,p);
            x=1;
        elseif(user_matrix_ID_Taxi(j,p+1)>0 && user_matrix(j,p)>0 && user_fulfillment_VT_Taxi(j)>0)
            user2derivative_extend(j,p)=user2derivative_VT_Taxi_extend(m,p)+number_Private_extend;
            y=1;
        end
        if(isempty(user_matrix_ID_Shuttle)==0)
            if(k<=q)
                if( user_matrix_ID_Shuttle(k,1)==j && user_matrix_ID_Shuttle(k,p+1)>0 && user_matrix(j,p)>0 )
                    user2derivative_extend(j,p)=user2derivative_VT_Shuttle_extend(k,p)+number_Private_extend+number_Taxi_extend;
                    z=1;
                end
            end
        end
    end
    if(z==1)
        k=k+1;
    end
    if(x==1)
        l=l+1;
    end
    if(y==1)
        m=m+1;
    end
end

%Delete Zero Derivat
[number_derivative_extend,char]=size(derivative_suggestion_pre);
derivative_suggestion_pre2=zeros(number_derivative_extend,char+1);
%Save Derivat ID
derivative_suggestion_pre=[(1:number_derivative_extend)' derivative_suggestion_pre];
k=0;
for i=1:number_derivative_extend
    if(sum(derivative_suggestion_pre(i,2:6))>0)
        k=k+1;
        derivative_suggestion_pre2(k,:)=derivative_suggestion_pre(i,:);
    end
end
derivative_suggestion_extend=derivative_suggestion_pre2(1:k,:);
%Updating processing window
d.Value = 1; 
d.Message = sprintf('Succesfull optimized!');
pause(5)


end

