function map = MapCellReconstruction(map)
    Threshold = 0.1;
    response = map.response;
    nodecnt = 0;
    reconstruction = zeros(map.inputsize);
    for n=1:length(response(:))
        if(response(n)>Threshold)
            nodecnt=nodecnt+response(n).^2;
            reconstruction = reconstruction +  ...
                map.inputWeight{n}.*response(n).^2;
        end
    end
    reconstruction = reconstruction./nodecnt;
    map.reconstruction = reconstruction;
end