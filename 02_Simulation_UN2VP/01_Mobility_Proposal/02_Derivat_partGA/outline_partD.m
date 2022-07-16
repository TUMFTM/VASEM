function [derivat_partGA] = outline_partD(x,number_derivat)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Outline of derivat part D1-D6 C2 C3 in matrice notation

%-----------------------
% Input:

% x,number_derivat

%-----------------------
% Output:

%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....

%% Function:
derivat_partGA=zeros(number_derivat,8);
k=1;
for i=1:number_derivat
    derivat_partGA(i,:)=x(k:k+7);
    k=k+8;
end

end

