function result = CreateAnimationRand(imgbuf, xx,yy)
    pointrange = [2;1];
    alenrange = [2;4];
    offsetrange = [00,00; 10,10];
    zoomrange = [2,2; 4,4];
    cutrange = [-0.1, -0.1; 0.1 0.1];
    rotaterange = [-pi/6; pi/6];
    colorrange = [0,1; 0.3,0.7];
    
    img = imgbuf{floor(rand()*length(imgbuf))};
    pointnum = round(GetRandPar(pointrange));
    alen = round(GetRandPar(alenrange));
    offset = GetRandParEx(offsetrange, pointnum);
%     offset = [10,10; 60,10];
    zoom = GetRandParEx(zoomrange, pointnum);
    cut = GetRandParEx(cutrange, pointnum);
    rotate = GetRandParEx(rotaterange, pointnum);
    color = GetRandParEx(colorrange, pointnum);
    
    result = CreateAnimation(img, alen, offset, zoom, cut, rotate,color , xx,yy);
end

function result = GetRandParEx(paramrange, pointnum)
    s = size(paramrange);
    result = zeros(pointnum,s(2));
    for n =1:pointnum
        for m = 1:s(2)
            t=paramrange(:,m);
            result(n,m) = min(t)+rand()*(max(t)-min(t));
        end
    end
end

function result = GetRandPar(paramrange)
    s = size(paramrange);
    result = zeros(1,s(2));
    for m = 1:s(2)
        t=paramrange(:,m);
        result(m) = min(t)+rand()*(max(t)-min(t));
    end
end