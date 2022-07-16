function [c,ceq] = constrains(user_reduced,x,number_derivat,VT,min_fullfillment)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Constrains for GA
%-----------------------
% Input:
%User_reduced
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
%x
%[D1 D2 D3 D4 D5 D6 C2 C3 D1 D2 D3 D4 D5 ...] for each derivat

%VT==1: Private
%VT==2: Taxi
%VT==3: Shuttle

%-----------------------
% Output:
% constrains



%% Function:

[m,n]=size(user_reduced);
[derivat_partGA] = outline_partD(x,number_derivat);
[ff_user_n_amn_c,mean_ff] = user_ff(user_reduced,derivat_partGA,min_fullfillment,VT);
%% Unbalanced Constrains
%unbalanced constrains

%% Zero over all users sould be zero in vehicle for D1-D5
%If one secondary activity is equal to zero for every user, then vehicle
%should also be equal to zero for this Activity
c_1=zeros(number_derivat,5);
%sum up users for the part: secondary activities
user_sum=zeros(1,5);
for i=1:m
    user_sum=user_sum+user_reduced(i,2:6);
end
j=1;
for i=1:number_derivat
    c_1(i,:)=x(j:j+4)-user_sum;
    j=j+8;
end

%% Maximum and Minimum in one vehicle according to secondary activity
%Sum of D1 to D5 should be smaller or equal to 10
c_2=zeros(number_derivat,5);
k=1;
for i=1:number_derivat
    %Ausprägung Fahrzeugraum in einem Fahrzeug begrenzt
    if(x(k+4)<5)
        c_2(i,1)=-10+sum(x(k:k+3));
    else
       c_2(i,1)=-10+sum(x(k:k+4));
    end
    k=k+8;

end

%% Space
%Space for Secondary Activity is limited due to maximum vehicle length
c_3=zeros(number_derivat,5);
[interior_space,maximum_vehicle_space] = space4secondActiv(derivat_partGA,VT);
c_3(:,1)=interior_space(:,1)-maximum_vehicle_space(1);

%% max(D1,....,D8) <= max(N1,...,N5,AMN1...AMN4,C2,C3)
c_4=zeros(1,5);
c_5=zeros(1,5);
c_6=zeros(1,5);
%Read Max User Input
user_N=user_reduced(:,2:6);
user_AMN=user_reduced(:,7:10);
user_C=user_reduced(:,12:13);
if(m<2)
    max_entryN=user_reduced(:,2:6);
    max_AMN=max(user_reduced(:,7:10));
    max_entryC=user_reduced(:,12:13);
    min_AMN=min(user_reduced(:,7:10));
    min_entryC=user_reduced(:,12:13);
else
    max_entryN=max(user_reduced(:,2:6));
    max_AMN=max(max(user_reduced(:,7:10)));
    max_entryC=max(user_reduced(:,12:13));
    min_AMN=min(min(user_AMN(user_AMN > 0)));
    if(sum(sum(user_AMN))==0 || isempty(min_AMN)==1 )
        min_AMN=0;
    end
    min_entryC=min(user_reduced(:,12:13));
end
%Read max Derivat Entry
derivat_AMN=derivat_partGA(:,6);
derivat_C=derivat_partGA(:,7:8);
if(number_derivat<2)
    max_d_N=derivat_partGA(:,1:5);
    max_d_AMN=derivat_partGA(:,6);
    max_d_C=derivat_partGA(:,7:8);
    min_d_C=derivat_partGA(:,7:8);
    min_d_AMN=derivat_partGA(:,6);
else
    max_d_N=max(derivat_partGA(:,1:5));
    max_d_AMN=max(derivat_partGA(:,6));
    max_d_C=max(derivat_partGA(:,7:8));
    min_d_AMN=min(derivat_AMN(derivat_AMN > 0));
    if(isempty(min_d_AMN)==1)
        min_d_AMN=0;
    end
    min_d_C=min(derivat_partGA(:,7:8));
end
%Calculate Constrain
c_6(1,1)=max_d_N(1)-max_entryN(1);
c_6(1,2)=max_d_N(2)-max_entryN(2);
c_6(1,3)=max_d_N(3)-max_entryN(3);
c_6(1,4)=max_d_N(4)-max_entryN(4);
c_6(1,5)=max_d_N(5)-max_entryN(5);
c_4(1,1)=(max_d_AMN-max_AMN); %Max Passengers
c_5(1,1)=max_d_C(1)-max_entryC(1);
c_5(1,2)=max_d_C(2)-max_entryC(2);
c_4(1,2)=(min_AMN-min_d_AMN); %min Passengers
c_5(1,3)=min_entryC(1)-min_d_C(1);
c_5(1,4)=min_entryC(2)-min_d_C(2);
%Number passeneger in Shuttle no constrain.
if(VT==3)
    c_4(1,1)=0;
    c_4(1,2)=0;
end

%% Sum unbalanced constrains
%Sum up all unbalanced constrains
c=[c_1;c_2;c_3;c_4;c_5;c_6];

%% Balanced Constrains
%balanced constrains

%% No Option of Driving for Shuttle
%For shuttle, there should be no option of driving
ceq_1=zeros(number_derivat,1);
if(VT==3)
    k=1;
    for i=1:number_derivat
        ceq_1(i,1)=x(k);
        k=k+8;
    end
end


%% Sum all balanced constrains
%Sup up all balanced constrains
if(VT==3)
    ceq=[ceq_1];
else
    ceq=[0];
end

end

