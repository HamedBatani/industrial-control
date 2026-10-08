clear; clc; close all;

%load 
data_path = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\RefData.mat';
load(data_path, 'RefSignal', 'RefTime');

v = RefSignal(:);     
t = RefTime(:);        % time vector
T = mean(diff(t));    
N = length(t);          

%I
tau1 = 0.2;  

v1_I = zeros(N,1);
v2_I = zeros(N,1);
v1_I(1) = v(1);

for k = 2:N
    dv_raw = (v(k) - v(k-1)) / T;                       % backward-euler derivative
    v2_I(k) = (tau1*v2_I(k-1) + T*dv_raw) / (tau1 + T);  % low-pass filter on derivative
    v1_I(k) = (tau1*v1_I(k-1) + T*v(k))   / (tau1 + T);  % low-pass filter on the signal
end

%II 
lambda3 = 0.1;   % tuning parameter

v1_II = zeros(N,1);
v2_II = zeros(N,1);
v1_II(1) = v(1);

for k = 1:N-1
    e = v1_II(k) - v(k);
    v1dot = v2_II(k) - e/lambda3;
    v2dot = -2*e/lambda3;
    v1_II(k+1) = v1_II(k) + T*v1dot;   % forward-euler integration
    v2_II(k+1) = v2_II(k) + T*v2dot;
end

%III 
r3 = 50;   % tuning parameter

v1_III = zeros(N,1);
v2_III = zeros(N,1);
v1_III(1) = v(1);

for k = 1:N-1
    v1dot = v2_III(k);
    v2dot = -r3*sign(v1_III(k) - v(k) + v2_III(k)*abs(v2_III(k))/(2*r3));
    v1_III(k+1) = v1_III(k) + T*v1dot;
    v2_III(k+1) = v2_III(k) + T*v2dot;
end

% IV 
r0 = 80;   
h0 = 5*T;   

v1_IV = zeros(N,1);
v2_IV = zeros(N,1);
v1_IV(1) = v(1);

for k = 1:N-1
    x1 = v1_IV(k) - v(k);
    x2 = v2_IV(k);
    u = fhan(x1, x2, r0, h0);   % time-optimal synthesis function
    v1_IV(k+1) = v1_IV(k) + T*x2;
    v2_IV(k+1) = v2_IV(k) + T*u;
end

%plots
fig1 = figure('name','v1 comparison');
plot(t, v, 'color', [0.75 0.75 0.75]); hold on;
plot(t, v1_I,  'linewidth', 1.2);
plot(t, v1_II, 'linewidth', 1.2);
plot(t, v1_III,'linewidth', 1.2);
plot(t, v1_IV, 'linewidth', 1.2);
hold off; grid on;
xlabel('time (s)'); ylabel('v_1(t)');
title('filtered reference signal v_1(t) - comparison of methods');
legend('noisy v(t)', 'I - backward-euler + lpf', 'II - linear td', ...
       'III - nonlinear td (tod)', 'IV - nonlinear td (fhan)', ...
       'location', 'best');


fig2 = figure('name','v2 comparison');
plot(t, v2_I,  'linewidth', 1.2); hold on;
plot(t, v2_II, 'linewidth', 1.2);
plot(t, v2_III,'linewidth', 1.2);
plot(t, v2_IV, 'linewidth', 1.2);
hold off; grid on;
xlabel('time (s)'); ylabel('v_2(t)');
title('derivative estimate v_2(t) - comparison of methods');
legend('I - backward-euler + lpf', 'II - linear td', ...
       'III - nonlinear td (tod)', 'IV - nonlinear td (fhan)', ...
       'location', 'best');

% save
save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q2\a';
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end
saveas(fig1, fullfile(save_dir, 'v1_comparison.png'));
saveas(fig2, fullfile(save_dir, 'v2_comparison.png'));

% local function , fhan
function u = fhan(x1, x2, r, h)
    d  = r*h;
    d0 = h*d;
    y  = x1 + h*x2;
    a0 = sqrt(d^2 + 8*r*abs(y));

    if abs(y) > d0
        a = x2 + (a0 - d)/2 * sign(y);
    else
        a = x2 + y/h;
    end

    if abs(a) > d
        u = -r*sign(a);
    else
        u = -r*a/d;
    end
end