% ============================================================
% KON429E Autonomous Vehicles - Homework 3
% Part (b): Stanley Gain Comparison and Signal Analysis
% ============================================================

clear; clc; close all;

% ------------------------------------------------------------
% Load parameters
% ------------------------------------------------------------
params_hw3;

% ------------------------------------------------------------
% Simulink model name
% ------------------------------------------------------------
modelName = 'hw3_model';   % kendi model adın farklıysa değiştir

% ------------------------------------------------------------
% Required Stanley gain values
% ------------------------------------------------------------
k_values = [0.1, 0.4, 1.0, 10.0];

% ------------------------------------------------------------
% Simulation settings
% ------------------------------------------------------------
Ts = 0.05;
Tfinal = 120;

% ------------------------------------------------------------
% Initial conditions
% ------------------------------------------------------------
psi0 = atan2(waypoints(2,2) - waypoints(1,2), ...
             waypoints(2,1) - waypoints(1,1));

% Final waypoint
xfinal = waypoints(end,1);
yfinal = waypoints(end,2);

% Storage structure
results = struct();

% ============================================================
% Run simulations for each Stanley gain
% ============================================================

for i = 1:length(k_values)

    k = k_values(i);

    fprintf('Running simulation for k = %.1f...\n', k);

    out = sim(modelName, 'StopTime', num2str(Tfinal));

    % --------------------------------------------------------
    % Extract trajectory logs
    % --------------------------------------------------------
    x_log = out.X_log;
    y_log = out.Y_log;

    if isa(x_log, 'timeseries')
        t = x_log.Time;
        x = x_log.Data;
        y = y_log.Data;
    else
        t = x_log(:,1);
        x = x_log(:,2);
        y = y_log(:,2);
    end

    % --------------------------------------------------------
    % Extract segment index
    % --------------------------------------------------------
    seg_log = out.seg_idx_log;

    if isa(seg_log, 'timeseries')
        seg_idx = seg_log.Data;
    else
        seg_idx = seg_log(:,2);
    end

    % --------------------------------------------------------
    % Extract cross-track error
    % --------------------------------------------------------
    e_log = out.e_front_log;

    if isa(e_log, 'timeseries')
        e_front = e_log.Data;
    else
        e_front = e_log(:,2);
    end

    % --------------------------------------------------------
    % Extract heading error
    % --------------------------------------------------------
    theta_log = out.theta_e_log;

    if isa(theta_log, 'timeseries')
        theta_e = theta_log.Data;
    else
        theta_e = theta_log(:,2);
    end

    % --------------------------------------------------------
    % Extract steering angle
    % --------------------------------------------------------
    delta_log = out.delta_log;

    if isa(delta_log, 'timeseries')
        delta = delta_log.Data;
    else
        delta = delta_log(:,2);
    end

    % --------------------------------------------------------
    % Truncate after reaching final waypoint
    % --------------------------------------------------------
    dist_final = sqrt((x - xfinal).^2 + (y - yfinal).^2);

    final_tol = 2.0; % [m]

    idx_final = find(seg_idx >= size(waypoints,1)-1 & dist_final < final_tol, ...
                     1, 'first');

    if isempty(idx_final)
        idx_plot = 1:length(x);
        fprintf('Warning: final waypoint was not detected for k = %.1f.\n', k);
    else
        idx_plot = 1:idx_final;
    end

    % --------------------------------------------------------
    % Store truncated results
    % --------------------------------------------------------
    results(i).k = k;
    results(i).t = t(idx_plot);
    results(i).x = x(idx_plot);
    results(i).y = y(idx_plot);
    results(i).seg_idx = seg_idx(idx_plot);
    results(i).e_front = e_front(idx_plot);
    results(i).theta_e = theta_e(idx_plot);
    results(i).delta = delta(idx_plot);

    % --------------------------------------------------------
    % Performance metrics
    % --------------------------------------------------------
    results(i).mean_abs_e = mean(abs(results(i).e_front));
    results(i).rms_e = sqrt(mean(results(i).e_front.^2));
    results(i).max_abs_e = max(abs(results(i).e_front));

    results(i).mean_abs_theta = mean(abs(results(i).theta_e));
    results(i).rms_theta = sqrt(mean(results(i).theta_e.^2));
    results(i).max_abs_theta = max(abs(results(i).theta_e));

    results(i).mean_abs_delta = mean(abs(results(i).delta));
    results(i).max_abs_delta = max(abs(results(i).delta));

    % ========================================================
    % Separate trajectory plot for each gain
    % ========================================================
    figure;
    plot(waypoints(:,1), waypoints(:,2), 'ko--', 'LineWidth', 1.2);
    hold on;
    plot(results(i).x, results(i).y, 'b', 'LineWidth', 1.8);

    grid on;
    axis equal;
    xlabel('X [m]');
    ylabel('Y [m]');
    title(sprintf('Stanley Path Tracking Result, k = %.1f', k));
    legend('Waypoint Path', 'Vehicle Trajectory', 'Location', 'best');

end

% ============================================================
% Combined trajectory comparison plot
% ============================================================

figure;
plot(waypoints(:,1), waypoints(:,2), 'ko--', 'LineWidth', 1.2);
hold on;

for i = 1:length(k_values)
    plot(results(i).x, results(i).y, 'LineWidth', 1.8);
end

grid on;
axis equal;
xlabel('X [m]');
ylabel('Y [m]');
title('Stanley Path Tracking Comparison for Different Gain Values');

legend_entries = [{'Waypoint Path'}, ...
    arrayfun(@(val) sprintf('k = %.1f', val), k_values, 'UniformOutput', false)];

legend(legend_entries, 'Location', 'best');

% ============================================================
% Cross-track error comparison
% ============================================================

figure;
hold on;

for i = 1:length(k_values)
    plot(results(i).t, results(i).e_front, 'LineWidth', 1.5);
end

grid on;
xlabel('Time [s]');
ylabel('e_{front} [m]');
title('Front Axle Cross-Track Error for Different Stanley Gains');
legend(arrayfun(@(val) sprintf('k = %.1f', val), k_values, 'UniformOutput', false), ...
       'Location', 'best');

% ============================================================
% Absolute cross-track error comparison
% ============================================================

figure;
hold on;

for i = 1:length(k_values)
    plot(results(i).t, abs(results(i).e_front), 'LineWidth', 1.5);
end

grid on;
xlabel('Time [s]');
ylabel('|e_{front}| [m]');
title('Absolute Cross-Track Error for Different Stanley Gains');
legend(arrayfun(@(val) sprintf('k = %.1f', val), k_values, 'UniformOutput', false), ...
       'Location', 'best');

% ============================================================
% Heading error comparison
% ============================================================

figure;
hold on;

for i = 1:length(k_values)
    plot(results(i).t, results(i).theta_e, 'LineWidth', 1.5);
end

grid on;
xlabel('Time [s]');
ylabel('\theta_e [rad]');
title('Heading Error for Different Stanley Gains');
legend(arrayfun(@(val) sprintf('k = %.1f', val), k_values, 'UniformOutput', false), ...
       'Location', 'best');

% ============================================================
% Steering angle comparison
% ============================================================

figure;
hold on;

for i = 1:length(k_values)
    plot(results(i).t, results(i).delta, 'LineWidth', 1.5);
end

yline(0.5236, '--', 'Upper Steering Limit');
yline(-0.5236, '--', 'Lower Steering Limit');

grid on;
xlabel('Time [s]');
ylabel('\delta [rad]');
title('Steering Angle Command for Different Stanley Gains');
legend(arrayfun(@(val) sprintf('k = %.1f', val), k_values, 'UniformOutput', false), ...
       'Location', 'best');

% ============================================================
% Segment index comparison
% ============================================================

figure;
hold on;

for i = 1:length(k_values)
    stairs(results(i).t, results(i).seg_idx, 'LineWidth', 1.5);
end

grid on;
xlabel('Time [s]');
ylabel('Active Segment Index');
title('Active Segment Index for Different Stanley Gains');
legend(arrayfun(@(val) sprintf('k = %.1f', val), k_values, 'UniformOutput', false), ...
       'Location', 'best');

% ============================================================
% Print performance table
% ============================================================

fprintf('\n================ STANLEY GAIN COMPARISON ================\n');
fprintf(' k     Mean|e|     RMS e     Max|e|    Mean|theta|  RMS theta  Max|theta|  Mean|delta| Max|delta|\n');
fprintf('-------------------------------------------------------------------------------------------------\n');

for i = 1:length(k_values)
    fprintf('%4.1f   %8.4f   %8.4f   %8.4f    %10.4f  %9.4f  %10.4f   %10.4f  %9.4f\n', ...
        results(i).k, ...
        results(i).mean_abs_e, ...
        results(i).rms_e, ...
        results(i).max_abs_e, ...
        results(i).mean_abs_theta, ...
        results(i).rms_theta, ...
        results(i).max_abs_theta, ...
        results(i).mean_abs_delta, ...
        results(i).max_abs_delta);
end

fprintf('=================================================================================================\n');