function KEL = ComputeStiffness(nodes, con, prop)
  x1 = nodes(con(1), 1);
  y1 = nodes(con(1), 2);
  x2 = nodes(con(2), 1);
  y2 = nodes(con(2), 2);
  l = sqrt((x2 - x1)^2 + (y2-y1)^2);
  rod_stiff = prop(1) * prop(2) / l;
  cosa = (x2 - x1) / l;
  sina = (y2 - y1) / l;
  B = [cosa sina 0 0; 0 0 cosa sina];
  k = [rod_stiff -rod_stiff; -rod_stiff rod_stiff];
  KEL = B' * k * B;
end
