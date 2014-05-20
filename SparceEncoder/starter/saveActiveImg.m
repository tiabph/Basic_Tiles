%write simulated image and activation into files
%write simulated image
patchfile = 'patch.tif';
activefile = 'active.tif';
patchnum = size(patches,2);
patchsize = 8;
imgbuf = reshape(patches, patchsize, patchsize, patchnum);
imgbuf = imgbuf./max(imgbuf(:)).*1024;

tiffwriteStack(imgbuf, patchfile);

hiddensize = 5;
activebuff = zeros(hiddensize, hiddensize, patchnum);
for m=1:patchnum
    tinput = patches(:,m);
    tactive = W1*tinput;
    activebuff(:,:,m) = reshape(tactive, hiddensize, []);
end
activebuff = activebuff ./ max(activebuff(:));
activebuff = activebuff.*1024;
tiffwriteStack(activebuff, activefile);