
%% Header

% Subject : Analysis of a P-Controlled Mechanichal System

%Topics:
% 1.Stability analysis of an Uncontrolled Mechanichal System;
% 2.Bode diagram of said Uncontrolled System;
% 3.Stability analysis of a P-Controlled Mechanichal System;
% 4.Indirect and Direct methods used to assess the stability of the Controlled System;
% 5.Performance in time domain with respect to step input and plot.

clear
close all
clc


%% Data

g = 9.81;               % [m/s^2]           Gravity Acceleration
L = 1;                  % [m]               Semi-Lenght  Pendulum
m = 80;                 % [kg]              Mass of the Pendulum
J = 20;                 % [kgm^2]           Moment of Inercia relative to the center of mass
k = 200;                % [N/m]             Mass of the spring
r = 25;                 % [Ns/m]            Damping

Js = m*L^2 + J;         % [kg^2]            Generalized moment of Inertia
rs = 4*r*L^2;           % [Ns/rad]          Generalized damping
ks = 4*k*L^2-m*g*L;     % [Nrad]            Generalized stiffness

%% Uncontrolled System

numG = [1];             % Numerator of G tilde
denG = [Js rs ks];      % Denominator of G tilde
G = tf(numG,denG);

% ALternative way to do it:

%s = tf([1,0],1);        % Define the complex variable s
%G = 1/(Js*s^2+rs*s+ks);

% Assess stability of the uncontrolled system
pG = pole(G);

fprintf('----Uncontrolled System ----\n'); %\n -> new line
if real(pG)<=0
    fprintf('Poles of G(s): \n%f+j%f\n%f+j%f\n',real(pG(1)),imag(pG(1)),real(pG(2)),imag(pG(2)))
    disp('Uncontrolled System is stable')
else
    fprintf('Poles of G(s): \n%f+j%f+j%f\n',real(pG(1)),imag(pG(1)),real(pG(2)),imag(pG(2)))
    disp('Uncontrolled System is unstable')
end

%% Bode diagram of G(jw)

%Standart way to plot bode plot:

%figure(1)
%bode(G)
%grid on


[mag,phase,w_out] = bode(G); % Gives us the magnitude, phase and respective frequency and they are stored in vectors

%More custumizable way to plot the bode diagram

figure(1)
sgtitle('Bode Plot of the \textbf{Uncontrolled System}',Interpreter='latex')
subplot(2,1,1)
semilogx(w_out,20*log10(squeeze(mag)),'linewidth',1.5)
title('Magnitude of G','interpreter','latex')
xlabel ('$\omega$ [rad/s]','Interpreter','latex')
grid on

subplot(2,1,2)
semilogx(w_out,squeeze(phase))
title('Phase of G','interpreter','latex')
xlabel ('$\omega$ [rad/s]','Interpreter','latex')
grid on
set(gcf,'color','w')

KG = dcgain(G);

%% Controlled system, stability analysis with inderect methods

kp = 1000;              %Proportional Gain

% Definition of the open loop TF CGH, H = 1

numCG = [kp];
denCG = [Js rs ks];

CG = tf(numCG,denCG);

% Alternative method
%s = tf ([1 0],1);
%CG = kp*G


% Evaluate the number of unstable poles of the open loop TF
pCG = pole(CG);

fprintf('\n')
fprintf('----Controlled System ----\n'); %\n -> new line
if real(pG)<=0
    fprintf('Poles of C(s)G(s): \n%f+j%f\n%f+j%f\n',real(pCG(1)),imag(pCG(1)),real(pCG(2)),imag(pCG(2)))
    NyquistLegend = ('There are no unstable poles in the OLTF');
    disp(NyquistLegend)
else
    fprintf('Poles of C(s)G(s): \n%f+j%f+j%f\n',real(pCG(1)),imag(pCG(1)),real(pCG(2)),imag(pCG(2)))
    n = sum(real(pCG)>0); 
    NyquistLegend = append('There are', n ,' unstable poles in the OLTF');
    fprintf(NyquistLegend);
end

% Evaluate the Nyquist Diagram
figure(2)
subplot(1,3,1)

nyquist(CG)            %[re, im, w] = nyquist(CG) if you want the data to be saved
title('Nyquist Diagram', 'Sublegend')
subtitle(NyquistLegend)

% Apply the Bode Criterion
[Gm,Pm] = margin(CG);
fprintf('\nPhase margin: %f\nGain margin: %f\n',Pm,Gm)

subplot(1,3,2)
margin(CG)

%sgtitle('Indirect Analysis Plots',interpreter='latex')

% Root Locus
subplot(1,3,3)
rlocus(CG/kp)

grid on %Polar Grid
axis equal

%% Direct method in time domain

% Eigenvalues of the state matrix
Ac = [-rs/Js -(ks+kp)/Js;...     %Definition of the state matrix
        1          0];

[Vc,Dc]= eig(Ac);                %Vc will be a matrix of the eigenvalues 

lambda = diag(Dc);


%% Performance in time domain with respect to step input

% Define the closed loop transfer function
numL = [kp];
denL = [Js rs ks+kp];

L = tf(numL,denL);


figure(3)
subplot(1,2,1)
title('Response of the System')
sgtitle('Plots for the \textbf{Controlled System}',interpreter='latex')
step(L)
grid on

theta_inf = dcgain(L);      %steady state angular position
e_inf = 1-theta_inf;        %steady state error

subplot(1,2,2)
title('Bode Plot of the Closed Loop TF')
bode(L)
grid on

BW = bandwidth(L);          %bandwidth