%set up
mdl = 'ladrc_model';
load_system(mdl);

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\a\a_4';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% fixed parameters
K = 1; T = 1;
assignin('base', 'K', K);
assignin('base', 'T', T);

T_dead_values = [0, 0.1];

% i tried matching colors with original figures for easier grading
color_0    = 'k';            % T_dead=0      black
color_01   = 'r';            % T_dead=0.1    red

colors = {color_0, color_01};
lws    = [2.5, 1.0];

%case 1: no ESO compensation, s_ESO = 2*s_CL (Fig7 a/b) 
assignin('base', 'k_ob_const', 2);
assignin('base', 'T_dead_ESO', 0);

fig1 = figure('Name', 'Fig7 ab - no ESO compensation', ...
              'Position', [100, 100, 900, 400]);

for ti = 1:length(T_dead_values)
    assignin('base', 'T_dead', T_dead_values(ti));

    % run
    out = sim(mdl, 'StopTime', '2.0');

    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);

    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);
end

subplot(1,2,1);
plot([0 2],[1 1],'k:','HandleVisibility','off');
title('(a)'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(b)'); xlabel('t'); ylabel('u');
axis([0 2 0 5]); legend('Location','northeast','FontSize',7);

fname = fullfile(save_dir, 'Fig7_ab.jpg');
exportgraphics(fig1, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

%case 2
assignin('base', 'k_ob_const', 2);
assignin('base', 'T_dead_ESO', 0.05);

fig2 = figure('Name', 'Fig7 cd - ESO compensation 0.05', ...
              'Position', [100, 100, 900, 400]);

for ti = 1:length(T_dead_values)
    assignin('base', 'T_dead', T_dead_values(ti));

    % run
    out = sim(mdl, 'StopTime', '2.0');

    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);

    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);
end

subplot(1,2,1);
plot([0 2],[1 1],'k:','HandleVisibility','off');
title('(c)'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(d)'); xlabel('t'); ylabel('u');
axis([0 2 0 5]); legend('Location','northeast','FontSize',7);

fname = fullfile(save_dir, 'Fig7_cd.jpg');
exportgraphics(fig2, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

%case 3
assignin('base', 'k_ob_const', 2);
assignin('base', 'T_dead_ESO', 0.1);

fig3 = figure('Name', 'Fig7 - ESO compensation 0.1', ...
              'Position', [100, 100, 900, 400]);

for ti = 1:length(T_dead_values)
    assignin('base', 'T_dead', T_dead_values(ti));

    % run
    out = sim(mdl, 'StopTime', '2.0');

    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);

    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);
end

subplot(1,2,1);
plot([0 2],[1 1],'k:','HandleVisibility','off');
title('(e) T^{ESO}_{dead}=0.1'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(f) T^{ESO}_{dead}=0.1'); xlabel('t'); ylabel('u');
axis([0 2 0 5]); legend('Location','northeast','FontSize',7);

fname = fullfile(save_dir, 'Fig7_ef_Tdead01.jpg');
exportgraphics(fig3, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

%case 4
assignin('base', 'k_ob_const', 5);
assignin('base', 'T_dead_ESO', 0);

fig4 = figure('Name', 'Fig7 - sESO=5', ...
              'Position', [100, 100, 900, 400]);

for ti = 1:length(T_dead_values)
    assignin('base', 'T_dead', T_dead_values(ti));

    % run
    out = sim(mdl, 'StopTime', '2.0');

    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);

    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
         'DisplayName', ['T_{dead} = ', num2str(T_dead_values(ti))]);
end

subplot(1,2,1);
plot([0 2],[1 1],'k:','HandleVisibility','off');
title('(g) s^{ESO}=5\cdots^{CL}'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(h) s^{ESO}=5\cdots^{CL}'); xlabel('t'); ylabel('u');
axis([0 2 0 5]); legend('Location','northeast','FontSize',7);

fname = fullfile(save_dir, 'Fig7_gh_sESO5.jpg');
exportgraphics(fig4, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

fprintf('All Fig7 figures saved.\n');
