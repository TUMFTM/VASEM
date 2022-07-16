%% Description
% Designed by David Fischer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2021
% Last update: 
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Preprocessing the user scenarios
%-----------------------
% Input:
% user_matrix
% excel file with user scenarios

%-----------------------
% Output:
% mat-file with user scenarios



%%Converting the data in the excel sheet into .mat file
clear
clc

fulldata = readtable('Scenario_Rawdata');

%Scenario1: Family
userMatrix_sc1 = fulldata{1:4,3:18};
userNames_sc1 = string(fulldata{1:4,2});

%Scenario2: Daily grind
userMatrix_sc2 = fulldata{5:10,3:18};
userNames_sc2 = string(fulldata{5:10,2});

%Scenario3: Commuter
userMatrix_sc3 = fulldata{11:16,3:18};
userNames_sc3 = string(fulldata{11:16,2});

save('Scenario_Data.mat')