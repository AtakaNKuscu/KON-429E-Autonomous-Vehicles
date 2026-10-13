clear; clc; close all;

% Load original homework data
load("hw2_ekf_data.mat");

% Number of samples
N = size(x_true, 2);

% Time vector
t = (0:N-1)' * dt;

% Initial conditions for Simulink Unit Delay blocks
x0 = x_hat;
P0 = P;

% Construct Simulink-compatible input signal
% u = [delta, v]
u_data = [delta_arr(:), v*ones(N,1)];
u_sim = timeseries(u_data, t);

% Construct Simulink-compatible measurement signal
% z = [px_meas, py_meas]
z_data = z_meas';
z_sim = timeseries(z_data, t);

% Optional checking
disp("EKF initialization completed.")
disp("Original .mat file was only loaded, not modified.")
disp(["N = ", num2str(N)])
disp(["size(u_data) = ", mat2str(size(u_data))])
disp(["size(z_data) = ", mat2str(size(z_data))])