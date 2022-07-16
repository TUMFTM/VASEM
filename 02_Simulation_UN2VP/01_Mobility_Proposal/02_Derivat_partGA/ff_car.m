function [ff_vehicle_spec] = ff_car(derivat_partGA)


%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
%Fitness Function Constrain sum of D1-D5<=10
%-----------------------
% Input:
% derivat_partGA

%-----------------------
% Output:
% ff_vehicle_spec

%Fitness Function Constrain sum of D1-D5<=10
[number_derivat,m]=size(derivat_partGA);
vehicle_constrain=zeros(number_derivat,1);
for i=1:number_derivat
    if(derivat_partGA(i,5)<5)
        vehicle_constrain(i,1)=sum(derivat_partGA(i,1:4));
    else
        vehicle_constrain(i,1)=sum(derivat_partGA(i,1:5));
    end
    %If Sum of D1-D5 > 10 scale Fitness Value drastically
    if(vehicle_constrain(i,1)>10)
        vehicle_constrain(i,1)=vehicle_constrain(i,1)^2;
    end
end
ff_vehicle_spec=sum(vehicle_constrain);
while ff_vehicle_spec>10
    ff_vehicle_spec=ff_vehicle_spec/10;
end
end

