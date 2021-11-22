function plot_structure(nodes,connectivity,f,c)

figure(f)
hold on

%Counts the number of lines of the connectivity matrix, i.e, number of rods
nrods = size(connectivity, 1);

%Connects and plots every par of nodes for each e
for e = 1:nrods
    
    %Defines the extrimities of the rods 
    %(connection of the nodes in each e )
    
    n1 = connectivity(e,1); %Defines node1
    n2 = connectivity(e,2); %Defines node2
    
    %Defines the positions of the nodes:

    x1 = nodes(n1,1);
    y1 = nodes(n1,2);
    x2 = nodes(n2,1);
    y2 = nodes(n2,2);
    
    plot([x1,x2],[y1,y2],'-o',Color=c)
end
end