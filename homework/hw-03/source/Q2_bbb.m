%set up
b0 = 1;
T_settle = 1;

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q3\c';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% part c
ke_grid  = linspace(0.001, 6, 250);
kob_grid = linspace(1, 40, 250);
stable_map = false(length(kob_grid), length(ke_grid));

for i = 1:length(kob_grid)
    [k1, k2, l1, l2, l3] = ladrc_gains(T_settle, kob_grid(i));
    for j = 1:length(ke_grid)
        stable_map(i,j) = is_stable(ke_grid(j), k1, k2, l1, l2, l3, b0);
    end
end

fig1 = figure('name', 'part c - stability region');
imagesc(ke_grid, kob_grid, stable_map); set(gca, 'ydir', 'normal');
colormap([1 1 1; 0.5 0.5 0.5]); hold on;
plot(ke_grid, kob_grid(end)/ke_grid(end)*ke_grid, 'k--');   % k_ob = k_e line, for reference
hold off;
xlabel('k_e'); ylabel('k_{ob}');
title('part c - stable region of LADRC in k_e - k_{ob} plane, T_{settle}=1');
saveas(fig1, fullfile(save_dir, 'partC_stability_region.png'));

% pick 2 random points inside and 2 outside the stable region, then verify by simulation
[in_idx_row, in_idx_col]   = find(stable_map);
[out_idx_row, out_idx_col] = find(~stable_map);

rng(7);
pick_in  = randperm(length(in_idx_row), 2);
pick_out = randperm(length(out_idx_row), 2);

pts_ke  = [ke_grid(in_idx_col(pick_in)),  ke_grid(out_idx_col(pick_out))];
pts_kob = [kob_grid(in_idx_row(pick_in)), kob_grid(out_idx_row(pick_out))];
labels  = {'inside #1', 'inside #2', 'outside #1', 'outside #2'};

fig2 = figure('name', 'part c - chosen points on stability map');
imagesc(ke_grid, kob_grid, stable_map); set(gca, 'ydir', 'normal');
colormap([1 1 1; 0.5 0.5 0.5]); hold on;
plot(pts_ke, pts_kob, 'r*', 'markersize', 10, 'linewidth', 1.5);
for i = 1:4
    text(pts_ke(i)+0.05, pts_kob(i), labels{i}, 'color', 'r', 'fontweight', 'bold');
end
hold off; xlabel('k_e'); ylabel('k_{ob}');
title('part c - 2 random points inside and 2 outside the stable region');
saveas(fig2, fullfile(save_dir, 'partC_chosen_points.png'));

fig3 = figure('name', 'part c - step response at the 4 chosen points'); hold on;
styles = {'-', '--', '-.', ':'};
eig_verdict = {'stable', 'stable', 'unstable', 'unstable'};   % by construction: pts 1,2 inside, 3,4 outside
for i = 1:4
    [k1, k2, l1, l2, l3] = ladrc_gains(T_settle, pts_kob(i));
    [t, Y, blew] = sim_core(pts_ke(i), b0, k1, k2, l1, l2, l3, 5, 1e6);
    plot(t, Y(:,1), styles{i}, 'linewidth', 1.4);
    sim_verdict = ternary(~blew, 'stable', 'unstable');
    fprintf('%s: ke=%.3f, kob=%.3f -> eigenvalue test: %s, simulation: %s\n', ...
        labels{i}, pts_ke(i), pts_kob(i), eig_verdict{i}, sim_verdict);
end
yline(1, 'k--'); hold off; grid on; ylim([-5 10]); xlim([0 5]);
xlabel('time (s)'); ylabel('y(t)');
title('part c - closed-loop step response at the 4 chosen (k_e,k_{ob}) points');
legend([labels, {'reference'}], 'location', 'best');
saveas(fig3, fullfile(save_dir, 'partC_verification_steps.png'));




function [k1, k2, l1, l2, l3] = ladrc_gains(T_settle, k_ob)
    s_CL  = -4/T_settle;
    s_ESO = k_ob*s_CL;
    k1 = s_CL^2; k2 = -2*s_CL;
    l1 = -3*s_ESO; l2 = 3*s_ESO^2; l3 = -s_ESO^3;
end


function tf = is_stable(ke, k1, k2, l1, l2, l3, b0)
    M = [   0,      1,        0,         0,      0;
         -160,    100,    -ke*k1/b0, -ke*k2/b0, -ke/b0;
           l1,      0,      -l1,        1,      0;
           l2,      0,  -(k1+l2),     -k2,      0;
           l3,      0,      -l3,        0,      0];
    tf = all(real(eig(M)) < 0);
end

function ds = closed_loop_ode(~, s, ke, b0, k1, k2, l1, l2, l3)
    p1=s(1); p2=s(2); xh1=s(3); xh2=s(4); xh3=s(5);
    r = 1; rdot = 0; rddot = 0;
    u0 = k1*(r-xh1) + k2*(rdot-xh2) + rddot;
    u  = (u0 - xh3)/b0;
    e_y = p1 - xh1;
    ds = [p2; 100*p2-160*p1+ke*u; xh2+l1*e_y; xh3+b0*u+l2*e_y; l3*e_y];
end

function [value, isterminal, direction] = blowup_event(~, s, thresh)
    value = thresh - abs(s(1)); isterminal = 1; direction = 0;
end

function [t, Y, blew] = sim_core(ke, b0, k1, k2, l1, l2, l3, t_end, thresh)
    odefun = @(t,s) closed_loop_ode(t, s, ke, b0, k1, k2, l1, l2, l3);
    opts = odeset('Events', @(t,s) blowup_event(t,s,thresh), 'RelTol', 1e-7, 'AbsTol', 1e-9);
    [t, Y, te] = ode15s(odefun, [0 t_end], zeros(5,1), opts);
    blew = ~isempty(te);
end

function out = ternary(cond, a, b)
    if cond, out = a; else, out = b; end
end