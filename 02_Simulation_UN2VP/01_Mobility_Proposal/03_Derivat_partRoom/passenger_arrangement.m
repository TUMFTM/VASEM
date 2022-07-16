function [interior_space, derivat_partGA] = passenger_arrangement(derivat_partGA,room_derivat,maximum_vehicle_space)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Calculation of requirements of whole interior space according to number of
% passengers and seating topology
%-----------------------
% Input:
%Room_derivat
%Derivat 1 [RoomX RoomY RoomZ]
%Derivat 2 [RoomX RoomY RoomZ]
%....
%Maximum_vehicle_space allowed for specific VT
% [X Y Z] Direction
%-----------------------
% Output:
%Derivat 1 [Room_X_res Room_Y_res Room_Z_res]
%Derivat 2 [Room_Y_res Room_Y_res Room_Z_res]
%...


%% Number of Derivat
[number_derivat,m]=size(derivat_partGA);

%% Round to the next integer of AMN
derivat_partGA(:,6)=ceil(derivat_partGA(:,6));

%% Initialize Outputvariable
interior_space=zeros(number_derivat,3);

%% Calculation of width
number_per_row=zeros(number_derivat,1);
for j=1:number_derivat
    if(derivat_partGA(j,6)>5)
        if(maximum_vehicle_space(2)<(3*room_derivat(j,2)))
            people_per_row=2;
        else
            people_per_row=3;
        end
        interior_space(j,2)=room_derivat(j,2)*people_per_row;
        %Save number_per_row
        number_per_row(j,1)=people_per_row;
    else
        interior_space(j,2)=room_derivat(j,2); %In case of Only luggage space
end
%% Caluculation of length
number_rows=ceil(derivat_partGA(:,6)./number_per_row);
for j=1:number_derivat
    if(derivat_partGA(j,6)>5)
        interior_space(j,1)=room_derivat(j,1).*number_rows(j);
    else
        interior_space(j,1)=room_derivat(j,1);
    end
end

%% Store height
interior_space(:,3)=room_derivat(:,3);

end

