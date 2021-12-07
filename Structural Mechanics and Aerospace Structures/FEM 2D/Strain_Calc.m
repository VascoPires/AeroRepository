function [Strain_Element,Strain_Tensor_Element] = Strain_Calc(nodes,Global_Displ_Element,xi)

    [der, J] = SpatialDerivative(nodes, xi);
    B = BN(der);
    Strain_Tensor_Element = B;
    
    %Strain = [B]*u_element
    Strain_Element = B*Global_Displ_Element;

end