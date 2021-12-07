function ElTens  = PlaneStressElasticTensor(E, nu)
	
    %   PlaneStress Elastic tensor
    %   Inputs: Young's Modulus and Poisson's Coefficient
	%   ElTens = Plane stress elastic tensor matrix for 2D
	
        ElTens = [1 nu 0; nu 1 0; 0 0 (1 - nu) / 2] * (E / (1 - nu^2));
end