close all; clear all;

% Load LP filter data
LPF = load('LP_filter.txt');
lp_filt = LPF(:, 2);

% Load data
load f_07.txt
NE = f_07(:, 6);
NW = f_07(:, 5);

nfft = 2047;
dt = 1;
m = (nfft+1)/2;

% LP filter transfer function
n1 = 49;
h1 = [lp_filt; zeros(nfft - (2*n1-1), 1); lp_filt(n1:-1:2)]; 
H1 = fft(h1);
ph1 = 180/pi*(atan2(abs(imag(H1)),abs(real(H1))));
ph1(ph1<-165) = ph1(ph1<-175) + 360;

% Moving average transfer function
n2 = 24; 
h2 = [ones(n2,1); zeros(m-2*n2,1); ones(n2,1)]/(2*n2);
H2 = fft(h2);
ph2 = 180/pi*(atan2(abs(imag(H2)),abs(real(H2))));
ph2(ph2<-165) = ph2(ph2<-175) + 360;

n = 0 : 1/m : (m-1)*1/(m);

% Plot tranfer functions
figure;
subplot(2,2,1);
plot(n, real(H1(1:m)), 'k-');
hold on;
plot(n, real(H2(1:m)), 'r-');
xlabel('f [Hz]');
ylabel('Real(H)');
plot(1/12, 0, 'db');
plot(1/17, 0, 'dr');
plot(1/24, 0, 'dm');
xlim([0 0.5]);
legend('LP filter','Klizni srednjak','1/12','1/17','1/24');
grid on;

subplot(2,2,2);
plot(n, imag(H1(1:m)), 'k-');
hold on;
plot(n, imag(H2(1:m)), 'r-');
xlabel('f [Hz]');
ylabel('Imag(H)');
xlim([0 0.5]);
grid on;

subplot(2,2,3);
plot(n, abs(H1(1:m)), 'k-');
hold on;
plot(n, abs(H2(1:m)), 'r-');
xlabel('f [Hz]');
ylabel('Amplituda');
plot(1/12, 0, 'db');
plot(1/17, 0, 'dr');
plot(1/24, 0, 'dm');
xlim([0 0.5]);
grid on;

subplot(2,2,4);
plot(n, ph1(1:m), 'k-');
hold on;
plot(n, ph2(1:m), 'r-');
xlabel('f [Hz]');
ylabel('Faza');
xlim([0 0.5]);
grid on;

% LP filter data
NE1 = filt_fir(NE, [lp_filt(n1:-1:2); lp_filt]);
NW1 = filt_fir(NW, [lp_filt(n1:-1:2); lp_filt]);

% Moving average filter data
NE2 = filt_fir(NE, ones(2*n2, 1)/(2*n2));
NW2 = filt_fir(NW, ones(2*n2, 1)/(2*n2));

% Plot filtered data
figure;
subplot(2, 1, 1);
plot(NE, '-k');
hold on;
plot(NE1, '-b');
plot(NE2, '-r');
grid on;
legend('Podatci','LP filtrirani','Klizni srednjak');
title('NE komponenta');
ylabel('Amplituda');
xlabel('Vrijeme');

subplot(2, 1, 2);
plot(NW, '-k');
hold on;
plot(NW1, '-b');
plot(NW2, '-r');
grid on;
title('NW komponenta');
ylabel('Amplituda');
xlabel('Vrijeme');

% Plot difference between filtered data
figure;
subplot(2,1,1);
plot(NE1-NE2);
grid on;
legend('Razlika LP filtra i kliznog srednjaka');
title('NE komponenta');
ylabel('Amplituda');
xlabel('Vrijeme');

subplot(2,1,2);
plot(NW1-NW2);
grid on;
title('NW komponenta');
ylabel('Amplituda');
xlabel('Vrijeme');

% Periodgrams
PNE = abs(fft(NE)); % Raw data
PNE1 = abs(fft(NE1(49:744))); % LP filter
PNE2 = abs(fft(NE2(49:744))); % Moving average

PNW = abs(fft(NW)); % Raw data
PNW1 = abs(fft(NW1(49:744))); % LP filter
PNW2 = abs(fft(NW2(49:744))); % Moving average

pn = length(PNE);
pn1 = length(PNE1);
pn2 = length(PNE2);

x = 0 : 1/pn : (pn-1)*1/(pn);
x1 = 0 : 1/pn1 : (pn1-1)*1/(pn1);
x2 = 0 : 1/pn2 : (pn2-1)*1/(pn2);

% Plot periodgrams
figure;
subplot(2,1,1);
plot(x(1:pn/2), PNE(1:pn/2), '-k');
hold on;
plot(x1(1,1:pn1/2), PNE1(1:pn1/2), '-b');
plot(x2(1:pn2/2), PNE2(1:pn2/2), '-r');
plot(1/12, 0, 'db');
plot(1/17, 0, 'dr');
plot(1/24, 0, 'dm');
plot([1/12, 1/12], [0 3000], '--b');
plot([1/17, 1/17], [0 3000], '--r');
plot([1/24, 1/24], [0 3000], '--m');
ylabel('|H| [m/s]');
xlabel('f [Hz]');
title('Periodogram NE komponente');
xlim([0 0.25]);
ylim([0 3000]);
grid on;
legend('Podatci','LP filtrirani','Klizni srednjak','1/12','1/17','1/24');

subplot(2,1,2);
plot(x(1:pn/2), PNW(1:pn/2), '-k');
hold on;
plot(x1(1,1:pn1/2), PNW1(1:pn1/2), '-b');
plot(x2(1:pn2/2), PNW2(1:pn2/2), '-r');
plot(1/12, 0, 'db');
plot(1/17, 0, 'dr');
plot(1/24, 0, 'dm');
plot([1/12, 1/12], [0 2200], '--b');
plot([1/17, 1/17], [0 2200], '--r');
plot([1/24, 1/24], [0 2200], '--m');
ylabel('|H| [m/s]');
xlabel('f [Hz]');
title('Periodogram NW komponente');
xlim([0 0.25]);
ylim([0 2200]);
grid on;

% Decimating data
for i = 1:length(NE)/24
	NEd(i) = mean(NE(i*24-23:i*24));
	NWd(i) = mean(NW(i*24-23:i*24));
end

% LP filter
NE1d = NE1(24:24:end);
NW1d = NW1(24:24:end);

% Moving average
NE2d = NE2(24:24:end);
NW2d = NW2(24:24:end);

% Periodgrams of decimated data
PNEd = abs(fft(NEd)); % Raw data 
PNE1d = abs(fft(NE1d(3:end-2))); % LP filter
PNE2d = abs(fft(NE2d(2:end-1))); % Moving average

PNWd = abs(fft(NWd)); % Raw data
PNW1d = abs(fft(NW1d(3:end-2))); % LP filter
PNW2d = abs(fft(NW2d(2:end-1))); % Moving average

pnd = length(PNEd);
pn1d = length(PNE1d);
pn2d = length(PNE2d);

xd = 0 : 1/(pnd) : (pnd-1)*1/(pnd);
x1d = 0 : 1/(pn1d) : (pn1d-1)*1/(pn1d);
x2d = 0 : 1/(pn2d) : (pn2d-1)*1/(pn2d);

% Plot periodgrams of decimated data
figure;
subplot(2,1,1);
plot(xd(1:pnd/2), PNEd(1:pnd/2), '-k');
hold on;
plot(x1d(1:pn1d/2), PNE1d(1:pn1d/2), '-b');
plot(x2d(1:pn2d/2), PNE2d(1:pn2d/2), '-r');
plot(1/12, 0, 'db');
plot(1/17, 0, 'dr');
plot(1/24, 0, 'dm');
plot([1/12, 1/12], [0 150], '--b');
plot([1/17, 1/17], [0 150], '--r');
plot([1/24, 1/24], [0 150], '--m');
ylabel('|H| [m/s]');
xlabel('f [Hz]');
title('Periodogram decimirane NE komponente');
xlim([0 0.45]);
ylim([0 140]);
grid on;
legend('Podatci','LP filtrirani','Klizni srednjak','1/12','1/17','1/24');

subplot(2,1,2);
plot(xd(1:pnd/2), PNWd(1:pnd/2), '-k');
hold on;
plot(x1d(1:pn1d/2), PNW1d(1:pn1d/2), '-b');
plot(x2d(1:pn2d/2), PNW2d(1:pn2d/2), '-r');
plot(1/12, 0, 'db');
plot(1/17, 0, 'dr');
plot(1/24, 0, 'dm');
plot([1/12, 1/12], [0 60], '--b');
plot([1/17, 1/17], [0 60], '--r');
plot([1/24, 1/24], [0 60], '--m');
ylabel('|H| [m/s]');
xlabel('f [Hz]');
title('Periodogram decimirane NW komponente');
xlim([0 0.45]);
ylim([0 50]);
grid on;