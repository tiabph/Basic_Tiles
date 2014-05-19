%test rotation response
testimg = 'rout.tif';

testimgbuf = double(tiffread(testimg));
timglen = size(testimgbuf,3);
mapsize = map.mapsize;
resultbuf = zeros(mapsize(1), mapsize(2), timglen);
anglelist = (1:timglen)./timglen.*260;

for m = 1:round(timglen)
    timg = testimgbuf(:,:,m);
    timg = timg./max(timg(:));
    [map] = TestMapCell(map, timg);
    resultbuf(:,:,m) = map.response;
end

dirmap = zeros(mapsize(1), mapsize(2));
ampmap = zeros(mapsize(1), mapsize(2));
for m=1:mapsize(1)
    for n=1:mapsize(2)
        tres = reshape(resultbuf(m,n,:),1,[]);
        posmax = find(tres==max(tres));
        posmax=posmax(1);
        dirmap(m,n) = anglelist(posmax);
        ampmap(m,n) = max(tres) - min(tres);
    end
end

%display map
figure(1)
subplot(2,2,1)
imagesc(dirmap)
colormap gray
title('dir map');
subplot(2,2,2)
hist(dirmap(:), 50)

subplot(2,2,3)
imagesc(ampmap)
title( 'amp map');
subplot(2,2,4)
hist(ampmap(:), 50)
