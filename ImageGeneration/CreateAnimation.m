function Animation = CreateAnimation(img, alen, offset, zoom, cut, rotate,color, xx,yy)
    Animation = [];
    Animation.img = img;
    Animation.alen = alen;
    Animation.offset = offset;
    Animation.zoom = zoom;
    Animation.cut=cut;
    Animation.rotate=rotate;
    Animation.color = color;
    Animation.xx=xx;
    Animation.yy=yy;
    Animation.CurrentFrame = 1;
    Animation.CurrentImage = [];
end