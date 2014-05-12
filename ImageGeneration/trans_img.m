function resultimg = trans_img(img, offset, zoom, cut, rotate,color, xx,yy)
    imgsize = size(img);
    [img_xx img_yy] = meshgrid(1:imgsize(1),1:imgsize(2));
    outimgsize = size(xx);
    %resultimg = zeros(outimgsize);
    transmat = [1/zoom(1) 0; 0 1/zoom(2)]*[cos(rotate) -sin(rotate); sin(rotate) cos(rotate)] ...
        *[1 cut(1); 0 1] *[1 0; cut(2) 1];
    poslist = [xx(:)-offset(1) yy(:)-offset(2)];
    poslist_img = (transmat*poslist')';
    int = interp2(img_xx, img_yy, img, poslist_img(:,1), poslist_img(:,2), 'cubic');
    int(isnan(int)) =0;
    int = int*(color(2)-color(1))+color(1);
    resultimg = reshape(int, outimgsize);
end