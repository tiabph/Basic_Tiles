function Sample = GenSampleBuf(samplesize, samplenum, mask, filepath)
load('handwritingnumbers_t10k.mat');
[xx yy] = meshgrid(1:100, 1:100);
% a = CreateAnimationRand(imgbuf, xx,yy);
tilesize = samplesize(1);   %6*6
sampleSize = samplenum;
% tiffname = 'out.tif';

Threshold = 10;
if(nargin<3)
    mask = [1];
end
Sample = zeros(tilesize, tilesize, sampleSize);
scnt = 0;
% hwaitbar=waitbar(0,'progress...');
while(1)
    if(scnt>sampleSize)
        break
    end
    a = CreateAnimationRand(imgbuf, xx,yy);
    
    while(1)
        if(scnt>sampleSize)
            break
        end
        a=GetNextAnimationFrame(a);
        if(~isempty(a.CurrentImage))
            timg = a.CurrentImage;
            timg = timg./max(timg(:));
            timg2 = conv2(timg, mask, 'same');
            timg2 = timg2.*255;
            for m=1:tilesize:(100-tilesize)
                if(scnt>sampleSize)
                    break
                end
                for n=1:tilesize:(100-tilesize)
                    ttile = timg2(m:m+tilesize-1,n:n+tilesize-1);
                    if(sum(abs(ttile(:)))>Threshold)
                        scnt = scnt+1;
                        if(scnt>sampleSize)
                            break
                        end
                        Sample(:,:,scnt) = ttile;
%                         waitbar(scnt/sampleSize, hwaitbar);
                    end
                end
            end
        else
            break;
        end
    end
end

% close(hwaitbar);

if(nargin>=4)%write file
    tiffwriteStack(Sample, filepath);
end

end