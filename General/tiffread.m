function [img imglen] = tiffread(filepath)
    imginfo = imfinfo(filepath);
    imglen = length(imginfo);
    imginfo = imginfo(1);
    img = zeros(imginfo.Height, imginfo.Width, imglen);
    for m=1:imglen
        img(:,:,m) = imread(filepath,m);
    end
end