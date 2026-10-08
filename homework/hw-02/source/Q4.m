clc;
clear;

fprintf('\nproblem (a): ziegler-nichols ultimate gain method\n');
fprintf('system: go(s) = (-s+1)/(s+1)^2\n\n');

num_a = [-1 1];
den_a = conv([1 1], [1 1]);
go_a = tf(num_a, den_a);

ku = 2;
omega_u = sqrt(3);
tu = 2*pi/omega_u;

fprintf('ultimate gain ku = %.4f\n', ku);
fprintf('ultimate period tu = %.4f\n\n', tu);

fprintf('ziegler-nichols ultimate gain pid settings:\n');
fprintf('controller    kp        ti        td\n');

kp_p = 0.5*ku;
fprintf('p             %.4f    inf       0\n', kp_p);

kp_pi = 0.45*ku;
ti_pi = tu/1.2;
fprintf('pi            %.4f    %.4f    0\n', kp_pi, ti_pi);

kp_pid = 0.6*ku;
ti_pid = 0.5*tu;
td_pid = 0.125*tu;
fprintf('pid           %.4f    %.4f    %.4f\n\n', kp_pid, ti_pid, td_pid);

c_p = kp_p;
c_pi = tf([kp_pi*ti_pi, kp_pi], [ti_pi, 0]);
c_pid = tf([kp_pid*ti_pid*td_pid, kp_pid*ti_pid, kp_pid], [ti_pid, 0]);

gcl_p = feedback(c_p*go_a, 1);
gcl_pi = feedback(c_pi*go_a, 1);
gcl_pid = feedback(c_pid*go_a, 1);

figure;
step(go_a);
title('open loop step response: go(s) = (-s+1)/(s+1)^2');
grid on;

figure;
step(gcl_p, gcl_pi, gcl_pid);
title('closed loop step responses with zn ultimate gain tuning');
legend('p controller', 'pi controller', 'pid controller');
grid on;

fprintf('\nproblem (b): cohen-coon method\n');
fprintf('system: go(s) = (-as+1)/((s+1)(s+3))\n\n');

a_values = [0.1, 1, 5 , 10 ,  15 , 20];

fprintf('parameter identification and cohen-coon pid settings:\n');
fprintf('a        ko       tau_o    nu_o     x        kp       ti       td\n');

for i = 1:length(a_values)
    a = a_values(i);
    
    num_b = [-a, 1];
    den_b = conv([1 1], [1 3]);
    go_b = tf(num_b, den_b);
    
    t_sim = linspace(0, 50, 5000);
    [y, t] = step(go_b, t_sim);
    
    y_ss = y(end);
    ko = y_ss;
    
    dy = diff(y) ./ diff(t);
    [max_slope, idx] = max(dy);
    t_max = t(idx);
    y_max = y(idx);
    
    t1 = t_max + (y(1) - y_max)/max_slope;
    t2 = t_max + (y_ss - y_max)/max_slope;
    
    tau_o = t1;
    nu_o = t2 - t1;
    x = tau_o / nu_o;
    
    if nu_o > 0
        kp = (1/ko) * (nu_o/tau_o) * (4/3 + tau_o/(4*nu_o));
        ti = tau_o * (32 + 6*tau_o/nu_o) / (13 + 8*tau_o/nu_o);
        td = tau_o * 4 / (11 + 2*tau_o/nu_o);
    else
        kp = -inf;
        ti = 0;
        td = 0;
    end
    
    fprintf('%-8.2f %-8.3f %-8.3f %-8.3f %-8.3f %-8.3f %-8.3f %-8.3f\n', ...
        a, ko, tau_o, nu_o, x, kp, ti, td);
end


clear; clc;

Go_a01 = tf([-0.1 1], conv([1 1], [1 3]));
Go_a1 = tf([-1 1], conv([1 1], [1 3]));
Go_a5 = tf([-5 1], conv([1 1], [1 3]));
Go_a10 = tf([-10 1], conv([1 1], [1 3]));
Go_a15 = tf([-15 1], conv([1 1], [1 3]));
Go_a20 = tf([-20 1], conv([1 1], [1 3]));

Kp_vals = [1.73, 1.35, 0.88, 0.59, 0.44, 0.35];
Ti_vals = [1.49, 1.71, 2.27, 2.83, 3.24, 3.64];
Td_vals = [0.37, 0.43, 0.57, 0.71, 0.81, 0.91];

C_a01 = pid(Kp_vals(1), Kp_vals(1)/Ti_vals(1), Kp_vals(1)*Td_vals(1));
C_a1 = pid(Kp_vals(2), Kp_vals(2)/Ti_vals(2), Kp_vals(2)*Td_vals(2));
C_a5 = pid(Kp_vals(3), Kp_vals(3)/Ti_vals(3), Kp_vals(3)*Td_vals(3));
C_a10 = pid(Kp_vals(4), Kp_vals(4)/Ti_vals(4), Kp_vals(4)*Td_vals(4));
C_a15 = pid(Kp_vals(5), Kp_vals(5)/Ti_vals(5), Kp_vals(5)*Td_vals(5));
C_a20 = pid(Kp_vals(6), Kp_vals(6)/Ti_vals(6), Kp_vals(6)*Td_vals(6));

T_a01 = feedback(C_a01*Go_a01, 1);
T_a1 = feedback(C_a1*Go_a1, 1);
T_a5 = feedback(C_a5*Go_a5, 1);
T_a10 = feedback(C_a10*Go_a10, 1);
T_a15 = feedback(C_a15*Go_a15, 1);
T_a20 = feedback(C_a20*Go_a20, 1);

figure('position', [100 100 1200 800]);

subplot(2,3,1);
step(T_a01, 30);
title('a = 0.1');
grid on;

subplot(2,3,2);
step(T_a1, 30);
title('a = 1');
grid on;

subplot(2,3,3);
step(T_a5, 30);
title('a = 5');
grid on;

subplot(2,3,4);
step(T_a10, 30);
title('a = 10');
grid on;

subplot(2,3,5);
step(T_a15, 30);
title('a = 15');
grid on;

subplot(2,3,6);
step(T_a20, 30);
title('a = 20');
grid on;
