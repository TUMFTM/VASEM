function [input_parameter_matrix] = ConvertDP2AuVeCoDe(input_parameter_matrix)
%% Description:
% Designed by Marc Raudszus, Ferdinand Schockenhoff (FTM, Techical University of Munich)
%---------------------------------------
% Created on:   December 2021
% Last update:  January 2022
%---------------------------------------
% Version: Matlab2020b
%---------------------------------------
% Description:  This function converts the output of the Design
%               Parameters App to input for the AuVeCoDe-tool
%---------------------------------------
% Input:    input_parameter_matrix: (all necessary input parameters of the Vehicle Concepts for AuVeCoDe-tool)  
%           => cell (n x m) n = number of inputs / m = number of vehicle concepts + 1
%---------------------------------------
% Output:   input_parameter_matrix: (all necessary input parameters of the Vehicle Concepts for AuVeCoDe-tool)  
%           => cell (n x m) n = number of inputs / m = number of vehicle concepts + 1
%% Initialize function
%load('09_Design Parameters\DP_Saved_Scenarios\DP DailyGrind 80UF.mat','input_parameter_matrix'); % Matrix with all input variable names and default values for AuVeCoDe

[~,IPM_columns] = size(input_parameter_matrix);


%% Convert

for VC_count_var = 1:(IPM_columns - 1)

% Convert seating layout and number of seats per rows to total number of seats and seating layout

% Find index of desired input
index_nos_fr = find(strcmp(input_parameter_matrix(:,1),'input_seats_row_1'));
index_nos_sr = find(strcmp(input_parameter_matrix(:,1),'input_seats_row_2'));
index_nos_tr = find(strcmp(input_parameter_matrix(:,1),'input_seats_row_3'));
index_nor = find(strcmp(input_parameter_matrix(:,1),'input_int_n_rows'));
index_layout = find(strcmp(input_parameter_matrix(:,1),'input_seating_layout'));
index_layout_3rd_row = find(strcmp(input_parameter_matrix(:,1),'input_int_3rows_type'));
index_3rd_row = find(strcmp(input_parameter_matrix(:,1),'input_int_3rows'));


% Third row
if input_parameter_matrix{index_nor,VC_count_var + 1} == 3
    
    input_parameter_matrix{index_3rd_row,VC_count_var + 1} = 1;
    switch input_parameter_matrix{index_layout,VC_count_var + 1}
        case 'Conventional'
            input_parameter_matrix{index_layout_3rd_row,VC_count_var + 1} = '3con';
        case 'Vis-à-Vis in front'
            input_parameter_matrix{index_layout_3rd_row,VC_count_var + 1} = '3vavcon';
            %input_parameter_matrix{index_layout,VC_count_var + 1} = 'Vis-a-Vis';
        case 'Vis-à-Vis in back'
            input_parameter_matrix{index_layout_3rd_row,VC_count_var + 1} = '3convav';
            %input_parameter_matrix{index_layout,VC_count_var + 1} = 'Conventional';
    end
    
else
    input_parameter_matrix{index_3rd_row,VC_count_var + 1} = 0;
end

% Manipulate steering diameter (dependent on overall length)
% fe.: steering_dia_new = steering_dia_old * vehicle length / 4000


end
end
