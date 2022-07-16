function [FF_AMN,AMN_ff_j] = ff_AMN(layer_ff_jp,layer_AMN,derivat_partGA)
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
%layers

%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....
%-----------------------
% Output:
% FF_AMN
% AMN_ff_j


%% Function:

%Size
[n_derivat,c]=size(derivat_partGA);

%Boarder for Choosing relevant AMN
b_AMN=0.95;
%Overfullfillment Factor
overfullfillment_factor=-1;
%Underfullfillment Factor
underfullfillment_factor=1;

%Initialization
maxff_jp=zeros(n_derivat,1);
rel_copy_layer_AMN=zeros(n_derivat,4);
AMN_ff_j=zeros(n_derivat,1);
f_AMN=zeros(n_derivat,1);

for j=1:n_derivat
    %Save max ff_jp in layer_ff_jp
    maxff_jp(j,1)=max(layer_ff_jp(j,:));
    %Fill rel_copy_layer_AMN according to boarder b_AMN
    for p=1:4
        if(layer_ff_jp(j,p)/maxff_jp(j,1) > b_AMN)
            rel_copy_layer_AMN(j,p)=layer_AMN(j,p);
        end
    end
    %select AMN for Calculation of Fullfillment
    AMN_ff_j(j,1)=max(rel_copy_layer_AMN(j,:)); %Max number of passanger is preferred
    %Weighting over and underfullfillment
    f_AMN(j,1)=fw(overfullfillment_factor,underfullfillment_factor,AMN_ff_j(j),derivat_partGA(j,6));
end
%Sum over all derivates;
FF_AMN=sum(f_AMN);    
    
end

