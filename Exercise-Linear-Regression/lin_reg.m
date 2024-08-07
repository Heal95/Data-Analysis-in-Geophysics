close all; clear all;

load my_data.mat

% \ method
a1_t_LAMI = t_LAMI(:,2:end) \ t_LAMI(:,1);
x1_t_LAMI = t_LAMI(:,2:end) * a1_t_LAMI;

a1_t_ECMWF = t_ECMWF(:,2:end) \ t_ECMWF(:,1);
x1_t_ECMWF = t_ECMWF(:,2:end) * a1_t_ECMWF;

a1_v_LAMI = v_LAMI(:,2:end) \ v_LAMI(:,1);
x1_v_LAMI = v_LAMI(:,2:end) * a1_v_LAMI;

a1_v_ECMWF = v_ECMWF(:,2:end) \ v_ECMWF(:,1);
x1_v_ECMWF = v_ECMWF(:,2:end) * a1_v_ECMWF;

% normal equations
a2_t_LAMI = (t_LAMI(:,2:end).' * t_LAMI(:,2:end))^(-1) * (t_LAMI(:,2:end).' * t_LAMI(:,1));
x2_t_LAMI = t_LAMI(:,2:end) * a2_t_LAMI;

a2_t_ECMWF = (t_ECMWF(:,2:end).' * t_ECMWF(:,2:end))^(-1) * (t_ECMWF(:,2:end).' * t_ECMWF(:,1));
x2_t_ECMWF = t_ECMWF(:,2:end) * a2_t_ECMWF;

a2_v_LAMI = (v_LAMI(:,2:end).' * v_LAMI(:,2:end))^(-1) * (v_LAMI(:,2:end).' * v_LAMI(:,1));
x2_v_LAMI = v_LAMI(:,2:end) * a2_v_LAMI;

a2_v_ECMWF = (v_ECMWF(:,2:end).' * v_ECMWF(:,2:end))^(-1) * (v_ECMWF(:,2:end).' * v_ECMWF(:,1));
x2_v_ECMWF = v_ECMWF(:,2:end) * a2_v_ECMWF;


% SVD method
[a3_t_LAMI x3_t_LAMI u_t_LAMI s_t_LAMI v_t_LAMI] = svd_lin(t_LAMI(:,2:end), t_LAMI(:,1));
[a3_t_ECMWF x3_t_ECMWF u_t_ECMWF s_t_ECMWF v_t_ECMWF] = svd_lin(t_ECMWF(:,2:end), t_ECMWF(:,1));
[a3_v_LAMI x3_v_LAMI u_v_LAMI s_v_LAMI v_v_LAMI] = svd_lin(v_LAMI(:,2:end), v_LAMI(:,1));
[a3_v_ECMWF x3_v_ECMWF u_v_ECMWF s_v_ECMWF v_v_ECMWF] = svd_lin(v_ECMWF(:,2:end), v_ECMWF(:,1));

% for plots
x_t_LAMI = [x1_t_LAMI x2_t_LAMI x3_t_LAMI];
x_t_ECMWF = [x1_t_ECMWF x2_t_ECMWF x3_t_ECMWF];
x_v_LAMI = [x1_v_LAMI x2_v_LAMI x3_v_LAMI];
x_v_ECMWF = [x1_v_ECMWF x2_v_ECMWF x3_v_ECMWF];

% plotting data
figure;
subplot(4,1,1);
plot(t_LAMI(:,1), 'k');
hold on;
plot(x_t_LAMI(:,1));
hold on;
plot(x_t_LAMI(:,2));
hold on;
plot(x_t_LAMI(:,3));
ylabel('t2mL [^o C]');
legend('model', '\ method', 'normal eq.', 'SVD method');

subplot(4,1,2);
plot(t_ECMWF(:,1), 'k');
hold on;
plot(x_t_ECMWF(:,1));
hold on;
plot(x_t_ECMWF(:,2));
hold on;
plot(x_t_ECMWF(:,3));
ylabel('t2mE [^o C]');

subplot(4,1,3)
plot(v_LAMI(:,1), 'k');
hold on;
plot(x_v_LAMI(:,1));
hold on;
plot(x_v_LAMI(:,2));
hold on;
plot(x_v_LAMI(:,3));
ylabel('v10mL [m/s]');

subplot(4,1,4)
plot(v_ECMWF(:,1), '-k');
hold on;
plot(x_v_ECMWF(:,1));
hold on;
plot(x_v_ECMWF(:,2));
hold on;
plot(x_v_ECMWF(:,3));
ylabel('v10mE [m/s]');

% regression errors
for i = 1:3
    err_t_LAMI(:,i) = t_LAMI(:,1)-x_t_LAMI(:,i);
    err_t_ECMWF(:,i) = t_ECMWF(:,1)-x_t_ECMWF(:,i);
    err_v_LAMI(:,i) = v_LAMI(:,1)-x_v_LAMI(:,i);
    err_v_ECMWF(:,i) = v_ECMWF(:,1)-x_v_ECMWF(:,i);
end

% histogram plots
figure;
subplot(2,2,1);
histogram(err_t_LAMI(:,1), 'normalization', 'probability');
hold on;
histogram(err_t_LAMI(:,2), 'normalization', 'probability');
hold on;
histogram(err_t_LAMI(:,3), 'normalization', 'probability');
title('t2mL');

subplot(2,2,2);
histogram(err_t_ECMWF(:,1), 'normalization', 'probability');
hold on;
histogram(err_t_ECMWF(:,2), 'normalization', 'probability');
hold on;
histogram(err_t_ECMWF(:,3), 'normalization', 'probability');
legend('\ method', 'normal eq.', 'SVD method');
title('t2mE');

subplot(2,2,3);
histogram(err_v_LAMI(:,1), 'normalization', 'probability');
hold on;
histogram(err_v_LAMI(:,2), 'normalization', 'probability');
hold on;
histogram(err_v_LAMI(:,3), 'normalization', 'probability');
title('v10mL');
	
subplot(2,2,4);
histogram(err_v_ECMWF(:,1), 'normalization', 'probability');
hold on;
histogram(err_v_ECMWF(:,2), 'normalization', 'probability');
hold on;
histogram(err_v_ECMWF(:,3), 'normalization', 'probability');
title('v10mE');

% singular values
s1 = (s_t_LAMI.^2/sum(s_t_LAMI.^2)) * 100;
s2 = (s_t_ECMWF.^2/sum(s_t_ECMWF.^2)) * 100;
s3 = (s_v_LAMI.^2/sum(s_v_LAMI.^2)) * 100;
s4 = (s_v_ECMWF.^2/sum(s_v_ECMWF.^2)) * 100;

% plotting data
figure;
plot(s1);
hold on;
plot(s2);
plot(s3);
plot(s4);
legend('t2mL', 't2mE', 'v10mL', 'v10mE');

u_t = u_t_LAMI.';
u_v = u_v_LAMI.';
s_t = diag(1./s_t_LAMI);
s_v = diag(1./s_v_LAMI);

% 'cumulative' SVD
for i = 1:5
	a_t_LAMI(:,i) = v_t_LAMI(:,1:i)*((s_t(1:i,1:i)))*(u_t(1:i,:))*t_LAMI(:,1);
	x_t_LAMI(:,i) = t_LAMI(:,2:end)*a_t_LAMI(:,i);
	k_t(i) = (corr(t_LAMI(:,1),x_t_LAMI(:,i))).^2;

	a_v_LAMI(:,i) = v_v_LAMI(:,1:i)*(s_v(1:i,1:i))*(u_v(1:i,:))*v_LAMI(:,1);
	x_v_LAMI(:,i) = v_LAMI(:, 2:end)*a_v_LAMI(:,i);
	k_v(i) = (corr(v_LAMI(:,1),x_v_LAMI(:,i))).^2;
end

% plots
% temperature
figure;
for i = 1:5
	plot(a_t_LAMI(:,i), 'o-');
	hold on;
end
legend('1','2','3','4','5');
title('t2mL');

% v-component
figure;
for i = 1:5
	plot(a_v_LAMI(:,i), 'o-');
	hold on;
end
legend('1','2','3','4','5');
title('v10mL');

figure;
plot(k_t, 'o-');
hold on;
plot(k_v, 'o-');
legend('t2mL', 'v10mL');

% function for SVD method
function [A x U S V] = svd_lin(X, Y)
	[U S V] = svd(X);
	A = V*1/S*U.'*Y;
	x = X*A;
	k = min(size(S));
	S = diag(S(1:k, 1:k));
return
end