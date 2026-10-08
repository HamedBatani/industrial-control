% Setup
mdl = 'ladrc_model';
load_system(mdl);

% Fixed Nominal Parameters
K = 1; T = 1;
assignin('base', 'K', K);
assignin('base', 'T', T);

% Disable dead time from previous parts
assignin('base', 'T_dead', 0);
assignin('base', 'T_dead_ESO', 0);

% Define T2 values and colors matching Fig 8 
% (Using 0.001 instead of 0 to match paper and avoid strict properness/divide-by-zero warnings)
T2_vals = [0.001, 0.05];
colors = {'k', 'g'}; % Black for 0.001, Green for 0.05
line_names = {'T_2 = 0.001', 'T_2 = 0.05'};

%% --- Figure 1: sESO = 2 (Replicating Fig 8) ---
assignin('base', 'k_ob_const', 2);
fig1 = figure('Name', 'Part 5: Structural Uncertainty (sESO = 2)', ...
              'Position', [100, 500, 900, 400]);

for i = 1:length(T2_vals)
    assignin('base', 'T2', T2_vals(i));
    out = sim(mdl, 'StopTime', '2.0');
    
    % Plot Output (y)
    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, colors{i}, 'LineWidth', 1.5, ...
         'DisplayName', line_names{i});
     
    % Plot Control Effort (u)
    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, colors{i}, 'LineWidth', 1.5, ...
         'DisplayName', line_names{i});
end

% Format Fig 1
subplot(1,2,1);
plot([0 2],[1 1],'k:','HandleVisibility','off'); % Reference line
title('(a) y for s^{ESO} = 2 s^{CL}'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]); legend('Location','southeast');

subplot(1,2,2);
title('(b) u for s^{ESO} = 2 s^{CL}'); xlabel('t'); ylabel('u');
axis([0 2 0 4]); legend('Location','northeast');


%% --- Figure 2: sESO = 5 (Checking higher bandwidth) ---
assignin('base', 'k_ob_const', 5);
fig2 = figure('Name', 'Part 5: Structural Uncertainty (sESO = 5)', ...
              'Position', [100, 50, 900, 400]);

for i = 1:length(T2_vals)
    assignin('base', 'T2', T2_vals(i));
    out = sim(mdl, 'StopTime', '2.0');
    
    % Plot Output (y)
    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, colors{i}, 'LineWidth', 1.5, ...
         'DisplayName', line_names{i});
     
    % Plot Control Effort (u)
    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, colors{i}, 'LineWidth', 1.5, ...
         'DisplayName', line_names{i});
end

% Format Fig 2
subplot(1,2,1);
plot([0 2],[1 1],'k:','HandleVisibility','off'); % Reference line
title('(a) y for s^{ESO} = 5 s^{CL}'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]); legend('Location','southeast');

subplot(1,2,2);
title('(b) u for s^{ESO} = 5 s^{CL}'); xlabel('t'); ylabel('u');
axis([0 2 0 5]); legend('Location','northeast');

% Define the target directory
save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\a\a_5';

% Create the folder structure if it doesn't exist yet
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

% Save Figure 1 (sESO = 2) as PNG and FIG
saveas(fig1, fullfile(save_dir, 'Structural_Uncertainty_sESO2.png'));
saveas(fig1, fullfile(save_dir, 'Structural_Uncertainty_sESO2.fig'));

% Save Figure 2 (sESO = 5) as PNG and FIG
saveas(fig2, fullfile(save_dir, 'Structural_Uncertainty_sESO5.png'));
saveas(fig2, fullfile(save_dir, 'Structural_Uncertainty_sESO5.fig'));

disp(['Figures successfully saved to: ', save_dir]);
