%Generate rotation test image
imgsize = 5;
imglen = 100;

imgbuf = zeros(imgsize(1), imgsize(1), imglen);
img_base = zeros(imgsize(1)*2+1, imgsize(1)*2+1);
img_base(imgsize(1)+1,:)=1;
[xx yy] = meshgrid(1:imgsize, 1:imgsize);

for imgcnt = 1:imglen
    rotate = pi*2/imglen*imgcnt;
    resultimg = trans_img(img_base, [imgsize/2+0.5 imgsize/2+0.5], [1 1], [0 0], rotate,[0 1], xx,yy);
    imgbuf(:,:,imgcnt) = resultimg;
end

tiffwrite(imgbuf.*255, 'rout.tif');