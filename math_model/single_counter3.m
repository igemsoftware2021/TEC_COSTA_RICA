Kr1=2.8; Kr2=2; Kir=0.05; Ksyn=0.36; Ksynr=0.5; KbI=0.0001; Klri=0.00002;
ara_on = 0.1;
ara_off = 0.3;
per = 3;
kt = 0.03;
% time unit - hour
% y(1) PBtot
% y(2) LR-int4 first
% y(3) BP-int4-rdf2 first
% y(4) int_tot
% y(5) rdf_tot
Dtot=0.01; y0=[0 0 0 0 0 0 0]; % initial conditions for PxB reaction
%int_tot=0.4; rdf_tot=0.; %concentrations of integrase and RDF in mkM
%y0=[0 0 0]; rdf_tot=0.4; % initial conditions for LxR reaction
options = odeset();
%options = odeset('MaxStep',0.0001);

t=[3 9]; % time interval
[T, Y] = ode15s(@func_single_counter3,t,y0,options,Dtot,Kir,Kr1,Kr2,Ksyn,Ksynr,KbI,Klri,0.8,0.03,15,0.03);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%b=Y(:,5)-Y(:,4)+Kir;
%int=0.5.*(sqrt(b.*b+4*Y(:,4)*Kir)-b);
%rdf=Y(:,5)-Y(:,4)+int;
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
% kinetics of the total LR and PB during PxB reaction; t=[0 3]; integrase=0.4 mkM, rdf=0
% to run LxR reaction, change initial condition to y0=[0 0 0]
% to calculate the product level at 3h, use the last datapoint of the product vector: LRt for PxB reaction; Y(:1) for LxR reaction
% to calculate reaction kinetics with other integrase or RDF concentration, change values of variables int_tot=0.4 and rdf_tot
pulse = [];
for i=1:length(T)
      Th(i)=T(i);  
      pulse(i)=0.5*(tanh((Th(i)-ara_on-per*floor(Th(i)/per))/kt)-tanh((Th(i)-ara_off-per*floor(Th(i)/per))/kt));
end

max(Y(:,5))
max(Y(:,4))
figure (1)
plot(T,pulse,'m:'); %Pulse
hold on;
plot(T,LRt/Dtot,'r');%LR 
hold on;
plot(T,Y(:,1)/Dtot,'b');%PB 
hold on;
plot(T,Y(:,4)/max(Y(:,5)),'y'); %Integrase
hold on;
plot(T,Y(:,5)/max(Y(:,5)),'g'); %RDF
hold on;
%plot(T,Y(:,2),'k'); 
%hold on;
%plot(T,Y(:,3),'c'); 
%hold on;
%title('LR; PB;Int;RDF');
legend('LR','PB','Int','RDF')
title('Reverse recombination First Integrase')
xlabel('Time(h)') 
ylabel({'LR,PB,Inducer (AU)';'Int,RDF \muM'})