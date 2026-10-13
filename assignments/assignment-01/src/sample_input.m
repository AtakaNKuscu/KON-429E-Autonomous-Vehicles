%% Time Vector
time = (0:0.001:44)'; 

%% Steering Angle Profile (delta_f)

delta_f_val = zeros(size(time));
for i = 1:length(time)
    t = time(i);
    if t < 13
        delta_f_val(i) = 0.0;
    elseif t < 15.2
        delta_f_val(i) = 0.0 + 0.21 * ((t - 13) / 2.2);
    elseif t < 17
        delta_f_val(i) = 0.21 - 0.21 * ((t - 15.2) / 1.8);
    elseif t < 27
        delta_f_val(i) = 0.0;
    elseif t < 30
        delta_f_val(i) = 0.0 - 0.25 * ((t - 27) / 3);
    elseif t < 30.8
        delta_f_val(i) = -0.25;
    elseif t < 32.8
        delta_f_val(i) = -0.25 + 0.25 * ((t - 30.8) / 2.0);
    elseif t < 34
        delta_f_val(i) = 0.0;
    elseif t < 35
        delta_f_val(i) = 0.0 - 0.36 * ((t - 34) / 1);
    elseif t < 35.3
        delta_f_val(i) = -0.36;
    elseif t < 36.3
        delta_f_val(i) = -0.36 + 0.36 * ((t - 35.3) / 1);
    else
        delta_f_val(i) = 0.0;
    end
end
delta_f = [time, delta_f_val];
delta_r = [time, zeros(size(time))];

%% Torque Profile (Tf and Tr)

torque_val = zeros(size(time));
for i = 1:length(time)
    t = time(i);
    if t < 5
        torque_val(i) = 0;
    elseif t < 6
        torque_val(i) = 0.0 + 900 * (t-5);
    elseif t < 10
        torque_val(i) = 900;
    elseif t < 22
        torque_val(i) = 70;
    elseif t < 38
        torque_val(i) = 96;
    else
        torque_val(i) = 450;
    end
end

Tf = [time, torque_val];
Tr = [time, zeros(size(time))];
