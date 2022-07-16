function [mobility_typ] = user_class_fuzzy(user_character)
%Bestimmt die Ausprägung des Mobiltiätsvorschlags (Privat, Taxi, Shuttle)
fisObject=readfis("Character2Stakeholder");
fis = getFISCodeGenerationData(fisObject);
mobility_typ=evalfis(fis,user_character);
end

