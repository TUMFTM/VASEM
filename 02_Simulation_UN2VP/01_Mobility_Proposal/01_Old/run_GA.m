function [derivat_1,derivat_2,derivat_3,derivat_4,fullfilment] = run_GA(user_1,user_2)
%Genetischer Optimierungsalgorithmus
%Ein Derivat
%numberOfVariables=5;
%Zwei Derivate
numberOfVariables = 15;
%Variablenbegrenzung für ein Derivat;
%ub=[10,10,10,10,10];
%lb=[0,0,0,0,0];
%Variabelnbegrenzung für zwei Derivate;
ub=[10,10,10,10,10,10,10,10,10,10,10,10,10,10,10];
lb=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
%Constraint für ein Derivat
%constraintfct = @constraint;
%Constraint für zwei Derivate
constraintfct = @(x) constraint_two_cars(x,user_1,user_2);
%Fitnessfunktion mit zwei Nutzer und einem Derivat
%fitnessfct = @(x) fitness_two_user(x,user_1,user_2);
%Fitnessfunktion mit zwei Nutzer und zwei Derivaten
fitnessfct = @(x) fitness_multiple(x,user_1,user_2);
%RUN GA
[x,fval]=ga(fitnessfct,numberOfVariables,[],[],[],[],lb,ub,constraintfct);
derivat_1=x(1:5);
derivat_2=x(6:10);
derivat_3=x(11:15);
derivat_4=x(6:10);
fullfilment=zeros(2,5);
%fullfilment(1,:)=max(max(((derivat_1))./user_1,((derivat_2))./user_1),((derivat_3))./user_1);
%fullfilment(2,:)=max(max(((derivat_1))./user_2,((derivat_2))./user_2),((derivat_3))./user_2);


end

