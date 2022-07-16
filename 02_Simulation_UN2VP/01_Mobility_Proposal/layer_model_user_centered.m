function [layer_N_ID,layer_ff_ip,layer_AMN,layer_C2,layer_C3] = layer_model_user_centered(user_matrix,derivat_partGA)

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
% user_matrix
% [ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
% [ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
% ....

%Derivat_partGA
% [D1 D2 D3 D4 D5 D6 D7 D8]
% [D1 D2 D3 D4 D5 D6 D7 D8]
% ....
%-----------------------
% Output:
% layers of the optimazation (layer_N_ID,layer_ff_ip,layer_AMN,layer_C2,layer_C3)

%% Function:

%Size
[n_user,c1]=size(user_matrix);
[n_derivat,c2]=size(derivat_partGA);

%% 1./2.  Layer
%First/Second Layer: Which derivat fullfills user i in secondary activity
% p most

%Overfullfillment_Factor
overfullfillment_factor=-1;
%Underfullfillment_Factor
underfullfillment_factor=1;

%Initialize ff_jp_matrix
ff_ip_matrix=zeros(n_user,5);
ff_ip_ID=zeros(n_user,5);
%Initialize Layer Matrix
layer_AMN=zeros(n_derivat,100);
%Initialize Layer Matrix
layer_C2=zeros(n_derivat,100);
%Initialize Layer Matrix
layer_C3=zeros(n_derivat,100);

for i=1:n_user
    for p=1:5
        %Weighting user fullfillment
        u_d=fw(overfullfillment_factor,underfullfillment_factor,user_matrix(i,p+1),derivat_partGA(:,p));
        u_d_u=u_d./user_matrix(i,p+1);
        [ff_ip_c,derivat_ID]=max(1-u_d_u);
        for j=1:n_derivat
            if(u_d_u(j)<=100)
                ff_ip_ID(i,p)=derivat_ID;
            else
                ff_ip_ID(i,p)=0;
            end
        end
        ff_ip_matrix(i,p)=ff_ip_c;
        %Number Passanger wish 
        if(p<5 && user_matrix(i,p+1)>0)
            k=1;
            while(layer_AMN(derivat_ID,k)>0)
                k=k+1;
            end
            layer_AMN(derivat_ID,k)=user_matrix(i,p+6);
        end
        %Character Wish C2
        k=1;
        while(layer_C2(derivat_ID,k)>0)
            k=k+1;
        end
        layer_C2(derivat_ID,k)=user_matrix(i,12);
        %Character Wish C3
        k=1;
        while(layer_C3(derivat_ID,k)>0)
            k=k+1;
        end
        layer_C3(derivat_ID,k)=user_matrix(i,13);
    end
end

layer_N_ID=ff_ip_ID;
layer_ff_ip=ff_ip_matrix;
% %% 3. Layer
% %Third Layer: Saves the AMN Entry of the users
% 
% %Initialize Layer Matrix
% layer_AMN=zeros(n_derivat,5);
% %Fill Layer Matrix
% for j=1:n_derivat
%     for p=1:4
%         layer_AMN(j,p)=user_matrix(layer_N_ID(j,p),p+6);
%     end
% end
% 
% %% 4. Layer
% %Fourth Layer: Saves the C2 Entry of that User in Layer_N_ID at the same
% %position
% 
% %Initialize Layer Matrix
% layer_C2=zeros(n_derivat,5);
% %Fill Layer Matrix
% for j=1:n_derivat
%     for p=1:5
%         layer_C2(j,p)=user_matrix(layer_N_ID(j,p),12);
%     end
% end
% %% 5. Layer
% %Fifth Layer: Saves the C3 Enty of that User in Layer_N_ID at the same
% %position
% 
% %Initialize Layer Matrix
% layer_C3=zeros(n_derivat,5);
% %Fill Layer Matrix
% for j=1:n_derivat
%     for p=1:5
%         layer_C3(j,p)=user_matrix(layer_N_ID(j,p),13);
%     end
% end
end