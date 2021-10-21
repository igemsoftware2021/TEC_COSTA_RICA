%3 recombinases case
r1 = 0.99;
r2 = 0.9;
r3 = 0.8;
r4 = 0.78;
t_recom = 20; %Approximate time of recombination in minutes
p_0 = 1000000; %initial population andan 1 000 000
n = 4; %n is equals the number of recombinases
%There will be 2^n -1 nodes/leaves in the tree
sequence = 1;
%Sacar acumulado de cuantas bacterias han existido
%Relacionar con temas de bioprocesos
%Ingenieria inversa, pov cientifico
for i = 1:2^n -1
    for j = 1:n
        if mod(i,2^j)==2^(j-1)
            s1 = "r";
            s2 = int2str(j);
            s = strcat(s1,s2);
            if strcmp(s,"r1")
                k = r1;
            elseif strcmp(s,"r2")
                k = r2;
            elseif strcmp(s,"r3")
                k = r3;
            else
                k = r4;
            end
            break
        end
    end
sequence = [sequence k];
end
sequence(1) = [];

PM = zeros(2^n);
PM(2^n,2^n) = 1;
for i = 1:2^n - 1
    PM(i,i) = 1-sequence(i); %Fill Probability Matrix
    PM(i,i+1) = sequence(i);
end

PM(3,3) = 0.19;
PM(3,4) = 0.81;
vector = zeros(2^n,1);
vector(1,1) = 1;
f = transpose(PM)*vector;
prob = 0;
while f(end)<0.999
    f = transpose(PM)*f;
    prob = [prob f(end)];
end

suma = p_0;
for i=1:size(prob,2)
    actual = p_0(i) - round(p_0(i)*prob(i)); %floor
    suma = [suma  2*actual];
    p_0 = [p_0 2*actual];
end

time = 1:size(p_0,2);

time = (time*t_recom)-t_recom;

bac = 0;
for i=1:size(suma,2)
    bac = bac + suma(i);
end

bac

figure(1)
plot(time,p_0,'-o')
title('Population of bacteria over time')
xlabel('Time(minutes)') 
ylabel('Population') 