%% =========================================================
%  Full diagnostic plots for vehicle model
%  Assumes simulation output is stored in:
%       out   (SimulationOutput)
%
%  Expected signal names inside out:
%       X_out, Y_out, psi_out, V_out
%       beta_out, r_out
%       alpha_f_out, alpha_r_out
%       SLf_out, SLr_out
%       Fxf_out, Fxr_out, Fyf_out, Fyr_out
%
%  Signals are assumed to be saved as "Structure With Time"
%% =========================================================

clc;

%% ---------- Check SimulationOutput ----------
if ~exist('out','var')
    error('Workspace''te "out" isimli SimulationOutput objesi bulunamadi.');
end

%% ---------- Helper functions ----------
get_ts = @(s) deal(s.time, s.signals.values);

hasSignal = @(name) ...
    any(strcmp(name, out.who));

%% ---------- Read mandatory signals ----------
requiredSignals = {'X_out','Y_out','psi_out','V_out'};

for k = 1:numel(requiredSignals)
    if ~hasSignal(requiredSignals{k})
        error('out icinde gerekli sinyal bulunamadi: %s', requiredSignals{k});
    end
end

[tX, X]     = get_ts(out.X_out);
[tY, Y]     = get_ts(out.Y_out);
[tPsi, psi] = get_ts(out.psi_out);
[tV, V]     = get_ts(out.V_out);

%% ---------- Basic check ----------
fprintf('Loaded main outputs successfully.\n');
fprintf('Final time = %.3f s\n', tX(end));

%% =========================================================
%% 1) Main outputs
%% =========================================================

figure('Name','Main Outputs','Color','w');

subplot(2,3,1);
plot(X, Y, 'b', 'LineWidth', 1.8); hold on;
plot(X(1:1000:end), Y(1:1000:end), 'r.', 'MarkerSize', 10);
grid on;
xlabel('X (m)');
ylabel('Y (m)');
title('Vehicle Trajectory');
legend('Trajectory','Vehicle Position & Orientation','Location','best');
axis equal;

subplot(2,3,2);
plot(tX, X, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('X (m)');
title('X Coordinate');

subplot(2,3,3);
plot(tY, Y, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Y (m)');
title('Y Coordinate');

subplot(2,3,4);
plot(tPsi, psi, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('\psi (rad)');
title('Yaw Angle');

subplot(2,3,5);
plot(tV, V, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('V (m/s)');
title('Velocity');

%% =========================================================
%% 2) beta and yaw rate
%% =========================================================

if hasSignal('beta_out') && hasSignal('psidot_out')
    [tbeta, beta] = get_ts(out.beta_out);
    [tr, r]       = get_ts(out.psidot_out);

    figure('Name','Body Motion Diagnostics','Color','w');

    subplot(2,1,1);
    plot(tbeta, beta, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('\beta (rad)');
    title('Vehicle Sideslip Angle');

    subplot(2,1,2);
    plot(tr, r, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('r = \psi dot (rad/s)');
    title('Yaw Rate');
else
    warning('beta_out veya r_out bulunamadi; ilgili grafikler atlandi.');
end

%% =========================================================
%% 3) Slip angles
%% =========================================================

if hasSignal('alpha_f_out') && hasSignal('alpha_r_out')
    [taf, alpha_f] = get_ts(out.alpha_f_out);
    [tar, alpha_r] = get_ts(out.alpha_r_out);

    figure('Name','Slip Angles','Color','w');

    subplot(2,1,1);
    plot(taf, alpha_f, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('\alpha_f (rad)');
    title('Front Slip Angle');

    subplot(2,1,2);
    plot(tar, alpha_r, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('\alpha_r (rad)');
    title('Rear Slip Angle');

    figure('Name','Slip Angles Combined','Color','w');
    plot(taf, alpha_f, 'LineWidth', 1.5); hold on;
    plot(tar, alpha_r, 'LineWidth', 1.5);
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('Slip angle (rad)');
    title('Front / Rear Slip Angles');
    legend('\alpha_f','\alpha_r','Location','best');
else
    warning('alpha_f_out veya alpha_r_out bulunamadi; slip angle grafikleri atlandi.');
end

%% =========================================================
%% 4) Longitudinal slips
%% =========================================================

if hasSignal('SLf_out') && hasSignal('SLr_out')
    [tsf, SLf] = get_ts(out.SLf_out);
    [tsr, SLr] = get_ts(out.SLr_out);

    figure('Name','Longitudinal Slips','Color','w');

    subplot(2,1,1);
    plot(tsf, SLf, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('S_{Lf}');
    title('Front Longitudinal Slip');

    subplot(2,1,2);
    plot(tsr, SLr, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('S_{Lr}');
    title('Rear Longitudinal Slip');

    figure('Name','Longitudinal Slips Combined','Color','w');
    plot(tsf, SLf, 'LineWidth', 1.5); hold on;
    plot(tsr, SLr, 'LineWidth', 1.5);
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('Slip ratio');
    title('Front / Rear Longitudinal Slip');
    legend('S_{Lf}','S_{Lr}','Location','best');
else
    warning('SLf_out veya SLr_out bulunamadi; longitudinal slip grafikleri atlandi.');
end

%% =========================================================
%% 5) Tire forces
%% =========================================================

if hasSignal('Fxf_out') && hasSignal('Fxr_out') && ...
   hasSignal('Fyf_out') && hasSignal('Fyr_out')

    [tFxf, Fxf] = get_ts(out.Fxf_out);
    [tFxr, Fxr] = get_ts(out.Fxr_out);
    [tFyf, Fyf] = get_ts(out.Fyf_out);
    [tFyr, Fyr] = get_ts(out.Fyr_out);

    figure('Name','Tire Forces - Separate','Color','w');

    subplot(2,2,1);
    plot(tFxf, Fxf, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('Fxf (N)');
    title('Front Longitudinal Tire Force');

    subplot(2,2,2);
    plot(tFxr, Fxr, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('Fxr (N)');
    title('Rear Longitudinal Tire Force');

    subplot(2,2,3);
    plot(tFyf, Fyf, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('Fyf (N)');
    title('Front Lateral Tire Force');

    subplot(2,2,4);
    plot(tFyr, Fyr, 'LineWidth', 1.5); hold on;
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('Fyr (N)');
    title('Rear Lateral Tire Force');

    figure('Name','Tire Forces Combined','Color','w');
    plot(tFxf, Fxf, 'LineWidth', 1.5); hold on;
    plot(tFxr, Fxr, 'LineWidth', 1.5);
    plot(tFyf, Fyf, 'LineWidth', 1.5);
    plot(tFyr, Fyr, 'LineWidth', 1.5);
    yline(0,'k--');
    grid on;
    xlabel('Time (s)');
    ylabel('Force (N)');
    title('All Tire Forces');
    legend('Fxf','Fxr','Fyf','Fyr','Location','best');
else
    warning('Tire force sinyallerinden biri eksik; tire force grafikleri atlandi.');
end

%% =========================================================
%% 6) Summary statistics
%% =========================================================

fprintf('\n================ SUMMARY ================\n');
fprintf('Final X       = %.6f m\n', X(end));
fprintf('Final Y       = %.6f m\n', Y(end));
fprintf('Final psi     = %.6f rad\n', psi(end));
fprintf('Final V       = %.6f m/s\n', V(end));

fprintf('\nPeak main values:\n');
fprintf('Max X         = %.6f m\n', max(X));
fprintf('Min X         = %.6f m\n', min(X));
fprintf('Max Y         = %.6f m\n', max(Y));
fprintf('Min Y         = %.6f m\n', min(Y));
fprintf('Max psi       = %.6f rad\n', max(psi));
fprintf('Min psi       = %.6f rad\n', min(psi));
fprintf('Max V         = %.6f m/s\n', max(V));
fprintf('Min V         = %.6f m/s\n', min(V));

if hasSignal('beta_out')
    [~, beta] = get_ts(out.beta_out);
    fprintf('Max beta      = %.6f rad\n', max(beta));
    fprintf('Min beta      = %.6f rad\n', min(beta));
end

if hasSignal('SLf_out')
    [~, SLf] = get_ts(out.SLf_out);
    fprintf('Max SLf       = %.6f\n', max(SLf));
    fprintf('Min SLf       = %.6f\n', min(SLf));
end

if hasSignal('SLr_out')
    [~, SLr] = get_ts(out.SLr_out);
    fprintf('Max SLr       = %.6f\n', max(SLr));
    fprintf('Min SLr       = %.6f\n', min(SLr));
end

if hasSignal('alpha_f_out')
    [~, alpha_f] = get_ts(out.alpha_f_out);
    fprintf('Max alpha_f   = %.6f rad\n', max(alpha_f));
    fprintf('Min alpha_f   = %.6f rad\n', min(alpha_f));
end

if hasSignal('alpha_r_out')
    [~, alpha_r] = get_ts(out.alpha_r_out);
    fprintf('Max alpha_r   = %.6f rad\n', max(alpha_r));
    fprintf('Min alpha_r   = %.6f rad\n', min(alpha_r));
end

if hasSignal('Fxf_out')
    [~, Fxf] = get_ts(out.Fxf_out);
    fprintf('Max Fxf       = %.6f N\n', max(Fxf));
    fprintf('Min Fxf       = %.6f N\n', min(Fxf));
end

if hasSignal('Fxr_out')
    [~, Fxr] = get_ts(out.Fxr_out);
    fprintf('Max Fxr       = %.6f N\n', max(Fxr));
    fprintf('Min Fxr       = %.6f N\n', min(Fxr));
end

if hasSignal('Fyf_out')
    [~, Fyf] = get_ts(out.Fyf_out);
    fprintf('Max Fyf       = %.6f N\n', max(Fyf));
    fprintf('Min Fyf       = %.6f N\n', min(Fyf));
end

if hasSignal('Fyr_out')
    [~, Fyr] = get_ts(out.Fyr_out);
    fprintf('Max Fyr       = %.6f N\n', max(Fyr));
    fprintf('Min Fyr       = %.6f N\n', min(Fyr));
end

fprintf('=========================================\n');