%% Header
% Computes, using the displacement method, 
% the displacements of a 2D truss sctuture

%Required Inputs: 
% - Position of Nodes and Connectivity between them;
% - Stiffness properties of the Rods;
% - Constrains;
% - Loads,

% The inputs can be given by defining them explicity on the code
% Or by filling the different files on the folder

% Author: Vasco Pires

% Output:
% u = [u1 v1 u2 v2 u3 v3 u4 v4...]^T

clear 
close all
clc

%% Loading of the Inputs

load nodes.dat
load connectivity.dat
load properties_rod.dat
load loads.dat
load constraints.dat

%% Plot of the Undeformed Structure
f_plot = figure();
plot_structure(nodes,connectivity,f_plot,'#808080')

%% Computation of the stiffness matrix

nnodes = size(nodes,1); %Number of Nodes in the system
nnrods = size(connectivity, 1); %Number of rods/bars 

K = zeros(nnodes*2, nnodes*2); %For each node: 2 Directions

% The stiffness matrix will be 2nx2n
% [F]_2n = [K]2nx2n * [u]2n

for i = 1:nnrods
   
    %Compute the stiffness of element i
    %Connectivity(i,:) -> Line i of the matrix (rod i)
    %Properties_rod(i,:) -> Properties of the rod i

    Ki = ComputeStiffness(nodes,connectivity(i,:), properties_rod(i,:));
    
    %Assemble (sum) the stiffness of element i into K
    
    %Gets the number of the node associated with this element
    n1 = connectivity(i,1); % Node 1 of the element
    n2 = connectivity(i,2); % Node 2 of the element
    
    %Indexes. For example if we have node 1 and node 2 connected:
    %The indexes will be: [1,2,3,4] -> [u1,v1,u2,v2]
    idx = [(n1-1)*2+1 (n1-1)*2+2 (n2-1)*2+1 (n2-1)*2+2];
    
    %Sum of the Ki stiffness of a element to the global
    % stiffness matrix in the appropriate positions:
    K(idx,idx) = K(idx,idx)+Ki;
end

%% Constraints
% number of the node | direction of the constraint

nconstr = size(constraints, 1); %Number of constrains
constr_idx = zeros(1, nconstr); %Vector [a b ... ]

%Indexing of the constrains -> Index Vector
for c = 1:nconstr
  constr_idx(c) = (constraints(c, 1)-1)*2 + constraints(c, 2);
end

%Constrained Matrix
K_constr = K;

%For every indexed line from the constrain index
% -> Null 
K_constr(constr_idx, :) = [];

%For every indexed colum -> Null
K_constr(:, constr_idx) = [];


%% Loads
% Node Number | Direction | Magnitude


%Force vector f
f = zeros(2*nnodes, 1);

nf = size(loads, 1); %Number of loads

for fi = 1:nf
  
  %Index of forces and direction
  f_idx = (loads(fi, 1)-1)*2+loads(fi, 2);
  
  %Locating the magnitude of the force on 
  %the right index
  f(f_idx) = f(f_idx) + loads(fi, 3);
end

%Constrained Force Vetor
f_constr = f;

%Imposing the null vectors in the constrained 
%force vector
f_constr(constr_idx) = [];

%Solving the Linear System of Equations for the free nodes
u_constr = K_constr\f_constr;

%Initializing the u vector
u = zeros(2*nnodes, 1);

%Opens a vector with the size of 2*Number_of_Nodes
free_idx = 1:2*nnodes;

%Imposes null displacement in the constrained nodes and respective direction
free_idx(constr_idx) = [];

%Applies the null displacement to the overall displacement vector u
u(free_idx) = u_constr;

%Splits the displacement vector into a 2 row matrix, where the first row is
%the horizontal displacement and the sector row is the vertical placement

um = [u(1:2:end-1) u(2:2:end)];


%That allows to sum the horizontal and vertical displacement to the
%original position of the nodes, which was organized in this matrix form

scalor_factor = 100; %Scales the actual displacement in order to be seen on the plot

%Plots the deformed structure
plot_structure(nodes+um*scalor_factor, connectivity, f_plot,'black');
title('Deformed Structure',Interpreter='latex')

strlegend =  strings(nnrods+1);
strlegend(1) = 'Undeformed';
strlegend(nnrods+1) = 'Deformed';
legend(strlegend,Interpreter="latex")


xlabel('x [mm]','Interpreter','latex')
ylabel('y [mm]','Interpreter','latex')


fprintf('--------------------- Nodes Displacements --------------------- \n'); %\n -> new line

% Reaction Forces
R = K*u;
Rm = [R(1:2:end-1) R(2:2:end)];

%Prints the displacement of the nodes
for i = 1:nnrods
    fprintf('Node %f: X = %f mm | Y = %f mm\n',i,um(i,1),um(i,2))
end

fprintf('\n---------------------  Reaction Forces --------------------- \n'); %\n -> new line

for i = 1:nnrods
    fprintf('Node %f: Rx = %f N| Ry = %f N\n',i,Rm(i,1),Rm(i,2))
end

