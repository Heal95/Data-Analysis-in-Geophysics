close all; clear all;

load my_data.mat

% Problems with NaN values, so changing them to zeroes
uE(isnan(uE)) = 0;
vE(isnan(vE)) = 0;

% Plotting histograms
figure;
subplot(2,2,1);
hist(uL);
title('E-komponenta vjetra (LAMI)');
xlabel('Brzina vjetra [m/s]');
ylabel('Apsolutne cestine');

subplot(2,2,2);
hist(vL);
title('N-komponenta vjetra (LAMI)');
xlabel('Brzina vjetra [m/s]');
ylabel('Apsolutne cestine');

subplot(2,2,3);
hist(uE);
title('E-komponenta vjetra (ECMWF)');
xlabel('Brzina vjetra [m/s]');
ylabel('Apsolutne cestine');

subplot(2,2,4);
hist(vE);
title('N-komponenta vjetra (ECMWF)');
xlabel('Brzina vjetra [m/s]');
ylabel('Apsolutne cestine');

% Matrix for EOF
XL(1,:) = (uL)'; XL(2,:) = (vL)';
XE(1,:) = (uE)'; XE(2,:) = (vE)';

% SVD
[UL SL VL] = svd(XL, 'econ');
[UE SE VE] = svd(XE, 'econ');

% Main axes of the wind
alphaL = atan2(UL(1,1), UL(2,1));
alphaE = atan2(UE(1,1), UE(2,1));

% Scatter plot
figure;
subplot(1,2,1);
scatter(uL, vL, 'xr');
hold on;
title('LAMI');
plot([mean(uL)-15 mean(uL)+15], [mean(vL)+15/tan(pi+alphaL) mean(vL)-15/tan(pi+alphaL)], '--k', 'linewidth', 2);
plot([mean(uL)+15 mean(uL)-15], [mean(vL)+15*tan(pi+alphaL) mean(vL)-15*tan(pi+alphaL)], '--k', 'linewidth', 2);
xlim([-18 18]);
ylim([-18 18]);
xlabel('u [m/s]');
ylabel('v [m/s]');

subplot(1,2,2);
scatter(uE, vE, 'xr');
hold on;
title('ECMWF');
plot([mean(uE)-10 mean(uE)+10], [mean(vE)+10/tan(alphaE) mean(vE)-10*tan(alphaE)], '--k', 'linewidth', 2);
plot([mean(uE)+10 mean(uE)-10], [mean(vE)+10*tan(alphaE) mean(vE)-10*tan(alphaE)], '--k', 'linewidth', 2);
xlim([-18 18]);
ylim([-18 18]);
xlabel('u [m/s]');
ylabel('v [m/s]');

% Rotate data in main axes coordinate system
uL1 = uL.*cos(pi/2-alphaL) + vL.*sin(pi/2-alphaL);
vL1 = -uL.*sin(pi/2-alphaL) + vL.*cos(pi/2-alphaL);
uE1 = uE.*cos(pi/2-alphaE) + vE.*sin(pi/2-alphaE);
vE1 = -uE.*sin(pi/2-alphaE) + vE.*cos(pi/2-alphaE);

% MSQ velocities
pom = length(uL);
uL_MSQ = sum(uL.^2)/pom; vL_MSQ = sum(vL.^2)/pom;
uE_MSQ = sum(uE.^2)/pom; vE_MSQ = sum(vE.^2)/pom;

uL1_MSQ = sum(uL1.^2)/pom; vL1_MSQ = sum(vL1.^2)/pom;
uE1_MSQ = sum(uE1.^2)/pom; vE1_MSQ = sum(vE1.^2)/pom;

% Calculate energy to determine wheater it depends on cs
EnL = sum(uL.^2 + vL.^2)/2; EnE = sum(uE.^2 + vE.^2)/2;
EnL1 = sum(uL1.^2 + vL1.^2)/2; EnE1 = sum(uE1.^2 + vE1.^2)/2;
EnL_diff = EnL1 - EnL; EnE_diff = EnE1 - EnE;

% Plotting results
figure;
subplot(4,1,1);
plot(uL1(1:1000), '-k', 'linewidth', 1.5);
hold on;
plot(uL(1:1000), '-r', 'linewidth', 1.5);
legend('sustav glavnih osi', 'izvorni niz');
title('LAMI');
ylabel('u (m/s)');

subplot(4,1,2);
plot(vL1(1:1000), '-k', 'linewidth', 1.5);
hold on;
plot(vL(1:1000), '-r', 'linewidth', 1.5);
ylabel('v (m/s)');

subplot(4,1,3);
plot(uE1(1:1000), '-k', 'linewidth', 1.5);
hold on;
plot(uE(1:1000), '-r', 'linewidth', 1.5);
title('ECMWF');
ylabel('u (m/s)');

subplot(4,1,4);
plot(vE1(1:1000), '-k', 'linewidth', 1.5);
hold on;
plot(vE(1:1000), '-r', 'linewidth', 1.5);
ylabel('v (m/s)');
xlabel('Vrijeme [h]');

% Repeat for variability of the wind
% Matrix for EOF
uL_d = detrend(uL); vL_d = detrend(vL);
uE_d = detrend(uE); vE_d = detrend(vE);

XL_d(1,:) = (uL_d)'; XL_d(2,:) = (vL_d)';
XE_d(1,:) = (uE_d)'; XE_d(2,:) = (vE_d)';

% SVD
[UL_d SL_d VL_d] = svd(XL_d, 'econ');
[UE_d SE_d VE_d] = svd(XE_d, 'econ');

% Main axes of the wind
alphaL_d = atan2(UL_d(1,1), UL_d(2,1));
alphaE_d = atan2(UE_d(1,1), UE_d(2,1));

% Axes lengths
aL = 1/pom*(SL_d(1,1).^2); bL = 1/pom*(SL_d(2,2).^2);
aE = 1/pom*(SE_d(1,1).^2); bE = 1/pom*(SE_d(2,2).^2);

% Standard deviation elipse
t = linspace(0,2*pi,1000);
xL = aL * cos(t) * cos(alphaL_d) - bL * sin(t) * sin(alphaL_d);
yL = aL * cos(t) * sin(alphaL_d) + bL * sin(t) * cos(alphaL_d);
xE = aE * cos(t) * cos(alphaE_d) - bE * sin(t) * sin(alphaE_d);
yE = aE * cos(t) * sin(alphaE_d) + bE * sin(t) * cos(alphaE_d);

% Plotting results
figure;
subplot(1,2,1);
scatter(uL_d, vL_d, 'xr');
hold on;
title('LAMI');
plot(xL, yL, '-k', 'linewidth', 2);
plot([mean(uL_d)-15 mean(uL_d)+15], [mean(vL_d)+15/tan(pi+alphaL_d) mean(vL_d)-15/tan(pi+alphaL_d)], '--k', 'linewidth', 2);
plot([mean(uL_d)+15 mean(uL_d)-15], [mean(vL_d)+15*tan(pi+alphaL_d) mean(vL_d)-15*tan(pi+alphaL_d)], '--k', 'linewidth', 2);
xlim([-18 18]);
ylim([-18 18]);
xlabel('u [m/s]');
ylabel('v [m/s]');

subplot(1,2,2);
scatter(uE_d, vE_d, 'xr');
hold on;
title('ECMWF');
plot(xE, yE, '-k', 'linewidth', 2);
plot([mean(uE_d)-15 mean(uE_d)+15], [mean(vE_d)+15/tan(pi+alphaE_d) mean(vE_d)-15/tan(pi+alphaE_d)], '--k', 'linewidth', 2);
plot([mean(uE_d)+15 mean(uE_d)-15], [mean(vE_d)+15*tan(pi+alphaE_d) mean(vE_d)-15*tan(pi+alphaE_d)], '--k', 'linewidth', 2);
xlim([-18 18]);
ylim([-18 18]);
xlabel('u [m/s]');
ylabel('v [m/s]');















