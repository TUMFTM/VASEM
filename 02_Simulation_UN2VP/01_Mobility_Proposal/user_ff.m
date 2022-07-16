function [ff_user_n_amn_c,mean_ff] = user_ff(user_matrix,derivat_partGA,min_fullfillment,VT)

%% Description
% Designed by Maximilian Zähringer, Ferdinand Schockenhoff(FTM, Technical University of Munich)
%-----------------------
% Created on: August 2020
% Last update: 2021-08-20
%-----------------------
% Version: Matlab 2020b
%-----------------------
% Description:
% Calculation of User Fullfillment by created derivates

%-----------------------
% Input:
%user_matrix
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 1
%[ID N1 N2 N3 N4 N5 AMN1 AMN2 AMN3 AMN4 C1 C2 C3 B1 B2 B3 B4] User 2
%....

%Derivat_partGA
%[D1 D2 D3 D4 D5 D6 D7 D8]
%[D1 D2 D3 D4 D5 D6 D7 D8]
%....

% VT==1 (Private) ==2 (Taxi) ==3 (Shuttle)

% min_fullfillment (number)
%-----------------------
% Output:
%ff_user_n_amn_c,mean_ff

%% Function

%Size
%Number User
[n_user,c1]=size(user_matrix);
%Number Derivat
[n_derivat,c2]=size(derivat_partGA);

%Over and underfullfillment
overfullfillment_factor_amn=-1;
underfullfillment_factor_amn=1;
overfullfillment_factor_gc2=-1;
underfullfillment_factor_gc2=1;
overfullfillment_factor_gc3=-1;
underfullfillment_factor_gc3=1;

%Initialization
ff_user_n_amn_c=zeros(n_user,4);
mean_ff=zeros(n_user,1);
%For each user

for i=1:n_user
   %if derivat fullfills user minimal
   if(sum(user_matrix(i,2:5)>0) || VT==3)
       %load layer model4uff
       [ff_n_jp,ff_amn_jp,ff_gc_jp] = layer_model4uff(user_matrix(i,:),derivat_partGA,min_fullfillment);
       %% Secondary Activity
       ff_secondactiv_p=zeros(1,5);
       for p=1:5
           if(user_matrix(i,p+1)>0)
               ff_secondactiv_p(1,p)=max(ff_n_jp(:,p));
           else
               ff_secondactiv_p(1,p)=1;
           end
       end
       %Mean of user fullfillment
       ff_user_n_amn_c(i,1)=mean(ff_secondactiv_p);

       %% Number of Passenger
       ff_amn_j=zeros(n_derivat,1);
       k=0;
       for j=1:n_derivat
           for x=1:4
               max_sa_by_n=max(ff_n_jp(:,x));
               if(max_sa_by_n>0 && ff_n_jp(j,x)==max_sa_by_n && user_matrix(i,x+1)>0)
                   max_amn=ff_amn_jp(j,x);
                   k=k+1;
                   ff_amn_j(k,1)=max(0,1-(fw(overfullfillment_factor_amn,underfullfillment_factor_amn,max_amn,derivat_partGA(j,6))/max_amn));
               end
           end
       end
       if(k==0)
           ff_amn_j(1,1)=1;
           k=1;
       end
       ff_user_n_amn_c(i,2)=mean(ff_amn_j(1:k,1));

       %% Global Character
       ff_gc_j=zeros(n_derivat,2);
       k=0;
       for j=1:n_derivat
           if(ff_gc_jp(j,1)>0)
               k=k+1;
               ff_gc_j(k,1)=max(0,(1-(fw(overfullfillment_factor_gc2,underfullfillment_factor_gc2,ff_gc_jp(j,1),derivat_partGA(j,7))./ff_gc_jp(j,1))));
               ff_gc_j(k,2)=max(0,(1-(fw(overfullfillment_factor_gc3,underfullfillment_factor_gc3,ff_gc_jp(j,2),derivat_partGA(j,8))./ff_gc_jp(j,2))));
           end
       end
       if(k==0)
           k=1;
       end
        ff_user_n_amn_c(i,3)=mean(ff_gc_j(1:k,1));
        ff_user_n_amn_c(i,4)=mean(ff_gc_j(1:k,2));
        mean_ff(i)=mean(ff_user_n_amn_c(i,:));
   end

end
end



