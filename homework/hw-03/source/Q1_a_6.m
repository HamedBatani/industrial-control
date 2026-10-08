%set up 
K_nom = 1;
T_nom = 1;
T_dead = 0;
T_dead_ESO = 0;

% ADRC Parameters 
T_settle = 1;
b0 = K_nom / T_nom; 
k_ob_const = 10; 
omega_c = 3.85 / T_settle; 
omega_o = 10 * omega_c; 

% PI Parameters 
Kp = 3.85;
Ki = 3.85;

% Push fixed parameters to base workspace
assignin('base', 'T_dead', T_dead);
assignin('base', 'T_dead_ESO', T_dead_ESO);
assignin('base', 'b0', b0);
assignin('base', 'k_ob_const', k_ob_const);
assignin('base', 'omega_c', omega_c);
assignin('base', 'omega_o', omega_o);
assignin('base', 'Kp', Kp);
assignin('base', 'Ki', Ki);

% 2. Setup Variations
K_vals = [1, 0.2, 5];
T_vals = [1, 0.2, 5];
colors = {'k', 'g', 'm'}; % Colors for 1, 0.2, 5

mdl = 'ladrc_model';
load_system(mdl);

figure('Name', 'Figure 9 Regeneration', 'Position', [100, 100, 900, 700]);

% 3. Part (a) and (b): 
for i = 1:length(K_vals)
    assignin('base', 'K', K_vals(i));
    assignin('base', 'T', T_nom); % Fixed to nominal
    
    out = sim(mdl);
    t_sim = out.tout;
    
    % extract ADRC
    if isprop(out, 'y')
        if isa(out.y, 'timeseries'), t_adrc = out.y.Time; y_adrc = out.y.Data; else, t_adrc = t_sim; y_adrc = out.y; end
    else
        if isa(out.y_out, 'timeseries'), t_adrc = out.y_out.Time; y_adrc = out.y_out.Data; else, t_adrc = t_sim; y_adrc = out.y_out; end
    end
    
    % Extract PI
    if isprop(out, 'y_pi')
        if isa(out.y_pi, 'timeseries'), t_pi = out.y_pi.Time; y_pi = out.y_pi.Data; else, t_pi = t_sim; y_pi = out.y_pi; end
    else
        if isa(out.y_pi_out, 'timeseries'), t_pi = out.y_pi_out.Time; y_pi = out.y_pi_out.Data; else, t_pi = t_sim; y_pi = out.y_pi_out; end
    end
    
    % plot (a ) Variation of K, ADRC
    subplot(2,2,1); hold on; grid on;
    plot(t_adrc, y_adrc, 'Color', colors{i}, 'LineWidth', 1.5, 'DisplayName', sprintf('K = %g', K_vals(i)));
    
    % Plot ( b) Variation of K  , PI
    subplot(2,2,2); hold on; grid on;
    plot(t_pi, y_pi, 'Color', colors{i}, 'LineWidth', 1.5, 'DisplayName', sprintf('K = %g', K_vals(i)));
end

% 4. Part (c) and (d): Variation of T 
for i = 1:length(T_vals)
    assignin('base', 'K', K_nom); % Fixed to nominal
    assignin('base', 'T', T_vals(i));
    
    out = sim(mdl);
    t_sim = out.tout;
    
    % Extract ADRC
    if isprop(out, 'y')
        if isa(out.y, 'timeseries'), t_adrc = out.y.Time; y_adrc = out.y.Data; else, t_adrc = t_sim; y_adrc = out.y; end
    else
        if isa(out.y_out, 'timeseries'), t_adrc = out.y_out.Time; y_adrc = out.y_out.Data; else, t_adrc = t_sim; y_adrc = out.y_out; end
    end
    
    % extract PI
    if isprop(out, 'y_pi')
        if isa(out.y_pi, 'timeseries'), t_pi = out.y_pi.Time; y_pi = out.y_pi.Data; else, t_pi = t_sim; y_pi = out.y_pi; end
    else
        if isa(out.y_pi_out, 'timeseries'), t_pi = out.y_pi_out.Time; y_pi = out.y_pi_out.Data; else, t_pi = t_sim; y_pi = out.y_pi_out; end
    end
    
    % Plot ( c) Variation of T , ADRC
    subplot(2,2,3); hold on; grid on;
    plot(t_adrc, y_adrc, 'Color', colors{i}, 'LineWidth', 1.5, 'DisplayName', sprintf('T = %g', T_vals(i)));
    
    % plot (d) Variation of T, PI
    subplot(2,2,4); hold on; grid on;
    plot(t_pi, y_pi, 'Color', colors{i}, 'LineWidth', 1.5, 'DisplayName', sprintf('T = %g', T_vals(i)));
end

% 5. Formatting
% Subplot 1 (a)
subplot(2,2,1); title('(a) Variation of K, ADRC'); xlabel('t'); ylabel('y');
plot([0 3], [1 1], 'k:', 'HandleVisibility', 'off'); xlim([0 3]); ylim([0 1.4]); legend('Location','best');

% Subplot 2 (b)
subplot(2,2,2); title('(b) Variation of K, PI'); xlabel('t'); ylabel('y');
plot([0 3], [1 1], 'k:', 'HandleVisibility', 'off'); xlim([0 3]); ylim([0 1.4]); legend('Location','best');

% Subplot 3 (c)
subplot(2,2,3); title('(c) Variation of T, ADRC'); xlabel('t'); ylabel('y');
plot([0 2], [1 1], 'k:', 'HandleVisibility', 'off'); xlim([0 2]); ylim([0 1.4]); legend('Location','best');

% Subplot 4 (d)
subplot(2,2,4); title('(d) Variation of T, PI'); xlabel('t'); ylabel('y');
plot([0 2], [1 1], 'k:', 'HandleVisibility', 'off'); xlim([0 2]); ylim([0 1.4]); legend('Location','best');

% Define the target directory
save_dir = 'C:\Users\Asus\OneDrive\Desktop\EE_Archive\6th_semester\IndurstialControl\HWs\HW3\SimulationFigures\Q1\a\a_6';

% Create the directory if it doesn't exist
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

% Save the current figure (gcf) as both PNG and FIG formats
file_name_png = fullfile(save_dir, 'Figure9_Robustness_Sweep.png');
file_name_fig = fullfile(save_dir, 'Figure9_Robustness_Sweep.fig');

saveas(gcf, file_name_png);
saveas(gcf, file_name_fig);

disp(['Figures successfully saved to: ', save_dir]);
