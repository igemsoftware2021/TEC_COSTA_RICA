%pkg load statistics
%Definición de Parámetros
Kr1=2.8; Kr2=2; Kir=50; Ksyn=0.36; Ksynr=0.5; KbI=0.0001; Klri=0.00002;
Dtot=500; 
%int_tot=0; rdf_tot=400; %concentrations of integrase and RDF in mkM
%y0=[Dtot 0 0 0 0]; % initial conditions for PxB reaction
y0=[0 0 0 0 0]; %rdf_tot=0.4; % initial conditions for LxR reaction
kpr=6; 
kmr1=kpr/Kr1;
kmr2=kpr/Kr2;
kpsyn=0.006;
kmsyn=kpsyn/Ksyn;
kpsynr=0.06; 
kmsynr=kpsynr/Ksynr;
K = 115.2;
alpha1 = 4; beta1 = 3; alpha2 = 2; alpha3 = 4; beta2 = 9; alpha4 = 2;
%-----------------------------------------------------------------------------------
odes = [0,0,0,0,0,0,0]';           % condiciones iniciales [LRI1,PBIR1,PBtot,mRNAi,I,mRNArdf,RDF]
T = 4;                % tiempo de ejecución total
tiempo_actual = 0;      % tiempo actual

intrdf = odes(5).*odes(7)./Kir;
i_tot = odes(5)+intrdf;
rdf_tot = odes(7)+intrdf;
PB = (odes(3)-odes(2))./(1+odes(5).^4/KbI+intrdf.^4/KbI+odes(5).^2.*intrdf.^2/KbI);
LR = (Dtot-odes(3)-odes(1))./(1+odes(5).^4/KbI+intrdf.^4/KbI+odes(5).^2.*intrdf.^2/KbI);
LRtot=Dtot-odes(3);
PBI=PB.*odes(5).^4/KbI;
LRI2=LR.*odes(5).^4/KbI;
LRIR=LR.*intrdf.^4/KbI;
PBIR2=PB.*intrdf.^4/KbI;

% definición de eventos posibles
eventos = [  1   0   -1   0   0  0  0; ... % PBI*kpr
            -1   0    1   0   0  0  0; ... % LRI1*kmr1
             1   0    0   0   0  0  0; ... % LRI2*kmsyn
            -1   0    0   0   0  0  0; ... % LRI1*kpsyn
             0   1    1   0   0  0  0; ... % LRIR*kpr
             0  -1   -1   0   0  0  0; ... % PBIR1*kmr2
             0   1    0   0   0  0  0; ... % PBIR2*kmsynr
             0  -1    0   0   0  0  0; ... % PBIR1*kpsynr
             0   0    0   1   0  1  0; ... % K = promoter
             0   0    0  -1   0  0  0; ... % mRNAi*alpha1
             0   0    0   0   1  0  0; ... % mRNAi*beta1
             0   0    0   0  -1  0  0; ... % I*alpha2
             0   0    0   0   0 -1  0; ... % mRNArdf*alpha3
             0   0    0   0   0  0  1; ... % mRNArdf*beta2
             0   0    0   0   0  0 -1]';   % RDF*alpha4
 
% matriz de resultados
resultados = [0; odes]; % [tiempo,LRI1,PBIR1,PBtot,mRNAi,I,mRNArdf,RDF]
LRresultado=[0;LRtot];
pt = 1;
tasas=[PBI*kpr;kmr1*odes(1);LRI2*kmsyn;kpsyn*odes(1);kpr*LRIR;kmr2*odes(2);kmsynr*PBIR2;kpsynr*odes(2);K;alpha1*odes(4);beta1*odes(4);alpha2*odes(5);alpha3*odes(6);beta2*odes(6);alpha4*odes(7)];
while(tiempo_actual < T)
    % vector con tasas de transición
    tasas=[PBI*kpr;kmr1*odes(1);LRI2*kmsyn;kpsyn*odes(1);kpr*LRIR;kmr2*odes(2);kmsynr*PBIR2;kpsynr*odes(2);K;alpha1*odes(4);beta1*odes(4);alpha2*odes(5);alpha3*odes(6);beta2*odes(6);alpha4*odes(7)];
    %disp(tasas)
    % calcule delta_T (distribución exponencial)
    deltaT = -log(rand(1))/sum(tasas);
    % seleccione evento
    evento_ID = randsample(size(eventos,2),1,true,tasas);
    % actualice tiempo y odes 
    tiempo_actual = tiempo_actual + deltaT;
    odes = odes + eventos(:,evento_ID);
    % guardar tiempo actual y valores odes
    
    intrdf = odes(5).*odes(7)./Kir;
    i_tot = odes(5)+intrdf;
    rdf_tot = odes(7)+intrdf;
    PB = (odes(3)-odes(2))./(1+odes(5).^4/KbI+intrdf.^4/KbI+odes(5).^2.*intrdf.^2/KbI);
    LR = (Dtot-odes(3)-odes(1))./(1+odes(5).^4/KbI+intrdf.^4/KbI+odes(5).^2.*intrdf.^2/KbI);
    LRtot=Dtot-odes(3);
    PBI=PB.*odes(5).^4/KbI;
    LRI2=LR.*odes(5).^4/KbI;
    LRIR=LR.*intrdf.^4/KbI;
    PBIR2=PB.*intrdf.^4/KbI;
    
    pt = pt + 1;
    resultados(:,pt)   = [tiempo_actual; odes];
    LRresultado(:,pt) =  [tiempo_actual;LRtot];
end
%--------------------------------------------------------------------------

M = [resultados(4,:).',LRresultado(2,:).',resultados(6,:).',resultados(1,:).'];
writematrix(M,'Resultados.xlsx','Sheet',2,'Range','J2')
% gráficas de resultados
plot(resultados(1,:),resultados(4,:),'b')
hold on;
plot(LRresultado(1,:),LRresultado(2,:),'r')
hold on;
plot(resultados(1,:),resultados(6,:),'y')
hold on;
plot(resultados(1,:),resultados(8,:),'g')
xlabel('Time')
ylabel('Number of molecules')
title('Reverse recombination')
legend('PBtot','LRtot','Recombinase','RDF')