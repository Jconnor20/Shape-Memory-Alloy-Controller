% Define input parameters
clear;
clc;

rho = 6.45e3; % density (kg/m^3)
cp = 450; % specific heat (J/kg/K)
AL = pi*(0.5e-3)^2; % cross-sectional area (m^2)
h_con = 10; % convection heat transfer coefficient (W/m^2/K)
k_s = 14; % thermal conductivity (W/m/K)
D = 1e-3; % wire diameter (m)
T_inf = 25; % ambient temperature (°C)
T_crit = 70; % critical temperature (°C)
beta = 2; % transformation strain coefficient
lambda = 1e-3; % rate of transformation
t_0 = 0.2; % time delay for transformation (s)
sigma_max = 500e6; % maximum stress (Pa)
epsilon_max = 0.06; % maximum transformation strain

% Define initial conditions
T0 = T_inf; % initial temperature (°C)
T = T0; % initialize temperature array (°C)
t = 0:0.01:100; % time array (s)
sigma = zeros(size(t)); % stress array (Pa)
epsilon = zeros(size(t)); % transformation strain array
epsilon_dot = zeros(size(t)); % strain rate array
Q_ext = zeros(size(t)); % external heat source/sink array

% Calculate stress and transformation strain
for i = 1:length(t)
    % Calculate temperature
    T = T0 + trapz(t(1:i), ((sigma(1:i).*epsilon(1:i).*epsilon_dot(1:i)+ Q_ext(1:i) - h_con*AL*(T(1:i)-T_inf)).')/(rho*cp*AL), 2);
    % Calculate stress
    if T > T_crit
        sigma(i) = sigma_max;
    else
        sigma(i) = sigma_crit(T) + beta*epsilon(i);
    end
    
    % Calculate transformation strain
    epsilon(i) = epsilon_max*(1-exp(-lambda*(t(i)-t_0)));
    
    % Calculate strain rate
    if i == 1
        epsilon_dot(i) = 0;
    else
        epsilon_dot(i) = (epsilon(i) - epsilon(i-1))/(t(i) - t(i-1));
    end
end

% Plot results
figure;
plot(t, sigma);
xlabel('Time (s)');
ylabel('Stress (Pa)');
title('Stress vs. Time');

figure;
plot(t, epsilon);
xlabel('Time (s)');
ylabel('Transformation Strain');
title('Transformation Strain vs. Time');

figure;
plot(t, T);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs. Time');

% Define function for critical stress
function sigma_crit = sigma_crit(T)
    sigma_crit = 200e6 - 0.8e6*(T - 20);
end
