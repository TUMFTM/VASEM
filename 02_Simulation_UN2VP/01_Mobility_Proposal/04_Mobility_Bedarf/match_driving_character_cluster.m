function [derivat_partDC,derivat_partDC_extend,n_user_in_derivat,user2derivat_VT_extend] = match_driving_character_cluster(user_matrix_reduced,derivat_partGA)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
%Matching of the driving characteristics of the derivats according to the
%users driving characterstics using cluster procedure

%-----------------------
% Input:
% user_matrix in the format:
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
% ...
% [N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User n

%wish_fullfilment in %/100

%VT==1 (Private) ==2 (Taxi) ==3 (Shuttle)
%-----------------------
% Output:
% Derivat 1 [meanB1 meanB2 meanB3 meanB4 maxB1 maxB2 maxB3 maxB4]
% Derivat 2 [meanB1 meanB2 meanB3 meanB4 maxB1 maxB2 maxB3 maxB4]
% Derivat 3 ....




%% Number of derivats and users
[number_derivat,m]=size(derivat_partGA);
[number_user,k]=size(user_matrix_reduced);
%% Which Derivat fullfills user i in secondary activity p most -> Layer_N_ID
[layer_N_ID,layer_ff_ip,layer_AMN,layer_C2,layer_C3] = layer_model_user_centered(user_matrix_reduced,derivat_partGA);
user2derivat_VT_extend=layer_N_ID;

%% Calculate mean of driving characteristics in each derivat
derivat_partDC=zeros(number_derivat,8);
derivat_DC_pre=zeros(number_user,4);
derivat_DC_post_extend=zeros(1,4);
n_user_in_derivat=zeros(number_derivat,1);
for j=1:number_derivat
    n_user=0;
    max_B1=0; max_B2=0; max_B3=0; max_B4=0;
    for i=1:number_user
        row_user=0;
        for p=1:5
            if(layer_N_ID(i,p)==j && user_matrix_reduced(i,p+1)>0)
                if(row_user==0)
                    if(p<5) %no additionional derivative only because if Loading in the case that Loading isnt a main activity (>5)
                        n_user=n_user+1;
                    elseif(p==5 && user_matrix_reduced(i,p+1)>5 && derivat_partGA(j,p)>5)
                        n_user=n_user+1;
                    elseif(p==5 && n_user==0 && derivat_partGA(j,p)>5)
                        n_user=n_user+1;
                    elseif(i==number_user && n_user==0)
                        n_user=n_user+1;
                    end
                    row_user=1;
                end
                %derivat_partDC(j,1:4)=derivat_partDC(j,1:4)+user_matrix_reduced(i,14:17);
                if(n_user>0)
                    derivat_DC_pre(n_user,:)=user_matrix_reduced(i,14:17);
                end
                %Save max Entry of B1-B4
                if(user_matrix_reduced(i,14)>max_B1)
                    max_B1=user_matrix_reduced(i,14);
                end
                if(user_matrix_reduced(i,15)>max_B2)
                    max_B2=user_matrix_reduced(i,15);
                end
                if(user_matrix_reduced(i,16)>max_B3)
                    max_B3=user_matrix_reduced(i,16);
                end
                if(user_matrix_reduced(i,17)>max_B4)
                    max_B4=user_matrix_reduced(i,17);
                end
            end
        end
    end
    %Store max entrys
    derivat_partDC(j,5:8)=[max_B1 max_B2 max_B3 max_B4];
    %Calculate mean of B1-B4
    %derivat_partDC(j,1:4)=derivat_partDC(j,1:4)./n_user;
    %Use kmeans for building of one Cluster
    if(n_user>0)
        derivat_DC_post=derivat_DC_pre(1:n_user,:);
        [id,derivat_partDC(j,1:4)]=kmeans(derivat_DC_post,1);
        derivat_DC_post_extend=[derivat_DC_post_extend;derivat_DC_post]; %Safe for extend Calculation
    end
    n_user_in_derivat(j,1)=n_user; %Safe for extend calculation
end

%% Calcualtion for extend Version due to different driving character
number_derivat_extend=number_derivat;
derivat_partDC_extend=derivat_partDC;
%Prepare Extend Matrix
[a,b]=size(derivat_DC_post_extend);
derivat_DC_post_extend=derivat_DC_post_extend(2:a,:);

for m=1:number_derivat
    if(n_user_in_derivat(m,1)>1)
        number_derivat_extend=number_derivat_extend+1;
    end
end
%Only calcualte extended version if necessary
if(number_derivat_extend>number_derivat)
    derivat_partDC_extend=zeros(number_derivat_extend,8);
    pos_extend=1;
    pos_user_extend=1;
    for m=1:number_derivat
       if(n_user_in_derivat(m,1)==1)
           derivat_partDC_extend(pos_extend,:)=derivat_partDC(m,:);
           for i=1:number_user
               if(derivat_DC_post_extend(pos_user_extend,:)==user_matrix_reduced(i,14:17))
                   for p=1:5
                       if(layer_N_ID(i,p)==m)
                           user2derivat_VT_extend(i,p)=pos_extend;
                       end
                   end
               end
           end
           pos_extend=pos_extend+1;
           pos_user_extend=pos_user_extend+1;
       else
           derivat_cluster=derivat_DC_post_extend(pos_user_extend:pos_user_extend+n_user_in_derivat(m,1)-1,:);
           [id,derivat_partDC_extend(pos_extend:pos_extend+1,1:4)]=kmeans(derivat_cluster,2); %Extend uses 2 identical derivats with different DC
           [n_d_c,b]=size(derivat_cluster);
           for i=1:number_user
              for k=1:n_d_c
                  if(derivat_cluster(k,:)==user_matrix_reduced(i,14:17))
                      for p=1:5
                          if(layer_N_ID(i,p)==m)
                              user2derivat_VT_extend(i,p)=id(k)+pos_extend-1;
                          end
                      end
                  end
              end
           end
           pos_extend=pos_extend+2;
           pos_user_extend=pos_user_extend+n_user_in_derivat(m,1);
       end
    end
end

end