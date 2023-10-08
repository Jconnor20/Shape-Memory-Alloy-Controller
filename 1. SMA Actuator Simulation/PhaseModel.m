function [Phase] = PhaseModel(u)
%PHASEMODEL Summary of this function goes here
global As Af Ms Mf aA bA cA aM bM cM
global Es1 Ef1 Esave1

% - up to As it is all martensite
% - between As and Af is partially martensite and partially austenite
% - after Af is all austenite

heating = u(1,:);     % dT/dt > 0 = heating, dT/dt < 0 = cooling
Temp  = u(2,:);     % Temperature
sigma = u(3,:);     % Stress
sigma_dot = u(4,:);
phase = u(5,:);

% Heating phase
if (heating > 0)
   if (Temp > As && (cA(Temp-Af)<sigma<cA(Temp-As)))
        phase = -phase/2 * sin(aA(Temp-As-sigma/Ca))*(aA(heating-sigma_dot/cA));
   end
end
if (heating < 0)
   if (Temp > Ms && (cA(Temp-Af)<sigma<cA(Temp-As)))
        phase = -phase/2 * sin(aA(Temp-As-sigma/Ca))*(aA(heating-sigma_dot/cA));
   end
end

end

