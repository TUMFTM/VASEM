function [fw] = fw(overfullfillment_factor,underfullfillment_factor,x1,x2)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Weighting function for different weighting of under- and overfullfilment 
% overfullfillment_factor <0
% underfullfillment_factor >0
%-----------------------
% Input:
%user_matrix
%overfullfillment_factor,underfullfillment_factor,x1,x2
%-----------------------
% Output:
% fw

%% Function

function_value= x1-x2;
[m,n]=size(function_value);
fw=zeros(m,1);
for i=1:m
    if(function_value(i)>0)
        fw(i)=function_value(i)*underfullfillment_factor;
    else
        fw(i)=function_value(i)*overfullfillment_factor;
    end
end


end

