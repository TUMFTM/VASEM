function [FF_char,FF_c_jp] = ff_char_UC(layer_C2,layer_C3,derivat_partGA)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Fitness Function Part for Global Characteristics
%-----------------------
% Input:
%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....
%-----------------------
% Output:
% ...

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
            k=0;
            for i=1:100
                if(layer_C2(j,i)>0)
                    k=k+1;
                end
            end
            if(k==0)
                k=1;
            end
            active_layer_line=layer_C2(j,1:k);
            overfullfillment_factor=-1;
            underfullfillment_factor=1;
        else
            k=0;
            for i=1:100
                if(layer_C3(j,i)>0)
                    k=k+1;
                end
            end
            if(k==0)
                k=1;
            end
            active_layer_line=layer_C3(j,1:k);
            overfullfillment_factor=-1;
            underfullfillment_factor=1;
        end
        c_d=(fw(overfullfillment_factor,underfullfillment_factor,active_layer_line',derivat_partGA(j,p+6))).^2; %Square Distance
        FF_c_jp(j,p)=sum(c_d);
    end
end

%Sum up
FF_char=sum(sum(FF_c_jp));

end