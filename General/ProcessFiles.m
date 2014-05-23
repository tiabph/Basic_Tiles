function [filenum filenamelist resultbuf] = ProcessFiles(searchpath, isdir, matchexp, fileprocesshandle)
    filelist = dir(searchpath);
    filelen = length(filelist);
    filenum = 0;
    filenamelist = cell(1,filelen);
    resultbuf = cell(1,filelen);
    
    pathfix = '';
    if(isdir)
        pathfix = '\';
    end
    
    for m=1:filelen
        tempfile = filelist(m);
        tfilename = tempfile.name;
        if(strcmp(tfilename,'.') || strcmp(tfilename,'..'))
            continue
        end
        if(tempfile.isdir == isdir)
            if(isempty(matchexp) || ~isempty(regexpi(tfilename,matchexp,'once')))
                %processing file
                try
                    tresult = fileprocesshandle([searchpath tfilename pathfix]);
                    
                catch ex
                    % no output
                    fileprocesshandle([searchpath tfilename pathfix]);
                    tresult = [];
                end
                
                filenum = filenum+1;
                filenamelist{filenum} = tfilename;
                if(iscell(tresult))
                    resultbuf(filenum) = tresult;
                else
                    resultbuf{filenum} = tresult;
                end
            end
        end
    end
    filenamelist = filenamelist(1:filenum);
    resultbuf = resultbuf(1:filenum);
end