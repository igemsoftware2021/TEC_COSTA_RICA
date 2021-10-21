% main model file, calling for ode file Model_min_mod_1116.m
Kr1=2.8; Kr2=2; Kir=0.05; Ksyn=0.36; Ksynr=0.5; KbI=0.0001; Klri=0.00002;
ara_on = 0.3;
ara_off = 0.5;
kt = 0.03;
best = 0.3;
k1=0; k2=0; k3=0; k4=0;
% time unit - hour
% y(1) PBtot
% y(2) LR-int4 first
% y(3) BP-int4-rdf2 first
% y(4) int_tot
% y(5) rdf_tot
Dtot=0.01; y0=[Dtot 0 0 0 0 0 0]; % initial conditions for PxB reaction
%int_tot=0.4; rdf_tot=0.; %concentrations of integrase and RDF in mkM
%y0=[0 0 0]; rdf_tot=0.4; % initial conditions for LxR reaction

X = 1:0.5:5;
P = 1:0.5:5;
Z = 1:0.5:5;

for x = 1:length(X)
    for p = 1:length(P)
        for z = 1:length(Z)
           
                options = odeset();
                %options = odeset('MaxStep',0.0001);
                t=[0 2]; % time interval
                [T, Y] = ode15s(@func_single_counter1,t,y0,options,Dtot,Kir,Kr1,Kr2,Ksyn,Ksynr,KbI,Klri,X(x),P(p),Z(z),0.5,0.2);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                LRt=Dtot-Y(:,1);
                intrdf = Y(:,4).*Y(:,5)/Kir;
                i_tot = Y(:,4)+intrdf;
                rdf_tot = Y(:,5) + intrdf;
                Bp=(Y(:,1)-Y(:,3))./(1+Y(:,4).^4/KbI+intrdf.^4/KbI+Y(:,4).^2.*intrdf.^2/KbI);
                Lr=(Dtot-Y(:,1)-Y(:,2))./(1+Y(:,4).^4/KbI+intrdf.^4/KbI+Y(:,4).^2.*intrdf.^2/Klri);
                BpI=Bp.*Y(:,4).^4/KbI;
                LrI2=Lr.*Y(:,4).^4/KbI;
                LrIR=Lr.*intrdf.^4/KbI;
                BpIR2=Bp.*intrdf.^4/KbI;
                
                firstIndex = find(T > 1, 1);
                valueAtThresh = LRt(firstIndex)/Dtot;
               
                if valueAtThresh > best
                    k1 = X(x);
                    k2 = P(p);
                    k3 = Z(z);
                    best = valueAtThresh;
                end
            
        end
    end
end

sol = [k1 k2 k3]