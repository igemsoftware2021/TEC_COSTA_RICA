ara_on = 0;
ara_off = 0.2;
kt = 0.03;
k_int = 10;
k_deg = 5;
Dtot=0.01; y0=[Dtot 0 0 0 0 0 0]; % initial conditions for PxB reaction

        options = odeset('MaxStep',0.1);
        t=[0 2]; 

        [T, f] = ode15s(@func_single_counter1,t,y0,options,Dtot,Kir,Kr1,Kr2,Ksyn,Ksynr,KbI,Klri,1,1,1,0.05,0.2);
        % Find where Amplitude first exceeds 0.5:
        %firstIndex = find(LRt/Dtot > 0.74, 1);
        % Get Amplitude at that index:
        %amplitudeAtThresh = LRt(firstIndex)/Dtot;
        % Get time at that index:
        %timeAtThresh = t(firstIndex);
        %disp(timeAtThresh)
        %plot(T,Y,'r');
        LRt=Dtot-f(:,1);
        firstIndex = find(LRt/Dtot > 0.7, 1)
     
        valueAtThresh = LRt(firstIndex)/Dtot
        timeAtThresh = T(firstIndex)


