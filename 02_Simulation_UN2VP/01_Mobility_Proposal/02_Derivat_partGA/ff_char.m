function [FF_char,FF_c_jp] = ff_char(layer_C2,layer_C3,derivat_partGA)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
%Fitness Function Part for Global Characteristics
%-----------------------
% Input:
%layers

%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....
%-----------------------
% Output:
% FF_char
% FF_c-jp


%% Function:

%Size
[n_derivat,c]=size(derivat_partGA);



%Initialization
FF_c_jp=zeros(n_derivat,2);

%Fill FF_c_jp
for j=1:n_derivat
    for p=1:2
        %active Layer
        if(p<2)
            active_layer_line=layer_C2(j,:);
            overfullfillment_factor=-1;
            underfullfillment_factor=1;
        else
            active_layer_line=layer_C3(j,:);
            overfullfillment_factor=-1;
            underfullfillment_factor=1;
        end
        c_d=fw(overfullfillment_factor,underfullfillment_factor,active_layer_line',derivat_partGA(j,p+6));
        FF_c_jp(j,p)=sum(c_d);
    end
end

%Sum up
FF_char=sum(sum(FF_c_jp));

end

