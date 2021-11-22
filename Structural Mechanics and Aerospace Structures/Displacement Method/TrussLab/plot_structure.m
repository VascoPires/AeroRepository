function plot_structure(nodes, connectivity, f)
figure(f);
hold on;
nrods = size(connectivity, 1);
for e = 1:nrods
  n1 = connectivity(e, 1);
  n2 = connectivity(e, 2);
  x1 = nodes(n1, 1);
  y1 = nodes(n1, 2);
  x2 = nodes(n2, 1);
  y2 = nodes(n2, 2);
  plot([x1 x2], [y1 y2]);
 end
end

 