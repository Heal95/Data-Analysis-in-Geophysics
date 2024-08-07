close all; clear all;

% Load data
load sim_ts.mat
load ar_koeficijenti.mat

% Plot simulated timeseries
figure;
for i = 1:6
	subplot(6,1,i);
	plot(v(1:500, i));
	xlabel('t [h]');
	ylabel('Amplituda');
    grid on;
end

% Calculate theoretical spectum
fr_AR = [0:0.05/length(a10):0.5];
sp_AR = ar_teorijski_spektar(a10, fr_AR');

% Estimate spectum for different data-windows
tlen = 256; 
M = [32, 64, 128]; 
%tlen = 4096;
%M = [256, 512, 1024];

for i = 1:size(v, 2)
	[PS1(:,i), F1] = pwelch(detrend(v(1:tlen, i)), M(1), 0.5, M(1), 1, 'twosided');
	[PS2(:,i), F2] = pwelch(detrend(v(1:tlen, i)), M(2), 0.5, M(2), 1, 'twosided');
	[PS3(:,i), F3] = pwelch(detrend(v(1:tlen, i)), M(3), 0.5, M(3), 1, 'twosided');
end

% Calculate mean and percentiles
PS1m = mean(PS1, 2); PS2m = mean(PS2, 2); PS3m = mean(PS3, 2);
PS1p1 = prctile(PS1, 2.5, 2); PS2p1 = prctile(PS2, 2.5, 2); PS3p1 = prctile(PS3, 2.5, 2);
PS1p2 = prctile(PS1, 97.5, 2); PS2p2 = prctile(PS2, 97.5, 2); PS3p2 = prctile(PS3, 97.5, 2);

% Define confidence intervals
gamma1 = floor(3.795*(2*tlen/M(1)-1));
gamma2 = floor(3.795*(2*tlen/M(2)-1));
gamma3 = floor(3.795*(2*tlen/M(3)-1));

alfa = 0.05;
ci11 = gamma1/chi2inv(alfa/2, gamma1); ci12 = gamma1/chi2inv(1-alfa/2, gamma1);
ci21 = gamma2/chi2inv(alfa/2, gamma2); ci22 = gamma2/chi2inv(1-alfa/2, gamma2);
ci31 = gamma3/chi2inv(alfa/2, gamma3); ci32 = gamma3/chi2inv(1-alfa/2, gamma3);

% Plot results
figure;
subplot(3, 1, 1);
semilogy(fr_AR, sp_AR, 'k-');
title(['M = ', num2str(M(1)), ', gamma = ', num2str(gamma1)]);
hold on;
semilogy(F1(1:length(F1)/2+1), PS1m(1:length(F1)/2+1), 'b-');
semilogy(F1(1:length(F1)/2+1), PS1p1(1:length(F1)/2+1), 'r--');
semilogy(F1(1:length(F1)/2+1), PS1p2(1:length(F1)/2+1), 'r--');
semilogy([0.320 0.330],[1000 1000],'m-');
semilogy([0.325 0.325],[1000*ci11 1000*ci12],'m-');
xlabel('f [1/h]');
ylabel('Spektar snage');
grid on;
legend('PS','PS srednji','PS 2.5 percentil','PS 97.5 percentil');

subplot(3, 1, 2);
semilogy(fr_AR, sp_AR, 'k-');
title(['M = ', num2str(M(2)), ', gamma = ', num2str(gamma2)]);
hold on;
semilogy(F2(1:length(F2)/2+1), PS2m(1:length(F2)/2+1), 'b-');
semilogy(F2(1:length(F2)/2+1), PS2p1(1:length(F2)/2+1), 'r--');
semilogy(F2(1:length(F2)/2+1), PS2p2(1:length(F2)/2+1), 'r--');
semilogy([0.320 0.330],[1000 1000],'m-');
semilogy([0.325 0.325],[1000*ci21 1000*ci22],'m-');
xlabel('f [1/h]');
ylabel('Spektar snage');
grid on;

subplot(3, 1, 3);
semilogy(fr_AR, sp_AR, 'k-');
title(['M = ', num2str(M(3)), ', gamma = ', num2str(gamma3)]);
hold on;
semilogy(F3(1:length(F3)/2+1), PS3m(1:length(F3)/2+1), 'b-');
semilogy(F3(1:length(F3)/2+1), PS3p1(1:length(F3)/2+1), 'r--');
semilogy(F3(1:length(F3)/2+1), PS3p2(1:length(F3)/2+1), 'r--');
semilogy([0.320 0.330],[1000 1000],'m-');
semilogy([0.325 0.325],[1000*ci31 1000*ci32],'m-');
xlabel('f [1/h]');
ylabel('Spektar snage');
grid on;
