%% Vehicle Parameters

lf = 1.4;               % Front axle distance (m)
lr = 1.1;               % Rear axle distance (m)
m = 1300;               % Mass (kg)
slope = 0.0;            % Road slope (rad)
Frontal_area = 2.0;     % Frontal area (m²)
ro = 1.225;             % Air density (kg/m³)
Cd = 0.3;               % Drag coefficient
Crr = 0.014;            % Rolling resistance coefficient
g = 9.81;               % Gravitational acceleration (m/s²)
F_max_x = 15000;        % Max longitudinal force (N)
F_max_y = 9000;         % Max lateral force (N)
Cyf = 45000;            % Front lateral stiffness (N/rad)
Cxf = 55000;            % Front longitudinal stiffness (N)
Cyr = 45000;            % Rear lateral stiffness (N/rad)
Cxr = 55000;            % Rear longitudinal stiffness (N)
Jt = 3.5;               % Wheel inertia (kg*m²)
J = 580;                % Vehicle moment of inertia (kg*m²)
R = 0.3;                % Effective wheel radius (m)
