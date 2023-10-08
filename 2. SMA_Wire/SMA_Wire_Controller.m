%SMA Wire Control script and optimisation
clear
clc
close all

PWM_Sig = ones(1:30);
SM_Wire_Resistance = 500;

sim('SMA_Wire_Sim.slx')


