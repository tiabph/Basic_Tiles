function Animation = GetNextAnimationFrame(Animation)
    if(Animation.CurrentFrame > Animation.alen)
        Animation.CurrentImage=[];
        return;
    else
        pos = Animation.CurrentFrame / Animation.alen;
        %Animation.offset = offset;
        offset = GetPar(Animation.offset, pos);
        %Animation.zoom = zoom;
        zoom = GetPar(Animation.zoom, pos);
        %Animation.cut=cut;
        cut = GetPar(Animation.cut, pos);
        %Animation.rotate=rotate;
        rotate = GetPar(Animation.rotate, pos);
        %Animation.color = color;
        color = GetPar(Animation.color, pos);
        
        Animation.CurrentFrame = Animation.CurrentFrame +1;
        Animation.CurrentImage = trans_img(Animation.img, offset, zoom, cut, rotate,color, Animation.xx,Animation.yy);
    end
end

function par = GetPar(raw, pos)
    s = size(raw);
    par = zeros(1,s(2));
    for m=1:s(2)
        if(s(1)==1)
            par(m) = interp1([0 1], [raw(1,m) raw(1,m)], pos,'spline');
        else
            par(m) = interp1(((1:s(1))-1)./(s(1)-1), raw(:,m)',pos,'spline');
        end
    end
end