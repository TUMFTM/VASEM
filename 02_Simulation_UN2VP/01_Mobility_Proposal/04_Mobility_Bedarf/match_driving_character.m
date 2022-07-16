function [derivat_partDC] = match_driving_character(user_matrix_reduced,derivat_partGA)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-26
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
%Matching of the driving characteristics of the derivats according to the
%users driving characterstics

%-----------------------
% Input:
% user_matrix in the format:
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
% ...
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User n

%wish_fullfilment in %/100

%VT==1 (Private) ==2 (Taxi) ==3 (Shuttle)
%-----------------------
% Output:
% Derivat 1 [meanB1 meanB2 meanB3 meanB4 maxB1 maxB2 maxB3 maxB4]
% Derivat 2 [meanB1 meanB2 meanB3 meanB4 maxB1 maxB2 maxB3 maxB4]
% Derivat 3 ....


%% Number of derivats and users
[number_derivat,m]=size(derivat_partGA);
[number_user,k]=size(user_matrix_reduced);
%% Which Derivat fullfills user i in secondary activity p most -> Layer_N_ID
[layer_N_ID,layer_ff_ip,layer_AMN,layer_C2,layer_C3] = layer_model_user_centered(user_matrix_reduced,derivat_partGA);


%% Calculate mean of driving characteristics in each derivat
derivat_partDC=zeros(number_derivat,8);
for j=1:number_derivat
    n_user=0;
    max_B1=0; max_B2=0; max_B3=0; max_B4=0;
    for i=1:number_user
        for p=1:5
            if(layer_N_ID(i,p)==j)
                n_user=n_user+1;
                derivat_partDC(j,1:4)=derivat_partDC(j,1:4)+user_matrix_reduced(i,14:17);
                %Save max Entry of B1-B4
                if(user_matrix_reduced(i,14)>max_B1)
                    max_B1=user_matrix_reduced(i,14);
                end
                if(user_matrix_reduced(i,15)>max_B2)
                    max_B2=user_matrix_reduced(i,15);
                end
                if(user_matrix_reduced(i,16)>max_B3)
                    max_B3=user_matrix_reduced(i,16);
                end
                if(user_matrix_reduced(i,17)>max_B4)
                    max_B4=user_matrix_reduced(i,17);
                end
            end
        end
    end
    %Store max entrys
    derivat_partDC(j,5:8)=[max_B1 max_B2 max_B3 max_B4];
    %Calculate mean of B1-B4
    derivat_partDC(j,1:4)=derivat_partDC(j,1:4)./n_user;
    
end

end

