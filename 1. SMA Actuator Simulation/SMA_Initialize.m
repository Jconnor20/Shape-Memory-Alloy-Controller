% Author:       Jack Connor
% Simulation:   SMA Control Sim
% Paper:        TBD
% Date:         30/09/2023

clear 
clc

%% Gobal Variables

% General Sim Parameters
global BatVolt

% Wire Parameters
global Diameter Radius Length Density WireMass
global epsR Resis SectA SurfArea

% Phase Transformation
global As Af Ms Mf aA bA cA aM bM cM
global Es1 Ef1 Esave1 Es2 Ef2 Esave2

%Heat Transfer Model
global HeatCap HeatTransCoeff TempAmb 

% Resistance Model
global pm pa

%Constitutive Model
global thetaT 


% Fin/Pully Physical Properties
global Mass Inertia 

%kinematic Model
global TDB 
thetaT = 0; % Thermal coefficient of expansion of SMA (Pa/degC)
theta0 = -40*(pi/180);      % Initial angular position [rad]
vel0 = 0*(pi/180);          % Initial angular velocity [rad/s]
Lref = 9.17;                % Springs unstretched length [mm]
dXo1 = (17.44-Lref)/1000;   % SMA1 spring initial elongation [m]
dXo2 = (15.48-Lref)/1000;   % SMA2 spring initial elongation [m]
flagSpring = 2;             % Initial static analysis configuration:
                   
epsR1 = 0.041;              % SMA1 max. recovery strain
epsR2 = 0.041;  

epsR = 0.04;                   % SMA1 max. recovery strain
Da = 75e9;      % Modulus of elasticity at austenite (Pa)
Dm = 28e9;      % Modulus of elasticity at martensite (Pa)
D = (Da+Dm)/2;  % Average modulus of elasticity (Pa)
eps_l = 0.067;   % Maximum residual strain
%% Controller
BatVolt = 12; 

%% Wire Physical Properties 
%Diameter = 0.00031;             % Diameter [m] 
Diameter = 0.0002;             % Diameter [m] 
Radius = Diameter/2;            % Radius [m]
Length = 0.5;                  % SMA1 undeformed lenght [m]
Density = 6450.0;               % Density [kg/m^3]
Resis = 8.66;                   % Electric resistence per unit length [Ohm/m]
SectA = pi*(Diameter^2)/4;              % Sectional area
Sw = SectA;
SurfArea = Diameter*Length*pi;
Mw  = Density*pi*(Diameter^2)/4;         % Mass per unith length
WireMass = (Density*pi*(Diameter^2)*Length)/4;


%% Fin/Pully Physical Properties
PullyMass = 0.05;                  % Mass [kg]
PullyRadius = 0.02;            %Radius [m]
Inertia = 0.5*PullyMass*PullyRadius^2*0.001;             % Inertia [kgm^2]

%% Heat Transfer Model
TempAmb = 25;
HeatCap = 837.3;
HeatTransCoeff = 150;



%% Phase Transformation 
As = 88.0;          % Austenite starting temperature [deg]
Af = 98.0;         % Austenite final temperature [deg]
Ms = 72.0;          % Martensite starting temperature [deg] 
Mf = 62.0;          % Martensite final temperature [deg] 
aA = pi/(Af-As);    % Curve fitting parameters heating phase
cA = 10.3e6;        
bA = -aA/cA;       
aM = pi/(Ms-Mf);    % Curve fitting parameters cooling phase
cM = 10.3e6;       
bM = -aM/cM; 
Dm = 28.0e9;        % Martensite Young modulus [Pa]
Da = 75.0e9;        % Austenite Young modulus [Pa]

Es1 = 1;            % SMA1 starting martensite fraction
Ef1 = 0;            % SMA1 final martensite fraction
Esave1 = Es1;   
Es2 = 1;            % SMA2 starting martensite fraction
Ef2 = 0;            % SMA2 final martensite fraction
Esave2 = Es2;

D1 = Dm*Esave1 + (1-Esave1)*Da;     % SMA1 initial Young modulus
D2 = Dm*Esave2 + (1-Esave2)*Da;     % SMA2 initial Young modulus 

%% Resistance Model
pa = 100*10^-8;                 % Resistance in the Aust
pm = 80*10^-8;

initalResis = pm * Length / SectA;
%% Constitutive Model
%thetaT = 550000; % Thermal coefficient of expansion of SMA (Pa/degC)


disp_i = 0.01;
Ks = 100;           % Spring constant (N/m)
K = SectA * Dm /Length;
sigma0 = (disp_i*Ks)/SectA;
sigma1 = (disp_i*K)/SectA;



% SMA wire actuator dynamics
Ac = (pi*Diameter^2)/4;    % Cross sectional area of SMA wire (m^2)
          % Spring constant (N/m)
disp_i = 0.02;      % Initial displacement (m) prior to voltage application
eps_i = disp_i/Length;  % Initial strain prior to voltage application

Force = 7.5477 * 10^-8 * 1.5 * 10^8
A = pi * (0.00031/2)^2

fprintf('\n\n************ SMA Model Initialized ***************** \n');
% End of script