function [x,user_matrix_reduced] = GA(user_matrix,number_derivat,VT,min_fullfillment)
%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% RUN GA for one VT (1=Private, 2=Taxi, 3=Shuttle)
%-----------------------
% Input:
% user matrix in the format:
% [ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
% [ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
% ...
% [ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User n

% number_derivat (number of the current derivatives)

% VT (vehicle types)

% min_fullfillment: minimal user fullfillment (fittness value for the fitness function)
%-----------------------
% Output:
% %[D1 D2 D3 D4 D5 D6 C2 C3 D1 D2 D3 D4 D5 ...] for each derivat


%% Function
[m,n]=size(user_matrix);

%Reducing user matrix in case of all 1 to 4 secondary activities of one user are
%equal to zero, only for vehicle type 1 and 2
if(VT<3)
    user_matrix_reduced=zeros(m,n);
    k=0;
    for i=1:m
        if(sum(user_matrix(i,2:5)>0))
            k=k+1;
            user_matrix_reduced(k,:)=user_matrix(i,:);
        end
    end
    user_matrix_reduced=user_matrix_reduced(1:k,:);
else
    user_matrix_reduced=user_matrix;
end
%For the case there is no secondary activity for a specific vehicle type
if(isempty(user_matrix_reduced)==1)
    x=zeros(1,8);
    return
end
%Number of Variables
numberOfVariables=number_derivat*8;
%Constraints festlegen
constraintfct = @(x) constrains(user_matrix_reduced,x,number_derivat,VT,min_fullfillment);
%Lower Boundary
lb=zeros(1,numberOfVariables);
%Upper Boundary
ub=lb+10;
%Limiting D6(Number Passengers) from 0-9
k=6;
for i=1:number_derivat
    lb(k)=0;
    ub(k)=9;
    k=k+8;
end
%Fitnessfunktion
fitnessfct = @(x) ojectiv_function(x,user_matrix_reduced,number_derivat,min_fullfillment,VT);
%% Initial Population via fmincon
%[x0,A,b]=set_fmincon(number_derivat);
%opt=optimset('MaxIter',4000,'MaxFunEval',9000);
%[x1,fval]=fmincon(fitnessfct,x0,A,b,[],[],lb,ub,constraintfct,opt);
%Genetischer Algorithmus
%psoptions = psoptimset(@patternsearch);
%options = gaoptimset('HybridFcn', {@patternsearch,psoptions});
%[x1,fval]=ga(fitnessfct,numberOfVariables,[],[],[],[],lb,ub,constraintfct);
%[x1,fval_1]=particleswarm(fitnessfct,numberOfVariables,lb,ub);
%options=optimoptions('ga','InitialPopulation',[x1],'SelectionFcn',{@selectiontournament,4});
%% Use GA
options=optimoptions('ga','PopulationSize',numberOfVariables*25, 'MaxGeneration', 60,'TolFun',10e-20,'MutationFcn',@mutationadaptfeasible,'SelectionFcn',{@selectiontournament,2});
[x,fval,exitflag,output,population,scores]=ga(fitnessfct,numberOfVariables,[],[],[],[],lb,ub,constraintfct,options);
%opt=optimset('MaxIter',4000,'MaxFunEval',9000);
%[x,fval]=fmincon(fitnessfct,x1,[],[],[],[],lb,ub,constraintfct,opt);
%[x,fval]=particleswarm(fitnessfct,numberOfVariables,lb,ub);
%[x,fval] = patternsearch(fitnessfct,x1,[],[],[],[],lb,ub,constraintfct);
end

