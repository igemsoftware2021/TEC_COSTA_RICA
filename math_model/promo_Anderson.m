syms x y z
%GFP Taiwan
%alpha = 15;       0.060
%gamma_1 = 0.0022; 
%gamma_2 = 0.00052;

%RFP Alma
%alpha = 17.1;   %0.00077
%gamma_1 = 0.0337; 
%gamma_2 = 0.0048388; 

%RFP Pune_India
%alpha = 17.1;   
%gamma_1 = 0.00133; 
%gamma_2 = 0.002864; 

%RFP Nanjing_China
alpha = 0.072;   
gamma_1 = 0.0022; 
gamma_2 = 0.0012; 

time = [0     3*3600   5*3600]; %in seconds
%J23100 = 1000*[116.5 159.4 210.6]; %0.016156  1
%J23101 = 1000*[103 143 178.7];     %0.013695  0.84767
%J23102 = 1000*[97 151.1 157.8];    %0.012047  0.74567
%J23105 = 1000*[82 101.2 123.8];    %0.009484  0.58703
%J23106 = 1000*[80 118.8 131.9];    %0.010084  0.62416
%J23112 = 1000*[67 86.3 83];        %0.006324  0.39143
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J23100 = [19416.67 1295.93 716.33]; 
J23101 = [11444.44 694.17  452.41];     
J23102 = [13857.14 994.08  445.76];    
J23105 = [4823.53  404.8   283.94];    
J23106 = [10000    600     350];    
J23112 = [3383.84  349.39  200];        

chosen = J23101;
k_chosen = 0;
for i=1:(length(time)-2)
    for j=(i+1):(length(time)-1)
        for k=(j+1):(length(time))
            t1 = time(i);
            f1 = chosen(i);
            t2 = time(j);
            f2 = chosen(j);
            t3 = time(k);
            f3 = chosen(k);

            eqn1 = -(alpha/(gamma_1*(gamma_2-gamma_1)))*x*exp(-gamma_1*t1)+y*exp(-gamma_2*t1)+(alpha/(gamma_1*gamma_2))*z  == f1;
            eqn2 = -(alpha/(gamma_1*(gamma_2-gamma_1)))*x*exp(-gamma_1*t2)+y*exp(-gamma_2*t2)+(alpha/(gamma_1*gamma_2))*z  == f2;
            eqn3 = -(alpha/(gamma_1*(gamma_2-gamma_1)))*x*exp(-gamma_1*t3)+y*exp(-gamma_2*t3)+(alpha/(gamma_1*gamma_2))*z  == f3;
            %eqn3 = 4058441.56*x*exp(-0.0022*t3)+y*exp(-0.00052*t3)+13111888.11*z  == f3;
            sol = solve([eqn1, eqn2, eqn3], [x, y, z]);
            c1 = sol.x;
            c2 = sol.y;
            k = sol.z;
            %disp(double(k))
            %solution = double(k);
            k_chosen = [k_chosen double(k)];
        end
    end
end

k_chosen(1) = [];
k_chosen
fprintf('The mean is : %f\n', mean(k_chosen));
fprintf('The standard deviation is : %f\n', std(k_chosen));
%fun = @(n) -(alpha./(gamma_1.*(gamma_2-gamma_1))).*c1.*exp(-gamma_1.*n)+c2.*exp(-gamma_2.*n)+(alpha/(gamma_1.*gamma_2)).*k ;
%fun =  @(n) 4058441.56.*c1.*exp(-0.0022.*n)+c2.*exp(-0.00052.*n)+13111888.11.*k;
%fplot(fun,[0,10800],'g');
%grid on
%title('Gráfica de la función')
%xlabel('Tiempo(s)') 
%ylabel('Fluorescencia') 