function [user_privat, user_taxi, user_shuttle,user_typ,user_privat_id, user_taxi_id, user_shuttle_id] = classify_user(user,m)
%Teilt die Nutzer in Privatkauf, Taxi und Shuttle anhand ihrer Bereitschaft
%zu MaaS ein

user_privat=zeros(m,8);
user_taxi=zeros(m,8);
user_shuttle=zeros(m,8);
user_privat_id=zeros(m,1);
user_taxi_id=zeros(m,1);
user_shuttle_id=zeros(m,1);
%%
%Fuzzy nutzen, um User anhand Character (C1-C3) zu unterscheiden
user_typ=zeros(m,1);
for i=1:m
    user_character=user(i,6:8)';
    [user_typ(i,1)] = user_class_fuzzy(user_character);
end
%%
%Nutzer aus globaler User-Matrix auslesen
index_privat=1;
index_taxi=1;
index_shuttle=1;

for i=1:m
    if(user_typ(i,1)<=3.5) %Privat
        user_privat(index_privat,:)=user(i,1:8);
        user_privat_id(index_privat,1)=i; %id zuweisen
        index_privat=index_privat+1;
    elseif(user_typ(i,1)<=6.5) %Taxi
        user_taxi(index_taxi,:)=user(i,1:8);
        user_taxi_id(index_taxi,1)=i; %id zuweisen
        index_taxi=index_taxi+1;
    else
        user_shuttle(index_shuttle,:)=user(i,1:8); %Shuttle
        user_shuttle_id(index_shuttle,1)=i;
        index_shuttle=index_shuttle+1;
    end
end
user_privat=user_privat(1:index_privat-1,:);
user_taxi=user_taxi(1:index_taxi-1,:);
user_shuttle=user_shuttle(1:index_shuttle-1,:);
user_privat_id=user_privat_id(1:index_privat-1,1);
user_taxi_id=user_taxi_id(1:index_taxi-1,1);
user_shuttle_id=user_shuttle_id(1:index_shuttle-1,1);
end

