[xx yy] = meshgrid(1:100, 1:100);
a = CreateAnimationRand(imgbuf, xx,yy);
figure(1)
figure(2)
mask = [-1/8, -1/8, -1/8; ...
    -1/8, 1, -1/8; ...
    -1/8, -1/8, -1/8];
while(1)
    a=GetNextAnimationFrame(a);
    if(~isempty(a.CurrentImage))
        figure(1)
        imagesc(a.CurrentImage)
        drawnow
        colormap gray
        
        timg = a.CurrentImage;
        timg2 = conv2(timg, mask, 'same');
        figure(2)
        imagesc((timg2))
        drawnow
        colormap gray
    else
        break;
    end
%     drawnow
    pause(0.1);
end