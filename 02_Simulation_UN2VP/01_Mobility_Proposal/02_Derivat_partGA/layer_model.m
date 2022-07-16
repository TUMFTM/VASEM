function [layer_N_ID,layer_ff_jp,layer_AMN,layer_C2,layer_C3] = layer_model(user_matrix,derivat_partGA)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Building Layer Model for further processing

%-----------------------
% Input:
%user_matrix
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
%....

%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]

%-----------------------
% Output:
% layers


%Size
[n_user,c1]=size(user_matrix);
[n_derivat,c2]=size(derivat_partGA);

%% 1./2.  Layer
%First/Second Layer: Which user is most fullfilled by the derivat j for secondary
%activity p, ->ff_jp_matrix

%Overfullfillment_Factor
overfullfillment_factor=-0.5;
%Underfullfillment_Factor
underfullfillment_factor=1;

%Initialize ff_jp_matrix
ff_jp_matrix=zeros(n_derivat,5);
ff_jp_ID=zeros(n_derivat,5);
for j=1:n_derivat
    for p=1:5
        %Weighting user fullfillment
        u_d=fw(overfullfillment_factor,underfullfillment_factor,user_matrix(:,p+1),derivat_partGA(j,p));
        u_d_u=u_d./user_matrix(:,p+1);
        [ff_jp_c,user_ID]=max(1-u_d_u);
        ff_jp_ID(j,p)=user_ID;
        ff_jp_matrix(j,p)=ff_jp_c;
    end
end

layer_N_ID=ff_jp_ID;
layer_ff_jp=ff_jp_matrix;
%% 3. Layer
%Third Layer: Saves the AMN Entry of that user in layer_N_ID at the same
%position

%Initialize Layer Matrix
layer_AMN=zeros(n_derivat,5);
%Fill Layer Matrix
for j=1:n_derivat
    for p=1:4
        layer_AMN(j,p)=user_matrix(layer_N_ID(j,p),p+6);
    end
end

%% 4. Layer
%Fourth Layer: Saves the C2 Entry of that User in Layer_N_ID at the same
%position

%Initialize Layer Matrix
layer_C2=zeros(n_derivat,5);
%Fill Layer Matrix
for j=1:n_derivat
    for p=1:5
        layer_C2(j,p)=user_matrix(layer_N_ID(j,p),12);
    end
end
%% 5. Layer
%Fifth Layer: Saves the C3 Enty of that User in Layer_N_ID at the same
%position

%Initialize Layer Matrix
layer_C3=zeros(n_derivat,5);
%Fill Layer Matrix
for j=1:n_derivat
    for p=1:5
        layer_C3(j,p)=user_matrix(layer_N_ID(j,p),13);
    end
end
end

