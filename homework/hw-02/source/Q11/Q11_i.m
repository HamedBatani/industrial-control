
clear; clc; close all;


s = tf('s');

K_nom = 2;
tau1_nom = 4;
tau2_nom = 3;
theta_nom = 0.3;


G_nom = K_nom / ((tau1_nom*s + 1)*(tau2_nom*s + 1));
G_nom.InputDelay = theta_nom;

Kp = 0.9381;
Ki = 0.1535;
Kd = 0.2019;
C = pid(Kp, Ki, Kd);


T_nom = feedback(C * G_nom, 1);


S_info = stepinfo(T_nom);
fprintf('Rise Time:      %.4f seconds\n', S_info.RiseTime);
fprintf('Settling Time:  %.4f seconds\n', S_info.SettlingTime);
fprintf('Overshoot:      %.4f %%\n\n', S_info.Overshoot);
T_dist = feedback(G_nom, C);

t_sim = 0:0.01:40;


r = ones(size(t_sim));


d = zeros(size(t_sim));
d(t_sim >= 10) = 0.5;


y_ref = lsim(T_nom, r, t_sim);
y_dist = lsim(T_dist, d, t_sim);
y_total = y_ref + y_dist; 

figure('Name', 'Disturbance Rejection');
plot(t_sim, y_total, 'b', 'LineWidth', 1.5);
hold on;
plot(t_sim, r, 'k--', 'LineWidth', 1);
xline(10, 'r--', 'Disturbance Applied');
grid on;
title('System Response to Unit Reference and Disturbance at t=10s');
xlabel('Time [s]');
ylabel('Amplitude (y)');
legend('System Output', 'Reference', 'Location', 'best');


tau1_plus = tau1_nom * 1.20;
tau2_plus = tau2_nom * 1.20;
theta_plus = theta_nom * 1.20;
G_plus = K_nom / ((tau1_plus*s + 1)*(tau2_plus*s + 1));
G_plus.InputDelay = theta_plus;
T_plus = feedback(C * G_plus, 1);


tau1_minus = tau1_nom * 0.80;
tau2_minus = tau2_nom * 0.80;
theta_minus = theta_nom * 0.80;
G_minus = K_nom / ((tau1_minus*s + 1)*(tau2_minus*s + 1));
G_minus.InputDelay = theta_minus;
T_minus = feedback(C * G_minus, 1);

figure('Name', 'Sensitivity to Parameter Variations');
step(T_nom, 'b', 30); hold on;
step(T_plus, 'r--', 30);
step(T_minus, 'g-.', 30);
grid on;
title('Robustness to \pm20% Plant Parameter Variations');
legend('Nominal Parameters', '+20% Variation', '-20% Variation', 'Location', 'best');
