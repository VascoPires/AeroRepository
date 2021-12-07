function ders =  BilinWeightsDer(x)
        %Bilinear interpolating functions
        %   Detailed explanation goes here
    
        ndim = 2;
        nnodes = 4;
        %Bilinear weight derivatives
        %   x must be a (1x2) vector
        %   ders is a (2x4) vector: ders(i,j) is the partial derivative of
        %   weight j with respect to the coordinate i
        ders = zeros(2, 4);
        ders(1, 1) = (x(2) - 1.) *  0.25;   %-1 -1
        ders(1, 2) = (x(2) - 1.) * -0.25;   % 1 -1
        ders(1, 3) = (x(2) + 1.) *  0.25;   % 1  1
        ders(1, 4) = (x(2) + 1.) * -0.25;   %-1  1
        ders(2, 1) = (x(1) - 1.) *  0.25;   %-1 -1
        ders(2, 2) = (x(1) + 1.) * -0.25;   % 1 -1
        ders(2, 3) = (x(1) + 1.) *  0.25;   % 1  1
        ders(2, 4) = (x(1) - 1.) * -0.25;   %-1  1
end
