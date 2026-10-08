% set up
mdl = 'ladrc_model_2nd';
load_system(mdl);

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\b\b_2';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

% fixed nominal parameters
assignin('base', 'K', 1);
assignin('base', 'D', 1);
assignin('base', 'T_dead',     0);
assignin('base', 'T_dead_ESO', 0);
assignin('base', 'Kd', 0);

% i tried matching colors with original figures for easier grading
color_nom = 'k'; lw_nom = 2.5;
color_low = 'b'; lw_low = 1.0;
color_hi  = 'r'; lw_hi  = 1.0;

T_values     = [1, 0.5, 3.5];
colors       = {color_nom, color_low, color_hi};
lws          = [lw_nom, lw_low, lw_hi];

k_ob_vals    = [100, 10, 5];
fig_labels   = {'a','c','e'};
fig_labels_u = {'b','d','f'};

for ki = 1:length(k_ob_vals)
    assignin('base', 'k_ob_const', k_ob_vals(ki));

    fig = figure('Name', sprintf('Fig12 k_ob=%d', k_ob_vals(ki)), ...
                 'Position', [100,100,900,400]);

    for ti = 1:length(T_values)
        assignin('base', 'T', T_values(ti));

        % run
        out = sim(mdl, 'StopTime', '15.0');

        subplot(1,2,1); hold on; grid on;
        plot(out.tout, out.y_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
             'DisplayName', ['T = ', num2str(T_values(ti))]);

        subplot(1,2,2); hold on; grid on;
        plot(out.tout, out.u_out, 'Color', colors{ti}, 'LineWidth', lws(ti), ...
             'DisplayName', ['T = ', num2str(T_values(ti))]);
    end

    subplot(1,2,1);
    plot([0 15],[1 1],'k:','HandleVisibility','off');
    title(['(', fig_labels{ki}, ') s^{ESO}=', num2str(k_ob_vals(ki)), 's^{CL}']);
    xlabel('t'); ylabel('y');
    axis([0 15 0 1.4]); legend('Location','southeast','FontSize',7);

    subplot(1,2,2);
    title(['(', fig_labels_u{ki}, ')']);
    xlabel('t'); ylabel('u');
    legend('Location','northeast','FontSize',7);

    % code to save the figure would go here
    fname = fullfile(save_dir, sprintf('Fig12_%s%s.jpg', fig_labels{ki}, fig_labels_u{ki}));
    exportgraphics(fig, fname, 'Resolution', 150);
    fprintf('Saved: %s\n', fname);
end

fprintf('All Fig12 figures saved.\n');