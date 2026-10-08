%set up 
load_system(mdl);

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\b\b_4';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% fixed nominal parameters
assignin('base', 'K', 1);
assignin('base', 'D', 1);
assignin('base', 'T', 1);
assignin('base', 'T_dead',     0);
assignin('base', 'T_dead_ESO', 0);
assignin('base', 'Kd', 0);


% PI from paper
assignin('base', 'Kp_pi', 0.765);
assignin('base', 'Ki_pi', 0.51);
assignin('base', 'Kp', 0.765);
assignin('base', 'Ki', 0.51);
% PID parameters from paper


assignin('base', 'k_ob_const', 10);

% run
out = sim(mdl, 'StopTime', '35.0');

fig1 = figure('Name','Fig17 - Disturbance Rejection','Position',[100,100,900,400]);

subplot(1,2,1); hold on; grid on;
plot(out.tout, out.y_out,     'b', 'LineWidth', 1.5, 'DisplayName', 'ADRC');
plot(out.tout, out.y_pi_out,  'g', 'LineWidth', 1.5, 'DisplayName', 'PI');
plot(out.tout, out.y_pid_out, 'r', 'LineWidth', 1.5, 'DisplayName', 'PID');
plot([0 35],[1 1],'k:','HandleVisibility','off');
title('(a)'); xlabel('t'); ylabel('y');
axis([0 35 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2); hold on; grid on;
plot(out.tout, out.u_out,     'b', 'LineWidth', 1.5, 'DisplayName', 'ADRC');
plot(out.tout, out.u_pi_out,  'g', 'LineWidth', 1.5, 'DisplayName', 'PI');
plot(out.tout, out.u_pid_out, 'r', 'LineWidth', 1.5, 'DisplayName', 'PID');
title('(b)'); xlabel('t'); ylabel('u');
axis([0 35 0 3]); legend('Location','northeast','FontSize',7);

% code  to save the figure would go here
fname = fullfile(save_dir, 'Fig17_DisturbanceRejection.jpg');
exportgraphics(fig1, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

kob_vals = [2, 10, 20];
colors   = {'r', 'b', 'k'};

y_adrc_all = cell(1,3);
u_adrc_all = cell(1,3);
t_out_all  = cell(1,3);

for i = 1:length(kob_vals)
    assignin('base', 'k_ob_const', kob_vals(i));

    % run
    out = sim(mdl, 'StopTime', '35.0');

    t_out_all{i}  = out.tout;
    y_adrc_all{i} = out.y_out;
    u_adrc_all{i} = out.u_out;
end

fig2 = figure('Name','Fig17 - kob effect','Position',[100,100,900,400]);

subplot(1,2,1); hold on; grid on;
for i = 1:length(kob_vals)
    plot(t_out_all{i}, y_adrc_all{i}, colors{i}, 'LineWidth', 1.5, ...
         'DisplayName', ['k_{ob}=', num2str(kob_vals(i))]);
end
plot([0 35],[1 1],'k:','HandleVisibility','off');
title('(c) Effect of k_{ob} on y'); xlabel('t'); ylabel('y');
axis([0 35 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2); hold on; grid on;
for i = 1:length(kob_vals)
    plot(t_out_all{i}, u_adrc_all{i}, colors{i}, 'LineWidth', 1.5, ...
         'DisplayName', ['k_{ob}=', num2str(kob_vals(i))]);
end
title('(d) Effect of k_{ob} on u'); xlabel('t'); ylabel('u');
axis([0 35 0 3]); legend('Location','northeast','FontSize',7);

% code to save the figure would go here
fname = fullfile(save_dir, 'Kob_Comparison_Fig17.jpg');
exportgraphics(fig2, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

fprintf('All Fig17 figures saved.\n');