function [nodes, elements, constr_nodes]= Nodes(nx, ny,l,h)

%Nx - Number of elements in the x diretion
%Ny - Number of elements in the y direction
%l - Lenght of the Beam
%h - Height of the Beam

%Computes the nodes and elements of the problem and the constrained nodes


    % Opens a node matrix with nx+1 nodes in the x direction and ny+1 nodes in
    % the y direction -> (nx+1)*(ny+1) rows and 2 columns
    nodes = zeros((nx+1) * (ny+1), 2); 
    x = [0 : l/nx : l];
    
    %Builds the nodes matrix
    nodes(:,1) = (repmat(x,1,ny+1))'; %Repeats the x vector in the nodes first column ny+1 times
    nodes(:,2) = reshape(repmat((0:ny)/ny*h, nx+1, 1), (nx+1)*(ny+1), 1);
    
    %Building elements
    elements = zeros(nx * ny, 4);
    
    elements(:, 1) = reshape(repmat((1:nx)',1,ny) + repmat(0:nx+1:nx*ny+(ny-nx),nx,1), nx*ny, 1);
    elements(:, 2) = elements(:, 1) + 1;
    elements(:, 3) = elements(:, 1) + 1 + nx + 1;
    elements(:, 4) = elements(:, 1) + nx + 1;
    
    %Constrained Nodes
    constr_nodes = 1:nx+1:(nx+1)*(ny+1);
end
