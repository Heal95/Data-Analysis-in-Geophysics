close all; clear all;
load ar_koeficijenti.mat

for i = 1:1000
	v(:,i) = arsim(0, -a10', 1, 4096);
end

save sim_ts.mat v