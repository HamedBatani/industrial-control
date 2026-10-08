%set up
mdl = 'ladrc_model';
load_system(mdl);

save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFiles\SimulationFigures\Q1\a\a_2';
if ~exist(save_dir, 'dir'), mkdir(save_dir); end

K = 1;
T_values  = [1, 0.1, 10];
k_ob_vals = [100, 10, 5];
fig_labels   = {'a','c','e'};
fig_labels_u = {'b','d','f'};

% i tried matching colors with original figures for easier grading 
color_1   = 'k';          % T=1    black
color_01  = 'b';          % T=0.1  blue
color_10  = [0.8 0.8 0];  % T=10   yellow

colors = {color_1, color_01, color_10};

for ki = 1:length(k_ob_vals)
    assignin('base', 'k_ob_const', k_ob_vals(ki));

    fig = figure('Name', sprintf('k_ob=%d', k_ob_vals(ki)), ...
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

        % plot y
        subplot(1, 2, 1); hold on; grid on;
        plot(out.tout, out.y_out, ...
             'Color', c, 'LineWidth', lw, ...
             'DisplayName', ['T = ', num2str(T)]);

        % plot u
        subplot(1, 2, 2); hold on; grid on;
        plot(out.tout, out.u_out, ...
             'Color', c, 'LineWidth', lw, ...
             'DisplayName', ['T = ', num2str(T)]);
    end

    % Format y subplot
    subplot(1, 2, 1);
    plot([0 2], [1 1], 'k:', 'HandleVisibility', 'off');
    title(['(', fig_labels{ki}, ')']);
    xlabel('t'); ylabel('y');
    axis([0 2 0 1.4]);
    legend('Location', 'southeast', 'FontSize', 7);

    % Format u subplot
    subplot(1, 2, 2);
    title(['(', fig_labels_u{ki}, ')']);
    xlabel('t'); ylabel('u');
    legend('Location', 'northeast', 'FontSize', 7);

   
end

