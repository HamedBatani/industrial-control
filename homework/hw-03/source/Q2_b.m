%==========================================================================
%   LADRC Stability Investigation - Part c: Region Regeneration & Verification
%==========================================================================
clear; clc; close all;

% Fixed parameters for part c
T_settle = 1;
s_CL = -4 / T_settle;
k1 = s_CL^2; 
k2 = -2 * s_CL;
b0 = 1;
blow_thresh = 1e6;
t_end_c = 12;

save_dir_c = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q3\c';
if ~exist(save_dir_c, 'dir'), mkdir(save_dir_c); end

%% -------------------------------------------------------------------------
%% PHASE 1: NUMERICALLY EVALUATE TRUE EIGENVALUES TO REGENERATE THE REGION
%% -------------------------------------------------------------------------
ke_grid_vec  = linspace(0.01, 6, 300);
kob_grid_vec = linspace(0.01, 40, 300);
[KE, KOB] = meshgrid(ke_grid_vec, kob_grid_vec);
stability_mask = zeros(size(KE));

fprintf('Mapping out the stability region across the ke-kob plane...\n');
for r = 1:size(KE, 1)
    for c = 1:size(KE, 2)
        ke_val  = KE(r, c);
        kob_val = KOB(r, c);
        
        % Compute observer gains
        s_ESO_val = kob_val * s_CL;
        l1 = -3 * s_ESO_val; 
        l2 = 3 * s_ESO_val^2; 
        l3 = -s_ESO_val^3;
        
        % Direct Closed-Loop System Matrix A_sys for state vector: [y; dy; xh1; xh2; xh3]
        A_sys = [    0,   1,          0,          0,       0;
                  -160, 100, -ke_val*k1, -ke_val*k2, -ke_val;
                    l1,   0,        -l1,          1,       0;
                    l2,   0,  -(k1+l2),        -k2,       0;
                    l3,   0,        -l3,          0,       0];
                
        % Stable if the maximum real part of all 5 eigenvalues is strictly negative
        if max(real(eig(A_sys))) < 0
            stability_mask(r, c) = 1; 
        end
    end
end

%% -------------------------------------------------------------------------
%% PHASE 2: CHOOSE 4 VALID TEST POINTS (2 INSIDE THE SHADED AREA, 2 OUTSIDE)
%% -------------------------------------------------------------------------
% Coordinates: [ke, kob]
inside_pts  = [2.5, 30; 
               3.5, 34];
outside_pts = [1.2, 15; 
               5.0, 20];
           
test_points = [inside_pts; outside_pts];
pt_labels   = {'Inside Point 1 (Stable)', 'Inside Point 2 (Stable)', ...
               'Outside Point 1 (Unstable)', 'Outside Point 2 (Unstable)'};
pt_colors   = {'go', 'g*', 'ro', 'r*'};
line_styles = {'g-', 'g--', 'r-', 'r--'};

%% -------------------------------------------------------------------------
%% PHASE 3: PLOT THE REGENERATED STABILITY INTERVAL FIGURE
%% -------------------------------------------------------------------------
fig_region = figure('Name', 'Part c - Regenerated Stability Region');
hold on;

% Plot the filled gray stability region
contourf(KE, KOB, stability_mask, [0.5 0.5], 'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');

% Plot the characteristic dashed line tracking the minimum vertex
plot([0, 2.65], [0, 23.2], 'k--', 'LineWidth', 1.5);

% Overlay the 4 test points
for i = 1:4
    plot(test_points(i,1), test_points(i,2), pt_colors{i}, 'MarkerSize', 10, 'LineWidth', 2.5);
end

grid on; box on;
xlim([0 6]); ylim([0 40]);
xlabel('k_e'); ylabel('k_{ob}');
title('Part c - Regenerated LADRC Stability Map (True Matrix Method)');
legend({'Stable Shaded Region', 'Minimum Bandwidth Line', ...
        'Inside P1 (2.5, 30)', 'Inside P2 (3.5, 34)', ...
        'Outside P1 (1.2, 15)', 'Outside P2 (5.0, 20)'}, 'Location', 'Best');
hold off;
saveas(fig_region, fullfile(save_dir_c, 'partC_regenerated_stability_map.png'));

%% -------------------------------------------------------------------------
%% PHASE 4: TIME-DOMAIN SIMULATION VERIFICATION
%% -------------------------------------------------------------------------
fig_steps = figure('Name', 'Part c - Step Responses Verification');
hold on;

fprintf('\n=== Numerical Eigenvalue Verification for Selected Points ===\n');
for i = 1:4
    ke_val  = test_points(i, 1);
    kob_val = test_points(i, 2);
    
    s_ESO_val = kob_val * s_CL;
    l1 = -3 * s_ESO_val; 
    l2 = 3 * s_ESO_val^2; 
    l3 = -s_ESO_val^3;
    
    A_sys = [    0,   1,          0,          0,       0;
              -160, 100, -ke_val*k1, -ke_val*k2, -ke_val;
                l1,   0,        -l1,          1,       0;
                l2,   0,  -(k1+l2),        -k2,       0;
                l3,   0,        -l3,          0,       0];
    
    max_real_eig = max(real(eig(A_sys)));
    fprintf('%s (k_e=%.2f, k_ob=%.2f) -> Max Real Eigenvalue: %.4f ', ...
            pt_labels{i}, ke_val, kob_val, max_real_eig);
    if max_real_eig < 0
        fprintf('[HURWITZ - STABLE]\n');
    else
        fprintf('[NON-HURWITZ - UNSTABLE]\n');
    end
    
    % Run numerical state simulation
    [t, Y, ~] = sim_core_c(ke_val, b0, k1, k2, l1, l2, l3, t_end_c, blow_thresh);
    plot(t, Y(:,1), line_styles{i}, 'LineWidth', 1.8);
end

yline(1, 'k--');
grid on; xlim([0 t_end_c]); ylim([-2 6]);
xlabel('Time (s)'); ylabel('y(t)');
title('Part c - Step Response Verification for Selected Points');
legend([pt_labels, {'Unit Step Reference'}], 'Location', 'Best');
hold off;
saveas(fig_steps, fullfile(save_dir_c, 'partC_step_responses_verification.png'));

%% -------------------------------------------------------------------------
%% SIMULATOR CORE FUNCTIONS
%% -------------------------------------------------------------------------
% Stiff system integration using ode15s
function [t, Y, blew] = sim_core_c(ke, b0, k1, k2, l1, l2, l3, t_end, thresh)
    odefun = @(t,s) closed_loop_ode_c(t, s, ke, b0, k1, k2, l1, l2, l3);
    opts = odeset('Events', @(t,s) blowup_event_c(t,s,thresh), 'RelTol', 1e-6, 'AbsTol', 1e-8);
    [t, Y, te] = ode15s(odefun, [0 t_end], zeros(5,1), opts);
    blew = ~isempty(te);
end

function ds = closed_loop_ode_c(~, s, ke, b0, k1, k2, l1, l2, l3)
    p1=s(1); p2=s(2); xh1=s(3); xh2=s(4); xh3=s(5);
    r = 1; rdot = 0; rddot = 0;
    u0 = k1*(r-xh1) + k2*(rdot-xh2) + rddot;
    u  = (u0 - xh3)/b0;
    e_y = p1 - xh1;
    
    ds = [p2;
          100*p2 - 160*p1 + ke*u;
          xh2 + l1*e_y;
          xh3 + b0*u + l2*e_y;
          l3*e_y];
end

function [value, isterminal, direction] = blowup_event_c(~, s, thresh)
    value = thresh - abs(s(1));
    isterminal = 1; 
    direction = 0;
end