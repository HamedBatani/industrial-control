clear; clc; close all;
% a 
% define symbolic variables
syms x1 x2 u real

% define non-linear equations
f1 = x2;
f2 = x1 - 0.2*x2 + x1^3 + u;
f = [f1; f2];

g = x1 + 0.1*x2^2 + 0.2*u;

% state and input vectors
x = [x1; x2];

% compute symbolic jacobians
A_sym = jacobian(f, x);
B_sym = jacobian(f, u);
C_sym = jacobian(g, x);
D_sym = jacobian(g, u);

% operating point
xs = [1; 0];
us = -2;

% substitute operating point into jacobians
A = double(subs(A_sym, [x; u], [xs; us]));
B = double(subs(B_sym, [x; u], [xs; us]));
C = double(subs(C_sym, [x; u], [xs; us]));
D = double(subs(D_sym, [x; u], [xs; us]));

disp('part a: linearized state-space matrices');
disp('A = '), disp(A)
disp('B = '), disp(B)
disp('C = '), disp(C)
disp('D = '), disp(D)

% b
open_loop_poles = eig(A);
disp('part b: open-loop eigenvalues');
disp(open_loop_poles)

if any(real(open_loop_poles) > 0)
    disp('system is locally unstable.')
else
    disp('system is locally stable.')
end

% c
desired_poles = [-7; -6.5];
K = place(A, B, desired_poles);

disp('part c: feedback gain matrix K');
disp(K)

% closed-loop system matrix
A_cl = A - B*K;
closed_loop_poles = eig(A_cl);
disp('closed-loop eigenvalues:');
disp(closed_loop_poles)

% d
% define simulation time
t_span = [0 10];

% initial perturbation
x0 = [0.1; 0];

% define closed loop linear system diff eq
sys_cl = @(t, xl) A_cl * xl;

% solve ode
[t, xl_sim] = ode45(sys_cl, t_span, x0);

% calculate control effort
ul_sim = zeros(length(t), 1);
for i = 1:length(t)
    ul_sim(i) = -K * xl_sim(i, :)';
end

% plot results
figure('color', 'w', 'position', [100 100 800 600]);

% plot states
subplot(2,1,1);
plot(t, xl_sim(:,1), 'linewidth', 2, 'color', [0.8500 0.3250 0.0980]); hold on;
plot(t, xl_sim(:,2), 'linewidth', 2, 'color', [0.0000 0.4470 0.7410]);
grid on; grid minor;
title('closed-loop state responses (perturbation dynamics)', 'fontsize', 14);
xlabel('time (s)', 'fontsize', 12);
ylabel('state values', 'fontsize', 12);
legend('x_{l,1} (position)', 'x_{l,2} (velocity)', 'fontsize', 12, 'location', 'northeast');

% plot control effort
subplot(2,1,2);
plot(t, ul_sim, 'linewidth', 2, 'color', [0.4660 0.6740 0.1880]);
grid on; grid minor;
title('control input perturbation', 'fontsize', 14);
xlabel('time (s)', 'fontsize', 12);
ylabel('u_l', 'fontsize', 12);
legend('u_l (control effort)', 'fontsize', 12);

sgtitle('linearized system stabilization', 'fontsize', 16, 'fontweight', 'bold');
