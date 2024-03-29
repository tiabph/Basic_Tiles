[xx yy] = meshgrid(1:200, 1:200);
% a=CreateAnimation(imgbuf{100,1}, 100, [40 40; 60 60], [1 1;3 4], [0 0], [0.5; -0.5],[0 1; 1 0], xx,yy);
% [xx yy] = meshgrid(1:100, 1:100);
a = CreateAnimationRand(imgbuf, xx,yy);
figure(1)
while(1)
    a=GetNextAnimationFrame(a);
    if(~isempty(a.CurrentImage))
        imagesc(a.CurrentImage)
        colormap gray
    else
        break;
    end
    drawnow
    pause(0.1);
end