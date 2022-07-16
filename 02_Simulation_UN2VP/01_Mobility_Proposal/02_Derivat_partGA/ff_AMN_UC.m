function [FF_AMN,AMN_ff_j] = ff_AMN_UC(layer_ff_jp,layer_AMN,derivat_partGA)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Fitness Function part for AMN
%-----------------------
% Input:
%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....
%-----------------------
% Output:
% ...


%Size
[n_derivat,c]=size(derivat_partGA);

%Boarder for Choosing relevant AMN
b_AMN=0.95;
%Overfullfillment Factor
overfullfillment_factor=-1;
%Underfullfillment Factor
underfullfillment_factor=1;

%Initialization
FF_AMN_d=zeros(n_derivat,1);
for j=1:n_derivat
    k=0;
    for i=1:100
        if(layer_AMN(j,i)>0)
            k=k+1;
        end
    end
    if(k==0)
        k=1;
    end
    rel_copy_layer_AMN=layer_AMN(j,1:k);

    %max number of passenger
    AMN_ff_j=max(rel_copy_layer_AMN); %Max number of passanger is preferred
    %error over all user wishes
    %AMN_ff_j=rel_copy_layer_AMN;
    %Weighting over and underfullfillment
    f_AMN=(fw(overfullfillment_factor,underfullfillment_factor,AMN_ff_j',derivat_partGA(j,6))).^2; %Square Distance
    
    FF_AMN_d(j)=sum(f_AMN);
end
%Sum over all derivates;
FF_AMN=sum(FF_AMN_d);

    
end