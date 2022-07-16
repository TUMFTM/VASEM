function [room_derivat] = room_per_passenger(derivat_partGA)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Room per passenger according to secondary activity and willingness of
% invest
%-----------------------
% Input:
% derivat_partGA

%-----------------------
% Output:
%Derivat 1 [Room_X Room_Y Room_Z]
%Derivat 2 [Room_X Room_Y Room_Z]
%...


%% Border Values for room definition
[number_derivat,m]=size(derivat_partGA);
%Drivers Room
D1_min=[1200 600 1200];
D1_max=[1400 800 1400];
%Relax Room
D2_min=[750 450 1500];
D2_max=[1400 800 1800];
%Working Office
D3_min=[750 450 1600];
D3_max=[1400 800 2000];
%Sleeping Room
%Chair
D4_min_chair=[750 450 1500];
D4_max_chair=[1400 800 1700];
%Bed
D4_min_bed=[750 450 1500];
D4_max_bed=[2200 800 1700];
%Luggage Space
%Primary Usage
D5_min_prim=[1500 1700 1600];
D5_max_prim=[3000 1900 2000];
%Secondary Usage
D5_min_sec=[200 0 0]; %Only additional Space in x-direction
D5_max_sec=[600 0 0]; %Only additional Space in x-direction

%% Calculation 
room_derivat=zeros(number_derivat,3);
for i=1:number_derivat
    room_req=zeros(5,3); %[X Y Z]
    actual_derivat=derivat_partGA(i,:);
    index_primuse=0;
    max_scale_value_invest=10;
    for k=1:5
        max_scale_req=10;
        if(k==1)
            D_min=D1_min;
            D_max=D1_max;
        elseif(k==2)
            D_min=D2_min;
            D_max=D2_max;
        elseif(k==3)
            D_min=D3_min;
            D_max=D3_max;
        elseif(k==4 && actual_derivat(1,7)<=7 && actual_derivat(1,k)<=10 ) %Invest <= 7
            D_min=D4_min_chair;
            D_max=D4_max_chair;
            max_scale_value_invest=7;
        end
        if(k==4 && actual_derivat(1,7)>7 && actual_derivat(1,k)>7) % Invest > 7
            D_min=D4_min_bed;
            D_max=D4_max_bed;
        end
        if(k==5 && actual_derivat(1,k)<=5)
            D_min=D5_min_sec;
            D_max=D5_max_sec;
            index_primuse=0;
            max_scale_req=5;
        elseif(k==5)
            D_min=D5_min_prim;
            D_max=D5_max_prim;
            index_primuse=1;
        end
        %IF Secondary activity is greater than zero
        if(actual_derivat(1,k)>0.1)
            for j=1:3
                room_req(k,j)=linear_scale(D_min(j),max_scale_req,max_scale_value_invest,D_max(j),actual_derivat(k),actual_derivat(7));
            end
        end
    end
    if(index_primuse==0)
        room_derivat(i,1)=max(room_req(1:4,1))+room_req(5,1); %X Anteil Stauraum
        room_derivat(i,2)=max(room_req(1:4,2));
        room_derivat(i,3)=max(room_req(1:4,3));
    else
        room_derivat(i,1)=max(room_req(:,1));
        room_derivat(i,2)=max(room_req(:,2));
        room_derivat(i,3)=max(room_req(:,3));
    end
    
end


end

