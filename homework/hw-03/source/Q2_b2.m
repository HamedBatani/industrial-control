%% LADRC stability region
clear; clc;

% ---- tunable parameters (check these against the assignment) ----
T_settle = 1.0;        % settling-time spec used in pole placement
b0       = 1.0;        % plant input gain estimate

% ---- finer grid: a coarse grid hides the true tip of the region ----
ke_grid  = linspace(0.001, 6, 800);
kob_grid = linspace(1, 40, 800);

%% scan grid
STAB = false(numel(kob_grid), numel(ke_grid));

for i = 1:numel(kob_grid)
    [k1,k2,l1,l2,l3] = gains(T_settle, kob_grid(i));
    for j = 1:numel(ke_grid)
        STAB(i,j) = is_stable(ke_grid(j), k1,k2,l1,l2,l3, b0);
    end
end

%% find minimum kob that has any stable ke (the "tip")
min_kob = NaN;
for i = 1:numel(kob_grid)
    if any(STAB(i,:))
        min_kob = kob_grid(i);
        break;
    end
end
fprintf('Tip of stable region: kob = %.3f\n', min_kob);

%% plot stability region
[KE, KOB] = meshgrid(ke_grid, kob_grid);

figure; hold on;
% shade stable points
scatter(KE(STAB), KOB(STAB), 6, [0.2 0.6 1.0], 'filled');
xlabel('k_e'); ylabel('k_{ob}');
title('Stability region');
xlim([min(ke_grid) max(ke_grid)]);
ylim([min(kob_grid) max(kob_grid)]);
grid on; box on;

%% ---- helper functions ----
function [k1,k2,l1,l2,l3] = gains(T_settle, k_ob)
    s_CL  = -4/T_settle;
    s_ESO = k_ob*s_CL;
    k1 = s_CL^2;   k2 = -2*s_CL;
    l1 = -3*s_ESO;
    l2 =  3*s_ESO^2;
    l3 = -s_ESO^3;
end

function tf = is_stable(ke, k1,k2,l1,l2,l3, b0)
    M = [ 0      1     0          0      0;
         -160   100  -ke*k1/b0  -ke*k2/b0  -ke/b0;
          l1     0    -l1        1      0;
          l2     0   -(k1+l2)   -k2     0;
          l3     0    -l3        0      0];
    tf = all(real(eig(M)) < 0);
end
