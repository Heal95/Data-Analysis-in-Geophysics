close all; clear all;

% Load data for selected station (Rijeka, i=3)
load ('LAMI_ECMWF_data.mat')
i = 3;
p = mslpL(:,i); t = t2mL(:,i); u = u10mL(:,i); v = v10mL(:,i);

% Plot temperature, pressure, E-W  and N-S wind components
figure;
subplot(4,1,1);
plot(p);
xlabel('t [h]');
ylabel('p [hPa]');
grid on;

subplot(4,1,2);
plot(t);
xlabel('t [h]');
ylabel('t [^o C]');
grid on;

subplot(4,1,3);
plot(u);
xlabel('t [h]');
ylabel('u [m/s]');
grid on;

subplot(4,1,4);
plot(v);
xlabel('t [h]');
ylabel('v [m/s]');
grid on;

% Remove seasonality and trend
n = size(p, 1);
tt = [1:n]';
f1 = 1/(4*365);
f2 = 1/(2*365);
x = [ones(size(tt)) sin(2*pi*f1*tt) cos(2*pi*f1*tt) sin(2*pi*f2*tt) cos(2*pi*f2*tt)];

a_t = (x'*x)\(x'*t); tx = x*a_t; t = t - tx; p = detrend(p);
a_p = (x'*x)\(x'*p); px = x*a_p; p = p - px; t = detrend(t);
a_u = (x'*x)\(x'*u); ux = x*a_u; u = u - ux; u = detrend(u);
a_v = (x'*x)\(x'*v); vx = x*a_v; v = v - vx; v = detrend(v);

% Estimate spectum for different data-windows
M = [1024 512 256 128 64];

[PS1_p, F1_p] = pwelch(p, M(1), 0.5, M(1), 1/3, 'twosided');
[PS1_t, F1_t] = pwelch(t, M(1), 0.5, M(1), 1/3, 'twosided');
[PS1_u, F1_u] = pwelch(u, M(1), 0.5, M(1), 1/3, 'twosided');
[PS1_v, F1_v] = pwelch(v, M(1), 0.5, M(1), 1/3, 'twosided');

[PS2_p, F2_p] = pwelch(p, M(2), 0.5, M(2), 1/3, 'twosided');
[PS2_t, F2_t] = pwelch(t, M(2), 0.5, M(2), 1/3, 'twosided');
[PS2_u, F2_u] = pwelch(u, M(2), 0.5, M(2), 1/3, 'twosided');
[PS2_v, F2_v] = pwelch(v, M(2), 0.5, M(2), 1/3, 'twosided');

[PS3_p, F3_p] = pwelch(p, M(3), 0.5, M(3), 1/3, 'twosided');
[PS3_t, F3_t] = pwelch(t, M(3), 0.5, M(3), 1/3, 'twosided');
[PS3_u, F3_u] = pwelch(u, M(3), 0.5, M(3), 1/3, 'twosided');
[PS3_v, F3_v] = pwelch(v, M(3), 0.5, M(3), 1/3, 'twosided');

[PS4_p, F4_p] = pwelch(p, M(4), 0.5, M(4), 1/3, 'twosided');
[PS4_t, F4_t] = pwelch(t, M(4), 0.5, M(4), 1/3, 'twosided');
[PS4_u, F4_u] = pwelch(u, M(4), 0.5, M(4), 1/3, 'twosided');
[PS4_v, F4_v] = pwelch(v, M(4), 0.5, M(4), 1/3, 'twosided');

[PS5_p, F5_p] = pwelch(p, M(5), 0.5, M(5), 1/3, 'twosided');
[PS5_t, F5_t] = pwelch(t, M(5), 0.5, M(5), 1/3, 'twosided');
[PS5_u, F5_u] = pwelch(u, M(5), 0.5, M(5), 1/3, 'twosided');
[PS5_v, F5_v] = pwelch(v, M(5), 0.5, M(5), 1/3, 'twosided');

% Define confidence intervals
tlen = length(p);
gamma1 = floor(3.795*(2*tlen/M(1)-1));
gamma2 = floor(3.795*(2*tlen/M(2)-1));
gamma3 = floor(3.795*(2*tlen/M(3)-1));
gamma4 = floor(3.795*(2*tlen/M(4)-1));
gamma5 = floor(3.795*(2*tlen/M(5)-1));

alfa = 0.05;
ci11 = gamma1/chi2inv(alfa/2, gamma1); ci12 = gamma1/chi2inv(1-alfa/2, gamma1);
ci21 = gamma2/chi2inv(alfa/2, gamma2); ci22 = gamma2/chi2inv(1-alfa/2, gamma2);
ci31 = gamma3/chi2inv(alfa/2, gamma3); ci32 = gamma3/chi2inv(1-alfa/2, gamma3);
ci41 = gamma4/chi2inv(alfa/2, gamma4); ci42 = gamma4/chi2inv(1-alfa/2, gamma4);
ci51 = gamma5/chi2inv(alfa/2, gamma5); ci52 = gamma5/chi2inv(1-alfa/2, gamma5);

% Plot results
figure;
subplot(2, 2, 1);
semilogy(F1_p(1:length(F1_p)/2+1), PS1_p(1:length(F1_p)/2+1), '-b');
hold on;
semilogy(F2_p(1:length(F2_p)/2+1), PS2_p(1:length(F2_p)/2+1), '-r');
semilogy(F3_p(1:length(F3_p)/2+1), PS3_p(1:length(F3_p)/2+1), '-g');
semilogy(F4_p(1:length(F4_p)/2+1), PS4_p(1:length(F4_p)/2+1), '-y');
semilogy(F5_p(1:length(F5_p)/2+1), PS5_p(1:length(F5_p)/2+1), '-m');
semilogy([0.09 0.15], [15000 15000],'-k');
semilogy([0.105 0.105], [15000*ci11 15000*ci12],'b-');
semilogy([0.115 0.115], [15000*ci21 15000*ci22],'r-');
semilogy([0.125 0.125], [15000*ci31 15000*ci32],'g-');
semilogy([0.135 0.135], [15000*ci41 15000*ci42],'y-');
semilogy([0.145 0.145], [15000*ci51 15000*ci52],'m-');
title('Tlak');
ylabel('Spektar snage');
xlabel('f [1/h]');
xlim([0 0.1665]);
grid on;
set(gca,'MinorGridLineStyle','none');

subplot(2, 2, 2);
semilogy(F1_t(1:length(F1_t)/2+1), PS1_t(1:length(F1_t)/2+1), '-b');
hold on;
semilogy(F2_t(1:length(F2_t)/2+1), PS2_t(1:length(F2_t)/2+1), '-r');
semilogy(F3_t(1:length(F3_t)/2+1), PS3_t(1:length(F3_t)/2+1), '-g');
semilogy(F4_t(1:length(F4_t)/2+1), PS4_t(1:length(F4_t)/2+1), '-y');
semilogy(F5_t(1:length(F5_t)/2+1), PS5_t(1:length(F5_t)/2+1), '-m');
semilogy([0.09 0.15], [15000 15000],'-k');
semilogy([0.105 0.105], [15000*ci11 15000*ci12],'b-');
semilogy([0.115 0.115], [15000*ci21 15000*ci22],'r-');
semilogy([0.125 0.125], [15000*ci31 15000*ci32],'g-');
semilogy([0.135 0.135], [15000*ci41 15000*ci42],'y-');
semilogy([0.145 0.145], [15000*ci51 15000*ci52],'m-');
title('Temperatura');
ylabel('Spektar snage');
xlabel('f [1/h]');
xlim([0 0.1665]);
grid on;
set(gca,'MinorGridLineStyle','none');

subplot(2, 2, 3);
semilogy(F1_u(1:length(F1_u)/2+1), PS1_u(1:length(F1_u)/2+1), '-b');
hold on;
semilogy(F2_u(1:length(F2_u)/2+1), PS2_u(1:length(F2_u)/2+1), '-r');
semilogy(F3_u(1:length(F3_u)/2+1), PS3_u(1:length(F3_u)/2+1), '-g');
semilogy(F4_u(1:length(F4_u)/2+1), PS4_u(1:length(F4_u)/2+1), '-y');
semilogy(F5_u(1:length(F5_u)/2+1), PS5_u(1:length(F5_u)/2+1), '-m');
semilogy([0.09 0.15], [15000 15000],'-k');
semilogy([0.105 0.105], [15000*ci11 15000*ci12],'b-');
semilogy([0.115 0.115], [15000*ci21 15000*ci22],'r-');
semilogy([0.125 0.125], [15000*ci31 15000*ci32],'g-');
semilogy([0.135 0.135], [15000*ci41 15000*ci42],'y-');
semilogy([0.145 0.145], [15000*ci51 15000*ci52],'m-');
title('E-W komp. vjetra');
ylabel('Spektar snage');
xlabel('f [1/h]');
xlim([0 0.1665]);
grid on;
set(gca,'MinorGridLineStyle','none');

subplot(2, 2, 4);
semilogy(F1_v(1:length(F1_v)/2+1), PS1_v(1:length(F1_v)/2+1), '-b');
hold on;
semilogy(F2_v(1:length(F2_v)/2+1), PS2_v(1:length(F2_v)/2+1), '-r');
semilogy(F3_v(1:length(F3_v)/2+1), PS3_v(1:length(F3_v)/2+1), '-g');
semilogy(F4_v(1:length(F4_v)/2+1), PS4_v(1:length(F4_v)/2+1), '-y');
semilogy(F5_v(1:length(F5_v)/2+1), PS5_v(1:length(F5_v)/2+1), '-m');
semilogy([0.09 0.15], [15000 15000],'-k');
semilogy([0.105 0.105], [15000*ci11 15000*ci12],'b-');
semilogy([0.115 0.115], [15000*ci21 15000*ci22],'r-');
semilogy([0.125 0.125], [15000*ci31 15000*ci32],'g-');
semilogy([0.135 0.135], [15000*ci41 15000*ci42],'y-');
semilogy([0.145 0.145], [15000*ci51 15000*ci52],'m-');
title('N-S komp. vjetra');
ylabel('Spektar snage');
xlabel('f [1/h]');
xlim([0 0.1665]);
grid on;
set(gca,'MinorGridLineStyle','none');
