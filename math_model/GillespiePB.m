
%Parameter Definition
Kr1=2.8; Kr2=2; Kir=50; Ksyn=0.36; Ksynr=0.5; KbI=0.0001; Klri=0.00002;
avogadro = 6.022*10^23;
Dtot=500; %10 nM initial concentration
%int_tot=400; rdf_tot=0; %concentrations of integrase and RDF in mkM
y0=[Dtot 0 0 0 0]; % initial conditions for PxB reaction
%y0=[0 0 0 0 0]; %rdf_tot=0.4; % initial conditions for LxR reaction
kpr=6; 
kmr1=kpr/Kr1;
kmr2=kpr/Kr2;
kpsyn=0.006;
kmsyn=kpsyn/Ksyn;
kpsynr=0.06; 
kmsynr=kpsynr/Ksynr;
K = 115.2;%PBAD
%K = 9.36;%Pnrd
alpha1 = 4;
beta1 = 3;
alpha2 = 2;
%-----------------------------------------------------------------------------------
odes = [0,0,Dtot,0,0]';           % condiciones iniciales [LRI1,PBIR1,PBtot,mRNAi,I]
T = 4;                % tiempo de ejecución total
tiempo_actual = 0;      % tiempo actual

intrdf = 0;%No hay RDF presente
i_tot = odes(5);%No hay RDF presente
PB = (odes(3)-odes(2))./(1+odes(5).^4/KbI+intrdf.^4/KbI+odes(5).^2.*intrdf.^2/KbI);
LR = (Dtot-odes(3)-odes(1))./(1+odes(5).^4/KbI+intrdf.^4/KbI+odes(5).^2.*intrdf.^2/KbI);
LRtot=Dtot-odes(3);
PBI=PB.*odes(5).^4/KbI;
LRI2=LR.*odes(5).^4/KbI;
LRIR=LR.*intrdf.^4/KbI;
PBIR2=PB.*intrdf.^4/KbI;

% definición de eventos posibles
eventos = [  1   0   -1   0   0; ... % PBI*kpr
            -1   0    1   0   0; ... % LRI1*kmr1
             1   0    0   0   0; ... % LRI2*kmsyn
            -1   0    0   0   0; ... % LRI1*kpsyn
             0   1    1   0   0; ... % LRIR*kpr
             0  -1   -1   0   0; ... % PBIR1*kmr2
             0   1    0   0   0; ... % PBIR2*kmsynr
             0  -1    0   0   0; ... % PBIR1*kpsynr
             0   0    0   1   0; ... % K = promoter
             0   0    0  -1   0; ... % mRNAi*alpha1
             0   0    0   0   1; ... % mRNAi*beta1
             0   0    0   0  -1]';   % I*alpha2
 
% matriz de resultados
resultados = [0; odes]; % [tiempo,LRI1,PBIR1,PBtot,mRNAi,I]
LRresultado=[0;LRtot];
pt = 1;
tasas=[PBI*kpr;kmr1*odes(1);LRI2*kmsyn;kpsyn*odes(1);kpr*LRIR;kmr2*odes(2);kmsynr*PBIR2;kpsynr*odes(2);K;alpha1*odes(4);beta1*odes(4);alpha2*odes(5)];
while(tiempo_actual < T)
    % vector con tasas de transición
    tasas=[PBI*kpr;kmr1*odes(1);LRI2*kmsyn;kpsyn*odes(1);kpr*LRIR;kmr2*odes(2);kmsynr*PBIR2;kpsynr*odes(2);K;alpha1*odes(4);beta1*odes(4);alpha2*odes(5)];
    %disp(tasas)
    % calcule delta_T (distribución exponencial)
    deltaT = -log(rand(1))/sum(tasas);
    % seleccione evento
    evento_ID = randsample(size(eventos,2),1,true,tasas);
    % actualice tiempo y odes 
    tiempo_actual = tiempo_actual + deltaT;
    odes = odes + eventos(:,evento_ID);
    % guardar tiempo actual y valores odes
    
    intrdf = 0;%No hay RDF presente
    i_tot = odes(5);%No hay RDF presente
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
%M = [resultados(4,:).',LRresultado(2,:).',resultados(6,:).',resultados(1,:).'];
%writematrix(M,'Resultados.xlsx','Sheet',2,'Range','A2')

% gráficas de resultados
plot(resultados(1,:),resultados(4,:),'b')
hold on;
plot(LRresultado(1,:),LRresultado(2,:),'r')
hold on;
plot(resultados(1,:),resultados(6,:),'y')
xlabel('Time')
ylabel('Number of molecules')
title('Forward recombination')
legend('PBtot','LRtot','Recombinase')