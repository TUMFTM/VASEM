function [derivat] = outline_derivat(x,number_derivat)
%Auslesen der Derivate aus dem Ergebnisvektor x des GA
derivat=zeros(number_derivat,5);
j=1;
for i=1:number_derivat
    derivat(i,:)=x(j:j+4);
    j=j+5;
end

