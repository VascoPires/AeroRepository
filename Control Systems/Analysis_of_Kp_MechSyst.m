%% Header

% Subject : Analysis of influence of Kp in the response of the system

% Plots Nyquist, Bode and Step Response for different values of Kp

clear
close all
clc


%% Data

g = 9.81;               % [m/s^2]           Gravity Acceleration
L = 1;                  % [m]               Semi-Lenght of Pendulum
m = 80;                 % [kg]              Mass of the Pendulum
J = 20;                 % [kgm^2]           Moment of Inercia relative to the center of mass
k = 200;                % [N/m]             Mass of the spring
r = 25;                 % [Ns/m]            Damping

Js = m*L^2 + J;         % [kg^2]            Generalized moment of Inertia
rs = 4*r*L^2;           % [Ns/rad]          Generalized damping
ks = 4*k*L^2-m*g*L;     % [Nrad]            Generalized stiffness

%% Uncontrolled System

%numG = [1];             % Numerator of G tilde
%denG = [Js rs ks];      % Denominator of G tilde
%G = tf(numG,denG);

% ALternative way to do it:

s = tf([1,0],1);        % Define the complex variable s
G = 1/(Js*s^2+rs*s+ks);

kp = [500 1000 1500 2000];           % Proportional Gain
strlegend = [];                      % Initialize the string for the legend

for ii=1:length(kp)

    C = kp(ii);
    CG = C*G;
    L = kp(ii)/(Js*s^2+rs*s+ks+kp(ii));
    
    strlegend{ii} = ['kp=' num2str(kp(ii))];

    %plot the nyquist
    figure(1)
    nyquist(CG)
    hold on
    legend(strlegend)

    axis equal
   
    % bode criterion
    figure(2)
    margin(CG)
    grid on
    hold on
    legend(strlegend)

    % Step Response
    figure(3)
    step(L)
    grid on
    hold on
    legend(strlegend)
end