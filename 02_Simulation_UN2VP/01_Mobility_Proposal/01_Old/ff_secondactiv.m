function [ff_N] = ff_secondactiv(user_partN,number_derivat,x,weight_N,user_reduced)
%Fitness Function Part for Secondary Activity
%User_part_N
%[N1 N2 N3 N4 N5] User 1
%[N1 N2 N3 N4 N5] User 2
%...
%x
%[D1 D2 D3 D4 D5 D6 C2 C3 D1 D2 D3 D4 D5 ...] für jedes Derivat

%Anzahl der User
[m,n]=size(user_partN);

%% V1
%For each user
fullfilment_user=ones(m,5);
for i=1:m
    %for each vehicle
    k=1;
    for j=1:number_derivat
        fullfilment_user(i,:)=fullfilment_user(i,:).*((user_partN(i,:)-x(k:k+4)).^2);
        k=k+8;
    end
end
%Sum up for all User and multiply weigth
sum_column=sum(fullfilment_user);
ff_N_V1=sum(sum_column)*weight_N;


%% V2
% %For each user
% fullfilment_user_i=ones(number_derivat,5);
% [derivat_partGA] = outline_partD(x,number_derivat);
% derivat_rel=derivat_partGA(:,1:5);
% add_pN=ones(m,5);
% sumD=zeros(1,5);
% sumN=zeros(1,5);
% for i=1:5
%     sumD(i)=sum(derivat_rel(:,i));
%     sumN(i)=sum(user_partN(:,i));
% end
% ff_N_D=sum((sumD-sumN).^2);
% for i=1:m
%     add=derivat_rel-user_partN(i,:);
%     fullfilment_user_i=fullfilment_user_i.*(add.^2);
%     %Product of column entrys of add
%     for j=1:number_derivat
%         for p=1:5
%             if(derivat_rel(j,p)>0 || user_partN(i,p)>0)
%                 add_pN(i,p)=add_pN(i,p).*add(j,p);
%             end
%         end
%     end
% end
% sum_column=sum(fullfilment_user_i);
% sum_column_Add=sum(add_pN.^2);
% ff_N_Add=sum(sum_column_Add)*weight_N;
% ff_N_N=sum(sum_column)*weight_N;
% ff_N=ff_N_Add+ff_N_D;

%% V3
%for user
% [derivat_partGA] = outline_partD(x,number_derivat);
% fullfilment_user_derivat=zeros(m,5);
% for i=1:m
%     %for secondary activit
%     for j=1:5
%        %for number derivat
%        fullfilment_N_by_D=1;
%        for p=1:number_derivat  
%            fullfilment_N_by_D=fullfilment_N_by_D*((user_partN(i,j)-derivat_partGA(p,j))^2);     
%        end
%        fullfilment_user_derivat(i,j)=fullfilment_N_by_D;
%     end
% end
% ff_N=sum(sum(fullfilment_user_derivat))*weight_N;

%% V4
[derivat_partGA] = outline_partD(x,number_derivat);
N_mat=zeros(5,m);
N_index=zeros(1,5);
D_mat=ones(5,number_derivat);
D_index=zeros(1,5);
%Step1
for i=1:5
    %User
    [N,X]=hist(user_partN(:,i),10);
    X=round(X);
    for j=1:10
        if(N(j)>0 && X(j)>0)
            N_index(1,i)=N_index(1,i)+1;
            N_mat(i,N_index(1,i))=X(j);
        end
    end
    %Derivat
    for p=1:number_derivat
       if(derivat_partGA(p,i)>0)
          lineD=D_mat(i,:)-derivat_partGA(p,i);
          if(prod(lineD)~=0 || derivat_partGA(p,i)==1)
              D_index(1,i)=D_index(1,i)+1;
              D_mat(i,D_index(1,i))=derivat_partGA(p,i);
          end
       end
    end
    for l=1:number_derivat
        if(D_mat(i,l)==1 && D_index(1,i)<1)
           D_mat(i,l)=0;
       end
    end
end
%Step2
sumD=zeros(1,5);
sumN=zeros(1,5);
prodD=zeros(1,5);
prodN=zeros(1,5);
for i=1:5
    sumD(1,i)=sum(D_mat(i,1:D_index(1,i)));
    sumN(1,i)=sum(N_mat(i,1:N_index(1,i)));
    prodD(1,i)=prod(D_mat(i,1:D_index(1,i)));
    if(D_index(1,i)==0)
        prodD(1,i)=0;
    end
    prodN(1,i)=prod(N_mat(i,1:N_index(1,i)));
    if(N_index(1,i)==0)
        prodN(1,i)=0;
    end
end
ff_sum=sum((sumD-sumN).^2);
ff_prod=sum((prodD-prodN).^2);
%ff_N_V4=ff_sum+ff_prod;
%% Test Partikel Schwarm
%Constrain Sum D1-D5<10
ff_D_con=zeros(1,number_derivat);
for d=1:number_derivat
    if(sum(derivat_partGA(d,1:5))>10)
        ff_D_con(1,d)=((sum(derivat_partGA(d,1:5))-10)*100)^2;
    end
end
% Constrain User fullfilment for all user equal
weights=[1 0 0];
[fullfilment_per_VT] = VT_fullfilment(user_reduced,derivat_partGA,weights);
  ff_U_con=0;
if(m>1)
    for i=1:m-1
        ff_U_con=ff_U_con+(((fullfilment_per_VT(i)-fullfilment_per_VT(i+1))*100)^2);
    end
end

ff_N_V4=(sum(ff_D_con)+ff_sum+ff_prod+ff_U_con)*weight_N;

%% Fitness Function
ff_N=ff_N_V1+ff_N_V4;
end

