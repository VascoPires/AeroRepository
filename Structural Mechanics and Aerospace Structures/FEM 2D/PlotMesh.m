function PlotMesh( nodes, elements, f, col,linetype,width)
%PlotMesh plot the mesh
%   nodes(nnodes, 2): position of the nodes
%   elements(nelements, 4): element connectivity
figure(f);
hold on;
c = [1 2; 2 3; 3 4; 4 1];

for e = 1:size(elements, 1);
    el = elements(e, :);
    for l = 1:4
        plot(nodes(el(c(l,:)), 1), nodes(el(c(l,:)), 2),Color=col,LineStyle=linetype,LineWidth=width);
    end
end

end

