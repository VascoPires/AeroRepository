function BN = BN (der)
%Build the deformation tensor shape functions
%The DOFs are ordered as [x1 x2 x3 x4 y1 y2 y3 y4]  
%Matrix 3x8:
%Each row is a component of the strain
%Each column is what we are multiplying by the respective displacement
    BN = zeros(3, 8);
    
    %We will have 3 componentes of strain:
    BN(1, 1:4) = der(1,:);  %Strain Epsilon_xx
    BN(2, 5:8) = der(2,:);  %Strain Epsilon_yy
    BN(3, 1:4) = der(2,:);  %Strain Epsilon_xy
    BN(3, 5:8) = der(1,:);
end