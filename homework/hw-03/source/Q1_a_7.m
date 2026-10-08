% Setup
mdl = 'ladrc_model'; % Change this to your actual Simulink file name
load_system(mdl);

% Process and PI Parameters
assignin('base', 'K', 1);
assignin('base', 'T', 1);
assignin('base', 'T_dead', 0);
assignin('base', 'T_dead_ESO', 0);
assignin('base', 'Kp_pi', 3.85);
assignin('base', 'Ki_pi', 3.85);

% ADRC Parameters
omega_c = 3.85; % Based on T_settle = 1
kob_vals = [2, 10, 20];
colors = {'r', 'b', 'k'};

y_adrc_all = cell(1, 3);
u_adrc_all = cell(1, 3);
t_out_all = cell(1, 3);

% Run simulations for different kob values
% Run simulations for different kob values
for i = 1:length(kob_vals)
    omega_o = kob_vals(i) * omega_c;
    assignin('base', 'omega_o', omega_o);
    
    % ADD THIS LINE to fix the error:
    assignin('base', 'k_ob_const', kob_vals(i)); 
    
    out = sim(mdl, 'StopTime', '6.0');
    t_out_all{i} = out.tout;
    
    % Handle timeseries vs array formats seamlessly
    if isa(out.y_out, 'timeseries'), y_adrc_all{i} = out.y_out.Data; else, y_adrc_all{i} = out.y_out; end
    if isa(out.u_out, 'timeseries'), u_adrc_all{i} = out.u_out.Data; else, u_adrc_all{i} = out.u_out; end
    
    % Get PI response once (it doesn't change with kob)
    if kob_vals(i) == 10
        if isa(out.y_pi_out, 'timeseries'), y_pi = out.y_pi_out.Data; else, y_pi = out.y_pi_out; end
        if isa(out.u_pi_out, 'timeseries'), u_pi = out.u_pi_out.Data; else, u_pi = out.u_pi_out; end
    end
end


%% Figure 1: Regenerate Figure 10 (Using kob = 10)
figure('Name', 'Figure 10 Replication', 'Position', [100, 100, 800, 350]);

subplot(1, 2, 1); hold on; grid on;
plot(t_out_all{2}, y_adrc_all{2}, 'b', 'LineWidth', 1.2);
plot(t_out_all{2}, y_pi, 'g', 'LineWidth', 1.2);
title('(a) Output response (y)'); xlabel('t'); ylabel('y');
axis([0 6 0 1.4]);
legend('ADRC', 'PI', 'Location', 'southeast');

subplot(1, 2, 2); hold on; grid on;
plot(t_out_all{2}, u_adrc_all{2}, 'b', 'LineWidth', 1.2);
plot(t_out_all{2}, u_pi, 'g', 'LineWidth', 1.2);
title('(b) Controller output (u)'); xlabel('t'); ylabel('u');
axis([0 6 -1 4]);
legend('ADRC', 'PI', 'Location', 'northeast');

%% Figure 2: Effect of kob on Disturbance Rejection
figure('Name', 'Effect of kob', 'Position', [150, 150, 800, 350]);

subplot(1, 2, 1); hold on; grid on;
for i = 1:length(kob_vals)
    plot(t_out_all{i}, y_adrc_all{i}, colors{i}, 'LineWidth', 1.2);
end
title('Effect of k_{ob} on y'); xlabel('t'); ylabel('y');
axis([0 6 0 1.4]);
legend('k_{ob}=2', 'k_{ob}=10', 'k_{ob}=20', 'Location', 'southeast');

subplot(1, 2, 2); hold on; grid on;
for i = 1:length(kob_vals)
    plot(t_out_all{i}, u_adrc_all{i}, colors{i}, 'LineWidth', 1.2);
end
title('Effect of k_{ob} on u'); xlabel('t'); ylabel('u');
axis([0 6 -1 4]);
legend('k_{ob}=2', 'k_{ob}=10', 'k_{ob}=20', 'Location', 'northeast');


% Define the target directory
saveDir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\a\a_7';

% Create the directory if it doesn't already exist
if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

% Save Figure 1 (Replication of Fig 10)
% (Assumes the figure is currently figure(1))
saveas(figure(1), fullfile(saveDir, 'Fig10_DisturbanceRejection.png'));
savefig(figure(1), fullfile(saveDir, 'Fig10_DisturbanceRejection.fig'));

% Save Figure 2 (Comparison of different k_ob values)
% (Assumes the figure is currently figure(2))
saveas(figure(2), fullfile(saveDir, 'Kob_Comparison.png'));
savefig(figure(2), fullfile(saveDir, 'Kob_Comparison.fig'));

disp(['Figures successfully saved to: ', saveDir]);
