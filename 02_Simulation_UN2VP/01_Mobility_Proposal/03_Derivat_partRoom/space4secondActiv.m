function [interior_space,maximum_vehicle_space,derivat_partGA] = space4secondActiv(derivat_partGA,VT)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% %Space Estimation for secondary activity based on C2 (Invest) and
% Importance of Secondary Activity
%-----------------------
% Input:
% derivat_partGA

%VT==1 (Private) ==2 (Taxi) ==3 (Shuttle)
%-----------------------
% Output:
% interior_space,maximum_vehicle_space,derivat_partGA

%% Maximum Vehicle Space According to VT
% maximum_vehicle_space for Privat
if(VT==1)
    maximum_vehicle_space=[4200,2000,2000];
elseif(VT==2) %Taxi
    maximum_vehicle_space=[4200,2000,2000];
else %Shuttle
    maximum_vehicle_space=[5200,2000,2000];
end

%% Room per Passanger Calculation
[room_derivat] = room_per_passenger(derivat_partGA);

%% Passanger Arrangment Calculation
[interior_space,derivat_partGA] = passenger_arrangement(derivat_partGA,room_derivat,maximum_vehicle_space);
end

