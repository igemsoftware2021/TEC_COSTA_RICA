%pkg load statistics
%Definición de Parámetros
Kr1=2.8; Kr2=2; Kir=50; Ksyn=0.36; Ksynr=0.5; KbI=0.0001; Klri=0.00002;
Dtot=100; 
int_tot=400; rdf_tot=0; %concentrations of integrase and RDF in mkM
y0=[Dtot 0 0]; % initial conditions for PxB reaction
%y0=[0 0 0]; %rdf_tot=0.4; % initial conditions for LxR reaction
kpr=6; 
kmr1=kpr/Kr1;
kmr2=kpr/Kr2;
kpsyn=0.006;
kmsyn=kpsyn/Ksyn;
kpsynr=0.06; 
kmsynr=kpsynr/Ksynr;

b=rdf_tot-int_tot+Kir;
int=0.5*(sqrt(b*b+4*int_tot*Kir)-b);
rdf=rdf_tot-int_tot+int;
intrdf=int*rdf/Kir;

%--------------------------------------------------------------------------
sir = [Dtot,0,0]';           % condiciones iniciales [PBtot,LRI1,PBIR1]
T = 3;                % tiempo de ejecución total
tiempo_actual = 0;      % tiempo actual

Bp=sir(1)-sir(3);
Lr=Dtot-sir(1)-sir(2);
LRtot=Dtot-sir(1);
BpI=Bp;
LrI2=Lr;


% definición de eventos posibles
eventos = [ -1   1   0; ... % PB1*kpr
             1  -1   0; ... % LRI1*kmr1
             0   1   0; ... % LRI2*kmsyn
             0  -1   0]';   % LRI1*kpsyn
 
% matriz de resultados
resultados = [0; sir]; % [tiempo,PBtot,LRI1,PBIR1]
LRresultado=[0;LRtot];
pt = 1;
tasas=[BpI*kpr;kmr1*sir(2);LrI2*kmsyn;kpsyn*sir(2)];
while(tiempo_actual < T)
    % vector con tasas de transición
    tasas=[BpI*kpr;kmr1*sir(2);LrI2*kmsyn;kpsyn*sir(2)];
    %disp(tasas)
    % calcule delta_T (distribución exponencial)
    deltaT = -log(rand(1))/sum(tasas);
    % seleccione evento
    evento_ID = randsample(size(eventos,2),1,true,tasas);
    % actualice tiempo y SIR 
    tiempo_actual = tiempo_actual + deltaT;
    sir = sir + eventos(:,evento_ID);
    % guardar tiempo actual y valores SIR
    Bp=sir(1)-sir(3);
    Lr=Dtot-sir(1)-sir(2);
    LRtot=Dtot-sir(1);
    BpI=Bp;
    LrI2=Lr;
    pt = pt + 1;
    resultados(:,pt)   = [tiempo_actual; sir];
    LRresultado(:,pt) =  [tiempo_actual;LRtot];
end
%--------------------------------------------------------------------------

% gráficas de resultados
plot(resultados(1,:),resultados(2,:),'b')
hold on;
plot(LRresultado(1,:),LRresultado(2,:),'r')
legend('PBtot','LRtot')