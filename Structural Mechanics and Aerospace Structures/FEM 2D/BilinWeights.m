function weights = BilinWeights(x)
    %Bilinear interpolating functions
     %Bilinear weights

     %x must be a (1x2) vector
     %weights is a (1x4) vector [N1 N2 N3 N4]

     ndim = 2;
     nnodes = 4;
     weights = zeros(1, 4);
     weights(1) = (x(1) - 1.) * (x(2) - 1.) *  0.25; %-1 -1
     weights(2) = (x(1) + 1.) * (x(2) - 1.) * -0.25; % 1 -1
     weights(3) = (x(1) + 1.) * (x(2) + 1.) *  0.25; % 1  1
     weights(4) = (x(1) - 1.) * (x(2) + 1.) * -0.25; %-1  1
end

