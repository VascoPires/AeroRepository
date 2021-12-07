function Stiff = ElementLocalStiffness(nodes,E, xi)

%   ElementLocalStiffness computer the element local stiffness
%   nodes: coordinates of the nodes
%   E: Elastic tensor 
%   W: Interpolating function derivatives 
%   xi: local coordinate

%   der is the derivative
%   J is the jacobian

    [der, J] = SpatialDerivative(nodes, xi);
    B = BN(der);
    Stiff = B' * E * B * J;

end
