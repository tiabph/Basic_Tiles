%make active map for a big picture
patchsize = 8;
img = IMAGES(:,:,1);   %image
imgsize = size(img);
overlap = 0;
hiddensize = 25;
outsize = 3;
activemapsize = [floor(imgsize(1)/patchsize) floor(imgsize(2)/patchsize) hiddensize];
activemap = zeros(activemapsize);

tm=1;
tn=1;
transmat = (rand(outsize, hiddensize)-0.5)*2;%transform matrix
reconstructedimg = zeros(imgsize);
for m=1:(patchsize-overlap):(imgsize(1)-patchsize)
    tn=1;
    for n=1:(patchsize-overlap):(imgsize(2)-patchsize)
        patch = img(m:(m+patchsize-1), n:(n+patchsize-1));
        tactive = W1*reshape(patch, patchsize*patchsize,1)+b1;
        toutput = W2 * tactive+b2;
        reconstructedimg(m:(m+patchsize-1), n:(n+patchsize-1)) = reshape(toutput, patchsize, patchsize);
        activemap(tm,tn,:) = tactive(:);
        tn=tn+1;
    end
    tm=tm+1;
end

tiffwrite(abs(activemap+40).*100,'activemap.tif')