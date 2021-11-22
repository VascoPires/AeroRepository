
close all
clc

load nodes.dat
load connectivity.dat
load properties.dat
load constraints.dat
load forces.dat

f_plot = figure();
plot_structure(nodes, connectivity, f_plot);

nnodes = size(nodes, 1);
nnels = size(connectivity, 1);

K = zeros(nnodes*2, nnodes*2);
for el = 1:nnels
  %compute the stiffness of element el
  KEL = ComputeStiffness(nodes, connectivity(el,:), properties(el,:));
  %assemble (sum) the stiffness of element el into K
  n1 = connectivity(el, 1);
  n2 = connectivity(el, 2);
  idx = [(n1-1)*2+1 (n1-1)*2+2 (n2-1)*2+1 (n2-1)*2+2 ];
  K(idx, idx) = K(idx,idx) + KEL;
end
nconstr = size(constraints, 1);
constr_idx = zeros(1, nconstr);
%%

for c = 1:nconstr
  constr_idx(c) = (constraints(c, 1)-1)*2 + constraints(c, 2);
end

K_constr = K;
K_constr(constr_idx, :) = [];
K_constr(:, constr_idx) = [];

f = zeros(2*nnodes, 1);
nf = size(forces, 1);
for fi = 1:nf
  idx = (forces(fi, 1)-1)*2+forces(fi, 2);
  f(idx) = f(idx) + forces(fi, 3);
end

f_constr = f;
f_constr(constr_idx) = [];

u_constr = K_constr\f_constr;
u = zeros(2*nnodes, 1);
free_idx = 1:2*nnodes;
free_idx(constr_idx) = [];
u(free_idx) = u_constr;
um = [u(1:2:end-1) u(2:2:end)];
plot_structure(nodes+um*100, connectivity, f_plot);
