clc; clc; clear; close all;

lb = [0, 0, 0];       
ub = [10, 10, 10];    
K0 = [1, 1, 1];       

%ga : 
disp('Running Genetic Algorithm (ga)...');
options_ga = optimoptions('ga', 'PopulationSize', 50, ...
    'MaxGenerations', 50, 'Display', 'iter');
[K_ga, J_ga] = ga(@objectiveFunction, 3, [], [], [], [], lb, ub, [], options_ga);

%particleswarm
disp('Running Particle Swarm Optimization...');
options_pso = optimoptions('particleswarm', 'SwarmSize', 50, ...
    'MaxIterations', 50, 'Display', 'iter');
[K_pso, J_pso] = particleswarm(@objectiveFunction, 3, lb, ub, options_pso);

%sqp
disp('Running fmincon...');
options_fmincon = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
[K_fmincon, J_fmincon] = fmincon(@objectiveFunction, K0, [], [], [], [], lb, ub, [], options_fmincon);

%% 

fprintf('Algorithm\t Kp\t\t Ki\t\t Kd\t\t Cost (J)\n');
fprintf('GA\t\t %.4f\t %.4f\t %.4f\t %.4f\n', K_ga(1), K_ga(2), K_ga(3), J_ga);
fprintf('PSO\t\t %.4f\t %.4f\t %.4f\t %.4f\n', K_pso(1), K_pso(2), K_pso(3), J_pso);
fprintf('fmincon\t %.4f\t %.4f\t %.4f\t %.4f\n', K_fmincon(1), K_fmincon(2), K_fmincon(3), J_fmincon);

%plot

s = tf('s');
G = 2 / ((5*s + 1)*(2*s + 1));
G.InputDelay = 0.2;
Tf = 0.05;

% construct controllers
C_ga = pid(K_ga(1), K_ga(2), K_ga(3), Tf);
C_pso = pid(K_pso(1), K_pso(2), K_pso(3), Tf);
C_fmincon = pid(K_fmincon(1), K_fmincon(2), K_fmincon(3), Tf);

CL_ga = feedback(C_ga * G, 1);
CL_pso = feedback(C_pso * G, 1);
CL_fmincon = feedback(C_fmincon * G, 1);

% simulate
t = 0:0.01:30;
[y_ga, ~] = step(CL_ga, t);
[y_pso, ~] = step(CL_pso, t);
[y_fmincon, ~] = step(CL_fmincon, t);

% Plot
figure;
plot(t, y_ga, 'r', 'LineWidth', 1.5); hold on;
plot(t, y_pso, 'b--', 'LineWidth', 1.5);
plot(t, y_fmincon, 'k:', 'LineWidth', 1.5);
yline(1, 'g--', 'Reference');
title('Step Response Comparison of Optimization Algorithms');
xlabel('Time (s)');
ylabel('Amplitude');
legend(sprintf('GA (J=%.2f)', J_ga), ...
       sprintf('PSO (J=%.2f)', J_pso), ...
       sprintf('fmincon (J=%.2f)', J_fmincon), 'Location', 'best');
grid on;
