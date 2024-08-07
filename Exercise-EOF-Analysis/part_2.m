close all; clear all;

load 'LAMI_ECMWF_data.mat'
m = 30; % Number of stations

% Collect and detrend data
for i = 1:m
    %data(i,:) = detrend(t2mL(:,i), 'constant')'; % Temperature
    data(i,:) = detrend(u10mL(:,i), 'constant')'; % E-component of wind
end

% SVD
[U S V] = svd(data, 'econ');
% EOF coef.
Coef = S*V.';

% EOF spectre
n = length(data);
Esp = 1/n * S.^2;
Esp_norm = Esp/sum(Esp);

% Principal component
Pcomp = Coef(1, :);

% N rule
N = 1000;
for i = 1:N
    pom = randn(m,n);
    [U_pom S_pom V_pom] = svd(pom, 'econ');
    if i==1
        S_randn = diag(1/n * S_pom.^2);
    else
        S_randn = [S_randn diag(1/n * S_pom.^2)];
    end
end
% 95% percentile
S_95 = prctile(S_randn', 95);
S_95_norm = S_95/sum(S_95);

% Plotting histograms
figure;
subplot(2,2,1);
hist(S_randn(1, :));
title('1. svojstvena vrijednost');
xlabel('Svojstvena vrijednost');
ylabel('Apsolutne cestine');

subplot(2,2,2);
hist(S_randn(5, :));
title('5. svojstvena vrijednost');
xlabel('Svojstvena vrijednost');
ylabel('Apsolutne cestine');

subplot(2,2,3);
hist(S_randn(10, :));
title('10. svojstvena vrijednost');
xlabel('Svojstvena vrijednost');
ylabel('Apsolutne cestine');

subplot(2,2,4);
hist(S_randn(15, :));
title('15. svojstvena vrijednost');
xlabel('Svojstvena vrijednost');
ylabel('Apsolutne cestine');

% Plotting results
figure;
subplot(3,1,1);
plot(Esp_norm, '-*b');
hold on;
plot(S_95_norm, '-xr');
plot([0 m], [1/m 1/m], '--k');
ylim([-0.1 1]);
ylabel('Postotak varijance');
xlabel('Mod');
legend('EOF spektar', '95. percentil MC simulacija','1/m');

subplot(3,1,2);
plot(U(:,1), '-r');
hold on;
plot(U(:,2), '-m');
plot(U(:,3), '-c');
ylabel('EOF');
xlabel('Redni broj postaje');
legend('1. EOF', '2. EOF','3. EOF');

subplot(3,1,3);
plot(Pcomp, '-k');
%ylabel('Amplituda (^o C)');
ylabel('Amplituda (m/s)');
xlabel('Vrijeme');
legend('Glavna komponenta');

% Initial and reconstruted data for station Rijeka (3)
%data_EOF = Coef(1,:) * U(3,1); % Temperature
data_EOF = Coef(1,:) * U(3,1) + Coef(2,:) * U(3,2); % E-component of wind

% Plot data and EOF data
figure;
subplot(2,1,1);
plot(data(3, 1:500),'-k');
hold on;
plot(data_EOF(1:500),'-r')
%ylabel('Amplituda (^o C)');
ylabel('Amplituda (m/s)');
xlabel('Vrijeme');
legend('Izvorni niz','Rekonstruirani niz');

subplot(2,1,2);
plot(data(3, 1:500)-data_EOF(1:500),'-b');
%ylabel('Amplituda (^o C)');
ylabel('Amplituda (m/s)');
xlabel('Vrijeme');
legend('Razlika');

% Plot initial data for all stations
figure;
for i = 1:m
    if i==3
        plot(data(i,:)+25*(i-1), '-r');
        hold on;
    else
        plot(data(i,:)+25*(i-1), '-b');
        hold on;
    end
end
%title('Izvorni nizovi anomalija temperature');
title('Izvorni nizovi anomalija E-komponente vjetra');
xlim([0 2750]);
ylim([-25 750]);
