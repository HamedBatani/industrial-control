% Q1_a_3 - Fig6 parts c and d - Actuator Saturation effect, varying T
%% Fig6cd - Saturation effect on ADRC with Varying T
mdl = 'ladrc_model';
load_system(mdl);

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\a\a_3';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% fixed parameters
K = 1;
assignin('base', 'k_ob_const', 10);

T_values = [1, 0.1, 10];

% i tried matching colors with original figures for easier grading
color_1   = 'k';          % T=1    black
color_01  = 'b';          % T=0.1  blue
color_10  = [0.8 0.8 0];  % T=10   yellow

fig = figure('Name', 'Fig6 cd - Saturation Varying T', ...
             'Position', [100, 100, 900, 400]);

for ti = 1:length(T_values)
    T = T_values(ti);
    assignin('base', 'K', K);
    assignin('base', 'T', T);

    if T == 1
        c = color_1;  lw = 2.5;
    elseif T == 0.1
        c = color_01; lw = 1.0;
    elseif T == 10
        c = color_10; lw = 1.0;
    end

    % run
    out = sim(mdl, 'StopTime', '2.0');

    % plot y subplot (c)
    subplot(1, 2, 1); hold on; grid on;
    plot(out.tout, out.y_out, ...
         'Color', c, 'LineWidth', lw, ...
         'DisplayName', ['T = ', num2str(T)]);

    % plot u subplot (d) - saturated (solid) and unsaturated (dashed)
    subplot(1, 2, 2); hold on; grid on;
    plot(out.tout, out.u_out, ...
         'Color', c, 'LineWidth', lw, ...
         'DisplayName', ['T = ', num2str(T)]);
    plot(out.tout, out.u_unsat, ...
         'Color', c, 'LineWidth', 1.0, ...
         'LineStyle', '--', 'HandleVisibility', 'off');
end

% Format y subplot (c)
subplot(1, 2, 1);
plot([0 2], [1 1], 'k:', 'HandleVisibility', 'off');
title('(c)'); xlabel('t'); ylabel('y');
axis([0 2 0 1.4]);
legend('Location', 'southeast', 'FontSize', 7);

% Format u subplot (d)
subplot(1, 2, 2);
plot([0 2], [5 5],  'k--', 'LineWidth', 1.0, 'HandleVisibility', 'off');
plot([0 2], [-5 -5],'k--', 'LineWidth', 1.0, 'HandleVisibility', 'off');
title('(d)'); xlabel('t'); ylabel('u');
axis([0 2 -2 10]);
legend('Location', 'northeast', 'FontSize', 7);

% Code to save the figure would go here
fname = fullfile(save_dir, 'Fig6_cd.jpg');
exportgraphics(fig, fname, 'Resolution', 150);
fprintf('Saved: %s\n', fname);