% set up 
mdl = 'ladrc_model_2nd';
load_system(mdl);

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\b\b_3';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% fixed nominal parameters
assignin('base', 'T_dead',     0);
assignin('base', 'T_dead_ESO', 0);
assignin('base', 'k_ob_const', 10);
assignin('base', 'Kd', 0);

% PI parameters from paper: KI=0.51, KP=0.765
assignin('base', 'Kp_pi',  0.765);
assignin('base', 'Ki_pi',  0.51);
assignin('base', 'Kp', 0.765);
assignin('base', 'Ki', 0.51);

% PID parameters from paper in parallel form


% i tried matching colors with original figures for easier grading
color_nom = 'k'; lw_nom = 2.5;
color_low = 'b'; lw_low = 1.0;
color_hi  = 'r'; lw_hi  = 1.0;

%k 
assignin('base', 'D', 1);
assignin('base', 'T', 1);

fig1 = figure('Name','Fig16 abc - K variation','Position',[100,100,1200,400]);

K_values = [1, 0.2, 5];
colors_K = {color_nom, color_low, color_hi};
lws_K    = [lw_nom, lw_low, lw_hi];

for i = 1:length(K_values)
    assignin('base', 'K', K_values(i));

    % run
    out = sim(mdl, 'StopTime', '15.0');

    subplot(1,3,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors_K{i}, 'LineWidth', lws_K(i), ...
         'DisplayName', ['K=', num2str(K_values(i))]);

    subplot(1,3,2); hold on; grid on;
    plot(out.tout, out.y_pi_out, 'Color', colors_K{i}, 'LineWidth', lws_K(i), ...
         'DisplayName', ['K=', num2str(K_values(i))]);

    subplot(1,3,3); hold on; grid on;
    plot(out.tout, out.y_pid_out, 'Color', colors_K{i}, 'LineWidth', lws_K(i), ...
         'DisplayName', ['K=', num2str(K_values(i))]);
end

subplot(1,3,1);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(a) ADRC'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,3,2);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(b) PI'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,3,3);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(c) PID'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

fname = fullfile(save_dir, 'Fig16_abc.jpg');
exportgraphics(fig1, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

%d
assignin('base', 'K', 1);
assignin('base', 'T', 1);

fig2 = figure('Name','Fig16 def - D variation','Position',[100,100,1200,400]);

D_values = [1, 0.2, 5];
colors_D = {color_nom, color_low, color_hi};
lws_D    = [lw_nom, lw_low, lw_hi];

for i = 1:length(D_values)
    assignin('base', 'D', D_values(i));

    % run
    out = sim(mdl, 'StopTime', '15.0');

    subplot(1,3,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors_D{i}, 'LineWidth', lws_D(i), ...
         'DisplayName', ['D=', num2str(D_values(i))]);

    subplot(1,3,2); hold on; grid on;
    plot(out.tout, out.y_pi_out, 'Color', colors_D{i}, 'LineWidth', lws_D(i), ...
         'DisplayName', ['D=', num2str(D_values(i))]);

    subplot(1,3,3); hold on; grid on;
    plot(out.tout, out.y_pid_out, 'Color', colors_D{i}, 'LineWidth', lws_D(i), ...
         'DisplayName', ['D=', num2str(D_values(i))]);
end

subplot(1,3,1);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(d) ADRC'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,3,2);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(e) PI'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,3,3);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(f) PID'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

fname = fullfile(save_dir, 'Fig16_def.jpg');
exportgraphics(fig2, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

%t
assignin('base', 'K', 1);
assignin('base', 'D', 1);

fig3 = figure('Name','Fig16 ghi - T variation','Position',[100,100,1200,400]);

T_values = [1, 0.5, 3.5];
colors_T = {color_nom, color_low, color_hi};
lws_T    = [lw_nom, lw_low, lw_hi];

for i = 1:length(T_values)
    assignin('base', 'T', T_values(i));

    % run
    out = sim(mdl, 'StopTime', '15.0');

    subplot(1,3,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors_T{i}, 'LineWidth', lws_T(i), ...
         'DisplayName', ['T=', num2str(T_values(i))]);

    subplot(1,3,2); hold on; grid on;
    plot(out.tout, out.y_pi_out, 'Color', colors_T{i}, 'LineWidth', lws_T(i), ...
         'DisplayName', ['T=', num2str(T_values(i))]);

    subplot(1,3,3); hold on; grid on;
    plot(out.tout, out.y_pid_out, 'Color', colors_T{i}, 'LineWidth', lws_T(i), ...
         'DisplayName', ['T=', num2str(T_values(i))]);
end

subplot(1,3,1);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(g) ADRC'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,3,2);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(h) PI'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,3,3);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(i) PID'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

fname = fullfile(save_dir, 'Fig16_ghi.jpg');
exportgraphics(fig3, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

fprintf('All Fig16 figures saved.\n');