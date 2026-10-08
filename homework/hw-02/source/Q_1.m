clear; clc; close all;

s = tf('s');
G1 = (80 / (s + 8)^2) * (1 / (s + 2) + 0.4 / (s + 0.04));
G2 = (s + 5)^2 / (s * (s + 2)^2 * (s + 25));

systems = {G1, G2};
sys_names = {'G_1(s)', 'G_2(s)'};
N = 10; 

figure('Name', 'CHR PID Tuning Results', 'Position', [100, 100, 1000, 400]);

for i = 1:length(systems)
    G = systems{i};
    
    [y, t] = step(G);
    
    dy = diff(y) ./ diff(t);
    [max_slope, max_idx] = max(dy);
    
    t_inf = t(max_idx);
    y_inf = y(max_idx);
    
    L = t_inf - y_inf / max_slope;
    a = abs(max_slope * (0 - t_inf) + y_inf);
    
    K_no = 0.6 / a;
    Ti_no = 1.0 * L;
    Td_no = 0.5 * L;
    
    K_20 = 0.95 / a;
    Ti_20 = 1.357 * L;
    Td_20 = 0.473 * L;
    
    C_no = pid(K_no, K_no/Ti_no, K_no*Td_no, Td_no/N);
    C_20 = pid(K_20, K_20/Ti_20, K_20*Td_20, Td_20/N);
    
    sys_cl_no = feedback(C_no * G, 1);
    sys_cl_20 = feedback(C_20 * G, 1);
    
    subplot(1, 2, i);
    [y_no, t_no] = step(sys_cl_no);
    [y_20, t_20] = step(sys_cl_20);
    
    plot(t_no, y_no, 'g', 'LineWidth', 2); hold on;
    plot(t_20, y_20, 'm', 'LineWidth', 2);
    
    grid on;
    title(['Closed-Loop Step Responses for ', sys_names{i}]);
    xlabel('Time (s)'); ylabel('Amplitude');
    legend('No Overshoot Tracking', '20% Overshoot Tracking', 'Location', 'Best');
    
    info_no = stepinfo(sys_cl_no);
    info_20 = stepinfo(sys_cl_20);
    
    fprintf('\nPerformance for %s\n', sys_names{i});
    fprintf('No Overshoot:\n  Overshoot: %.2f%%\n', info_no.Overshoot);
    fprintf('20%% Overshoot:\n  Overshoot: %.2f%%\n', info_20.Overshoot);
end