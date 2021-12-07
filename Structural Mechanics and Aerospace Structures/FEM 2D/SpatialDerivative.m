function [xder, J] = SpatialDerivative(nodes, xi)

	deN_dexi = BilinWeightsDer(xi);
	dex_dexi = deN_dexi * nodes;
	J = det(dex_dexi);
	%dexi_dex = inv(dex_dexi);
	xder = dex_dexi\deN_dexi;
    
end