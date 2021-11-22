function Ki = ComputeStiffness(nodes,conn,properties)

%conn -> connectivity matrix for the line i
%properties -> properties of the rod i

%conn and properties are vectors [a b] corresponding to one 
%line of the respective matrix

    %First node position of the rod:
    x1 = nodes(conn(1),1); 
    y1 = nodes(conn(1),2); 

    
    %Second node position of the rod:    
    x2 = nodes(conn(2),1);
    y2 = nodes(conn(2),2);
    
    %Lenght of the rod:
    L = sqrt((x2-x1)^2+(y2-y1)^2);
    
    %Rod Stiffness: E*A/L
    rod_stiff = properties(1) * properties(2)/L;
    
    %Components of the Rotation Matrix
    cosa = (x2-x1)/L;
    sina = (y2-y1)/L;
    
    %Rotation Matrix B -> Transformation Matrix
    
    B = [cosa sina 0 0; 0 0 cosa sina];

    %Stiffness of the rod idealized as a spring, 
    % (E*A/L)*[1 -1
    %         -1 1]
    Ki = rod_stiff * [1 -1;-1 1];
    
    Ki = B'*Ki*B;

end
