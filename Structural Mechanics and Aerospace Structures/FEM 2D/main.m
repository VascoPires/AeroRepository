%% Header
%Computes the solution of a cantilever beam submitted to force per unit of
%area in it's whole surface, i.e, there's a specific force applied in each
%element of the domain.

%The code is also valid if the nodes and elements are imported from a data
%file, however the code will need to be adapted.

%Author: Vasco Pires

clear all;
clc;
close all;

Scaling = 10;

%% Data (Inputs)

%Material
E = 20E3;           %Elastic Modulus [MPa]
nu = 0.3;           %Poisson coefficient

l = 10;              %Lenght of the beam [mm]
h = 2;               %Height of the beam [mm]

size_element_x = 0.1;
size_element_y = 0.1;

n_elements_x = round(l/size_element_x);
n_elements_y = round(h/size_element_y);

%n_elements_x = 30;   %Number of elements in the x direction
%n_elements_y = 30;   %Number of elements in the y direction

force = [0 1];      %Direction of the Force per unit of surface

% This force per unit of surface is applied in each element

%% Nodes

% Computes the Nodes, Elements and the Constrained Nodes
[nodes,elements,constr_nodes] = Nodes(n_elements_x,n_elements_y,l,h);

%Each row corresponds to the nodes of a said element. Example: The element
%1, will have nodes: [1 2 nx+2 nx+3]

%Constrained DOF, the first constr_nodes are in the horizontal direction
%and in order. The second part is the vertial displacement of the nodes.
constr_dofs = [constr_nodes constr_nodes + size(nodes, 1)]';

free_dofs = 1:2*size(nodes, 1);     %All DOF of the system
free_dofs(constr_dofs) = [];        %Changes the DOF to 0 using the constrained nodes index

%% Stiffness

% Computes the Stiffness matrix of an element
C = PlaneStressElasticTensor(E,nu);

GlobalStiff = zeros(size(nodes, 1)*size(nodes, 2));

GlobalRes = zeros(size(nodes, 1)*size(nodes, 2), 1);    %Residual Vector
GlobalDispl = GlobalRes;                                %Displacement Vector

%% Assembly

for e = 1:size(elements,1)
    
    conn = elements(e,:);     %In each row, we have all the nodes of a said element
    nod = nodes(conn,:);      %Coordinate of the nodes of each element

    %x is the local coordinate
    Stiff = GaussIntegr2D2x2(@(x)ElementLocalStiffness(nod,C,x)); %Internal virtual work in a element
    
    %Residual force vector
    Res = GaussIntegr2D2x2(@(x)VolumeForce(nod,force, x));  %External virtual work in a element

    %Indexes of the x and y componentes of the nodes related to this element
    conn = [elements(e,:) elements(e,:)+size(nodes, 1)]';      
  
    GlobalStiff(conn, conn) = GlobalStiff(conn, conn) + Stiff; %Assembles the global stiffness matrix
    GlobalRes(conn, :) = GlobalRes(conn, :) + Res;             %Assembles the global load vector
end


%Removes the columns and lines related to the constrained nodes in the Global
%Stiffness Matrix
GlobalStiff(:, constr_dofs) = [];   
GlobalStiff(constr_dofs, :) = [];

%Removes the lines related to the constrained nodes
GlobalRes(constr_dofs, :) = [];

%Solves the system of equations -> Displacement Vector
displ = GlobalStiff \ GlobalRes;

GlobalDispl(free_dofs,:) = displ;   %Only the free nodes will have displacement

%Reshape the vector into a matrix where each row has the (x,y) coordinates
%of the node
GlobalDispl = reshape(GlobalDispl, size(nodes));

%% Plot
f1 = figure(1);

%Patch Loop
new_nodes = nodes+GlobalDispl*Scaling;

for e=1:size(elements,1)
   
    conn = elements(e,:);   
    nod = new_nodes(conn,:);
    p = patch(nod(:,1),nod(:,2),[169,169,169]/255);
 
    hold on

end
%Plot the nodes and undeformed and deformed beam

PlotMesh(nodes, elements, f1, '#808080','--',0.5);  %Plots the undeformed beam
PlotMesh(nodes + GlobalDispl*Scaling, elements, f1, 'black','-',1);

%Plot distributed load

% last_node = max(elements(end,:));
% arrow_scaling = 0.3;
% 
% for i=1:10
% 
%     arrow_load(i) = quiver(new_nodes(last_node)-(i-1)*(l/10),new_nodes(end-1)+1,0,new_nodes(end-1)+1,arrow_scaling,color='black',LineWidth=1,MaxHeadSize=0.4);
% 
% end

%line([new_nodes(last_node)-i+1,new_nodes(last_node)],[new_nodes(end-1)+1,new_nodes(end-1)+1],Color='black')

axis equal
grid on

title('Deformed Beam','Interpreter','latex')
xlabel('x [mm]','Interpreter','latex')
ylabel('y [mm]','Interpreter','latex')

%% Post-Processing

%Calculating the strain tensor on an element. In this case Element 1:

conn = elements(1,:);   % Nodes in Element 1
nod = nodes(conn,:);    % Coordinates of the nodes of Element 1

Element_GlobalDispl = zeros(2*size(nod,1),1);
Element_GlobalDispl(size(nod)+1:end) = GlobalDispl(conn,2);
Element_GlobalDispl(1:size(nod)) = GlobalDispl(conn,1);


constr_dofs = [constr_nodes constr_nodes + size(nodes, 1)]';

[Strain_Element1,Strain_ElementTensor1] = Strain_Calc(nod,Element_GlobalDispl,[0,0]);

Stress_ElementTensor1 = C*Strain_ElementTensor1;

Stress_Element1 = C*Strain_Element1;

% Print the Tensors of the Element 1
fprintf('\n---------------------  Element 1 --------------------- \n'); %\n -> new line
fprintf('We want to calculate the Stress and Strain Tensors in Element 1\n'); %\n -> new line


fprintf('Strain Tensor:\n')
disp(Strain_ElementTensor1)
fprintf('Stress Tensor:\n')
disp(Stress_ElementTensor1)

fprintf('\nStrain:\n')
disp(Strain_Element1)
fprintf('\nStress (MPa):\n')
disp(Stress_Element1)

for e = 1:size(elements,1)
    
    conn = elements(e,:);     %In each row, we have all the nodes of a said element
    nod = nodes(conn,:);      %Coordinate of the nodes of each element
   
    Element_GlobalDispl(size(nod)+1:end) = GlobalDispl(conn,2);
    Element_GlobalDispl(1:size(nod)) = GlobalDispl(conn,1);

    %Strain
    [Strain_Element,Strain_Element_Tensor] = Strain_Calc(nod,Element_GlobalDispl,[0,0]);

    %Stress
    Stress_ElementTensor = C*Strain_Element_Tensor;
    Stress_Element = C*Strain_Element;

    delta = (Stress_Element(1)-Stress_Element(2))^2+(Stress_Element(1))^2 + (Stress_Element(2))^2+6*Stress_Element(3)^2;
    vonMises(e) = (1/sqrt(2))*sqrt(delta);
    sigma_xx(e) = Stress_Element(1);
    sigma_yy(e) = Stress_Element(2);
    sigma_xy(e) = Stress_Element(3); %Shear Stress
    

end

f2 = figure(2);

%PlotMesh(nodes + GlobalDispl*Scaling, elements, f2, 'black','-',1);

%Patch Loop von Mises stress

axis equal
grid on

title('Von Mises Stress Plot','Interpreter','latex')
xlabel('x [mm]','Interpreter','latex')
ylabel('y [mm]','Interpreter','latex')

for e=1:size(elements,1)
   
    conn = elements(e,:);   
    nod = new_nodes(conn,:);
    
    X(:,e) = nod(:,1);
    Y(:,e) = nod(:,2);
    col(e) = vonMises(e);
end

colormap('turbo');
p = patch(X,Y,col);

col_bar = colorbar;
col_bar.Label.String = '\sigma^{vM} [MPa]';
col_bar.TickLabelInterpreter = 'latex';
col_bar.Label.FontSize = 12;
col_bar.Label;

%Plot of sigma_xx
f3 = figure(3);

PlotMesh(nodes + GlobalDispl*Scaling, elements, f3, 'black','-',1);

axis equal
grid on

title('$\sigma_{xx}$ Stress Plot','Interpreter','latex')
xlabel('x [mm]','Interpreter','latex')
ylabel('y [mm]','Interpreter','latex')

for e=1:size(elements,1)
   
    conn = elements(e,:);   
    nod = new_nodes(conn,:);
    
    X(:,e) = nod(:,1);
    Y(:,e) = nod(:,2);
    col(e) = sigma_xx(e);
end

colormap('turbo');
p = patch(X,Y,col);

col_bar = colorbar;
col_bar.Label.String = '\sigma_{xx} [MPa]';
col_bar.TickLabelInterpreter = 'latex';
col_bar.Label.FontSize = 12;
col_bar.Label;

%Plot of sigma_yy

f4 = figure(4);
PlotMesh(nodes + GlobalDispl*Scaling, elements, f4, 'black','-',1);

axis equal
grid on

title('$\sigma_{yy}$ Stress Plot','Interpreter','latex')
xlabel('x [mm]','Interpreter','latex')
ylabel('y [mm]','Interpreter','latex')

for e=1:size(elements,1)
   
    conn = elements(e,:);   
    nod = new_nodes(conn,:);
    
    X(:,e) = nod(:,1);
    Y(:,e) = nod(:,2);
    col(e) = sigma_yy(e);
end

colormap('turbo');
p = patch(X,Y,col);

col_bar = colorbar;
col_bar.Label.String = '\sigma_{yy} (MPa)';
col_bar.TickLabelInterpreter = 'latex';
col_bar.Label.FontSize = 12;
col_bar.Label;

%Plot of sigma_xy
%%
f5 = figure(5);
PlotMesh(nodes + GlobalDispl*Scaling, elements, f5, 'black','-',1);

axis equal
grid on

title('$\tau_{xy}$ Stress Plot','Interpreter','latex')
xlabel('x [mm]','Interpreter','latex')
ylabel('y [mm]','Interpreter','latex')

for e=1:size(elements,1)
   
    conn = elements(e,:);   
    nod = new_nodes(conn,:);
    
    X(:,e) = nod(:,1);
    Y(:,e) = nod(:,2);
    col(e) = sigma_xy(e);
end

colormap('turbo');
p = patch(X,Y,col);

col_bar = colorbar;
col_bar.Label.String = '\tau_{xy} (MPa)';
col_bar.TickLabelInterpreter = 'latex';
col_bar.Label.FontSize = 12;
col_bar.Label;
