clear; clc; close all;

p.a0 = 1;
p.b0 = 1;
p.bm = 1;

wc = 1;
wo = 3;

p.kp = wc;
p.beta1 = 2 * wo;
p.beta2 = wo^2;

p.r = 1;
X0 = [0; 0; 0; 0];
tspan = [0 25];

a1_values = [1.00, 0.50, 0.20, 0.00];
colors = lines(length(a1_values));

fig = figure;
hold on;

for i = 1:length(a1_values)
    p.a1 = a1_values(i);
    
    options = odeset('RelTol', 1e-4, 'AbsTol', 1e-5, 'MaxStep', 0.05);
    
    [t, X] = ode45(@(t,X) ladrc_system_dynamics(t,X,p), tspan, X0, options);
    
    plot(t, X(:,1), 'LineWidth', 1.5, 'Color', colors(i,:), ...
         'DisplayName', sprintf('a_1 = %.2f', p.a1));
end

plot(tspan, [p.r p.r], 'k--', 'LineWidth', 1, 'DisplayName', 'Reference');
hold off;
grid on;
title('1st-Order LADRC on 2nd-Order Plant: Effect of Damping');
xlabel('Time (s)');
ylabel('Output y(t)');
legend('show', 'Location', 'SouthEast');
ylim([-1, 2]);

savePath = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q3\e\simulation_result.png';
saveas(fig, savePath);

function dX_dt = ladrc_system_dynamics(t, X, p)
    x1 = X(1);
    x2 = X(2);
    z1 = X(3);
    z2 = X(4);
    
    u = (p.kp * (p.r - z1) - z2) / p.bm;
    
    dx1_dt = x2;
    dx2_dt = -p.a0*x1 - p.a1*x2 + p.b0*u;
    
    y_measured = x1;
    dz1_dt = z2 + p.bm*u + p.beta1*(y_measured - z1);
    dz2_dt = p.beta2*(y_measured - z1);
    
    dX_dt = [dx1_dt; dx2_dt; dz1_dt; dz2_dt];
end
