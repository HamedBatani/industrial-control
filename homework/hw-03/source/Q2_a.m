%set up
b0 = 1;
blow_thresh = 1e6;

save_dir_a = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q3\a';
save_dir_b = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q3\b';
if ~exist(save_dir_a, 'dir'), mkdir(save_dir_a); end
if ~exist(save_dir_b, 'dir'), mkdir(save_dir_b); end

% part a
T_settle = 0.1; k_ob = 100;
s_CL = -4/T_settle; s_ESO = k_ob*s_CL;
k1 = s_CL^2; k2 = -2*s_CL;
l1 = -3*s_ESO; l2 = 3*s_ESO^2; l3 = -s_ESO^3;

t_end_a = 0.5;        
t_end_a_demo = 0.45;  
ke_sweep = logspace(-3, 2, 80);
err_a = zeros(size(ke_sweep));
for i = 1:length(ke_sweep)
    [t, Y, blew] = sim_core(ke_sweep(i), b0, k1, k2, l1, l2, l3, t_end_a, blow_thresh);
    if blew
        err_a(i) = blow_thresh;
    else
        tail = t > 0.8*t_end_a;
        err_a(i) = max(abs(Y(tail,1) - 1));
    end
end

fig1 = figure('name', 'part a - stability vs ke');
loglog(ke_sweep, err_a, 'b', 'linewidth', 1.2); hold on;
yline(1, 'k--'); xline(0.07, 'r--'); xline(8.4, 'r--'); hold off;
grid on; xlabel('k_e'); ylabel('steady-state |y-r| (log)');
title('part a - tracking error vs k_e, T_{settle}=0.1, k_{ob}=100');
legend('simulated error', 'reference scale', 'claimed bounds (0.07, 8.4)', 'location', 'best');
saveas(fig1, fullfile(save_dir_a, 'partA_error_vs_ke.png'));

ke_demo_a = [0.055, 4.5, 8.55];   
styles_a = {'-', '--', ':'};        
fig2 = figure('name', 'part a - illustrative step responses'); hold on;
for i = 1:length(ke_demo_a)
    [t, Y, ~] = sim_core(ke_demo_a(i), b0, k1, k2, l1, l2, l3, t_end_a_demo, blow_thresh);
    plot(t, Y(:,1), styles_a{i}, 'linewidth', 1.6);
end
yline(1, 'k--'); hold off; grid on; ylim([-5 10]);
xlabel('time (s)'); ylabel('y(t)');
title('part a - step response for several k_e values');
legend([arrayfun(@(k) sprintf('k_e=%.2g', k), ke_demo_a, 'uniformoutput', false), {'reference'}], 'location', 'best');
saveas(fig2, fullfile(save_dir_a, 'partA_step_responses.png'));

%part b 
T_settle = 1; k_ob = 10;
s_CL = -4/T_settle; s_ESO = k_ob*s_CL;
k1 = s_CL^2; k2 = -2*s_CL;
l1 = -3*s_ESO; l2 = 3*s_ESO^2; l3 = -s_ESO^3;

t_end_b = 8;          
t_end_b_demo = 6.5;   
ke_sweep = logspace(-3, 4, 80);
err_b = zeros(size(ke_sweep));
for i = 1:length(ke_sweep)
    [t, Y, blew] = sim_core(ke_sweep(i), b0, k1, k2, l1, l2, l3, t_end_b, blow_thresh);
    if blew
        err_b(i) = blow_thresh;
    else
        tail = t > 0.8*t_end_b;
        err_b(i) = max(abs(Y(tail,1) - 1));
    end
end

fig3 = figure('name', 'part b - stability vs ke');
loglog(ke_sweep, err_b, 'b', 'linewidth', 1.2); hold on;
yline(1, 'k--'); hold off;
grid on; xlabel('k_e'); ylabel('steady-state |y-r| (log)');
title('part b - tracking error vs k_e, T_{settle}=1, k_{ob}=10 (no stabilizing k_e)');
legend('simulated error', 'reference scale', 'location', 'best');
saveas(fig3, fullfile(save_dir_b, 'partB_error_vs_ke.png'));

ke_demo_b = [0.055, 4.5, 8.55];  
styles_b = {'-', '--', ':'};       
fig4 = figure('name', 'part b - illustrative step responses'); hold on;
for i = 1:length(ke_demo_b)
    [t, Y, ~] = sim_core(ke_demo_b(i), b0, k1, k2, l1, l2, l3, t_end_b_demo, blow_thresh);
    plot(t, Y(:,1), styles_b{i}, 'linewidth', 1.6);
end
yline(1, 'k--'); hold off; grid on; ylim([-10 10]);
xlabel('time (s)'); ylabel('y(t)');
title('part b - step response for several k_e values');
legend([arrayfun(@(k) sprintf('k_e=%.2g', k), ke_demo_b, 'uniformoutput', false), {'reference'}], 'location', 'best');
saveas(fig4, fullfile(save_dir_b, 'partB_step_responses.png'));

% closed-loop ode
function ds = closed_loop_ode(~, s, ke, b0, k1, k2, l1, l2, l3)
    p1=s(1); p2=s(2); xh1=s(3); xh2=s(4); xh3=s(5);
    r = 1; rdot = 0; rddot = 0;       % unit step reference
    u0 = k1*(r-xh1) + k2*(rdot-xh2) + rddot;   % eq.59
    u  = (u0 - xh3)/b0;                          % eq.58
    e_y = p1 - xh1;
    ds = [p2;
          100*p2 - 160*p1 + ke*u;      % true plant: ke*g3(s)
          xh2 + l1*e_y;
          xh3 + b0*u + l2*e_y;
          l3*e_y];
end

% stops integration early once the output clearly diverges
function [value, isterminal, direction] = blowup_event(~, s, thresh)
    value = thresh - abs(s(1));
    isterminal = 1;
    direction = 0;
end

% stiff closed-loop simulator (it handles the very large eso gain robustly)
function [t, Y, blew] = sim_core(ke, b0, k1, k2, l1, l2, l3, t_end, thresh)
    odefun = @(t,s) closed_loop_ode(t, s, ke, b0, k1, k2, l1, l2, l3);
    opts = odeset('Events', @(t,s) blowup_event(t,s,thresh), 'RelTol', 1e-7, 'AbsTol', 1e-9);
    [t, Y, te] = ode15s(odefun, [0 t_end], zeros(5,1), opts);
    blew = ~isempty(te);
end