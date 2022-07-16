function [derivat_VT,derivat_VT_extend,user_fullfilment_VT,user2derivat_VT,user2derivat_VT_extend,number_derivat,number_derivat_extend] = mobility_prop_VT(user_matrix_ID_VT,wish_fullfillment,VT)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Runs GA for one Vehicle Type (VT) till wish user fullfilment is fullfilled by increasing number of vehicles
%-----------------------
% Input:
% user_matrix in the format:
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
% ...
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User n

%wish_fullfilment in %/100

%VT==1 (Private) ==2 (Taxi) ==3 (Shuttle)
%-----------------------
% Output:
% User Fulfillment
% User 1 [FF_N FF_AMN FF_C2 FF_C3]
% User 2 [FF_N FF_AMN FF_C2 FF_C3]
% ....

%Derivat_VT
% Derivat 1 [D1 D2 D3 D4 D5 D6 D7 D8 D9 C2 C3 B1 B2 B3 B4 VT]
% Derivat 2 [D1 D2 D3 D4 D5 D6 D7 D8 D9 C2 C3 B1 B2 B3 B4 VT]
% Derivat 3 ...

%user2derivat_VT
%Which derivat j fullfills user i in secondary activity p
%        N1  N2  N3  N4  N5
%User 1  
%User 2
%...


%% Read Number of User Inputs
[m,n]=size(user_matrix_ID_VT);


%% Start GA
actual_fullfilment=0;
number_derivat=0;
iter=0;
time=1000;
while actual_fullfilment<wish_fullfillment
    if(time>180 || iter>10)
        number_derivat=number_derivat+1;
    end
    %RUN GA
    time=0;
    tic;
    [x,user_matrix_reduced] = GA(user_matrix_ID_VT,number_derivat,VT,wish_fullfillment);
    time=time+toc;
    iter=iter+1;
    %Outline Derivat    
    [derivat_partGA] = outline_partD(x,number_derivat);
    %Calculate User fullfilment
    [ff_user_n_amn_c,mean_ff] = user_ff(user_matrix_ID_VT,derivat_partGA,wish_fullfillment,VT);
    %Save actual fullfilment
    if(VT<3)
        actual_fullfilment=mean(mean_ff(mean_ff>0));
    else
        actual_fullfillment=mean(ff_user_n_amn_c(:,1)); %For Shuttle only fullfillment of secondary activity is relevant
    end
    
    %If Actual Fullfilment is equal to zero, the usermatrix in this vehicle
    %type is equal to zero for N1-N4
    if(actual_fullfilment==0)
        actual_fullfilment=1;
    end
end
if(isempty(mean_ff)==1)
    user_fullfilment_VT=zeros(1,1);
else
    user_fullfilment_VT=mean_ff;
end
%GA Finish

%% Initialize Outputvariable
derivat_VT=zeros(number_derivat,17);
derivat_VT(:,17)=VT;
%% Space Requirement Calcualtion
[interior_space,maximum_vehicle_space,derivat_partGA] = space4secondActiv(derivat_partGA,VT);
% Space Requirement Calculation Finish
%% Fill Outputvariable Part GA
derivat_VT(:,1:6)=derivat_partGA(:,1:6);
derivat_VT(:,10:11)=derivat_partGA(:,7:8);
%% Fill Outputvariable Part Interior Space
derivat_VT(:,7:9)=interior_space./1000; %in m
derivat_VT(:,10:11)=derivat_partGA(:,7:8); %Update due to rounded number of passengers
%% Driving Characerization in Derivat
[derivat_partDC,derivat_partDC_extend,n_user_in_derivat,user2derivat_VT_extend] = match_driving_character_cluster(user_matrix_reduced,derivat_partGA);
%Driving Characteriszation Finish
%% Fill Outputvariable Part DC
% Display Mean Value
derivat_VT(:,12:15)=derivat_partDC(:,1:4);
% Display Max Value
%derivat_VT(:,12:15)=derivat_partDC(:,5:8);
%Calc mean deviation to max values
for j=1:number_derivat
    derivat_VT(j,16)=mean(derivat_partDC(j,1:4)./derivat_partDC(j,5:8));
end

%% Which user i is fullfilled in secondary activity p by derivat j?
[user2derivat_VT,layer_ff_ip,layer_AMN,layer_C2,layer_C3] = layer_model_user_centered(user_matrix_reduced,derivat_partGA);

%% IF Number Deivat==0
if(isempty(user2derivat_VT)==1)
    user2derivat_VT=zeros(1,5);
    user2derivat_VT_extend=zeros(1,5);
end

%% Create Extended Derivat due to Driving Character
[number_derivat_extend,b]=size(derivat_partDC_extend);
derivat_VT_extend=zeros(number_derivat_extend,17);
derivat_VT_extend(:,17)=VT;
%Fill in identical information and information about DC
pos_extend=1;
for j=1:number_derivat
   if(n_user_in_derivat(j,1)==1)
       derivat_VT_extend(pos_extend,:)=derivat_VT(j,:);
       pos_extend=pos_extend+1;
   elseif(n_user_in_derivat(j,1)>1)
       derivat_VT_extend(pos_extend,1:11)=derivat_VT(j,1:11);
       derivat_VT_extend(pos_extend+1,1:11)=derivat_VT(j,1:11);
       derivat_VT_extend(pos_extend:pos_extend+1,12:15)=derivat_partDC_extend(pos_extend:pos_extend+1,1:4);
       pos_extend=pos_extend+2;
   end
end


end

