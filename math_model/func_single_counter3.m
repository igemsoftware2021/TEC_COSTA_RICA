function Func = func_single_counter3(t,y,Dtot,Kir,Kr1,Kr2,Ksyn,Ksynr,KbI,Klri,k1,k2,k3,k4)
%Pulso arabinosa
ara_on = 0;
ara_off = 0.2;
kt = 0.03;
per = 3;
%puls = 0.5*(tanh((t-ara_on)/kt)-tanh((t-ara_off)/kt)); 
puls = 0.5*(tanh((t-per*floor(t/per)-ara_on)/kt)-tanh((t-per*floor(t/per)-ara_off)/kt));
%puls = 0.5*heaviside(t-0.3);
%puls = 0.05*(tanh(t/kt)+1); %sigmoide
%puls = 0.1;
% solving ODEs
Func = zeros(5, 1);
% y(1) BPtot
% y(2) LR-int4 first
% y(3) BP-int4-rdf2 first
% y(4) int
% y(5) rdf
%Constants
kpr=6;
kmr1=kpr/Kr1;
kmr2=kpr/Kr2;
kpsyn=0.006;
kmsyn=kpsyn/Ksyn;
kpsynr=0.06;
kmsynr=kpsynr/Ksynr;
k_int = 3;
k_dil = 2;
k_rdf = 0.3;
k_tscr = 120;
k_rdf_tsl = 0.3;
k_rna = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%b=y(5)-y(4)+Kir;
%int=0.5*(sqrt(b*b+4*y(4)*Kir)-b);
%rdf=y(5)-y(4)+int;
intrdf=y(4).*y(5)/Kir;
i_tot = y(4)+intrdf;
rdf_tot = y(5) + intrdf;
Bp=(y(1)-y(3))./(1+y(4).^4/KbI+intrdf.^4/KbI+y(4).^2.*intrdf.^2/KbI);
Lr=(Dtot-y(1)-y(2))./(1+y(4).^4/KbI+intrdf.^4/KbI+y(4).^2.*intrdf.^2/Klri);
BpI=Bp.*y(4).^4/KbI;
LrI2=Lr.*y(4).^4/KbI;
LrIR=Lr.*intrdf.^4/KbI;
BpIR2=Bp.*intrdf.^4/KbI;
Func(1) = kmr1*y(2)-kpr*BpI+kpr*LrIR-kmr2*y(3);
Func(2) = kpr*BpI-kmr1*y(2)-kpsyn*y(2)+kmsyn*LrI2;
Func(3) = kpr*LrIR-kmr2*y(3)-kpsynr*y(3)+kmsynr*BpIR2;
Func(4) = (4*k_int*y(6) - 1*k_dil*y(4))*heaviside(t-6); %Integrase protein
%Func(4) = 0.8*rbs*k_int*puls - 0.03*tag*k_dil*y(4)-intrdf-BpI-LrI2-LrIR-BpIR2;
%Func(4) = 0;
Func(5) = (50*k_rdf_tsl*y(7) - 1*k_dil*y(5))*heaviside(t-3);%RDF protein
%Func(5) = 0;
Func(6) = (1*k_tscr*puls -1*k_rna*y(6))*heaviside(t-6);%Integrase mRNA
Func(7) = (1*k_tscr*puls -1*k_rna*y(7))*heaviside(t-3);%RDF mRNA