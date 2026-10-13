%% Compare normal R and large R
load("hw2_ekf_data.mat");

% But preserve simulation outputs
% If this script reloads R, no problem since outputs are already stored.

t_normal = out_normal.tout;
x_normal = squeeze(out_normal.x_hat_log);

t_largeR = out_largeR.tout;
x_largeR = squeeze(out_largeR.x_hat_log);

% Fix orientation
if size(x_normal,2) == 3
    x_normal = x_normal';
end

if size(x_largeR,2) == 3
    x_largeR = x_largeR';
end

N = min([size(x_true,2), size(x_normal,2), size(x_largeR,2), length(t_normal)]);

x_true_c = x_true(:,1:N);
z_meas_c = z_meas(:,1:N);
x_normal = x_normal(:,1:N);
x_largeR = x_largeR(:,1:N);
t_c = t_normal(1:N);

figure;
hold on; grid on; axis equal;

plot(x_true_c(1,:), x_true_c(2,:), 'b-', 'LineWidth', 2);
plot(z_meas_c(1,:), z_meas_c(2,:), 'r.', 'MarkerSize', 8);
plot(x_normal(1,:), x_normal(2,:), 'g-', 'LineWidth', 2);
plot(x_largeR(1,:), x_largeR(2,:), 'k--', 'LineWidth', 2);

xlabel('p_x [m]');
ylabel('p_y [m]');
title('Effect of Increased Measurement Noise Covariance R');
legend('Ground Truth', 'Noisy GPS Measurements', ...
       'EKF Estimate: Original R', 'EKF Estimate: Large R', ...
       'Location', 'best');

% Error comparison
pos_error_normal = sqrt((x_true_c(1,:) - x_normal(1,:)).^2 + ...
                        (x_true_c(2,:) - x_normal(2,:)).^2);

pos_error_largeR = sqrt((x_true_c(1,:) - x_largeR(1,:)).^2 + ...
                        (x_true_c(2,:) - x_largeR(2,:)).^2);

figure;
hold on; grid on;

plot(t_c, pos_error_normal, 'g-', 'LineWidth', 2);
plot(t_c, pos_error_largeR, 'k--', 'LineWidth', 2);

xlabel('Time [s]');
ylabel('Position Error [m]');
title('Position Error Comparison for Original R and Large R');
legend('Original R', 'Large R', 'Location', 'best');

rmse_pos_normal = sqrt(mean(pos_error_normal.^2));
rmse_pos_largeR = sqrt(mean(pos_error_largeR.^2));

fprintf("\n===== R COMPARISON =====\n");
fprintf("RMSE position, original R = %.4f m\n", rmse_pos_normal);
fprintf("RMSE position, large R    = %.4f m\n", rmse_pos_largeR);