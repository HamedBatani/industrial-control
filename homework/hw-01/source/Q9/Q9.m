% first we define the operating point 
xs = [1; 0];
us = -0.5;
ys = xs(1) + 0.1*xs(2)^2 + 0.2*us; 

% then we define the input step perturbation
ul = 0.2;          % linearized input
u_nl = us + ul;    % Nnonlinear input

% linearized system matrices 
A = [0, 1; 4, -0.2];
B = [0; 1];
C = [1, 0];
D = 0.2;

% simulation setup
tspan = [0 1.5];
x0_nl = xs;    
x0_l = [0; 0]; 
% simulat non)linear system
f_nl = @(t, x) [x(2); x(1) - 0.2*x(2) + x(1)^3 + u_nl];
[t_nl, x_nl] = ode45(f_nl, tspan, x0_nl);
% calculate nonlinear output and convert to perturbation form
y_nl = x_nl(:,1) + 0.1*x_nl(:,2).^2 + 0.2*u_nl;
yl_nl = y_nl - ys; 
% simulate Linearized System
f_l = @(t, xl) A*xl + B*ul;
[t_l, x_l] = ode45(f_l, tspan, x0_l);

% calculate linearized output
yl = (C*x_l')' + D*ul;

% plotting
figure;
plot(t_nl, yl_nl, 'b-', 'LineWidth', 2); hold on;
plot(t_l, yl, 'r--', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Perturbation Output (y_l)');
title('Q9a: Nonlinear vs Linearized Model (Step Input u_l = 0.2)');
legend('Nonlinear Model (y_l^{nl})', 'Linearized Model (y_l)', 'Location', 'best');
grid on;

% closed loop sim ( with controller k ) 
% controller matrix from Q8
K = [49.5000, 13.3000];
%refrence step input
r = 0.2; 
tspan_cl = [0 5.5]; 
% clossd loop non_linear system
f_nl_cl = @(t, x) [x(2); 
                   x(1) - 0.2*x(2) + x(1)^3 + (us + r - K*(x - xs))];
[t_nl_cl, x_nl_cl] = ode45(f_nl_cl, tspan_cl, x0_nl);

u_nl_actual = us + r - (x_nl_cl - xs') * K'; 
y_nl_cl = x_nl_cl(:,1) + 0.1*x_nl_cl(:,2).^2 + 0.2*u_nl_actual;
yl_nl_cl = y_nl_cl - ys; 

% closed loop linearized system

f_l_cl = @(t, xl) (A - B*K)*xl + B*r;
[t_l_cl, x_l_cl] = ode45(f_l_cl, tspan_cl, x0_l);

u_l_actual = r - (x_l_cl * K');
yl_cl = (C*x_l_cl')' + D*u_l_actual;

% plot
figure;
plot(t_nl_cl, yl_nl_cl, 'b-', 'LineWidth', 2); hold on;
plot(t_l_cl, yl_cl, 'r--', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Perturbation Output (y_l)');
title('Closed-Loop: Nonlinear vs Linearized Model (with Controller K)');
legend('Nonlinear Model (y_l^{nl})', 'Linearized Model (y_l)', 'Location', 'best');
grid on;
