dt = 0.001;
t = 0:dt:6;
r = double(t >= 1);

Kp = 5;
Ki = 15;

y = zeros(size(t));
uc = zeros(size(t));
u = zeros(size(t));

integral_e = 0;

for i = 1:length(t)-1
    e = r(i) - y(i);
    
    uc(i) = Kp * e + Ki * integral_e;
    
    if uc(i) > 2
        u(i) = 2;
    elseif uc(i) < -2
        u(i) = -2;
    else
        u(i) = uc(i);
    end
    
    y(i+1) = y(i) + dt * (-y(i) + u(i));
    
    integral_e = integral_e + dt * e;
end

e = r(end) - y(end);
uc(end) = Kp * e + Ki * integral_e;
u(end) = max(-2, min(2, uc(end)));

figure('Color', 'w', 'Position', [100, 100, 800, 600]);

subplot(2,1,1);
plot(t, r, 'k--', 'LineWidth', 1.5);
hold on;
plot(t, y, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1);
title('Output Response: y(t)');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Reference r(t)', 'Output y(t)', 'Location', 'best');

subplot(2,1,2);
plot(t, uc, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
hold on;
plot(t, u, 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1);
title('Control Signals: u_c(t) and u(t)');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Control before saturation u_c(t)', 'Saturated control signal u(t)', 'Location', 'best');



% b : 

N = length(t); 
kaw = 10; 
u_max = 2;

y_aw = zeros(1, N);
uc_aw = zeros(1, N);
u_aw = zeros(1, N);

xP_aw = 0; 
xI_aw = 0; 

for i = 1:N-1
    e = r(i) - y_aw(i);
    
    uc_aw(i) = Kp * e + Ki * xI_aw;
    
    if uc_aw(i) > u_max
        u_aw(i) = u_max;
    elseif uc_aw(i) < -u_max
        u_aw(i) = -u_max;
    else
        u_aw(i) = uc_aw(i);
    end
    
    % Plant: y_dot = -y + u -> Euler integration
    dxP = -xP_aw + u_aw(i);
    xP_aw = xP_aw + dxP * dt;
    y_aw(i+1) = xP_aw;
    
    dxI = e + kaw * (u_aw(i) - uc_aw(i));
    xI_aw = xI_aw + dxI * dt;
end

e = r(N) - y_aw(N);
uc_aw(N) = Kp * e + Ki * xI_aw;
if uc_aw(N) > u_max
    u_aw(N) = u_max;
elseif uc_aw(N) < -u_max
    u_aw(N) = -u_max;
else
    u_aw(N) = uc_aw(N);
end

figure('Color', 'w', 'Position', [150, 150, 800, 600]);

subplot(2,1,1);
plot(t, r, 'k--', 'LineWidth', 1.5); hold on;
plot(t, y_aw, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1);
title('Output Response with Back-Calculation Anti-Windup');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Reference r(t)', 'Output y(t)', 'Location', 'best');

subplot(2,1,2);
plot(t, uc_aw, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2); hold on;
plot(t, u_aw, 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 2);
plot(t, u_max*ones(size(t)), 'k--', 'LineWidth', 1);
plot(t, -u_max*ones(size(t)), 'k--', 'LineWidth', 1);
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1);
title('Control Signals with Anti-Windup');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Unconstrained u_c(t)', 'Saturated u(t)', 'Limits', 'Location', 'best');



% c : 

x_I_c = zeros(1, N); 
y_c = zeros(1, N);   
x_P_c = zeros(1, N); 
u_c_unconstrained = zeros(1, N); 
u_c_sat = zeros(1, N); 

for k = 1:N-1
    %error
    e = r(k) - y_c(k);
  
    u_c_unconstrained(k) = Kp * e + Ki * x_I_c(k);
    % actuator saturation

    u_c_sat(k) = max(-u_max, min(u_max, u_c_unconstrained(k)));
    
    % condition 
    if (u_c_sat(k) == u_max && e > 0) || (u_c_sat(k) == -u_max && e < 0)
        x_I_dot = 0; 
    else
        x_I_dot = e; 
    end
    x_I_c(k+1) = x_I_c(k) + dt * x_I_dot;
   
    x_P_dot = -x_P_c(k) + u_c_sat(k);
    

    x_P_c(k+1) = x_P_c(k) + dt * x_P_dot;
    y_c(k+1) = x_P_c(k+1);
end

e_last = r(N) - y_c(N);
u_c_unconstrained(N) = Kp * e_last + Ki * x_I_c(N);
u_c_sat(N) = max(-u_max, min(u_max, u_c_unconstrained(N)));

% plot
figure;
subplot(2,1,1);
plot(t, r, 'k--', 'LineWidth', 1.5); hold on;
plot(t, y_c, 'Color', [0 0.4470 0.7410], 'LineWidth', 1.5);
title('Part (c): Conditional Integration Anti-Windup - System Response');
xlabel('Time (s)');
ylabel('Output y(t)');
legend('Reference', 'Output y(t)', 'Location', 'SouthEast');
grid on;

subplot(2,1,2);
plot(t, u_c_unconstrained, 'Color', [0.8500 0.3250 0.0980], 'LineStyle', '--', 'LineWidth', 1.5); hold on;
plot(t, u_c_sat, 'Color', [0 0.4470 0.7410], 'LineWidth', 1.5);
title('Control Signal');
xlabel('Time (s)');
ylabel('Control u(t)');
legend('Unconstrained u_c(t)', 'Saturated u(t)', 'Location', 'SouthEast');
grid on;
