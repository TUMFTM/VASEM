function [user_matrix_VT] = VTforSecondaryActivity(user_matrix)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff (FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Using Fuzzy for Estimation of Vehicle Type for ech secondary activity
%-----------------------
% Input:
% users in the format (N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4)
%-----------------------
% Output:
% vehicle type per user need

%% Function

[n,m]=size(user_matrix); %n: number of users

%Varibalen Initialisierung
user_matrix_VT=zeros(n,m+4); %User Matrix with estimated Vehicle Type
user_matrix_VT(:,1:m)=user_matrix;
%Get Fuzzy System
fisObject=readfis("Character2VT");
fis = getFISCodeGenerationData(fisObject);

%For each user
for i=1:n
    actual_user=user_matrix(i,:);
    %For first four secondary activities
    for j=1:4
        fuzzy_input=zeros(1,5);
        fuzzy_input(1,1)=actual_user(1,j); %Secondary Activity
        fuzzy_input(1,2)=actual_user(1,j+5); %Number People
        fuzzy_input(1,3:5)=actual_user(1,10:12); %Character C1-C3
        VT=evalfis(fis,fuzzy_input);
        user_matrix_VT(i,j+16)=VT; %Save VT in Global Matrice
    end
        
end

end

