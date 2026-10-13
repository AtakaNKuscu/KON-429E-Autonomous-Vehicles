%% Time Vector
time = (0:0.001:24)';

%% Steering Angle Profile
delta_f_val = zeros(size(time));

for i = 1:length(time)
    t = time(i);

    if t < 11.5
        delta_f_val(i) = 0;

    elseif t < 12.2
        % sola hızlı giriş
        delta_f_val(i) = 0.28 * ((t - 11.5)/0.7);

    elseif t < 13.0
        % kısa süre tut
        delta_f_val(i) = 0.28;

    elseif t < 13.8
        % hızlı counter steer
        delta_f_val(i) = 0.28 - 0.43*((t - 13.0)/0.8);

    elseif t < 14.5
        % kısa sağ tut
        delta_f_val(i) = -0.15;

    elseif t < 15.2
        % merkeze dön
        delta_f_val(i) = -0.15 + 0.15*((t - 14.5)/0.7);

    else
        delta_f_val(i) = 0;
    end
end

delta_f = [time, delta_f_val];
delta_r = [time, zeros(size(time))];

%% Torque Profile
torque_val = zeros(size(time));

for i = 1:length(time)
    t = time(i);

    if t < 5
        torque_val(i) = 0;

    elseif t < 7
        torque_val(i) = 1200 * ((t - 5)/2);

    elseif t < 11.5
        torque_val(i) = 1200;

    elseif t < 14.5
        torque_val(i) = 1400;

    elseif t < 18
        torque_val(i) = 900;

    else
        torque_val(i) = 300;
    end
end

Tf = [time, torque_val];
Tr = [time, zeros(size(time))];