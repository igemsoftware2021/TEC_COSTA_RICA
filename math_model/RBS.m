ara_on = 0;
ara_off = 5;
k_int = 10;
k_deg = 5;
Kr1=2.8; Kr2=2; Kir=0.05; Ksyn=0.36; Ksynr=0.5; KbI=0.0001; Klri=0.00002;
kt = 0.3;
Dtot=0.01; y0=[Dtot 0 0 0 0]; % initial conditions for PxB reaction
%int_tot=0.4; rdf_tot=0.; %concentrations of integrase and RDF in mkM
%y0=[0 0 0]; rdf_tot=0.4; % initial conditions for LxR reaction
options = odeset();
X = 1:0.5:10;
Y = 1:0.5:10;
Z = zeros(length(Y),length(X));
for i = 1:length(Y)
    for j = 1:length(X)
        options = odeset('MaxStep',0.1);
        t=[0 5]; 
        tag = Y(i);
        rbs = X(j);
        [T, f] = ode15s(@func_single_counter,t,y0,options,Dtot,Kir,Kr1,Kr2,Ksyn,Ksynr,KbI,Klri,rbs,tag);
        % Find where Amplitude first exceeds 0.5:
        %firstIndex = find(LRt/Dtot > 0.74, 1);
        % Get Amplitude at that index:
        %amplitudeAtThresh = LRt(firstIndex)/Dtot;
        % Get time at that index:
        %timeAtThresh = t(firstIndex);
        %disp(timeAtThresh)
        %plot(T,Y,'r');
        b=f(:,5)-f(:,4)+Kir;
        int=0.5.*(sqrt(b.*b+4*f(:,4)*Kir)-b);
        rdf=f(:,5)-f(:,4)+int;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        LRt=Dtot-f(:,1);
        Intrdf=int.*rdf/Kir;
        BP=(f(:,1)-f(:,3))/(1+int.^4/KbI+Intrdf.^4/KbI+int.^2.*Intrdf.^2/KbI);
        LR=(Dtot-f(:,1)-f(:,2))/(1+int.^4/KbI+Intrdf.^4/KbI+int.^2.*Intrdf.^2/Klri);
        BPI=BP.*int.^4/KbI;
        LRI2=LR.*int.^4/KbI;
        LRIR=LR.*Intrdf.^4/KbI;
        BPIR2=BP.*Intrdf.^4/KbI;
        
        Z(i,j) = max(f(:,4));
    end
end
        
%z = randi(10,10);
surf(X,Y,Z) 
title('Gráfica 3D')
xlabel('RBS')
ylabel('Degradation Tag')
colormap(jet)
s.EdgeColor = 'none';
colorbar