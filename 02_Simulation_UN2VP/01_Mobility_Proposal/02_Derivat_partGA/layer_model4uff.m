function [ff_n_jp,ff_amn_jp,ff_gc_jp] = layer_model4uff(user_matrix_row,derivat_partGA,min_fullfillment)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Building Layer Model for Calculation of User Fullfillment for one user

%-----------------------
% Input:
%user_matrix_row
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1

%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....

% min_fullfillment (number)
%-----------------------
% Output:
%ff_n_jp,ff_amn_jp,ff_gc_jp

%% Functions:
%Size
%Number Derivat
[n_derivat,c]=size(derivat_partGA);

%Overfullfillment Factor Secondary Activity
overfullfillment_factor_N=-0.25;
%Underfullfillment Factor Secondary Activity
underfullfillment_factor_N=1;

%% 1. Layer
%Layer for Calculation of Fullfillment of Secondary Activity
ff_n_jp=zeros(n_derivat,5);

for j=1:n_derivat
    for p=1:5
        if(user_matrix_row(1,p+1)>0)
            ff_n_jp(j,p)=1-(fw(overfullfillment_factor_N,underfullfillment_factor_N,user_matrix_row(1,p+1),derivat_partGA(j,p))/user_matrix_row(1,p+1));
        elseif(user_matrix_row(1,p+1)==0 && derivat_partGA(j,p)==0)
            ff_n_jp(j,p)=1;
        else
            ff_n_jp(j,p)=1-(fw(overfullfillment_factor_N,underfullfillment_factor_N,user_matrix_row(1,p+1),derivat_partGA(j,p))/5);
        end
    end
end

%% 2. Layer 
%Layer for Calculation of Fullfillment of Number of Passengers 
ff_amn_jp=zeros(n_derivat,5);
b_AMN_ff=min(min_fullfillment,0); %Derivat fullfills user if ff_n_jp > b_AMN_ff


for j=1:n_derivat
    for p=1:4
        if(user_matrix_row(1,p+1)>0 && ff_n_jp(j,p)>b_AMN_ff)
            ff_amn_jp(j,p)=user_matrix_row(1,p+6);
        end
    end
end

%% 3. Layer 
%Layer for Calculation of Fullfillment of Global Character C2 C3
ff_gc_jp=zeros(n_derivat,2);
%b_gc_ff=min(min_fullfillment,0.3); %Derivat fullfills user if ff_n_jp > b_AMN_ff

for j=1:n_derivat
    for p=1:5
        %Fullfills derivat j the secondary activity p most?
        max_sa_n=max(ff_n_jp(:,p));
        if(user_matrix_row(1,p+1)>0 && ff_n_jp(j,p)==max_sa_n)
            ff_gc_jp(j,1:2)=user_matrix_row(1,12:13);
        end
    end
end
end

