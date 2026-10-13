%% Plot outputs of the vehicle model
% Assumes To Workspace blocks are saved as "Structure With Time"
% Expected variables:
% X_out, Y_out, psi_out, V_out
%
% Optional:
% beta_out, r_out, alpha_f_out, alpha_r_out, SLf_out, SLr_out, ...
%
% Run parameters.m and sample_input.m before this if needed.

clc;

%% --- Helper function for reading Structure With Time ---
get_ts = @(s) deal(s.time, s.signals.values);

%% Read main outputs
[tX, X]     = get_ts(out.X_out);
[tY, Y]     = get_ts(out.Y_out);
[tPsi, psi] = get_ts(out.psi_out);
[tV, V]     = get_ts(out.V_out);

%% Basic consistency check
if ~(isequal(tX,tY) && isequal(tX,tPsi) && isequal(tX,tV))
    warning('Time vectors are not exactly equal. Using each signal''s own time vector.');
end

%% Figure 1: Vehicle trajectory
figure('Name','Vehicle Trajectory','Color','w');
plot(X, Y, 'b', 'LineWidth', 1.8); hold on;
plot(X(1:1000:end), Y(1:1000:end), 'r.', 'MarkerSize', 10); % red points like sampled vehicle positions
grid on;
xlabel('X (meters)');
ylabel('Y (meters)');
title('Vehicle Trajectory');
legend('Trajectory','Vehicle Position & Orientation','Location','best');
axis equal;

%% Figure 2: X coordinate change
figure('Name','X Coordinate Change','Color','w');
plot(tX, X, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (seconds)');
ylabel('X (meters)');
title('X Coordinate Change');

%% Figure 3: Y coordinate change
figure('Name','Y Coordinate Change','Color','w');
plot(tY, Y, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Y (meters)');
title('Y Coordinate Change');

%% Figure 4: Yaw angle change
figure('Name','Yaw Angle Change','Color','w');
plot(tPsi, psi, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Yaw angle (radians)');
title('Yaw Angle Change');

%% Figure 5: Velocity change
figure('Name','Velocity Change','Color','w');
plot(tV, V, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Velocity (m/s)');
title('Velocity Change');

%% ---------------------------------------------------------
%% Optional diagnostic plots
%% These help if the reference plots do not match

if exist('beta_out','var')
    [tbeta, beta] = get_ts(beta_out);
    figure('Name','Sideslip Angle','Color','w');
    plot(tbeta, beta, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (seconds)');
    ylabel('\beta (rad)');
    title('Vehicle Sideslip Angle');
end

if exist('r_out','var')
    [tr, r] = get_ts(r_out);
    figure('Name','Yaw Rate','Color','w');
    plot(tr, r, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (seconds)');
    ylabel('r = d\psi/dt (rad/s)');
    title('Yaw Rate');
end

if exist('alpha_f_out','var') && exist('alpha_r_out','var')
    [taf, alpha_f] = get_ts(alpha_f_out);
    [tar, alpha_r] = get_ts(alpha_r_out);
    figure('Name','Slip Angles','Color','w');
    plot(taf, alpha_f, 'LineWidth', 1.5); hold on;
    plot(tar, alpha_r, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (seconds)');
    ylabel('Slip angle (rad)');
    title('Front / Rear Slip Angles');
    legend('\alpha_f','\alpha_r','Location','best');
end

if exist('SLf_out','var') && exist('SLr_out','var')
    [tsf, SLf] = get_ts(SLf_out);
    [tsr, SLr] = get_ts(SLr_out);
    figure('Name','Longitudinal Slips','Color','w');
    plot(tsf, SLf, 'LineWidth', 1.5); hold on;
    plot(tsr, SLr, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (seconds)');
    ylabel('Slip ratio');
    title('Front / Rear Longitudinal Slip');
    legend('S_{Lf}','S_{Lr}','Location','best');
end

if exist('Fxf_out','var') && exist('Fxr_out','var') && ...
   exist('Fyf_out','var') && exist('Fyr_out','var')
    [t1, Fxf] = get_ts(Fxf_out);
    [t2, Fxr] = get_ts(Fxr_out);
    [t3, Fyf] = get_ts(Fyf_out);
    [t4, Fyr] = get_ts(Fyr_out);

    figure('Name','Tire Forces','Color','w');
    plot(t1, Fxf, 'LineWidth', 1.5); hold on;
    plot(t2, Fxr, 'LineWidth', 1.5);
    plot(t3, Fyf, 'LineWidth', 1.5);
    plot(t4, Fyr, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (seconds)');
    ylabel('Force (N)');
    title('Tire Forces');
    legend('Fxf','Fxr','Fyf','Fyr','Location','best');
end

%%
%% Quick summary at final time
fprintf('Final time = %.3f s\n', tX(end));
fprintf('Final X     = %.6f m\n', X(end));
fprintf('Final Y     = %.6f m\n', Y(end));
fprintf('Final psi   = %.6f rad\n', psi(end));
fprintf('Final V     = %.6f m/s\n', V(end));

fprintf('\nPeak values:\n');
fprintf('Max X       = %.6f m\n', max(X));
fprintf('Max Y       = %.6f m\n', max(Y));
fprintf('Max psi     = %.6f rad\n', max(psi));
fprintf('Min psi     = %.6f rad\n', min(psi));
fprintf('Max V       = %.6f m/s\n', max(V));
fprintf('Min V       = %.6f m/s\n', min(V));