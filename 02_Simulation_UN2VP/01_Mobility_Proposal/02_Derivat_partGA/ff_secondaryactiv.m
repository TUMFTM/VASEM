function [FF_ip_matrix,FF_N] = ff_secondaryactiv(user_matrix,derivat_partGA)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Fitness Function Part for Secondary Activity
%-----------------------
% Input:
%user_matrix
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
%....

%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....
%-----------------------
% Output:
% FF_ip_matrix
% FF_N



%% Function

%Overfullfillment <0
overfullfillment_factor=-1;
%Underfullfillment >0
underfullfillment_factor=1;

%Number User
[n_user,c1]=size(user_matrix);
%Number Derivat
[n_derivat,c2]=size(derivat_partGA);

%Initialize FF_ip_matrix
FF_ip_matrix=zeros(n_user,5);

%Fill FF_ip_matrix
for i=1:n_user
    for p=1:5
        %Weighting of Fullfillment via fw-Function and Invest C2
        u_d=fw(overfullfillment_factor,underfullfillment_factor,user_matrix(i,p+1),derivat_partGA(:,p))*(user_matrix(i,12)/10); %Column Vector
        u_d=(u_d.^2); %Square distance
        FF_ip_matrix(i,p)=prod(u_d);
        %Change Optimization Goal if Usage is small than 5
        if(p==5)
            for j=1:n_derivat
                if(derivat_partGA(j,5)<5 && user_matrix(i,p+1)>5)
                   FF_ip_matrix(i,p)=FF_ip_matrix(i,p)+u_d(j);
                end
            end
        end
    end
end
%Sum up all Entrys of FF_ip_matrix
FF_N=sum(sum(FF_ip_matrix));


end

