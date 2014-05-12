[xx yy] = meshgrid(1:100, 1:100);
a = CreateAnimationRand(imgbuf, xx,yy);
tilesize = 8;   %6*6
sampleSize = 100000;

mask = [-1/8, -1/8, -1/8; ...
    -1/8, 1, -1/8; ...
    -1/8, -1/8, -1/8];
Sample = zeros(sampleSize, tilesize*tilesize);
scnt = 0;
hwaitbar=waitbar(0,'progress...');
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
            for m=1:tilesize:(100-tilesize)
                if(scnt>sampleSize)
                    break
                end
                for n=1:tilesize:(100-tilesize)
                    ttile = timg2(m:m+tilesize-1,n:n+tilesize-1);
                    if(sum(abs(ttile(:)))>0.5)
                        scnt = scnt+1;
                        if(scnt>sampleSize)
                            break
                        end
                        Sample(scnt,:) = ttile(:);
                        waitbar(scnt/sampleSize, hwaitbar);
                    end
                end
            end
        else
            break;
        end
    end
end

close(hwaitbar);