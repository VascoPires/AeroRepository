function Integral = GaussIntegr2D2x2(f)
%   Gaussian quadrature 2x2
%   points and weights for 2x2 Gaussian quadrature
%   Integration domain: [-1, -1]x[1, 1]
% 
% Parameters:  
%   npoint: number of integration points
%   points(i,j): local coordinate j of integration point i
%   weights(i): integration weight of point i
%   Integral = integrate(f): integrate the function f(x); 
%   f must be a (matrix) function of a (1x2) vector
%   refer to: https://www.comsol.com/blogs/introduction-to-numerical-integration-and-gauss-points/

% The local position of the 2nd order Gaussian Quadrature is: +/- 1/(sqrt(3) 
% And the weight is 1

% For example, for a 3rd order Gaussian Quadrature:
% Position of points: 0, +/- 0.775
% Weights: 0.889 (= 8/9), 0.556 (= 5/9)

% The f function that this function will receive will be the interpolating
% N_i (xi) functions
    
    npoints = 4;
    points = [-1./sqrt(3.) -1./sqrt(3.);
    1./sqrt(3.) -1./sqrt(3.);
    1./sqrt(3.) 1./sqrt(3.);
    -1./sqrt(3.) 1./sqrt(3.)];

    weights = [1. 1. 1. 1.]';
    %Integrate the function f
    Integral = f(points(1,:)) * weights(1);

    for i = 2:npoints
     Integral = Integral + f(points(i,:)) * weights(i);
    end
   
end