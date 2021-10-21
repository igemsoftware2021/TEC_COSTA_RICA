%3 recombinases case
r1 = 0.99; %1 Bxb1
r2 = 0.9;%0.9 TP901
r3 = 0.8;
r4 = 0.78;
t_recom = 20; %Approximate time of recombination in minutes, doubling time E.coli

n = 2; %n is equal the number of recombinases
%There will be 2^n -1 nodes/leaves in the tree
sequence = 1;

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

%PM=[1-r1 r1 0 0 0 0 0 0;
    %0 1-r2 r2 0 0 0 0 0;
    %0 0 1-r1 r1 0 0 0 0;
    %0 0 0 1-r3 r3 0 0 0;
    %0 0 0 0 1-r1 r1 0 0;
    %0 0 0 0 0 1-r2 r2 0;
    %0 0 0 0 0 0 1-r1 r1;
    %0 0 0 0 0 0   0   1];%Probability Matrix
PM(3,3) = 0.19;
PM(3,4) = 0.81;
PM
vector = zeros(2^n,1);
vector(1,1) = 1;
f = transpose(PM)*vector;
prob = 0;
while f(end)<0.999
    f = transpose(PM)*f;
    prob = [prob f(end)];
end


rel_prob = prob(1);
current = 0;
for i=2:size(prob,2)
    current = prob(i)-prob(i-1);
    rel_prob = [rel_prob current];
end

x = 1:size(prob,2);
expected_value = x*transpose(rel_prob);
average_time_recombination = expected_value*t_recom;
output = ['The average recombination time is: ',num2str(average_time_recombination),' minutes'];
disp(output)


%M = [prob.',rel_prob.'];
%writematrix(M,'Resultados.xlsx','Sheet',3,'Range','A2')

figure(1)
bar(prob)
title('Probability of having reached the final state of the counter')
xlabel('Number of steps(Recombinations)') 
ylabel('Probability') 

figure(2)
bar(rel_prob,'r')
title('Probability to reach the final state of the counter in exactly n steps')
xlabel('Number of steps(Recombinations)') 
ylabel('Probability') 
    