function map = UpdateNodes(map, input, nodelist)
%update nodes' weight and connection
    mapsize = map.mapsize;
    weightRate = 0.02;
    connRate = 0.001;
    
    for m=1:length(nodelist)
        [nx ny] = ind2sub(mapsize, nodelist(m));
        
        %node parameter
        inputWeight = map.inputWeight{nx, ny};
        connection = map.connection{nx, ny};
        error = map.error(nx, ny);
        response = map.response(nx, ny);
        
        %
        input = (input-min(input(:)))./(max(input(:))-min(input(:)));
        distance = input - inputWeight;
        error = error*0.99 + norm(distance(:));
        
        %change the weight
        inputWeight = inputWeight + distance*weightRate;
        
        %change the connection
        fitness = sum(input(:).^2./input(:).*inputWeight(:));
        tempconnmap = InitConnectionMap(mapsize, nx, ny);
        tempconnmap = tempconnmap.*connRate;
        connection = connection + tempconnmap;
        
        for n=1:length(nodelist)
            if(n~=m)
                [tnx tny] = ind2sub(mapsize, nodelist(n));
                tresponse = map.response(tnx, tny);
                connection(tnx, tny) = connection(tnx, tny)+tresponse*connRate;
            end
        end
    end
end

%init connection map with gaussian function
function connmap = InitConnectionMap(mapsize, m,n)
    baselevel = -0.2;
    peak = 0.6;
    sigma1 = 3;
    sigma2 = 30;
    [xx yy] = meshgrid(1:mapsize(1), 1:mapsize(2));
    connmap = (peak-baselevel).*exp(-((xx-m).^2+(yy-n).^2)/sigma1^2) ...
        + baselevel.*exp(-((xx-m).^2+(yy-n).^2)/sigma2^2);
end