function [derivat_CRP] = read_fuzzy_CRP(derivat_suggestion_single)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff, David Fischer (FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Use Fuzzy Logic for calcualtion of customer relevant properties for one
% derivat "derivat_suggestion_single"
%-----------------------
% Input:
% derivat_suggestion_singele
% [ID D1 D2 D3 D4 D5 NumberPassenger Laengs Quer Vertikal Invest Safety City
% Rural Highway Daily Deviation2MaxDC VT]
%-----------------------
% Output:
% derivat_CRP
% values of the CRPs of the vehicle concepts




%% Input Structure of Fuzzy System
%[D1 D2 D3 D4 D5 Passenger Laengs Quer VT Invest Safety City Rural Highway
%Daily]

%% Prepare Input for Fuzzy
derivat_fuzzy=zeros(1,15);
derivat_fuzzy(1,1:6)=derivat_suggestion_single(1,2:7); %Room + Passenger
%Get input for Room Requirement on scale from 0 to 10 according to most important secondary
%activty
derivat_fuzzy(1,7)=mean([derivat_suggestion_single(1,11) max(derivat_suggestion_single(1,2:6))]);
derivat_fuzzy(1,8)=mean([derivat_suggestion_single(1,11) max(derivat_suggestion_single(1,2:6))]);
%derivat_fuzzy(1,7:8)=0.5; %Actual set at 0.5 , definition of real values follwos
derivat_fuzzy(1,9)=derivat_suggestion_single(1,18);
derivat_fuzzy(1,10:15)=derivat_suggestion_single(1,11:16);

%% Get Fuzzy System
fisObject=readfis("Fuzzy_CRP");
fis = getFISCodeGenerationData(fisObject);

%% Evaluate fuzzy
warning('off','all');
derivat_CRP=evalfis(fis,derivat_fuzzy);

end

