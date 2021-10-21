function [int_tot,T,rdf_tot,timeAtThresh,fc]=ODEsolver
tf = 2;
Dtot=0.01; y0=[Dtot 0 0 0 0 0 0]; % initial conditions for PxB reaction
% main model file, calling for ode file Model_tetR_f.m
Kr1=1; Kr2=1; Dtot=0.017; Ki=0.02; Kii=0.3; Kir=0.05; Kmod=3.4; Kmodr=1.9; Ks01=0.001; Ks02=0.007;
Ks1=0.1; Ks2=0.12; Ks3=0.1; Ks4=0.013; Kb1=0.02; Kb2=0.01; Kb3=0.025; Kb4=0.05; %Ks1,Ks3,Kb1,Kb3-dissociation constants
Ksyn=0.36;Ksynr=0.5; KbI=0.0001; Klri=0.00002;
k_dil=2; Ktet=10; ara_on=0.5; ara_off=0.7; period=24; k_tscr=120; k_int=3; k_rna=4; kt=0.03;
ktet_tsl=0.3; krdf_tsl=4; % default parameters
%Ktet=10; % to switch off tetR inhibition
%kt=0.03; 
%ktet_tsl=3.4; krdf_tsl=800; % optimized parameters
%ara_on=0.5; ara_off=0.7; 
% time unit - hour; concentrations - mkM

%tf=2;

options = odeset('MaxStep',0.1);

    %y0=Y(end,:);  
    t=[0 tf]; 
    [T, Y] = ode15s(@func_single_counter1,t,y0,options,Dtot,Kir,Kr1,Kr2,Ksyn,Ksynr,KbI,Klri,1,1,1,0.5,0.2);

    
%LRt=Y(:,1)+Y(:,6)+Y(:,8)+Y(:,9)+Y(:,11)+Y(:,13)+Y(:,15)+Y(:,18)+Y(:,22)+Y(:,28)+Y(:,29)+Y(:,30);
%PBt=Y(:,5)+Y(:,7)+Y(:,10)+Y(:,12)+Y(:,14)+Y(:,16)+Y(:,17)+Y(:,21)+Y(:,24)+Y(:,25)+Y(:,26)+Y(:,27)+Y(:,31)+Y(:,32)+Y(:,34)+Y(:,35)+Y(:,36);
%int_tot=Y(:,2)+Y(:,19)+2*(Y(:,3)+Y(:,20)+Y(:,21)+Y(:,22)+Y(:,4)+Y(:,5)+Y(:,6)+Y(:,12)+Y(:,13))+4*(Y(:,7)+Y(:,8)+Y(:,9)+Y(:,10)+Y(:,11)+Y(:,14)+Y(:,15)+Y(:,16)+Y(:,17)+Y(:,18)+Y(:,28)+Y(:,29)+Y(:,30)+Y(:,25)+Y(:,26)+Y(:,27))+6*(Y(:,31)+Y(:,32)+Y(:,34)+Y(:,35)+Y(:,36));
%rdf_tot=Y(:,23)+Y(:,19)+Y(:,20)+Y(:,21)+Y(:,22)+Y(:,25)+Y(:,28)+Y(:,34)+2*(Y(:,3)+Y(:,12)+Y(:,13)+Y(:,26)+Y(:,29)+Y(:,35))+3*(Y(:,27)+Y(:,30)+Y(:,36))+4*(Y(:,14)+Y(:,15)+Y(:,16)+Y(:,17)+Y(:,18)+Y(:,32));
%DNA_rdf=Y(:,13)+Y(:,15)+Y(:,18)+Y(:,22)+Y(:,28)+Y(:,29)+Y(:,30)+Y(:,12)+Y(:,14)+Y(:,16)+Y(:,17)+Y(:,21)+Y(:,25)+Y(:,26)+Y(:,27)+Y(:,32)+Y(:,34)+Y(:,36);
%------------------------------------------------------------
fc=[Y(end,1) Y(end,2) Y(end,3) Y(end,4)  Y(end,5) Y(end,6) Y(end,7) Y(end,8) Y(end,9) Y(end,10) Y(end,11) Y(end,12) Y(end,13) Y(end,14) Y(end,15) Y(end,16) Y(end,17) Y(end,18) Y(end,19) Y(end,20) Y(end,21) Y(end,22) Y(end,23) Y(end,24) Y(end,25) Y(end,26) Y(end,27) Y(end,28) Y(end,29) Y(end,30) Y(end,31) Y(end,32) Y(end,33) Y(end,34) Y(end,35) Y(end,36) Y(end,37) Y(end,38)];
%------------------------------------------------------------
% Find where Amplitude first exceeds 0.7:
firstIndex = find(Y(:,1)/Dtot > 0.7, 1);
% Get Amplitude at that index:
%amplitudeAtThresh = int_tot(firstIndex);
% Get time at that index:
timeAtThresh = T(firstIndex);
%disp(timeAtThresh) 
%------------------------------------------------------------

end 
