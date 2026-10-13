%% EKF Post-Processing for Simulink Output Object
clc; close all;

%% Load original data
load("hw2_ekf_data.mat");

%% Extract Simulink logs
t_sim = out.tout;

x_est_raw = out.x_hat_log;
P_raw     = out.P_log;

%% Format x_hat_log
% Expected possible formats:
% 3 x N, N x 3, or 3 x 1 x N

x_est_raw = squeeze(x_est_raw);

if size(x_est_raw,1) == 3
    x_est = x_est_raw;
elseif size(x_est_raw,2) == 3
    x_est = x_est_raw';
else
    error("Unexpected x_hat_log size: %s", mat2str(size(x_est_raw)));
end

%% Format P_log
% Expected possible formats:
% 3 x 3 x N, N x 3 x 3, N x 9, or 9 x N

P_raw = squeeze(P_raw);

if ndims(P_raw) == 3
    if size(P_raw,1) == 3 && size(P_raw,2) == 3
        P_est = P_raw;                  % 3 x 3 x N
    elseif size(P_raw,2) == 3 && size(P_raw,3) == 3
        P_est = permute(P_raw, [2 3 1]); % N x 3 x 3 -> 3 x 3 x N
    else
        error("Unexpected P_log 3D size: %s", mat2str(size(P_raw)));
    end
elseif ismatrix(P_raw)
    if size(P_raw,2) == 9
        % N x 9
        P_est = zeros(3,3,size(P_raw,1));
        for k = 1:size(P_raw,1)
            P_est(:,:,k) = reshape(P_raw(k,:), [3,3]);
        end
    elseif size(P_raw,1) == 9
        % 9 x N
        P_est = zeros(3,3,size(P_raw,2));
        for k = 1:size(P_raw,2)
            P_est(:,:,k) = reshape(P_raw(:,k), [3,3]);
        end
    else
        error("Unexpected P_log matrix size: %s", mat2str(size(P_raw)));
    end
else
    error("Unsupported P_log format.");
end

%% Match lengths
N_true = size(x_true, 2);
N_est  = size(x_est, 2);
N_cov  = size(P_est, 3);
N_time = length(t_sim);

N = min([N_true, N_est, N_cov, N_time]);

x_true_plot = x_true(:,1:N);
z_meas_plot = z_meas(:,1:N);
x_est_plot  = x_est(:,1:N);
P_plot      = P_est(:,:,1:N);
t_plot      = t_sim(1:N);

%% 2D Trajectory Plot with Uncertainty Ellipses
figure;
hold on; grid on; axis equal;

plot(x_true_plot(1,:), x_true_plot(2,:), 'b-', 'LineWidth', 2);
plot(z_meas_plot(1,:), z_meas_plot(2,:), 'r.', 'MarkerSize', 10);
plot(x_est_plot(1,:), x_est_plot(2,:), 'g-', 'LineWidth', 2);

ellipse_indices = round(linspace(1, N, 8));

for idx = ellipse_indices
    mu = x_est_plot(1:2, idx);
    Sigma = P_plot(1:2,1:2,idx);
    plot_uncertainty_ellipse(mu, Sigma, 2.0);
end

xlabel('p_x [m]');
ylabel('p_y [m]');
title('2D Trajectory with EKF Estimate and Uncertainty Ellipses');
legend('Ground Truth', 'Noisy GPS Measurements', 'EKF Estimate', ...
       'Uncertainty Ellipses', 'Location', 'best');

%% Heading Angle Plot
figure;
hold on; grid on;

plot(t_plot, x_true_plot(3,:), 'b-', 'LineWidth', 2);
plot(t_plot, x_est_plot(3,:), 'g-', 'LineWidth', 2);

xlabel('Time [s]');
ylabel('\theta [rad]');
title('Heading Angle Estimation');
legend('Ground Truth \theta', 'EKF Estimated \theta', 'Location', 'best');

%% Position and heading error plots
pos_error = sqrt((x_true_plot(1,:) - x_est_plot(1,:)).^2 + ...
                 (x_true_plot(2,:) - x_est_plot(2,:)).^2);

theta_error = wrapToPiLocal(x_true_plot(3,:) - x_est_plot(3,:));

figure;
plot(t_plot, pos_error, 'LineWidth', 2);
grid on;
xlabel('Time [s]');
ylabel('Position Error [m]');
title('EKF Position Error');

figure;
plot(t_plot, theta_error, 'LineWidth', 2);
grid on;
xlabel('Time [s]');
ylabel('Heading Error [rad]');
title('EKF Heading Error');

%% Numerical performance metrics
rmse_px = sqrt(mean((x_true_plot(1,:) - x_est_plot(1,:)).^2));
rmse_py = sqrt(mean((x_true_plot(2,:) - x_est_plot(2,:)).^2));
rmse_pos = sqrt(mean(pos_error.^2));
rmse_theta = sqrt(mean(theta_error.^2));

fprintf("\n===== EKF PERFORMANCE METRICS =====\n");
fprintf("RMSE px       = %.4f m\n", rmse_px);
fprintf("RMSE py       = %.4f m\n", rmse_py);
fprintf("RMSE position = %.4f m\n", rmse_pos);
fprintf("RMSE theta    = %.4f rad\n", rmse_theta);

%% Local functions

function plot_uncertainty_ellipse(mu, Sigma, n_sigma)
    Sigma = (Sigma + Sigma')/2;

    [V,D] = eig(Sigma);

    angle = linspace(0, 2*pi, 100);
    circle = [cos(angle); sin(angle)];

    ellipse = mu(:) + n_sigma * V * sqrt(max(D,0)) * circle;

    plot(ellipse(1,:), ellipse(2,:), 'm-', 'LineWidth', 1.5);
end

function ang = wrapToPiLocal(ang)
    ang = atan2(sin(ang), cos(ang));
end