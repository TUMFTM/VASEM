function [derivat,user_fullfilment] = suggest_derivat(user,number_derivat)
%Funktion zur Ermittlung der notwendigen Fahrzeugderivate für die Matrix
%User
%User:  [User1]=[N1 N2 N3 N4 N5] 
%       [User2]=[N1 N2 N3 N4 N5]     

%Anzahl der User bestimmen
[m,n]=size(user); % m User , n=5 (Nebentätigkeiten) Anzahl der Charakteristiken eines Nutzers
%Number of Variables
numberOfVariables=number_derivat*5;
%Constraints festlegen
constraintfct = @(x) constraint_user(x,user,number_derivat,m);
%Lower Boundary
lb=zeros(1,numberOfVariables);
%Upper Boundary
ub=lb+10;
%Fitnessfunktion
fitnessfct = @(x) fitness_user(x,user,m,number_derivat);
%Genetischer Algorithmus
[x,fval]=ga(fitnessfct,numberOfVariables,[],[],[],[],lb,ub,constraintfct);
%Derivate Auslesen
derivat=outline_derivat(x,number_derivat);
%Derivate mit User Plotten
% for i=1:m
%     figure;
%     P=zeros(number_derivat+1,5);
%     P(1,:)=user(i,:);
%     for j=1:number_derivat
%         P(j+1,:)=abs(derivat(j,:));
%     end
%     spider_plot(P,'AxesLabels',{'Drive','Relax','Work','Sleep','Usage'},'AxesLimits',[0,0,0,0,0;10,10,10,10,10]);
%     legend;
% end
%Erfüllung der Nutzerbedürfnisse berechnen
[user_fullfilment] = calculate_user_fullfilment(user,derivat,m,number_derivat);

end

