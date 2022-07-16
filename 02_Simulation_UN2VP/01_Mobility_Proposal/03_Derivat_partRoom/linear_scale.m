function [z] = linear_scale(z_min,x_max,y_max,z_max,x,y)
%Linear Function of two Variables z=f(x,y)=A_1 +A_2*x+A_2*y
A_1=z_min;
A_2=(z_max-z_min)/(x_max+y_max);
z=A_1+(A_2*x)+(A_2*y);
end

