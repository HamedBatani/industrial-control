

clear; clc; close all;

%our tunning paramters 
T_settle = 0.4;   
k_ob     = 4;       

% fixed plant and simulation parameters
K  = 12.5;       
Tp = 0.15;         
b0 = K/Tp;          

dt = 1e-3;            
y_noise_std = 0.03;     

rng(1);   

% derived adrc/eso gains
Kp    = 4/T_settle;
s_CL  = -Kp;
s_ESO = k_ob*s_CL;
l1    = -2*s_ESO;
l2    = s_ESO^2;

% save 
save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q2\b';
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

% part i 
% (eq. 50)
t_end_I = max(2, 6*T_settle);
t_I  = (0:dt:t_end_I)';
v_I  = ones(size(t_I));
lambda_LD = 0.05;   
[~, vdot_I] = lin_td(v_I, dt, lambda_LD);

noise_zero_I = zeros(size(t_I));
noise_I      = y_noise_std*randn(size(t_I));   

y_I_noTD_clean   = simulate_ladrc_notd(v_I, dt, K, Tp, b0, Kp, l1, l2, noise_zero_I);
y_I_withTD_clean = simulate_ladrc_withtd(v_I, vdot_I, dt, K, Tp, b0, Kp, l1, l2, noise_zero_I);

fig_I_a = figure('name', 'part i - step response - no noise');
plot(t_I, v_I, 'k--', t_I, y_I_noTD_clean, t_I, y_I_withTD_clean, 'linewidth', 1.2);
grid on; xlabel('time (s)'); ylabel('y(t)');
title('part i - step response, no measurement noise');
legend('reference', 'without ref. diff. (eq. 13)', 'with ref. diff. (eq. 45)', 'location', 'best');
saveas(fig_I_a, fullfile(save_dir, 'partI_step_noNoise.png'));

y_I_noTD_noisy   = simulate_ladrc_notd(v_I, dt, K, Tp, b0, Kp, l1, l2, noise_I);
y_I_withTD_noisy = simulate_ladrc_withtd(v_I, vdot_I, dt, K, Tp, b0, Kp, l1, l2, noise_I);

fig_I_b = figure('name', 'part i - step response - with noise');
plot(t_I, v_I, 'k--', t_I, y_I_noTD_noisy, t_I, y_I_withTD_noisy, 'linewidth', 1.2);
grid on; xlabel('time (s)'); ylabel('y(t)');
title('part i - step response, with measurement noise');
legend('reference', 'without ref. diff. (eq. 13)', 'with ref. diff. (eq. 45)', 'location', 'best');
saveas(fig_I_b, fullfile(save_dir, 'partI_step_withNoise.png'));

% part ii 
t_end_II = 3;
t_II = (0:dt:t_end_II)';
v_II = sin(2*pi*1*t_II);
[~, vdot_II] = lin_td(v_II, dt, lambda_LD);

noise_zero_II = zeros(size(t_II));
noise_II      = y_noise_std*randn(size(t_II));

y_II_noTD_clean   = simulate_ladrc_notd(v_II, dt, K, Tp, b0, Kp, l1, l2, noise_zero_II);
y_II_withTD_clean = simulate_ladrc_withtd(v_II, vdot_II, dt, K, Tp, b0, Kp, l1, l2, noise_zero_II);

fig_II_a = figure('name', 'part ii - 1 hz response - no noise');
plot(t_II, v_II, 'k--', t_II, y_II_noTD_clean, t_II, y_II_withTD_clean, 'linewidth', 1.2);
grid on; xlabel('time (s)'); ylabel('y(t)');
title('part ii - 1 hz sine response, no measurement noise');
legend('reference', 'without ref. diff. (eq. 13)', 'with ref. diff. (eq. 45)', 'location', 'best');
saveas(fig_II_a, fullfile(save_dir, 'partII_1hz_noNoise.png'));

y_II_noTD_noisy   = simulate_ladrc_notd(v_II, dt, K, Tp, b0, Kp, l1, l2, noise_II);
y_II_withTD_noisy = simulate_ladrc_withtd(v_II, vdot_II, dt, K, Tp, b0, Kp, l1, l2, noise_II);

fig_II_b = figure('name', 'part ii - 1 hz response - with noise');
plot(t_II, v_II, 'k--', t_II, y_II_noTD_noisy, t_II, y_II_withTD_noisy, 'linewidth', 1.2);
grid on; xlabel('time (s)'); ylabel('y(t)');
title('part ii - 1 hz sine response, with measurement noise');
legend('reference', 'without ref. diff. (eq. 13)', 'with ref. diff. (eq. 45)', 'location', 'best');
saveas(fig_II_b, fullfile(save_dir, 'partII_1hz_withNoise.png'));

% part iii 
T_settle_III = 0.05;
Kp_III    = 4/T_settle_III;
s_CL_III  = -Kp_III;
s_ESO_III = k_ob*s_CL_III;
l1_III    = -2*s_ESO_III;
l2_III    = s_ESO_III^2;

r_TOD = 5000;  

t_end_III = 0.6;
t_III = (0:dt:t_end_III)';
v_III = sin(2*pi*10*t_III);
[~, vdot_III] = tod_td(v_III, dt, r_TOD);

noise_zero_III = zeros(size(t_III));
noise_III      = y_noise_std*randn(size(t_III));

y_III_noTD_clean   = simulate_ladrc_notd(v_III, dt, K, Tp, b0, Kp_III, l1_III, l2_III, noise_zero_III);
y_III_withTD_clean = simulate_ladrc_withtd(v_III, vdot_III, dt, K, Tp, b0, Kp_III, l1_III, l2_III, noise_zero_III);

fig_III_a = figure('name', 'part iii - 10 hz response - no noise');
plot(t_III, v_III, 'k--', t_III, y_III_noTD_clean, t_III, y_III_withTD_clean, 'linewidth', 1.2);
grid on; xlabel('time (s)'); ylabel('y(t)');
title('part iii - 10 hz sine response, no measurement noise');
legend('reference', 'without ref. diff. (eq. 13)', 'with ref. diff. (eq. 45)', 'location', 'best');
saveas(fig_III_a, fullfile(save_dir, 'partIII_10hz_noNoise.png'));

y_III_noTD_noisy   = simulate_ladrc_notd(v_III, dt, K, Tp, b0, Kp_III, l1_III, l2_III, noise_III);
y_III_withTD_noisy = simulate_ladrc_withtd(v_III, vdot_III, dt, K, Tp, b0, Kp_III, l1_III, l2_III, noise_III);

fig_III_b = figure('name', 'part iii - 10 hz response - with noise');
plot(t_III, v_III, 'k--', t_III, y_III_noTD_noisy, t_III, y_III_withTD_noisy, 'linewidth', 1.2);
grid on; xlabel('time (s)'); ylabel('y(t)');
title('part iii - 10 hz sine response, with measurement noise');
legend('reference', 'without ref. diff. (eq. 13)', 'with ref. diff. (eq. 45)', 'location', 'best');
saveas(fig_III_b, fullfile(save_dir, 'partIII_10hz_withNoise.png'));

% part iv 
data_path = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\RefData.mat';
load(data_path, 'RefSignal', 'RefTime');

v_raw_IV = RefSignal(:);
t_IV     = RefTime(:);
dt_IV    = mean(diff(t_IV));
lambda_IV = 0.1;                                       % same as in part a
[v1_IV, v2_IV] = lin_td(v_raw_IV, dt_IV, lambda_IV);    

noise_IV = y_noise_std*randn(size(t_IV));

bc_list = [1 0; 1 1; 0.5 1];   
y_IV = zeros(length(t_IV), size(bc_list,1));

for i = 1:size(bc_list,1)
    y_IV(:,i) = simulate_ladrc_bc(v1_IV, v2_IV, dt_IV, K, Tp, b0, Kp, l1, l2, ...
                                   bc_list(i,1), bc_list(i,2), noise_IV);
end

fig_IV = figure('name', 'part iv - refsignal tracking, b,c sweep');
plot(t_IV, v_raw_IV, 'color', [0.8 0.8 0.8]); hold on;
plot(t_IV, y_IV(:,1), 'linewidth', 1.2);
plot(t_IV, y_IV(:,2), 'linewidth', 1.2);
plot(t_IV, y_IV(:,3), 'linewidth', 1.2);
hold off; grid on;
xlabel('time (s)'); ylabel('y(t)');
title('part iv - tracking of refsignal for different (b,c) weights');
legend('noisy reference', ...
       sprintf('b=%.1f, c=%.1f', bc_list(1,1), bc_list(1,2)), ...
       sprintf('b=%.1f, c=%.1f', bc_list(2,1), bc_list(2,2)), ...
       sprintf('b=%.1f, c=%.1f', bc_list(3,1), bc_list(3,2)), ...
       'location', 'best');
saveas(fig_IV, fullfile(save_dir, 'partIV_refsignal_bc_sweep.png'));


function [v1, v2] = lin_td(vin, dt, lambda)
    n = length(vin);
    v1 = zeros(n,1);
    v2 = zeros(n,1);
    v1(1) = vin(1);
    for k = 1:n-1
        e = v1(k) - vin(k);
        v1dot = v2(k) - e/lambda;
        v2dot = -2*e/lambda;
        v1(k+1) = v1(k) + dt*v1dot;
        v2(k+1) = v2(k) + dt*v2dot;
    end
end


function [v1, v2] = tod_td(vin, dt, r)
    n = length(vin);
    v1 = zeros(n,1);
    v2 = zeros(n,1);
    v1(1) = vin(1);
    for k = 1:n-1
        v1dot = v2(k);
        v2dot = -r*sign(v1(k) - vin(k) + v2(k)*abs(v2(k))/(2*r));
        v1(k+1) = v1(k) + dt*v1dot;
        v2(k+1) = v2(k) + dt*v2dot;
    end
end


function y = simulate_ladrc_notd(vp, dt, K, Tp, b0, Kp, l1, l2, noise_seq)
    n  = length(vp);
    y  = zeros(n,1);
    x1 = zeros(n,1);
    x2 = zeros(n,1);
    for k = 1:n-1
        y_meas = y(k) + noise_seq(k);
        u_k = (1/b0)*(Kp*(vp(k) - x1(k)) - x2(k));
        x1dot = -l1*x1(k) + x2(k) + b0*u_k + l1*y_meas;
        x2dot = -l2*x1(k)          + l2*y_meas;
        x1(k+1) = x1(k) + dt*x1dot;
        x2(k+1) = x2(k) + dt*x2dot;
        ydot = (K*u_k - y(k))/Tp;
        y(k+1) = y(k) + dt*ydot;
    end
end


function y = simulate_ladrc_withtd(vp, vdotp, dt, K, Tp, b0, Kp, l1, l2, noise_seq)
    n  = length(vp);
    y  = zeros(n,1);
    x1 = zeros(n,1);
    x2 = zeros(n,1);
    for k = 1:n-1
        y_meas = y(k) + noise_seq(k);
        u_k = (1/b0)*(Kp*(vp(k) - x1(k)) + vdotp(k) - x2(k));
        x1dot = -l1*x1(k) + x2(k) + b0*u_k + l1*y_meas;
        x2dot = -l2*x1(k)          + l2*y_meas;
        x1(k+1) = x1(k) + dt*x1dot;
        x2(k+1) = x2(k) + dt*x2dot;
        ydot = (K*u_k - y(k))/Tp;
        y(k+1) = y(k) + dt*ydot;
    end
end


function y = simulate_ladrc_bc(vp, vdotp, dt, K, Tp, b0, Kp, l1, l2, b, c, noise_seq)
    n  = length(vp);
    y  = zeros(n,1);
    x1 = zeros(n,1);
    x2 = zeros(n,1);
    for k = 1:n-1
        y_meas = y(k) + noise_seq(k);
        u_k = (1/b0)*(Kp*(b*vp(k) - x1(k)) + c*vdotp(k) - x2(k));
        x1dot = -l1*x1(k) + x2(k) + b0*u_k + l1*y_meas;
        x2dot = -l2*x1(k)          + l2*y_meas;
        x1(k+1) = x1(k) + dt*x1dot;
        x2(k+1) = x2(k) + dt*x2dot;
        ydot = (K*u_k - y(k))/Tp;
        y(k+1) = y(k) + dt*ydot;
    end
end