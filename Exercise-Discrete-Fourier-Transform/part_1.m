close all; clear all;

% Defining parameters
a = 10;
T = 500;
dt = 0.001;

% Defining function
t = [-a:dt:a-dt];
Fdef = (t.*t)/(a*a)-1; % Non-zero values

t = [-T:dt:T-dt]; % Whole interval of interest
n1 = size(t, 2);
n2 = size(Fdef, 2);
F = [zeros(1, (n1-n2)/2) Fdef zeros(1, (n1-n2)/2)]; % Complete function

% Sample intervals
dt_list = [5 2.5 1.25 0.625 0.3125];

% Define and plot function using different sample intervals
figure;
colors = ['b' 'r' 'g' 'y' 'm' 'c'];
for i = length(dt_list):-1:1
    ts = [-a:dt_list(i):a-dt];
	Fsdef = (ts.*ts)/(a*a)-1; % Non-zero values
    
	ts = [-T:dt_list(i):T-dt]; % Whole interval of interest
	n1s = size(ts, 2);
	n2s = size(Fsdef, 2);
	Fs = [zeros(1, (n1s-n2s)/2) Fsdef zeros(1, (n1s-n2s)/2)]; % Complete function
	
	subplot(length(dt_list), 1, i);
	plot(t, F, '-k');
	hold on;
	plot(ts(1:size(Fs, 2)), Fs, 'x', 'color', colors(i));
	title(['dT = ' num2str(dt_list(i))]);
	xlim([-30,30]);
    grid on;
	if (i == length(dt_list))
		xlabel('t');
    end
end

% Define and plot CFT and DFT of the function
figure;
for i = length(dt_list):-1:1
	ts = [-a:dt_list(i):a-dt];
	Fsdef = (ts.*ts)/(a*a)-1; % Non-zero values
	
    ts = [-T:dt_list(i):T-dt]; % Whole interval of interest
	n1s = size(ts, 2);
	n2s = size(Fsdef, 2);
	Fs = [zeros(1, (n1s-n2s)/2) Fsdef zeros(1, (n1s-n2s)/2)]; % Complete function

	% DFT using fft_zp function
	DFT = dt_list(i) * fft_zp(Fs');
	ndft = -1 / (2 * dt_list(i)) : 1 / (length(ts) * dt_list(i)) : 1 / (2 * dt_list(i));

    % CFT
	if (i == length(dt_list))
		ncft = [-10:0.001:10]; 
		x = 2*pi*ncft;
		CFT = 8 * (a*x.*cos(a*x) - sin(a*x)) ./ (a*a*((x).^3));
		plot(ncft, CFT, '-k')
		hold on;
		legend('F(f)');
        grid on;
	end

	plot(ndft(1:end-1), real(DFT), '-x', 'color', colors(i));
	hold on;
	xlim([-1.0 1.0]);
    grid on;
end
legend('CFT','DFT, dT = 0.3125','DFT, dT = 0.625', 'DFT, dT = 1.25','DFT, dT = 2.5', 'DFT, dT = 5.0');
xlabel('f');
ylabel('FT');

% Define and plot function multiplied with cos(2*pi*b*t) using different sample intervals
b = 0.5;
F1 = F .* cos(2*pi*b*t);
figure;
for i = length(dt_list):-1:1
	ts = [-a:dt_list(i):a-dt];
	F1sdef = ((ts.*ts)/(a*a)-1) .* cos(2*pi*b*ts); % Non-zero values
	
    ts = [-T:dt_list(i):T-dt]; % Whole interval of interest
	n1s = size(ts, 2);
	n2s = size(F1sdef, 2);
	F1s = [zeros(1, (n1s-n2s)/2) F1sdef zeros(1, (n1s-n2s)/2)]; % Complete function
	
	subplot(length(dt_list), 1, i);
	plot(t, F1, '-k');
	hold on;
	plot(ts, F1s, 'x', 'color', colors(i));
	title(['dT = ' num2str(dt_list(i))]);
	xlim([-20,20]);
    grid on;
	if (i == length(dt_list))
		xlabel('t');
    end
end

% Define and plot CFT and DFT of the function multiplied with cos(2*pi*b*t)
figure;
for i = length(dt_list):-1:1
	ts = [-a:dt_list(i):a-dt];
	F1sdef = ((ts.*ts)/(a*a)-1) .* cos(2*pi*b*ts); % Non-zero values
    
	ts = [-T:dt_list(i):T-dt]; % Whole interval of interest
	n1s = size(ts, 2);
	n2s = size(F1sdef, 2);
	F1s = [zeros(1, (n1s-n2s)/2) F1sdef zeros(1, (n1s-n2s)/2)]; % Complete function

	% DFT using fft_zp function
	DFT1 = dt_list(i) * fft_zp(F1s');
	ndft1 = -1 / (2 * dt_list(i)) : 1 / (length(ts) * dt_list(i)) : 1 / (2 * dt_list(i));

    % CFT
	if (i == length(dt_list))
		ncft1 = [-10:0.001:10];
		x1 = 2*pi*(ncft1 - b);
		x2 = 2*pi*(ncft1 + b);
		CFT1 = 0.5 * (8*(a*x1.*cos(a*x1) - sin(a*x1)) ./ (a*a*((x1).^3)) + 8*(a*x2.*cos(a*x2) - sin(a*x2)) ./ (a*a*((x2).^3)));
		plot(ncft1, CFT1, '-k')
		hold on;
	end

	plot(ndft1(1:end-1), real(DFT1), '-x', 'color', colors(i));
	hold on;
	xlim([-1.0 1.0]);
	grid on;
end
legend('CFT','DFT, dT = 0.3125','DFT, dT = 0.625', 'DFT, dT = 1.25','DFT, dT = 2.5', 'DFT, dT = 5.0');
xlabel('f');
ylabel('FT');

