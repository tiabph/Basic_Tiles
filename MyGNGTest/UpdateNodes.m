function map = UpdateNodes(map, input, nodelist)
%update nodes' weight and connection
    
    mapsize = map.mapsize;
    weightRate = 0.005;
    connRate = 0.0001;
    input = (input-min(input(:)))./(max(input(:))-min(input(:)));
    if(any(isnan(input(:))))
        return
    end
    map.age = map.age +1;
    for m=1:length(nodelist)
        [nx ny] = ind2sub(mapsize, nodelist(m));
        
        %node parameter
        inputWeight = map.inputWeight{nx, ny};
        connection = map.connection{nx, ny};
        error = map.error(nx, ny);
        response = map.response(nx, ny);
        
        %
%         input = (input-min(input(:)))./(max(input(:))-min(input(:)));
        distance = input - inputWeight;
        distance = distance-mean(distance(:));
        error = error*0.9 + norm(distance(:));
        if(isnan(error))
            disp('nan err');
        end
        
        %change the weight
        inputWeight = inputWeight + distance*weightRate;
%         for tm = (nx-2):(nx+2)
%             for tn = (ny-2):(ny+2)
%                 if((tm~=nx || tn~=ny) && tm>0 && tn>0 && tm<=mapsize(1) && tn<=mapsize(2))
%                     tdistance = input - map.inputWeight{tm, tn};
%                     tdistance = tdistance - mean(tdistance(:));
%                     map.inputWeight{tm, tn} = map.inputWeight{tm, tn} + tdistance*connRate;
%                 end
%             end
%         end
        
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
        
        map.inputWeight{nx, ny} = inputWeight;
        map.connection{nx, ny} = connection;
        map.error(nx, ny) = error;
        map.response(nx, ny) = response;
        map.age(nx, ny)=0;
    end
end

%init connection map with gaussian function
function connmap = InitConnectionMap(mapsize, m,n)
    baselevel = -0.1;
    peak = 0.6;
    sigma1 = 1;
    sigma2 = 10;
    [xx yy] = meshgrid(1:mapsize(1), 1:mapsize(2));
    connmap = (peak-baselevel).*exp(-((xx-m).^2+(yy-n).^2)/sigma1^2) ...
        + baselevel.*exp(-((xx-m).^2+(yy-n).^2)/sigma2^2);
end