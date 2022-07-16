function [ff_value] = ojectiv_function(x,user_matrix,number_derivat,wish_fullfillment,VT)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Complete Fitness Function
%-----------------------
% Input:
% user_matrix in the format:
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
% ...
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User n

% wish_fullfilment in %/100

% number_derivat

%VT 

%-----------------------
% Output:
%ff_value fitness value 

%% function

%Outline Derivat out of x
[derivat_partGA] = outline_partD(x,number_derivat);

%[layer_N_ID,layer_ff_jp,layer_AMN,layer_C2,layer_C3] = layer_model(user_matrix,derivat_partGA);
[layer_N_ID,layer_ff_ip,layer_AMN,layer_C2,layer_C3] = layer_model_user_centered(user_matrix,derivat_partGA);
[FF_ip_matrix,FF_N] = ff_secondaryactiv(user_matrix,derivat_partGA);
[FF_AMN,AMN_ff_j] = ff_AMN_UC(layer_ff_ip,layer_AMN,derivat_partGA);
[FF_char,FF_c_jp] = ff_char_UC(layer_C2,layer_C3,derivat_partGA);
[FF_fullfillment] = ff_fullfillment(user_matrix,derivat_partGA,wish_fullfillment,VT);
[FF_vehicle_spec] = ff_car(derivat_partGA); %Only because of convergence of GA, this part can also be find in constrains function
%Sum of all Parts
ff_value=FF_N+FF_AMN+FF_char+FF_fullfillment+FF_vehicle_spec/10;
end

