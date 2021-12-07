function [ Force ] = VolumeForce( nodes, f, xi )
%ElementLocalStiffness computer the element local stiffness
%   nodes: coordinates of the nodes
%   E: Elastic tensor
%   W: Inteprolating function
%   W: Interpolating function derivatives
%   xi: local coordinate

    N = BilinWeights(xi); %Interpolating Functions
    [der, J] = SpatialDerivative(nodes, xi);
    BN = [N*f(1), N*f(2)]';
    Force = BN * J;
end
