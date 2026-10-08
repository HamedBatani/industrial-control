clear; clc; close all;

%first we define transfer functions

s = tf('s');
G1_part2 = 1/(s+2) + 0.4/(s+0.04);
G1 = 80/(s+8)^2 * G1_part2;
G2 = (s+5)^2 / (s * (s+2)^2 * (s+25));

% Step response to find a and L 

[y1, t1] = step(G1);
[y2, t2] = step(G2);

% function to compute a and L from step response
[a1, L1] = compute_a_L(y1, t1);
[a2, L2] = compute_a_L(y2, t2);

fprintf('a and L : \n');
fprintf('G1(s): a = %.4f, L = %.4f\n', a1, L1);
fprintf('G2(s): a = %.4f, L = %.4f\n\n', a2, L2);

% CHR table ables 

% No overshoot
CHR_no_overshoot.P.Kp = 0.3 / a1;  
CHR_no_overshoot.PI.Kp = 0.6 / a1;
CHR_no_overshoot.PI.Ti = 4.0 * L1;
CHR_no_overshoot.PID.Kp = 0.95 / a1;
CHR_no_overshoot.PID.Ti = 2.4 * L1;
CHR_no_overshoot.PID.Td = 0.42 * L1;

% 20% Overshoot
CHR_20_overshoot.P.Kp = 0.7 / a1;
CHR_20_overshoot.PI.Kp = 0.7 / a1;
CHR_20_overshoot.PI.Ti = 1.2 * L1;  
CHR_20_overshoot.PID.Kp = 1.0 / a1;
CHR_20_overshoot.PID.Ti = 1.2 * L1;  
CHR_20_overshoot.PID.Td = 0.5 * L1;  

% For G2 (same structure)
CHR_no_overshoot2.PID.Kp = 0.95 / a2;
CHR_no_overshoot2.PID.Ti = 2.4 * L2;
CHR_no_overshoot2.PID.Td = 0.42 * L2;

CHR_20_overshoot2.PID.Kp = 1.0 / a2;
CHR_20_overshoot2.PID.Ti = 1.2 * L2;
CHR_20_overshoot2.PID.Td = 0.5 * L2;

% pid controllers for G1
Kp_n = CHR_no_overshoot.PID.Kp;
Ti_n = CHR_no_overshoot.PID.Ti;
Td_n = CHR_no_overshoot.PID.Td;
PID_no_overshoot = Kp_n * (1 + 1/(Ti_n*s) + Td_n*s);

Kp_20 = CHR_20_overshoot.PID.Kp;
Ti_20 = CHR_20_overshoot.PID.Ti;
Td_20 = CHR_20_overshoot.PID.Td;
PID_20_overshoot = Kp_20 * (1 + 1/(Ti_20*s) + Td_20*s);

% pid controllers for G2
Kp_n2 = CHR_no_overshoot2.PID.Kp;
Ti_n2 = CHR_no_overshoot2.PID.Ti;
Td_n2 = CHR_no_overshoot2.PID.Td;
PID_no_overshoot2 = Kp_n2 * (1 + 1/(Ti_n2*s) + Td_n2*s);

Kp_202 = CHR_20_overshoot2.PID.Kp;
Ti_202 = CHR_20_overshoot2.PID.Ti;
Td_202 = CHR_20_overshoot2.PID.Td;
PID_20_overshoot2 = Kp_202 * (1 + 1/(Ti_202*s) + Td_202*s);

% Closed-loop systems
CL_G1_no = feedback(PID_no_overshoot * G1, 1);
CL_G1_20 = feedback(PID_20_overshoot * G1, 1);
CL_G2_no = feedback(PID_no_overshoot2 * G2, 1);
CL_G2_20 = feedback(PID_20_overshoot2 * G2, 1);


fprintf(' G1(s) PID parameters \n');
fprintf('no Overshoot: Kp=%.4f, Ti=%.4f, Td=%.4f\n', Kp_n, Ti_n, Td_n);
fprintf('20%% overshoot: Kp=%.4f, Ti=%.4f, Td=%.4f\n\n', Kp_20, Ti_20, Td_20);

fprintf(' G2(s) PID Parameters \n');
fprintf('no overshoot: Kp=%.4f, Ti=%.4f, Td=%.4f\n', Kp_n2, Ti_n2, Td_n2);
fprintf('20%% overshoot: Kp=%.4f, Ti=%.4f, Td=%.4f\n\n', Kp_202, Ti_202, Td_202);

%plots
figure('Position', [100, 100, 1200, 800]);

% G1 responses
subplot(2,2,1);
step(CL_G1_no, CL_G1_20, 10);
grid on;
title('G1(s) Closed-Loop Step Response');
xlabel('Time (s)');
ylabel('Amplitude');
legend('No Overshoot', '20% Overshoot', 'Location', 'southeast');
set(gca, 'FontSize', 10);

% G2 responses
subplot(2,2,2);
step(CL_G2_no, CL_G2_20, 50);
grid on;
title('G2(s) Closed-Loop Step Response');
xlabel('Time (s)');
ylabel('Amplitude');
legend('No Overshoot', '20% Overshoot', 'Location', 'southeast');
set(gca, 'FontSize', 10);

% Open-loop step responses (to show tangent)
subplot(2,2,3);
step(G1, 5);
grid on;
title('G1(s) Open-Loop Step Response');
xlabel('Time (s)');
ylabel('Amplitude');
hold on;
% Plot tangent line approximation
t_tan1 = [0, L1, L1 + a1];
y_tan1 = [0, 0, 1];
plot(t_tan1, y_tan1, 'r--', 'LineWidth', 1.5);
legend('Step Response', 'Tangent (L, a)', 'Location', 'southeast');
set(gca, 'FontSize', 10);

subplot(2,2,4);
step(G2, 10);
grid on;
title('G2(s) Open-Loop Step Response');
xlabel('Time (s)');
ylabel('Amplitude');
hold on;
t_tan2 = [0, L2, L2 + a2];
y_tan2 = [0, 0, 1];
plot(t_tan2, y_tan2, 'r--', 'LineWidth', 1.5);
legend('Step Response', 'Tangent (L, a)', 'Location', 'southeast');
set(gca, 'FontSize', 10);

sgtitle('CHR PID Tuning Method - Tracking Design');

% Additional detailed plots
figure('Position', [100, 100, 1400, 500]);

subplot(1,2,1);
step(CL_G1_no, CL_G1_20, 15);
grid on;
title('G1(s): Comparison of CHR PID Tunings');
xlabel('Time (seconds)');
ylabel('Amplitude');
legend('No Overshoot (PID)', '20% Overshoot (PID)', 'Location', 'southeast');
set(gca, 'FontSize', 11);
% Calculate and display overshoot
[y_no, t_no] = step(CL_G1_no);
[y_20, t_20] = step(CL_G1_20);
overshoot_no = (max(y_no) - 1) * 100;
overshoot_20 = (max(y_20) - 1) * 100;
text(0.5, 1.2, sprintf('No OS Peak: %.1f%%', overshoot_no), 'FontSize', 10);
text(0.5, 1.1, sprintf('20%% OS Peak: %.1f%%', overshoot_20), 'FontSize', 10);

subplot(1,2,2);
step(CL_G2_no, CL_G2_20, 60);
grid on;
title('G2(s): Comparison of CHR PID Tunings');
xlabel('Time (seconds)');
ylabel('Amplitude');
legend('No Overshoot (PID)', '20% Overshoot (PID)', 'Location', 'southeast');
set(gca, 'FontSize', 11);
[y_no2, t_no2] = step(CL_G2_no);
[y_202, t_202] = step(CL_G2_20);
overshoot_no2 = (max(y_no2) - 1) * 100;
overshoot_202 = (max(y_202) - 1) * 100;
text(2, 1.3, sprintf('No OS Peak: %.1f%%', overshoot_no2), 'FontSize', 10);
text(2, 1.2, sprintf('20%% OS Peak: %.1f%%', overshoot_202), 'FontSize', 10);

sgtitle('Closed-Loop Step Response Comparison');

% performance metrics
fprintf('\nperformance : \n');
fprintf('G1 - No Overshoot: Peak=%.2f%%, Settling Time=%.3f s\n', ...
    overshoot_no, settling_time(y_no, t_no, 0.02));
fprintf('G1 - 20%% Overshoot: Peak=%.2f%%, Settling Time=%.3f s\n', ...
    overshoot_20, settling_time(y_20, t_20, 0.02));
fprintf('G2 - No Overshoot: Peak=%.2f%%, Settling Time=%.3f s\n', ...
    overshoot_no2, settling_time(y_no2, t_no2, 0.02));
fprintf('G2 - 20%% Overshoot: Peak=%.2f%%, Settling Time=%.3f s\n', ...
    overshoot_202, settling_time(y_202, t_202, 0.02));

% Helper function: 
function [a, L, a_prime] = compute_a_L(y, t)
    % Compute derivative
    dt = mean(diff(t));
    dy = diff(y) ./ dt;
    
    % Find max slope index
    [~, idx_max] = max(dy);
    idx_max = idx_max(1);
    
    % Tangent line: y = m*(t - t0) + y0
    m = dy(idx_max);
    t0 = t(idx_max);
    y0 = y(idx_max);
    
    % Find intersection with y=0 (L)
    L = t0 - y0/m;
    
    % Find intersection with y=1 (L + a)
    t_final = t0 + (1 - y0)/m;
    a = t_final - L;
    
    % --- NEW CODE ---
    % Find y-intercept (when t = 0)
    y_intercept = y0 - m * t0; % or simply: -m * L
    
    % Assign the absolute value to a' (a_prime)
    a_prime = abs(y_intercept);
    % ----------------
    
    % Ensure positive values
    L = max(L, 0);
    a = max(a, 0.001);
   
end


% Helper function: 2% criterion
function ts = settling_time(y, t, tol)
    final_value = y(end);
    idx = find(abs(y - final_value) <= tol * abs(final_value), 1, 'last');
    if isempty(idx)
        ts = t(end);
    else
        ts = t(idx);
    end
end