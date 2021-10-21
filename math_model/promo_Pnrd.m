%promo(0,25000,2700,27500,4860,32000)
%promo(0,25000,1080,26500,4860,32000)
syms x y z
alpha = 15;
gamma_1 = 0.0022;
gamma_2 = 0.00052;
PBAD_time = [9695  13295  16895  20495  22295];
PBAD_fluo = [90000 220000 420000 520000 540000];
Pnrd_time = [0     1080   2700 3780   4860];
Pnrd_fluo = [25000 26500 27500 28500 31000];
k_PBAD = 0;
k_Pnrd = 0;
for i=1:(length(Pnrd_time)-2)
    for j=(i+1):(length(Pnrd_time)-1)
        for k=(j+1):(length(Pnrd_time))
            t1 = Pnrd_time(i);
            f1 = Pnrd_fluo(i);
            t2 = Pnrd_time(j);
            f2 = Pnrd_fluo(j);
            t3 = Pnrd_time(k);
            f3 = Pnrd_fluo(k);

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
            k_Pnrd = [k_Pnrd double(k)];
        end
    end
end

k_Pnrd(1) = [];
k_Pnrd
fprintf('The mean is : %f\n', mean(k_Pnrd));
fprintf('The standard deviation is : %f\n', std(k_Pnrd));
%fun = @(n) -(alpha./(gamma_1.*(gamma_2-gamma_1))).*c1.*exp(-gamma_1.*n)+c2.*exp(-gamma_2.*n)+(alpha/(gamma_1.*gamma_2)).*k ;
%fun =  @(n) 4058441.56.*c1.*exp(-0.0022.*n)+c2.*exp(-0.00052.*n)+13111888.11.*k;
%fplot(fun,[0,10800],'g');
%grid on
%title('Gráfica de la función')
%xlabel('Tiempo(s)') 
%ylabel('Fluorescencia') 