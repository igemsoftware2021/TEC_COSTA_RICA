function dydt = promoter(t,y,ara_on,ara_off,kt,k_int,k_deg)
%dydt = 0;
puls=0.5*(tanh((t-ara_on)/kt)-tanh((t-ara_off)/kt));  
dydt = k_int*puls-k_deg*y;
end