function [map] = TestMapCell(map, inputInt)
    connfactor = 0.01;
    mapsize = map.mapsize;
    inputWeight = map.inputWeight;
    connection = map.connection;
    
    initresponse = zeros(mapsize);
    
    %raw response to the input
    for m =1:mapsize(1)
        for n=1:mapsize(2)
            initresponse(m,n) = sum(inputInt(:) .* inputWeight{m,n}(:));
        end
    end
    
    %add connection
    connresponse = zeros(mapsize);
    for m =1:mapsize(1)
        for n=1:mapsize(2)
            nodeconnection = connection{m,n};
            nodeconnection(m,n)=0;
            connresponse(m,n) = sum(nodeconnection(:).*initresponse(:));%/sum(nodeconnection(:).^2);
        end
    end
    
    initresponse = (1./(1+exp(-initresponse.*2))-0.5)*2;
    connresponse = (1./(1+exp(-connresponse.*2))-0.5)*2*connfactor;
    initresponse = initresponse+connresponse;
    %sigmoid response
    map.response = (1./(1+exp(-initresponse.*2))-0.5)*2;
end