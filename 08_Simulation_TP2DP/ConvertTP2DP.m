function [input_parameter_matrix] = ConvertTP2DP(TechnicalPropertiesVC,Derivative,MinMaxTP,VehicleTypes,currentCRP)
%% Description:
% Designed by Marc Raudszus, Ferdinand Schockenhoff (FTM, Techical University of Munich)
%---------------------------------------
% Created on:   October 2021
% Last update:  April 2022
%---------------------------------------
% Version: Matlab2020b
%---------------------------------------
% Description:  This function converts the output of the Technical Properties App to input for the AuVeCoDe-tool
%               For detailed documentation see: master's thesis "Nutzerorientierte Untersuchung konzeptbestimmender Eigenschaften autonomer Fahrzeuge" by Marc Raudszus
%---------------------------------------
% Input:    TechnicalPropertiesVC           (technical properties of the Vehicle Concepts)         double (n x 30) n= number of vehicle concepts
%           CustomerRelevantPropertiesVC    (customer-relevant properties of the Vehicle Concepts) double (n x 29) n= number of vehicle concepts
%           Derivative                      (previous derivative of the Vehicle Concepts)          double (n x 18) n = number of vehicle concepts
%           MinMaxTP                        (Min and Max Value of the 30 technical properties)     double (2 x 30)
%           VehicleType                     (Vehicle Type of the VCs)                              string (1 x n) n = number of vehicle concepts
%           currentCRP                      (current customer-relevant properties of the Vehicle Concepts)  double (n x 29) n= number of vehicle concepts
%---------------------------------------
% Output:   input_parameter_matrix: (all necessary input parameters of the Vehicle Concepts for AuVeCoDe-tool)
%           => cell (n x m) n = number of inputs / m = number of vehicle concepts + 1
%---------------------------------------
% Sources: Ferdinand Schockenhoff, "Fahrzeugkonzeptentwicklung für autonome, geteilte und elektrische Mobilität", Technical University of Munich, Institute of Automotive Technology, 2022

%% Initialize function

% Cleanup derivate-matrix (all user-need values less than than 1 will be set to zero due to optimization functionality)
Derivative(Derivative < 1) = 0;

% Get number of total Vehicle Concepts from Technical Properties App
Number_VC = height(TechnicalPropertiesVC);

% Load default input data for AuVeCoDe
load('08_Simulation_TP2DP\input_parameter_base_matrix.mat','input_parameter_base_matrix'); % Matrix with all input variable names and default values for AuVeCoDe

% Get number of input parameters
Number_IP = height(input_parameter_base_matrix);

% Create input parameter matrix
input_parameter_matrix = cell(Number_IP,Number_VC + 1);
input_parameter_matrix(:,1) = input_parameter_base_matrix(:,1);

% Fill input parameter matrix with default values from AuVeCoDe
for iColumn_idm = 2 : Number_VC + 1
    input_parameter_matrix(:,iColumn_idm) = input_parameter_base_matrix(:,2);
end

% Define thresholds
threshold_load = 5;             % If Load-UN is over threshold, VC is considered load-vehicle
threshold_self_driving = 2;     % If Self-Driving-UN is over threshold, VC needs to be driven by a human

% Update input parameter matrix with output data from Technical Properties App:
%% Copy TP with direct assignment to input parameter matrix
%-----------------------------------------------------------------------------------------------
% Top speed
% Find index of desired input (necessary if parameter input matrix gets updated)
index_vmax = find(strcmp(input_parameter_matrix(:,1),'input_maximal_speed'));
% Update input parameter matrix
input_parameter_matrix(index_vmax,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,1))'); %#ok<*FNDSB>
%-----------------------------------------------------------------------------------------------
% Acceleration 0 - 100 km/h
index_amax = find(strcmp(input_parameter_matrix(:,1),'input_maximal_acceleration'));
input_parameter_matrix(index_amax,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,2))');
%-----------------------------------------------------------------------------------------------
% Turning circle
index_turning_diameter = find(strcmp(input_parameter_matrix(:,1),'input_turning_diameter'));
input_parameter_matrix(index_turning_diameter,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,5))');
%-----------------------------------------------------------------------------------------------
% Range
index_range = find(strcmp(input_parameter_matrix(:,1),'input_range'));
input_parameter_matrix(index_range,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,19))');
%-----------------------------------------------------------------------------------------------
% Wheel Diameter
index_tire_diam_min = find(strcmp(input_parameter_matrix(:,1),'input_tire_diam_min'));
index_tire_diam_max = find(strcmp(input_parameter_matrix(:,1),'input_tire_diam_max'));
input_parameter_matrix(index_tire_diam_min,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,29))');
input_parameter_matrix(index_tire_diam_max,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,29))');
%-----------------------------------------------------------------------------------------------
% Step height
index_int_height_min = find(strcmp(input_parameter_matrix(:,1),'input_int_height_min'));
index_int_height_max = find(strcmp(input_parameter_matrix(:,1),'input_int_height_max'));
input_parameter_matrix(index_int_height_min,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,6))');
input_parameter_matrix(index_int_height_max,2:(Number_VC + 1)) = num2cell((TechnicalPropertiesVC(:,6))');
%-----------------------------------------------------------------------------------------------
%% Convert TP-output to AuVeCoDe-input
for VC_count_var = 1:Number_VC
    %% Convert TP to free crash length (side and back)
    
    % Necessary input for AuVeCoDe: - free crash length front
    %                               - free crash length rear
    %                               - free crash length side
    %
    % Available input from CRP2TP:  - free crash length front
    %
    % Solution for conversion: Linear interpolation with extreme values for
    % free crash length rear and side
    
    % Find index of free crash length (necessary if parameter input matrix gets updated)
    index_fcl_f = find(strcmp(input_parameter_matrix(:,1),'input_free_crash_length'));
    index_fcl_r = find(strcmp(input_parameter_matrix(:,1),'input_free_crash_length_2'));
    index_fcl_s = find(strcmp(input_parameter_matrix(:,1),'input_free_crash_length_3'));
    
    % Set limits for linear Interpolation
    %limits_fcl_f = [MinMaxTP(1,13), MinMaxTP(2,13)]; % Limits without reduced fcl
    limits_fcl_f = [(MinMaxTP(1,13)*(1-0.1)), (MinMaxTP(2,13)*(1-0.1))]; % Reducing the fcl front by 10% to mind cables and small components
    limits_fcl_r = [150, 550];  % Source: A2Mac1, Your Global Partner for Benchmarking. [Online] Verfügbar: https://portal.a2mac1.com/
    limits_fcl_s = [164, 282];  % Source: A2Mac1, Your Global Partner for Benchmarking. [Online] Verfügbar: https://portal.a2mac1.com/
    
    % Calculate ratio from current TP-value of free crash length front (ratio to min and max limits)
    ratio_TP_fcl = (TechnicalPropertiesVC(VC_count_var,13)*(1-0.1) - limits_fcl_f(1,1))/(limits_fcl_f(1,2)-limits_fcl_f(1,1));
    
    % Calculate free crash length rear and side and update input parameter base data matrix
    fcl_front = (TechnicalPropertiesVC(VC_count_var,13)*(1-0.1));   % Reducing the fcl front by 10% to mind cables and small components
    fcl_rear = ratio_TP_fcl*(limits_fcl_r(1,2)-limits_fcl_r(1,1))+limits_fcl_r(1,1);
    fcl_side = ratio_TP_fcl*(limits_fcl_s(1,2)-limits_fcl_s(1,1))+limits_fcl_s(1,1);
    
    % Update input parameter matrix
    input_parameter_matrix{index_fcl_f,VC_count_var+1} = fcl_front;
    input_parameter_matrix{index_fcl_r,VC_count_var+1} = fcl_rear;
    input_parameter_matrix{index_fcl_s,VC_count_var+1} = fcl_side;
    %% Convert TP to seating layout
    
    % Necessary input for AuVeCoDe: - seating layout
    %
    % Available input from CRP2TP:  - user needs
    %
    % Solution for conversion: Create probability function for seating layout depending on User-Needs
    
    % Find index of desired input
    index_seating_layout = find(strcmp(input_parameter_matrix(:,1),'input_seating_layout'));
    
    % Calculate seat rows with simple function (needed for this function)
    if TechnicalPropertiesVC(VC_count_var,22) < 3 % Less than 2 seats in VC overall
        % Allow one seat row
        seat_rows = 1;
    elseif TechnicalPropertiesVC(VC_count_var,22) >= 3 && TechnicalPropertiesVC(VC_count_var,22) < 7
        % Allow two seat rows
        seat_rows = 2;
    elseif TechnicalPropertiesVC(VC_count_var,22) >= 7
        % Allow three seat rows
        seat_rows = 3;
    end
    
    % Initialize constant seating layout probability for User-Needs
    % Probability-value = 0     -> seating layout = vis-á-vis
    % Probability-value = 100   -> seating layout = conventional
    % Border between both seating layouts: Probability-value = 50
    sl_prob_driving = 100;  % Source: Ferdinand Schockenhoff, "Fahrzeugkonzeptentwicklung für autonome, geteilte und elektrische Mobilität", Technical University of Munich, Institute of Automotive Technology, 2022
    sl_prob_relax = 17;     % Source: Ferdinand Schockenhoff, "Fahrzeugkonzeptentwicklung für autonome, geteilte und elektrische Mobilität", Technical University of Munich, Institute of Automotive Technology, 2022
    sl_prob_work = 50;      % Source: Ferdinand Schockenhoff, "Fahrzeugkonzeptentwicklung für autonome, geteilte und elektrische Mobilität", Technical University of Munich, Institute of Automotive Technology, 2022
    sl_prob_sleep = 83;     % Source: Ferdinand Schockenhoff, "Fahrzeugkonzeptentwicklung für autonome, geteilte und elektrische Mobilität", Technical University of Munich, Institute of Automotive Technology, 2022
    
    % Derivative(VC_count_var,2) = User-Need: self driving
    % Derivative(VC_count_var,3) = User-Need: relax
    % Derivative(VC_count_var,4) = User-Need: work
    % Derivative(VC_count_var,5) = User-Need: sleep
    
    % Calculate total probability (doesnt work for load vehicles)
    prob_tot = (Derivative(VC_count_var,5)*sl_prob_sleep + Derivative(VC_count_var,4)*sl_prob_work + ...
        Derivative(VC_count_var,3)*sl_prob_relax + Derivative(VC_count_var,2)*sl_prob_driving)/sum(Derivative(VC_count_var,(2:5)));
    
    % Define seating layout based on probability value and number of rows
    switch seat_rows
        case 1
            % VC with one seat row
            seating_layout = 'Single Row';
        case 2
            % VC with two seat rows
            if Derivative(VC_count_var,2) > threshold_self_driving
                % If driving user need is greater than threshold, first row needs to be in driving direction
                seating_layout = 'Conventional';
            elseif prob_tot >= 0 && prob_tot <= 50
                seating_layout = 'Vis-a-Vis';
            elseif prob_tot > 50 && prob_tot <= 100
                seating_layout = 'Conventional';
            end
        case 3
            % VC with three seat rows
            if prob_tot >= 0 && prob_tot <= 50
                if Derivative(VC_count_var,2) > threshold_self_driving
                    % If driving user need is greater than threshold, first row needs to be in driving direction
                    seating_layout = 'Vis-à-Vis in back';
                else
                    seating_layout = 'Vis-à-Vis in front';
                end
            elseif prob_tot > 50 && prob_tot <= 100
                seating_layout = 'Conventional';
            end
    end

    % Update input parameter base data matrix
    input_parameter_matrix{index_seating_layout,VC_count_var+1} = seating_layout;
    %% Convert TP to number of seats
    
    % Necessary input for AuVeCoDe: - number of seats (first row)
    %                               - number of seats (second row)
    %                               - number of seats (third row)
    %
    % Available input from CRP2TP:  - number of seats (total)
    %
    % Solution for conversion: Number of seats divided by number of rows
    % If number of seats cant be divided by number of rows (natural number)
    % => Number of seats in back = Number of seats in front + 1
    
    % Find index of desired input
    index_nos_fr = find(strcmp(input_parameter_matrix(:,1),'input_seats_row_1'));
    index_nos_sr = find(strcmp(input_parameter_matrix(:,1),'input_seats_row_2'));
    index_nos_tr = find(strcmp(input_parameter_matrix(:,1),'input_seats_row_3'));
    index_nor = find(strcmp(input_parameter_matrix(:,1),'input_int_n_rows'));
    
    if TechnicalPropertiesVC(VC_count_var,22) < 3
        % Allow one seat row
        seat_rows = 1;
        input_parameter_matrix{index_nos_fr,VC_count_var+1} = TechnicalPropertiesVC(VC_count_var,22);
        input_parameter_matrix{index_nos_sr,VC_count_var+1} = 0;
        input_parameter_matrix{index_nos_tr,VC_count_var+1} = 0;
        % For load vehicle create vehicle with one seat for possible
        % simulation in AuVeCoDe Tool
        if TechnicalPropertiesVC(VC_count_var,22) == 0
            input_parameter_matrix{index_nos_fr,VC_count_var+1} = 1;
        end
    elseif TechnicalPropertiesVC(VC_count_var,22) >= 3 && TechnicalPropertiesVC(VC_count_var,22) < 7
        % Allow two seat row
        seat_rows = 2;
        seats_per_row = fix(TechnicalPropertiesVC(VC_count_var,22)/2);
        input_parameter_matrix{index_nos_fr,VC_count_var+1} = seats_per_row;
        input_parameter_matrix{index_nos_tr,VC_count_var+1} = 0;
        % Fill seats from the back
        if mod(TechnicalPropertiesVC(VC_count_var,22),2) ~= 0
            input_parameter_matrix{index_nos_sr,VC_count_var+1} = seats_per_row + 1;
        else
            input_parameter_matrix{index_nos_sr,VC_count_var+1} = seats_per_row;
        end
    elseif TechnicalPropertiesVC(VC_count_var,22) >= 7
        % Allow three seat row
        seat_rows = 3;
        seats_per_row = fix(TechnicalPropertiesVC(VC_count_var,22)/3);
        % Fill seats from the back
        
        if mod(TechnicalPropertiesVC(VC_count_var,22),3) == 1   % Seven seats
            % Check for seating layout (for "Conventional" and "Vis-à-vis in
            % back" change row with 3 seats to front row, because 2nd and
            % 3rd row need to have the same parameters)
            if strcmp(seating_layout,'Conventional') || strcmp(seating_layout,'Vis-à-Vis in back')
                input_parameter_matrix{index_nos_fr,VC_count_var+1} = seats_per_row + 1;
                input_parameter_matrix{index_nos_sr,VC_count_var+1} = seats_per_row;
                input_parameter_matrix{index_nos_tr,VC_count_var+1} = seats_per_row;
            else % Vis-à-Vis in front
                % Fill seats from the back
                input_parameter_matrix{index_nos_fr,VC_count_var+1} = seats_per_row;
                input_parameter_matrix{index_nos_sr,VC_count_var+1} = seats_per_row;
                input_parameter_matrix{index_nos_tr,VC_count_var+1} = seats_per_row + 1;
            end
            
        elseif mod(TechnicalPropertiesVC(VC_count_var,22),3) == 2   % Eight seats
            % Check for seating layout (for "Vis-à-vis in front" change
            % rows with 3 seats to first and second row, because 1st and
            % 2nd row need to have the same parameters)
            if strcmp(seating_layout,'Vis-à-Vis in front')
                input_parameter_matrix{index_nos_fr,VC_count_var+1} = seats_per_row + 1;
                input_parameter_matrix{index_nos_sr,VC_count_var+1} = seats_per_row + 1;
                input_parameter_matrix{index_nos_tr,VC_count_var+1} = seats_per_row;
            else % Conventional and Vis-à-vis in back
                % Fill seats from the back
                input_parameter_matrix{index_nos_fr,VC_count_var+1} = seats_per_row;
                input_parameter_matrix{index_nos_sr,VC_count_var+1} = seats_per_row + 1;
                input_parameter_matrix{index_nos_tr,VC_count_var+1} = seats_per_row + 1;
            end
            
        else % Nine seats
            input_parameter_matrix{index_nos_fr,VC_count_var+1} = seats_per_row;
            input_parameter_matrix{index_nos_sr,VC_count_var+1} = seats_per_row;
            input_parameter_matrix{index_nos_tr,VC_count_var+1} = seats_per_row;
        end
    end
    
    % Update input parameter base data matrix
    input_parameter_matrix{index_nor,VC_count_var+1} = seat_rows;
    
    %% Convert Parameters to trunk/(body) type and window angle
    
    % Necessary input for AuVeCoDe: - trunk/(body) type front and rear
    %                               - window angle front and rear
    %                               - trunk ratio
    %
    % Available input from CRP2TP:  - seating layout
    %
    % Solution for conversion:  If seats are directed to the window, trunk/(body) type is hooded and inital window angle is 40°
    %                           If seats are NOT directed to the window, trunk/(body) type is integrated and inital window angle is 10°
    
    % Find index of desired input
    index_trunk_front = find(strcmp(input_parameter_matrix(:,1),'input_trunk_type_front'));
    index_trunk_rear = find(strcmp(input_parameter_matrix(:,1),'input_trunk_type_rear'));
    index_window_front = find(strcmp(input_parameter_matrix(:,1),'input_window_angle_front_min'));
    index_window_rear = find(strcmp(input_parameter_matrix(:,1),'input_window_angle_rear_min'));
    index_trunk_ratio = find(strcmp(input_parameter_matrix(:,1),'input_trunk_ratio_min'));
    
    % Define trunk/(body) type, window angle and Trunk ratio front/rear depending on the seating layout
    % in the front seats are directed to the window & in the rear seats are NOT directed to the window
    if strcmp(seating_layout,'Conventional') || strcmp(seating_layout,'Vis-à-Vis in back') || strcmp(seating_layout,'Single Row')
        trunk_front = 'hooded';
        trunk_rear = 'integrated';
        window_front = 50; %Source: A. König, S. Mayer, L. Nicoletti, S. Tumphart und M. Lienkamp, „The Impact of HVAC on the Development of Autonomous and Electric Vehicle Concepts“, Energies, Jg. 15, Nr. 2, S. 441, 2022, doi: 10.3390/en15020441
        window_rear = 15;  %Source: A. König, S. Mayer, L. Nicoletti, S. Tumphart und M. Lienkamp, „The Impact of HVAC on the Development of Autonomous and Electric Vehicle Concepts“, Energies, Jg. 15, Nr. 2, S. 441, 2022, doi: 10.3390/en15020441
        trunk_ratio = 20; %typical frunk
    
    % in the front and in the rear seats are NOT directed to the window
    else %'Vis-à-Vis' & 'Vis-à-Vis in front'
        trunk_front = 'integrated'; %Combi
        trunk_rear = 'integrated';  
        window_front = 15; %Source: A. König, S. Mayer, L. Nicoletti, S. Tumphart und M. Lienkamp, „The Impact of HVAC on the Development of Autonomous and Electric Vehicle Concepts“, Energies, Jg. 15, Nr. 2, S. 441, 2022, doi: 10.3390/en15020441
        window_rear = 15;  %Source: A. König, S. Mayer, L. Nicoletti, S. Tumphart und M. Lienkamp, „The Impact of HVAC on the Development of Autonomous and Electric Vehicle Concepts“, Energies, Jg. 15, Nr. 2, S. 441, 2022, doi: 10.3390/en15020441
        trunk_ratio = 50; % 2 similar trunks
        
    end
    
    % Update input parameter base data matrix
    input_parameter_matrix{index_trunk_front,VC_count_var+1} = trunk_front;
    input_parameter_matrix{index_trunk_rear,VC_count_var+1} = trunk_rear;
    input_parameter_matrix{index_window_front,VC_count_var+1} = window_front;
    input_parameter_matrix{index_window_rear,VC_count_var+1} = window_rear;
    input_parameter_matrix{index_trunk_ratio,VC_count_var+1} = trunk_ratio;
    
        
    %% Convert TP to number of doors
    
    % Necessary input for AuVeCoDe: - number of doors
    %
    % Available input from CRP2TP:  - number of seats
    %                               - door widths per seat
    %                               - vehicle type
    %
    % Solution for conversion: Use door widths per seats and number of seats to calculate door widths
    % Get number of doors depending on vehicle type and number of seat rows
    
    % Find index of desired input
    index_nod = find(strcmp(input_parameter_matrix(:,1),'input_n_doors'));
    
    % Calculate total door widths
    door_widths = TechnicalPropertiesVC(VC_count_var,8)*TechnicalPropertiesVC(VC_count_var,22);
    
    % Calculate number of doors depending on vehicle type
    % Constants for door widths:
    
    % Shuttle: 1250 mm  Source: EvoBus GmbH, Die Citaro Stadtbusse: Technische Information
    shuttle_width = 1250;
    
    % Private: 900 mm   Source: G. Weller, N. Strauzenberg, und M. Herle, Accident patterns and prospects for maintaining the safety of older drivers p.113
    private_width = 900;
    
    % Taxi: 1075 mm     Source: Average between Shuttle and Private
    taxi_width = 1075;
    
    % Load: special case with only one door
    
    vehicle_type = VehicleTypes{1,VC_count_var};
    
    switch vehicle_type
        
        case 'Shuttle'
            number_doors = round(door_widths/shuttle_width);
            if input_parameter_matrix{index_nos_tr,VC_count_var+1} == 0
                if input_parameter_matrix{index_nos_sr,VC_count_var+1} == 0
                    if number_doors > 2
                        number_doors = 2;
                    end
                end
                if number_doors > 4
                    number_doors = 4;
                end
            end
            if number_doors > 6
                number_doors = 6;
            end
            
        case 'Private'
            number_doors = round(door_widths/private_width);
            if input_parameter_matrix{index_nos_tr,VC_count_var+1} == 0
                if input_parameter_matrix{index_nos_sr,VC_count_var+1} == 0
                    if number_doors > 2
                        number_doors = 2;
                    end
                end
                if number_doors > 4
                    number_doors = 4;
                end
            end
            if number_doors > 6
                number_doors = 6;
            end
            
        case 'Taxi'
            number_doors = round(door_widths/taxi_width);
            if input_parameter_matrix{index_nos_tr,VC_count_var+1} == 0
                if input_parameter_matrix{index_nos_sr,VC_count_var+1} == 0
                    if number_doors > 2
                        number_doors = 2;
                    end
                end
                if number_doors > 4
                    number_doors = 4;
                end
            end
            if number_doors > 6
                number_doors = 6;
            end
        case 'Load'
            number_doors = 1;
    end
    
    % Update input parameter base data matrix
    input_parameter_matrix{index_nod,VC_count_var+1} = number_doors;
    %% Convert TP to backrest angle
    
    % Necessary input for AuVeCoDe: - backrest angle min (3 rows)
    %                               - backrest angle max (3 rows)
    %
    % Available input from CRP2TP:  - user needs
    %
    % Solution for conversion: Create function for backrest angle min/max depending on User-Needs
    
    % Find index of desired input (cleaner method)
    index_br_angle_max = zeros(seat_rows,1);
    index_br_angle_min = zeros(seat_rows,1);
    
    for i_interior = 1:seat_rows
        index_br_angle_max(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_angle_br_max_%0.0f',i_interior)));
        index_br_angle_min(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_angle_br_min_%0.0f',i_interior)));
    end
    
    % Initialize constant backrest-values for User-Needs
    br_angle_driving_min = 62; % Source: H. Bubb, Automobilergonomie, p.376
    br_angle_driving_max = 83; % Source: H. Bubb, Automobilergonomie, p.376
    br_angle_relax_min = 56;   % Source: S. Hiemstra-van Mastrigt, "Comfortable passenger seats", p.160/175
    br_angle_relax_max = 68;   % Source: S. Hiemstra-van Mastrigt, "Comfortable passenger seats", p.160/175
    br_angle_work_min = 60;    % Source: E. H. C. Woo, P. White, und C. W. K. Lai, "Ergonomics standards and guidelines for computer workstation design and the impact on users' health - a review," p.467
    br_angle_work_max = 90;    % Source: E. H. C. Woo, P. White, und C. W. K. Lai, "Ergonomics standards and guidelines for computer workstation design and the impact on users' health - a review," p.467
    br_angle_sleep_min = 0;    % Source: Sleeping position in bed
    br_angle_sleep_max = 25;   % Source: M. J. Stanglmeier et al, "Automated driving: A biomechanical approach for sleeping positions", p.7
    
    % Derivative(VC_count_var,2) = User-Need: self driving
    % Derivative(VC_count_var,3) = User-Need: relax
    % Derivative(VC_count_var,4) = User-Need: work
    % Derivative(VC_count_var,5) = User-Need: sleep
    
    % For load vehicles (all User-Needs execpt load = 0) angle function
    % does not work because sum(Derivative(VC_count_var,(2:5))) = 0 and
    % its not possible to divide by zero
    if sum(Derivative(VC_count_var,(2:5))) == 0
        br_angle_min = 60;
        br_angle_max = 90;
    else
        % Function for backrest angle min:
        br_angle_min = (Derivative(VC_count_var,2)*br_angle_driving_min + Derivative(VC_count_var,3)*br_angle_relax_min...
            + Derivative(VC_count_var,4)*br_angle_work_min + Derivative(VC_count_var,5)*br_angle_sleep_min)/sum(Derivative(VC_count_var,(2:5)));
        
        % Function for backrest angle max:
        br_angle_max = (Derivative(VC_count_var,2)*br_angle_driving_max + Derivative(VC_count_var,3)*br_angle_relax_max...
            + Derivative(VC_count_var,4)*br_angle_work_max + Derivative(VC_count_var,5)*br_angle_sleep_max)/sum(Derivative(VC_count_var,(2:5)));
    end
    
    % Adjust backrest angles for high User-Needs values:
    if Derivative(VC_count_var,2) > threshold_self_driving && br_angle_max < 85     % High self driving need and too low backrest angle max
        br_angle_max = 85;
    end
    
    if Derivative(VC_count_var,4) > 3 && br_angle_max < 85     % High work need and too low backrest angle max
        br_angle_max = 85;
    end
    
    if Derivative(VC_count_var,5) > 3 && br_angle_min > 25     % High sleep need and too high backrest angle min
        br_angle_min = 25;
    end
    
    % Update input parameter base data matrix
    for i_interior = 1:seat_rows
        input_parameter_matrix{index_br_angle_max(i_interior,1),VC_count_var+1} = br_angle_max;
        input_parameter_matrix{index_br_angle_min(i_interior,1),VC_count_var+1} = br_angle_min;
    end
    %% Convert TP to headroom and upper body length
    
    % Necessary input for AuVeCoDe: - headroom
    %                               - upper body length
    %
    % Available input from CRP2TP:  - package measure H-61 (8° tilted measure form hip joint to inner car ceiling)
    %
    % Solution for conversion: Calculating headroom with dimensional chain:
    % H-61 + rHSv = Upper body length + headroom
    
    % Find index of desired input (cleaner method)
    index_ubl = zeros(seat_rows,1);
    index_headroom = zeros(seat_rows,1);
    
    for i_interior = 1:seat_rows
        index_ubl(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_upperbody_length_%0.0f',i_interior)));
        index_headroom(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_headroom_%0.0f',i_interior)));
    end
    
    % Define seating reference point to hip joint point vertical as a constant in mm
    rHSv = 105;         % Source: Schienenfahrzeuge - Führerräume - Teil 1: Allgemeine Anforderungen, DIN 5566-1, p.7 recommended
    
    % Define head length as a constant in mm
    head_length = 205;  % Source: Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2, p.72
    
    % Define upper body length as a constant (95th percentile man) in mm
    UB_length = 965;    % Source: Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2, p.29
    
    % Calculate headroom
    % TechnicalPropertiesVC(VC_count_var,11) = package measure H-61
    headroom = TechnicalPropertiesVC(VC_count_var,11) + rHSv - UB_length;
    
    % Calculate headromm total, to mind for the cosinus of the head length
    % for low br angles
    headroom_tot = headroom + head_length*cosd(br_angle_max);
    
    if headroom_tot < 0
        msg_headroom = 'Headroom is negative!';
        error(msg_headroom);
    end
    
    % Update input parameter base data matrix
    for i_interior = 1:seat_rows
        input_parameter_matrix{index_ubl(i_interior,1),VC_count_var+1} = UB_length;
        input_parameter_matrix{index_headroom(i_interior,1),VC_count_var+1} = headroom_tot;
    end
    %% Convert TP to backrest length
    
    % Necessary input for AuVeCoDe: - backrest length (3 rows)
    %
    % Available input from CRP2TP:  - Upper body length
    %
    % Solution for conversion: Since the backrest length is only used for
    % cosmetic inputs: backreast length = constant value
    
    % Find index of desired input (cleaner method)
    index_br_length = zeros(seat_rows,1);
    
    for i_interior = 1:seat_rows
        index_br_length(i_interior) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_backrest_length_%0.0f',i_interior)));
    end
    
    % Define backrest length as 90% of upper body length (br length is purely cosmetic)
    br_length = UB_length*0.9;
    
    % Update input parameter base data matrix
    for i_interior = 1:seat_rows
        input_parameter_matrix{index_br_length(i_interior,1),VC_count_var+1} = br_length;
    end
    %% Convert TP to seat height and seat adjustment - z
    
    % Necessary input for AuVeCoDe: - seat height
    %                               - seat adjustment - z
    %
    % Available input from CRP2TP:  - clearance height interior
    %
    % Available input from steps before:   - headroom
    %                                      - upper body length
    %                                      - backrest angle
    %
    % Solution for conversion: Calculating seat height with dimensional chain:
    % Clearance height = headroom_tot + sin(backrest angle max)*upper body length + seat height
    %
    % For high values of clearance height seat height might be too high
    % above the ground (feet of passengers might not touch the ground)
    % because every variable except seat height is already set!
    %
    % For this scenario an if-loop will be implemented to make sure the
    % seat height is always low enough for passengers feet to touch the
    % ground (50th percentile woman seat surface height as threshold)
    
    % Find index of desired input (cleaner method)
    index_seat_height = zeros(seat_rows,1);
    index_seat_adj_z = zeros(seat_rows,1);
    
    for i_interior = 1:seat_rows
        index_seat_height(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_seat_height_%0.0f',i_interior)));
        index_seat_adj_z(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_seat_adjustment_z_%0.0f',i_interior)));
    end
    
    % Calculate seat height
    % TechnicalPropertiesVC(VC_count_var,7) = clearance height
    seat_height = TechnicalPropertiesVC(VC_count_var,7) - sind(br_angle_max)*UB_length - headroom_tot;
    
    % Set seat adjustment in z 0 (part of seat height)
    seat_adj_z = 0;
    
    % if-loop for seat height values greater than seat surface height of 50th percentile woman
    if seat_height > 415
        seat_height = 415; % Source: Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2, p.34
    end
    
    % Update input parameter base data matrix
    for i_interior = 1:seat_rows
        input_parameter_matrix{index_seat_height(i_interior,1),VC_count_var+1} = seat_height;
        input_parameter_matrix{index_seat_adj_z(i_interior,1),VC_count_var+1} = seat_adj_z;
    end
    %% Convert TP to backrest width, gap between seats and gap to wall
    
    % Necessary input for AuVeCoDe: - backrest width
    %                               - gap between seats
    %                               - gap to wall
    %
    % Available input from CRP2TP:  - package measure W-3 per seat (shoulderroom per seat)
    %                               - number of seats
    %
    % Solution for conversion: Calculating backrest width, gap between seats
    % and gap to wall with dimensional chain depending on number of seats
    % per row
    %
    % Backrest width = seat width in AuVeCoDe!
    
    % Find index of desired input (cleaner method)
    index_br_width = zeros(seat_rows,1);
    index_gap_seats = zeros(seat_rows,1);
    index_gap_wall = zeros(seat_rows,1);
    
    for i_interior = 1:seat_rows
        index_br_width(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_backrest_width_%0.0f',i_interior)));
        index_gap_seats(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_seatgap_%0.0f',i_interior)));
        index_gap_wall(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_gaptowall_%0.0f',i_interior)));
    end
    
    % Extract number of seats in row with maximum and minimum number of seats
    nos_row = [input_parameter_matrix{index_nos_fr,VC_count_var+1};input_parameter_matrix{index_nos_sr,VC_count_var+1};...
        input_parameter_matrix{index_nos_tr,VC_count_var+1}];
    [nos_row_max,~] = max(nos_row);
    
    % Calculate target shoulderroom (input from CRP2TP)
    % TechnicalPropertiesVC(VC_count_var,10) = package measure W-3 per seat
    % TechnicalPropertiesVC(VC_count_var,22) = number of seats
    shoulderroom_target = TechnicalPropertiesVC(VC_count_var,10)*nos_row_max;
    
    % Define minimum gap between seats and gap to wall as difference of body width (with elbows) and hip width (50th percentile woman)
    gap_wall_min = 48;                  % Source: Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2, p.40-41
    gap_seats_min = 2*gap_wall_min;     % Ratio of gap to wall and gap between seat is 1:2 (because two passengers elbow touch at gap between seats -> double the space necessary)
    
    % Define minimum backrest width as hip width in seating position (50th percentile woman)
    br_width_min = 390;                 % Source: Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2, p.41
    
    % Define maximum backrest width as average seat width for truck seats
    br_width_max = 490;                 % Source: Cleemann Sitzsysteme GmbH, ARIZONA Überzeugt durch Leistung und Komfort, (https://www.cleemann-sitze.de/sitzsysteme-fuer-alle-fahrzeuge/lkw/) (Dimensionen)
    
    % Calculate actual maximum shoulderroom (input for AuVeCoDe) of row with most seats
    shoulderroom_actual_max = br_width_max*nos_row_max + gap_wall_min*2 + gap_seats_min*(nos_row_max - 1);
    
    % Calculate actual minimum shoulderroom (input for AuVeCoDe) of row with most seats
    shoulderroom_actual_min = br_width_min*nos_row_max + gap_wall_min*2 + gap_seats_min*(nos_row_max - 1);
    
    % Calculate actual minimum shoulderroom without gap between seats (bench case)
    shoulderroom_actual_min_bench = br_width_min*nos_row_max + gap_wall_min*2;
    
    % First calculate interior components for row with most seats (later for rows with other number of seats)
    % Check if actual shoulderroom is less than target shoulderroom
    if shoulderroom_actual_max <= shoulderroom_target
        % If true, increase gaps between seats and to wall by calculating the dimensions (with constant maximum backrest width)
        gap_wall = (shoulderroom_target - (br_width_max*nos_row_max))/(2*nos_row_max);
        gap_seats = (shoulderroom_target - (br_width_max*nos_row_max))/nos_row_max;
        br_width = br_width_max;
    elseif shoulderroom_actual_max > shoulderroom_target
        % Check if target shoulderroom is possible with minimum backrest width
        if shoulderroom_actual_min <= shoulderroom_target
            % If true, decrease backrest width (with constant minimum gaps)
            br_width = (shoulderroom_target - gap_wall_min*2 - gap_seats_min*(nos_row_max - 1))/nos_row_max;
            gap_wall = gap_wall_min;
            gap_seats = gap_seats_min;
        elseif shoulderroom_actual_min > shoulderroom_target
            % Target shoulderroom is not feasible with minimum backrest width and minimum gaps!
            % Eliminate gap between seats and create a bench instead of multiple seats
            if shoulderroom_actual_min_bench <= shoulderroom_target
                % If true, calculate backrest width (multiple seats will merge into a bench)
                br_width = (shoulderroom_target - gap_wall_min*2)/nos_row_max;
                gap_wall = gap_wall_min;
                gap_seats = 0;
            else
                msg_width = 'Target shoulderroom is too small for passengers to fit in the vehicle! Consider updating TP "shoulderroom per seat"';
                error(msg_width);
            end
        end
    end
    
    % Update input parameter base data matrix depending on number of seats in current row
    for i_nos_row = 1:seat_rows
        if nos_row(i_nos_row,1) == nos_row_max   % Current row has the maximum number of seats (in a row)
            % Update input parameter base data matrix
            input_parameter_matrix{index_br_width(i_nos_row,1),VC_count_var+1} = br_width;
            input_parameter_matrix{index_gap_seats(i_nos_row,1),VC_count_var+1} = gap_seats;
            input_parameter_matrix{index_gap_wall(i_nos_row,1),VC_count_var+1} = gap_wall;
            % This code snippet is valid for minimum backrest width > 333 mm!
        elseif nos_row(i_nos_row,1) < nos_row_max && nos_row(i_nos_row,1) > 0  % Current row has less seats than the max row
            % Increase gaps between seats and to wall by calculating the dimensions (with constant maximum backrest width) and update input parameter base data matrix
            input_parameter_matrix{index_br_width(i_nos_row,1),VC_count_var+1} = br_width_max;
            input_parameter_matrix{index_gap_seats(i_nos_row,1),VC_count_var+1} = (shoulderroom_target - (br_width_max*nos_row(i_nos_row,1)))/nos_row(i_nos_row,1);
            input_parameter_matrix{index_gap_wall(i_nos_row,1),VC_count_var+1} = (shoulderroom_target - (br_width_max*nos_row(i_nos_row,1)))/(2*nos_row(i_nos_row,1));
        end
    end
    %% Convert TP to leg overlap (x)
    
    % Necessary input for AuVeCoDe: - x overlap
    %
    % Available input from CRP2TP:  - package measure L-53 (horizontal measurement from hip joint to heel point)
    %
    % Solution for conversion: Linear interpolation with extreme values for leg overlap
    
    % Find index of desired input
    index_x_overlap = find(strcmp(input_parameter_matrix(:,1),'input_int_x_overlap'));
    
    % Set limits for linear Interpolation
    limits_L53 = [MinMaxTP(1,9), MinMaxTP(2,9)];    % Min and max values of package measure L53
    limits_x_overlap = [0, 285];                    % (Max value of 285 = foot length) Source: [64] Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2, p.69
    
    % Calculate ratio from current TP-value of package measure L-53 (ratio to min and max limits)
    ratio_TP_L53 = (TechnicalPropertiesVC(VC_count_var,9)-limits_L53(1,1))/(limits_L53(1,2)-limits_L53(1,1));
    
    % Calculate free crash length rear and side and update input parameter base data matrix
    leg_overlap_x = ratio_TP_L53*(limits_x_overlap(1,2)-limits_x_overlap(1,1))+limits_x_overlap(1,1);
    
    % Update input parameter matrix
    input_parameter_matrix{index_x_overlap,VC_count_var+1} = leg_overlap_x;
    %% Convert TP to legroom additional, seat depth, seat adjustment x and foot length
    
    % Necessary input for AuVeCoDe: - legroom additional
    %                               - seat depth
    %                               - seat adjustment - x
    %                               - foot length
    %
    % Available input from CRP2TP:  - package measure L-53 (horizontal measurement from hip joint to heel point)
    %
    % Solution for conversion: Calculating legroom additional with dimensional chain: L-53 + rHSh = seat length + legroom additional
    % More complicated solution with legroom for conventional seating layout
    % Feet can go under seat in front => not implemented in AuVeCoDe Tool
    
    % Find index of desired input
    index_legroom_add = zeros(seat_rows,1);
    index_seat_depth = zeros(seat_rows,1);
    index_foot_length = zeros(seat_rows,1);
    index_seat_adj_x = zeros(seat_rows,1);
    legroom_add = zeros(seat_rows,1);
    
    for i_interior = 1:seat_rows
        index_legroom_add(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_legroom_additional_%0.0f',i_interior)));
        index_seat_depth(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_seat_depth_%0.0f',i_interior)));
        index_foot_length(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_foot_length_%0.0f',i_interior)));
        index_seat_adj_x(i_interior,1) = find(strcmp(input_parameter_matrix(:,1),sprintf('input_int_seat_adjustment_x_%0.0f',i_interior)));
    end
    
    % Seating reference point to hip joint point horizontal in mm (constant)
    rHSh = 125;        % Source: Schienenfahrzeuge - Führerräume - Teil 1: Allgemeine Anforderungen, DIN 5566-1, p.7 recommended
    
    % Define seat depth as a constant (worse comfort, if seat depth gets larger than threshold) in mm
    seat_depth = 460;  % Source: A2Mac1, Your Global Partner for Benchmarking. [Online] Verfügbar: https://portal.a2mac1.com/
    
    % Define foot length as a constant (95th percentile man) in mm
    foot_length = 285; % Source: Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2, p.69
    
    % Set seat adjustment in x 0 (part of legroom additional)
    seat_adj_x = 0;
    
    % Set comfort measure for distance between legs and seat in front
    % (Linear interpolation with extreme values for comfort measure)
    % Ratio regarding package measure L53 => More leg room = more room for overlap
    limits_comfort_length = [0, 100];
    comfort_length = ratio_TP_L53*(limits_comfort_length(1,2)-limits_comfort_length(1,1))+limits_comfort_length(1,1);
    
    %----------------------------------------------------------------------------------------
    % New function for legroom based on seat row in front
    knee_height = 585;      % Knee height seating from 95th percentile man Source:                      [64] Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2
    knee_length = 655;      % Knee length seating (buttocks to knee) from 95th percentile man Source:   [64] Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2,
    %lower_leg_radius = 66; % Radius of lower leg from 95th percentile man Source:                      [64] Ergonomie - Körpermaße des Menschen - Teil 2: Werte, DIN 33402-2,
    br_thickness = 150;     % Backrest thickness of AuVeCoDe Tool
    
    % Calculate min backrest angle at which knees from person
    % behind still fit under the backrest
    % => Height of backrest at the upper end (with br_angle_min = br_angle_min_fit)
    % touches knee of seating person in the row behind
    br_angle_min_fit = asind((br_thickness + knee_height - seat_height)/UB_length);
    
    % Calculate min backrest angle at which the shin touches
    % the backrest of seat infront (instead of the knee
    % touching the backrest)
    
    % Check if knees are in upright position
    if (TechnicalPropertiesVC(VC_count_var,9) + rHSh) - knee_length > 0
        % Knees aren't in upright position
        br_angle_min_legroom = atand(knee_height/(TechnicalPropertiesVC(VC_count_var,9) + rHSh - knee_length));
    else
        % Knees are in upright position -> Backrest will always touch knee
        % Define br_angle_min as 89° (not 90° because of extreme values in
        % matlab)
        br_angle_min_legroom = 89;
    end
    
    switch seating_layout
        case 'Single Row'
            legroom_add(1) = TechnicalPropertiesVC(VC_count_var,9) + rHSh - seat_depth;
        case 'Vis-a-Vis'
            legroom_add(:) = TechnicalPropertiesVC(VC_count_var,9) + rHSh - seat_depth;
        case 'Back-to-Back'
            legroom_add(:) = TechnicalPropertiesVC(VC_count_var,9) + rHSh - seat_depth;
        case 'Conventional'
            
            % First row
            legroom_add(1) = TechnicalPropertiesVC(VC_count_var,9) + rHSh - seat_depth;
            
            % Second row
            if br_angle_min > br_angle_min_legroom
                % Shin touches the seat infront:
                % Calculate the x-position of the shin at z = backrest lower edge height
                x_position_shin = TechnicalPropertiesVC(VC_count_var,9) + rHSh - ...
                    ((seat_height - br_thickness*cosd(br_angle_min))/tand(br_angle_min_legroom));
                % Calculate the x-position of the backrest at z = backrest lower edge height
                x_position_backrest = seat_depth + foot_length + UB_length*cosd(br_angle_min);
                % Calculate legroom additional:
                legroom_add(2) = x_position_shin - x_position_backrest;
                
            elseif br_angle_min > br_angle_min_fit
                % Knee touches backrest infront:
                % Calculate the x-position of the knee at z = knee height
                x_position_knee = knee_length;
                % Calculate the x-position of the backrest at z = knee height
                x_position_backrest = seat_depth + foot_length + UB_length*cosd(br_angle_min) + ...
                    br_thickness*sind(br_angle_min) - ((knee_height - seat_height)/tand(br_angle_min)) ...
                    - (br_thickness/sind(br_angle_min));
                % Calculate legroom additional:
                legroom_add(2) = x_position_knee - x_position_backrest + comfort_length;
                
            else
                % Knee doesnt fit under backrest infront and shin
                % touches upper edge of backrest
                % Calculate the x-position of the shin at z = backrest upper edge height
                x_position_shin = TechnicalPropertiesVC(VC_count_var,9) + rHSh - ...
                    ((seat_height + (UB_length + headroom)*sind(br_angle_min))/tand(br_angle_min_legroom));
                % Calculate the x-position of the backrest at z = backrest upper edge height
                x_position_backrest = seat_depth + foot_length;
                % Calculate legroom additional:
                legroom_add(2) = x_position_shin - x_position_backrest + headroom*cosd(br_angle_min);
            end
            
            % Third row
            if seat_rows == 3
                legroom_add(3) = legroom_add(2);
            end
            
            % No leg overlap for conventional seating layout
            leg_overlap_x = 0;
            
        case 'Vis-à-Vis in front'
            % For first and second row:
            legroom_add(1:2) = TechnicalPropertiesVC(VC_count_var,9) + rHSh - seat_depth;
            
            % Third row (Same function as above)
            if br_angle_min > br_angle_min_legroom
                % Shin touches the seat infront:
                % Calculate the x-position of the shin at z = backrest lower edge height
                x_position_shin = TechnicalPropertiesVC(VC_count_var,9) + rHSh - ...
                    ((seat_height - br_thickness*cosd(br_angle_min))/tand(br_angle_min_legroom));
                % Calculate the x-position of the backrest at z = backrest lower edge height
                x_position_backrest = seat_depth + foot_length + UB_length*cosd(br_angle_min);
                % Calculate legroom additional:
                legroom_add(3) = x_position_shin - x_position_backrest;
                
            elseif br_angle_min > br_angle_min_fit
                % Knee touches backrest infront:
                % Calculate the x-position of the knee at z = knee height
                x_position_knee = knee_length;
                % Calculate the x-position of the backrest at z = knee height
                x_position_backrest = seat_depth + foot_length + UB_length*cosd(br_angle_min) + ...
                    br_thickness*sind(br_angle_min) - ((knee_height - seat_height)/tand(br_angle_min)) ...
                    - (br_thickness/sind(br_angle_min));
                % Calculate legroom additional:
                legroom_add(3) = x_position_knee - x_position_backrest + comfort_length;
                
            else
                % Knee doesnt fit under backrest infront and shin
                % touches upper edge of backrest
                % Calculate the x-position of the shin at z = backrest upper edge height
                x_position_shin = TechnicalPropertiesVC(VC_count_var,9) + rHSh - ...
                    ((seat_height + (UB_length + headroom)*sind(br_angle_min))/tand(br_angle_min_legroom));
                % Calculate the x-position of the backrest at z = backrest upper edge height
                x_position_backrest = seat_depth + foot_length;
                % Calculate legroom additional:
                legroom_add(3) = x_position_shin - x_position_backrest + headroom*cosd(br_angle_min);
            end
            
        case 'Vis-à-Vis in back'
            
            legroom_add(1) = TechnicalPropertiesVC(VC_count_var,9) + rHSh - seat_depth;
            legroom_add(2:3) = TechnicalPropertiesVC(VC_count_var,9) + rHSh - seat_depth - (leg_overlap_x/2);
            leg_overlap_x = 0;
    end
    %----------------------------------------------------------------------------------------
    % Update input parameter base data matrix
    input_parameter_matrix{index_x_overlap,VC_count_var+1} = leg_overlap_x;
    for i_interior = 1:seat_rows
        input_parameter_matrix{index_legroom_add(i_interior,1),VC_count_var+1} = legroom_add(i_interior);
        input_parameter_matrix{index_seat_depth(i_interior,1),VC_count_var+1} = seat_depth;
        input_parameter_matrix{index_foot_length(i_interior,1),VC_count_var+1} = foot_length;
        input_parameter_matrix{index_seat_adj_x(i_interior,1),VC_count_var+1} = seat_adj_x;
    end
    %% Convert TP to distance wheelhouse to bumper
    
    % Necessary input for AuVeCoDe: - distance wheelhouse to bumper (min/max) (front/rear)
    %
    % Available input from CRP2TP:  - free crash length front
    %                               - free crash length rear
    %
    % Solution for conversion: Proportional change of distance wheelhouse
    % to bumper and free crash length after reaching defined distance
    % threshold
    
    % Find index of desired input
    index_dist_w2b_f_min = find(strcmp(input_parameter_matrix(:,1),'input_dist_wheelhouse2bumper_f_min'));
    index_dist_w2b_f_max = find(strcmp(input_parameter_matrix(:,1),'input_dist_wheelhouse2bumper_f_max'));
    index_dist_w2b_r_min = find(strcmp(input_parameter_matrix(:,1),'input_dist_wheelhouse2bumper_r_min'));
    index_dist_w2b_r_max = find(strcmp(input_parameter_matrix(:,1),'input_dist_wheelhouse2bumper_r_max'));
    
    % Define distance treshold at which every mm more free crash length results in the
    % same amount of increase to distance wheelhouse to bumper
    dist_fcl_w2b = 500;     % Investigation in AuVeCoDe Tool
    
    % Edit distance wheelhouse to bumper front values depending on fcl front-values
    if fcl_front > dist_fcl_w2b
        dist_w2b_f = fcl_front - dist_fcl_w2b;
    else
        dist_w2b_f = 0;
    end
    
    % Edit distance wheelhouse to bumper rear values depending on fcl rear-values
    if fcl_rear > dist_fcl_w2b
        dist_w2b_r = fcl_rear - dist_fcl_w2b;
    else
        dist_w2b_r = 0;
    end
    
    % Update input parameter base data matrix
    input_parameter_matrix{index_dist_w2b_f_min,VC_count_var+1} = dist_w2b_f;
    input_parameter_matrix{index_dist_w2b_f_max,VC_count_var+1} = dist_w2b_f;
    input_parameter_matrix{index_dist_w2b_r_min,VC_count_var+1} = dist_w2b_r;
    input_parameter_matrix{index_dist_w2b_r_max,VC_count_var+1} = dist_w2b_r;
    %% Convert TP to storage volume
    
    % Necessary input for AuVeCoDe: - storage volume
    %
    % Available input from CRP2TP:  - storage volume passenger vehicle
    %                               - storage volume load vehicle
    %
    % Solution for conversion: If user need "load" is greater than
    % defined threshold, define storage from load vehicle as standard
    % storage volume
    
    % Find index of desired input
    index_storage = find(strcmp(input_parameter_matrix(:,1),'input_trunk_volume'));
    
    % Check if threshold is reached and update input parameter base data matrix
    % Derivative(VC_count_var,6) = user need "load"
    if Derivative(VC_count_var,6) > threshold_load
        input_parameter_matrix{index_storage,VC_count_var+1} = TechnicalPropertiesVC(VC_count_var,18);
    else
        input_parameter_matrix{index_storage,VC_count_var+1} = TechnicalPropertiesVC(VC_count_var,17);
    end
  

    %% Convert user needs to tire type
    
    % Necessary input for AuVeCoDe: - tire type -> extra load or not (checkbox)
    %
    % Available input from CRP2TP:  - user needs
    %
    % Solution for conversion: If user need "load" is greater than
    % defined threshold, check the checkbox (checkbox is checked if value is 1 or 'true')
    
    % Find index of desired input
    index_tire_type = find(strcmp(input_parameter_matrix(:,1),'input_tire_load'));
    
    % Check if threshold is reached and update input parameter base data matrix
    % Derivative(VC_count_var,6) = user need "load"
    if Derivative(VC_count_var,6) > threshold_load
        input_parameter_matrix{index_tire_type,VC_count_var+1} = 1;
    else
        input_parameter_matrix{index_tire_type,VC_count_var+1} = 0;
    end
    %% Convert CRP to number of sensors
    
    % Necessary input for AuVeCoDe: - number of mechanical LiDAR sensors
    %                               - number of MEMS LiDAR sensors
    %                               - number of sonar sensors
    %                               - number of radar sensors
    %                               - number of surround cameras
    %                               - number of front cameras
    %
    % Available input from CRP2TP:  - CRP environment perception
    %
    % Solution for conversion: Create discrete function for number of sensors
    % depending on CRP environment perception
    
    % Find index of desired input
    index_mech_lidar = find(strcmp(input_parameter_matrix(:,1),'input_mech_lidar'));
    index_mems_lidar = find(strcmp(input_parameter_matrix(:,1),'input_mems_lidar'));
    index_sonar = find(strcmp(input_parameter_matrix(:,1),'input_sonar'));
    index_radar = find(strcmp(input_parameter_matrix(:,1),'input_radar'));
    index_surround_camera = find(strcmp(input_parameter_matrix(:,1),'input_surround_cameras'));
    index_front_camera = find(strcmp(input_parameter_matrix(:,1),'input_front_cameras'));
    
    % Create discrete function with if-loop
    % currentCRP(VC_count_var,14) = CRP-value for environment perception
    if currentCRP(VC_count_var,14) <= 6
        % Sensor combination for low quality of perception (Source: [37] R. Tutzauer, "Softwareintegration bei der Strukturierung und Konzeption eines autonomen Fahrzeuges" p.63)
        input_parameter_matrix{index_mech_lidar,VC_count_var+1} = 0;
        input_parameter_matrix{index_mems_lidar,VC_count_var+1} = 0;
        input_parameter_matrix{index_sonar,VC_count_var+1} = 12;
        input_parameter_matrix{index_radar,VC_count_var+1} = 5;
        input_parameter_matrix{index_surround_camera,VC_count_var+1} = 6;
        input_parameter_matrix{index_front_camera,VC_count_var+1} = 2;
    elseif currentCRP(VC_count_var,14) > 6 && currentCRP(VC_count_var,14) <= 8
        % Sensor combination for medium quality of perception (Source: [37] R. Tutzauer, "Softwareintegration bei der Strukturierung und Konzeption eines autonomen Fahrzeuges" p.63)
        input_parameter_matrix{index_mech_lidar,VC_count_var+1} = 1;
        input_parameter_matrix{index_mems_lidar,VC_count_var+1} = 0;
        input_parameter_matrix{index_sonar,VC_count_var+1} = 12;
        input_parameter_matrix{index_radar,VC_count_var+1} = 5;
        input_parameter_matrix{index_surround_camera,VC_count_var+1} = 6;
        input_parameter_matrix{index_front_camera,VC_count_var+1} = 2;
    elseif currentCRP(VC_count_var,14) > 8
        % Sensor combination for high quality of perception (Source: [37] R. Tutzauer, "Softwareintegration bei der Strukturierung und Konzeption eines autonomen Fahrzeuges" p.63)
        input_parameter_matrix{index_mech_lidar,VC_count_var+1} = 5;
        input_parameter_matrix{index_mems_lidar,VC_count_var+1} = 0;
        input_parameter_matrix{index_sonar,VC_count_var+1} = 12;
        input_parameter_matrix{index_radar,VC_count_var+1} = 5;
        input_parameter_matrix{index_surround_camera,VC_count_var+1} = 6;
        input_parameter_matrix{index_front_camera,VC_count_var+1} = 2;
    end
    
    %% Convert TP to number of side airbags
    
    % Necessary input for AuVeCoDe: - number of side airbags
    %
    % Available input from CRP2TP:  - free crash length front
    %
    % Solution for conversion: Linear interpolation with free crash length extreme values
    
    % Find index of desired input
    index_airbags = find(strcmp(input_parameter_matrix(:,1),'input_side_airbags'));
    
    % Define Limits
    limits_airbags = [0, 4*seat_rows + ...
        round(input_parameter_matrix{index_nos_fr,VC_count_var+1}/2+(input_parameter_matrix{index_nos_fr,VC_count_var+1} - 2)/10)+...   % First row
        round(input_parameter_matrix{index_nos_sr,VC_count_var+1}/2+(input_parameter_matrix{index_nos_sr,VC_count_var+1} - 2)/10)+...   % Second row
        round(input_parameter_matrix{index_nos_tr,VC_count_var+1}/2+(input_parameter_matrix{index_nos_tr,VC_count_var+1} - 2)/10)];     % Third row
    
    % Calculate number of side airbags
    number_side_airbags = round(ratio_TP_fcl*(limits_airbags(1,2)-limits_airbags(1,1))+limits_airbags(1,1));
    
    % Update input parameter base data matrix
    input_parameter_matrix{index_airbags,VC_count_var+1} = number_side_airbags;
    %% Convert TP to rear axle type
    
    % Necessary input for AuVeCoDe: - rear axle type (drop-down menu)
    %
    % Available input from CRP2TP:  - CRP quality of vertical dynamics
    %
    % Solution for conversion: Create discrete function for axle type
    % depending on CRP quality of vertical dynamics
    
    % Find index of desired input
    index_rear_axle = find(strcmp(input_parameter_matrix(:,1),'input_rear_axis_type'));
    
    % Create discrete function with if-loop and update input parameter base data matrix
    % currentCRP(VC_count_var,3) = CRP-value for quality of vertical dynamics
    if currentCRP(VC_count_var,3) <= 6
        % Rear axle type for low quality of vertical dynamics       (Source: B. Heißing, M. Ersoy, und S. Gies, "Achsen und Radaufhängungen", p. 426)
        input_parameter_matrix{index_rear_axle,VC_count_var+1} = 'torsion_beam'; % (Twist-beam rear suspension)
    elseif currentCRP(VC_count_var,3) > 6 && currentCRP(VC_count_var,3) <= 8
        % Rear axle type for medium quality of vertical dynamics    (Source: B. Heißing, M. Ersoy, und S. Gies, "Achsen und Radaufhängungen", p. 439-442)
        input_parameter_matrix{index_rear_axle,VC_count_var+1} = 'trapezoidal_link';
    elseif currentCRP(VC_count_var,3) > 8
        % Rear axle type for high quality of vertical dynamics      (Source: B. Heißing, M. Ersoy, und S. Gies, "Achsen und Radaufhängungen", p. 418)
        input_parameter_matrix{index_rear_axle,VC_count_var+1} = 'five_link';
    end
    %% Convert TP to aluminium percentage in BIW (Body in white = car body frame before painting)
    
    % Necessary input for AuVeCoDe: - aluminium percentage in BIW
    %
    % Available input from CRP2TP:  - too many influencing factors for this input
    %
    % Solution for conversion: There are too many influencing
    % factors with the same relevance for this input. Therefore an
    % input-value suitable for all VC combinations will be defined.
    
    % Find index of desired input
    index_alu_ratio = find(strcmp(input_parameter_matrix(:,1),'input_biw_alu_perc'));
    
    % Define base value update input parameter base data matrix
    input_parameter_matrix{index_alu_ratio,VC_count_var+1} = 20; % Source: B. Smith, A. Spulber, S. Modi, und T. Fiorelli, Technology Roadmaps: Intelligent Mobility Technology Materials and Manufacturing Processes and Light Duty Vehicle Propulsion, p.15
    %% Convert TP to battery cell type
    
    % Necessary input for AuVeCoDe: - battery cell type (drop-down menu)
    %
    % Available input from CRP2TP:  - too many influencing factors for this input
    %
    % Solution for conversion: There are too many influencing
    % factors with the same relevance for this input. Therefore an
    % input-value suitable for all VC combinations will be defined.
    
    % Find index of desired input
    index_bat_cell_type = find(strcmp(input_parameter_matrix(:,1),'input_cell_type'));
    
    % Define base value update input parameter base data matrix
    input_parameter_matrix{index_bat_cell_type,VC_count_var+1} = 'pouch';    % Currently a lot of manufacturers use the pouch cell for their BEV (Source: [72] S. Martin, Batterietechnologie für elektrisch angetriebene Fahrzeuge)
    %% Convert TP to drive type (drive train topology)
    
    % Necessary input for AuVeCoDe: - drive type (drop-down menu)
    %
    % Available input from CRP2TP:  - too many influencing factors for this input
    %
    % Solution for conversion: There are too many influencing
    % factors with the same relevance for this input. Therefore an
    % input-value suitable for all VC combinations will be defined.
    
    % Find index of desired input
    index_drive_type = find(strcmp(input_parameter_matrix(:,1),'input_drive_type'));
    
    if currentCRP(VC_count_var,1) >= 8
        % Drive type for high quality of axial dynamics (Acceleration 0-100km/h)
        input_parameter_matrix{index_drive_type,VC_count_var+1} = 'GM_GM';  % (4WD)
    elseif currentCRP(VC_count_var,16) >= 8
        % Drive type for high quality of bad road capability
        input_parameter_matrix{index_drive_type,VC_count_var+1} = 'GM_GM';  % (4WD)
    elseif currentCRP(VC_count_var,4) >= 8
        % Drive type for high quality of maneuverability
        input_parameter_matrix{index_drive_type,VC_count_var+1} = 'X_GM';    % Engine in back for higher steering angle in front
    else
        % Standard Drive type
        input_parameter_matrix{index_drive_type,VC_count_var+1} = 'GM_X';
    end
    %% Convert TP to engine type
    
    % Necessary input for AuVeCoDe: - engine type (drop-down menu)
    %
    % Available input from CRP2TP:  - CRP quality of longitudinal dynamics
    %
    % Solution for conversion: Switch engine type at defined threshold of
    % CRP-value quality of longitudinal dynamics
    
    % Find index of desired input
    index_engine_type = find(strcmp(input_parameter_matrix(:,1),'input_engine_type'));
    
    % Switch the engine types with if-loop and update input parameter base data matrix
    % currentCRP(VC_count_var,1) = CRP-value for quality of longitudinal dynamics
    if currentCRP(VC_count_var,1) < 8
        % Engine type for low and medium quality of longitudinal dynamics
        input_parameter_matrix{index_engine_type,VC_count_var+1} = 'PSM';
    elseif currentCRP(VC_count_var,1) >= 8
        % Engine type for high quality of longitudinal dynamics
        input_parameter_matrix{index_engine_type,VC_count_var+1} = 'ASM';    % Overload factor of ASM greater than PSM -> higher acceleration -> higher quality of longitudinal dynamics
        % Source: [68] W. Neß und K. Raggl, "E-Motortypen für sekundäre Elektroantriebe im Vergleich", p.41-42
    end
    %% Convert TP to two speed gearbox
    
    % (Necessary) input for AuVeCoDe: - two speed gearbox (checkbox)
    %
    % Available input from CRP2TP:  - CRP quality of longitudinal dynamics
    %
    % Solution for conversion: Switch number of gears at defined threshold of
    % CRP-value quality of longitudinal dynamics
        
    % Find index of desired input
    index_two_speed = find(strcmp(input_parameter_matrix(:,1),'input_two_speed'));
    
    % Switch the number of gears with if-loop and update input parameter base data matrix
    % currentCRP(VC_count_var,1) = CRP-value for quality of longitudinal dynamics
    if currentCRP(VC_count_var,1) < 8
        % Number of gears for low and medium quality of longitudinal dynamics (One-speed gearbox)
        input_parameter_matrix{index_two_speed,VC_count_var+1} = 0;
    elseif currentCRP(VC_count_var,1) >= 8
        % Number of gears for high quality of longitudinal dynamics (Two-speed gearbox)
        input_parameter_matrix{index_two_speed,VC_count_var+1} = 1;    % Higher acceleration and max speed with two-speed gearbox -> higher quality of longitudinal dynamics
    end
end
end

