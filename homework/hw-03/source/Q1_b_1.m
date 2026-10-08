% set up 
mdl = 'ladrc_model_2nd';
load_system(mdl);

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\b\b_1';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% fixed nominal parameters
assignin('base', 'T_dead',     0);
assignin('base', 'T_dead_ESO', 0);
assignin('base', 'k_ob_const', 10);
assignin('base', 'Kd', 0);

% i tried matching colors with original figures for easier grading
color_nom = 'k'; lw_nom = 2.5;
color_low = 'b'; lw_low = 1.0;
color_hi  = 'r'; lw_hi  = 1.0;

%variation of K 
assignin('base', 'D', 1);
assignin('base', 'T', 1);

fig1 = figure('Name','Fig11 ab - K variation','Position',[100,100,900,400]);

K_values = [1, 0.1, 5];
colors_K = {color_nom, color_low, color_hi};
lws_K    = [lw_nom, lw_low, lw_hi];

for i = 1:length(K_values)
    assignin('base', 'K', K_values(i));

    % run
    out = sim(mdl, 'StopTime', '15.0');

    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors_K{i}, 'LineWidth', lws_K(i), ...
         'DisplayName', ['K = ', num2str(K_values(i))]);

    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', colors_K{i}, 'LineWidth', lws_K(i), ...
         'DisplayName', ['K = ', num2str(K_values(i))]);
end

subplot(1,2,1);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(a)'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(b)'); xlabel('t'); ylabel('u');
axis([0 15 -5 15]); legend('Location','northeast','FontSize',7);

fname = fullfile(save_dir, 'Fig11_ab.jpg');
exportgraphics(fig1, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

%variation of d
assignin('base', 'K', 1);
assignin('base', 'T', 1);

fig2 = figure('Name','Fig11 cd - D variation','Position',[100,100,900,400]);

D_values = [1, 0.1, 10];
colors_D = {color_nom, color_low, color_hi};
lws_D    = [lw_nom, lw_low, lw_hi];

for i = 1:length(D_values)
    assignin('base', 'D', D_values(i));

    % run
    out = sim(mdl, 'StopTime', '15.0');

    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors_D{i}, 'LineWidth', lws_D(i), ...
         'DisplayName', ['D = ', num2str(D_values(i))]);

    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', colors_D{i}, 'LineWidth', lws_D(i), ...
         'DisplayName', ['D = ', num2str(D_values(i))]);
end

subplot(1,2,1);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(c)'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(d)'); xlabel('t'); ylabel('u');
axis([0 15 0 6]); legend('Location','northeast','FontSize',7);

fname = fullfile(save_dir, 'Fig11_cd.jpg');
exportgraphics(fig2, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

% varation t
assignin('base', 'K', 1);
assignin('base', 'D', 1);

fig3 = figure('Name','Fig11 ef - T variation','Position',[100,100,900,400]);

T_values = [1, 0.5, 3.5];
colors_T = {color_nom, color_low, color_hi};
lws_T    = [lw_nom, lw_low, lw_hi];

for i = 1:length(T_values)
    assignin('base', 'T', T_values(i));

    % run
    out = sim(mdl, 'StopTime', '15.0');

    subplot(1,2,1); hold on; grid on;
    plot(out.tout, out.y_out, 'Color', colors_T{i}, 'LineWidth', lws_T(i), ...
         'DisplayName', ['T = ', num2str(T_values(i))]);

    subplot(1,2,2); hold on; grid on;
    plot(out.tout, out.u_out, 'Color', colors_T{i}, 'LineWidth', lws_T(i), ...
         'DisplayName', ['T = ', num2str(T_values(i))]);
end

subplot(1,2,1);
plot([0 15],[1 1],'k:','HandleVisibility','off');
title('(e)'); xlabel('t'); ylabel('y');
axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

subplot(1,2,2);
title('(f)'); xlabel('t'); ylabel('u');
axis([0 15 -2 6]); legend('Location','northeast','FontSize',7);

fname = fullfile(save_dir, 'Fig11_ef.jpg');
exportgraphics(fig3, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);

fprintf('All Fig11 figures saved.\n');