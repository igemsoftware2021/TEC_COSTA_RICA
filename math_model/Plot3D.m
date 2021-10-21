ara_on = 0;
ara_off = 0.2;
kt = 0.03;
k_int = 10;
k_deg = 5;
Dtot=0.01; y0=[Dtot 0 0 0 0 0 0]; % initial conditions for PxB reaction
X = 0.1:0.02:1;
Y = 0.1:0.02:1;
Z = zeros(length(Y),length(X));
for i = 1:length(Y)
    for j = 1:length(X)
        options = odeset('MaxStep',0.1);
        t=[0 2]; 
        conc_pulse = Y(i);
        time_ind = X(j);
        [T, f] = ode15s(@func_single_counter1,t,y0,options,Dtot,Kir,Kr1,Kr2,Ksyn,Ksynr,KbI,Klri,1,1,1,conc_pulse,time_ind);
        % Find where Amplitude first exceeds 0.5:
        %firstIndex = find(LRt/Dtot > 0.74, 1);
        % Get Amplitude at that index:
        %amplitudeAtThresh = LRt(firstIndex)/Dtot;
        % Get time at that index:
        %timeAtThresh = t(firstIndex);
        %disp(timeAtThresh)
        %plot(T,Y,'r');
        firstIndex = find(T > 1, 1);

        LRt=Dtot-f(:,1);
        valueAtThresh = LRt(firstIndex)/Dtot;
        Z(i,j) = valueAtThresh;
    end
end
        
%z = randi(10,10);
surf(X,Y,Z) 
title('% of Recombination')
xlabel('Induced Time(h)')
ylabel('Inducer Concentration(\muM)')
colormap(jet)
s.EdgeColor = 'none';
colorbar