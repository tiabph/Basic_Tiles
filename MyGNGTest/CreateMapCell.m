function map = CreateMapCell(mapsize, inputsize)
    %Create the map, stored in cell
    
    %map size
    map.mapsize = mapsize;
    %input size
    map.inputsize = inputsize;
    %reconstruction result
    map.reconstruction = zeros(inputsize);
    
    %input weight of each nodes
    map.inputWeight = cell(mapsize);
    for m =1:mapsize(1)
        for n=1:mapsize(2)
            map.inputWeight{m,n} = (rand(inputsize)-0.5)*0.025;
        end
    end
    
    %connection between nodes
    map.connection = cell(mapsize);
    for m =1:mapsize(1)
        for n=1:mapsize(2)
            map.connection{m,n} = InitConnectionMap(mapsize,m,n);
        end
    end
    
    %error of each nodes
    map.error = zeros(mapsize);
    
    %map response map
    map.response = zeros(mapsize);
    
    %map age map
    map.age = zeros(mapsize);
end

%init connection map with gaussian function
function connmap = InitConnectionMap(mapsize, m,n)
    baselevel = -0.2;
    peak = 0.4;
    sigma1 = 1;
    sigma2 = 10;
    [xx yy] = meshgrid(1:mapsize(1), 1:mapsize(2));
    connmap = (peak-baselevel).*exp(-((xx-m).^2+(yy-n).^2)/sigma1^2) ...
        + baselevel.*exp(-((xx-m).^2+(yy-n).^2)/sigma2^2);
end