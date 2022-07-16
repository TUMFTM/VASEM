function [ff_fullfillment] = ff_fullfillment(user_matrix,derivat_partGA,wish_fullfillment,VT)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Fitness Function Part for user fullfilment
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

%wish_fullfillment

%VT

%-----------------------
% Output:
% ff_fullfillment

%% Function

%Number User
[n_user,c1]=size(user_matrix);
%Number Derivat
[n_derivat,c2]=size(derivat_partGA);

%User fullfilment
[ff_user_n_amn_c,mean_ff] = user_ff(user_matrix,derivat_partGA,wish_fullfillment,VT);
overfullfillment_factor=0;
underfullfillment_factor=2;
FF_n=zeros(n_user,5);
for i=1:4
    FF_n(:,i)=(fw(overfullfillment_factor,underfullfillment_factor,wish_fullfillment,ff_user_n_amn_c(:,i))).*user_matrix(:,12);
end
FF_n(:,5)=(fw(overfullfillment_factor,underfullfillment_factor,wish_fullfillment,mean_ff)).*user_matrix(:,12);
ff_fullfillment=sum(sum(FF_n));

end

