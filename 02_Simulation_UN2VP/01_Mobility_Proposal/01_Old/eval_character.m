function [mobility_character] = eval_character(user,privat_true,number_vehicle)
%List aus der globalen Nutzermatrix für jede Nutzergruppe die Globale
%Nutzercharakteristik eines Mobilitätsvorschlags aus

if(privat_true==1)
    [number_privat_vehicle,n]=size(user); %Pro User Ein Vorschlag
    mobility_character=zeros(number_privat_vehicle,3);
    %Für Privatkauf keine Mittelwertberechnung notwendig
    mobility_character=user(:,6:8);
else
    mobility_character=zeros(number_vehicle,3);
    %Für mehrere Nutzer pro Fahrzeug, werden die Charakteristiken der
    %Nutzer gemittelt
    for i=1:number_vehicle
        mobility_character(i,:)=[mean(user(:,6)) mean(user(:,7)) mean(user(:,8))];
    end
end


end

