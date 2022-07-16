%% Starts simulation for NSGA-II Metaoptimization
%% Description:
% Designed by: Adrian König (FTM, Technical University of Munich), Daniel Telschow
%-------------
% Created on: 25.11.2021
% ------------
% Version: Matlab2020b
%-------------
% Description: This function reads in saved App-Data and starts the simulation while changing the NSGA-II Parameters for Metaoptimization
% ------------
% Sources:  [1] Adrian König, "Methodik zur Auslegung von autonomen Fahrzeugkonzepten", Technical University of Munich, Institute of Automotive Technology, 2022
% ------------
% Input:    - Saved userform configuration for external simulation
%           - Table with NSGA-II parameters ("NSGAII_Par")
% ------------
% Output:   - Saved Optimizations in 06_Results folder
% ------------

clear
clc
%% Initialize and read in parameters
uiopen('*.mat')
%1) Find path
InputPath=fileparts(which("Run_AuVeCoDe.m"));
cd(InputPath);
%2) Add folders and subfolders
addpath(genpath(InputPath));

    folder_Opt= fullfile(InputPath,"02_NSGA_only"); %Determine where the Optimizer are located
    rmpath(genpath(folder_Opt));
    %% Optimization
    for j=1:size(NSGAII_Par,1)
        %Vary the parameters according to the table
        options.mutation{1, 2}      = NSGAII_Par.mut_sc(j);
        options.mutation{1, 3}      = NSGAII_Par.mut_shri(j);
        options.mutationFraction    = NSGAII_Par.mut_fra(j);
        options.crossover{1, 2}     = NSGAII_Par.cros_rat(j);
        options.crossoverFraction   = NSGAII_Par.cros_fra(j);
        
        for i = 1:options.RepeatNumber
            
            % prepare the path to save folder
            SaveFolder = fullfile(InputPath,"06_Results");
            options.ResultPath = fullfile(SaveFolder, (options.FolderName + "_Optimization_" + sprintf('%02d',i)));
            switch Parameters.optimization.result_separate_save
                case 0 % user wants to save additional results in 06_Results and overwrite old additional results
                    options.AdditionalResultPath = SaveFolder;
                case 1 % user wants to save additional results in current defined result folder
                    options.AdditionalResultPath = options.ResultPath;
            end
            
            % save Parameters_Pareto for plotting
            save(fullfile(options.AdditionalResultPath, "Parameters_Pareto.mat"), "Parameters");
            
            % run optimization
            [state] = options.func(options, Parameters);
            
            % prepare path for saving results
            formatOut='yymmdd'; %Right format
            currentdate=datestr(now,formatOut); %current date in right format
            SaveResultFile = fullfile(SaveFolder, ...
                (currentdate + "_Optimization_" + sprintf('%02d',i) + "_" + sprintf('%02d',j) + ".mat"));
            
            % save results
            save(SaveResultFile, 'state');
        end
    end


function choice = choosedialog(Name)

    d = dialog('Position',[800 800 250 150],'Name',Name);
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 80 210 40],...
           'String','Select the range of variation');
       
    popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[75 70 100 25],...
           'String',{'+- 10%';'+- 20%';'+- 30%';'+- 40%'},...
           'Callback',@popup_callback);
       
    btn = uicontrol('Parent',d,...
           'Position',[89 20 70 25],...
           'String','Continue',...
           'Callback','delete(gcf)');
       
    choice = '+- 10%';
       
    % Wait for d to close before running to completion
    uiwait(d);
   
       function popup_callback(popup,event)
          idx = popup.Value;
          popup_items = popup.String;
          choice = char(popup_items(idx,:));
       end
end
            