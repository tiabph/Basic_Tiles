%train a map cell
inputset = double(imgbuf);
inputset = inputset./max(inputset(:));

inputnum = size(inputset,3);
nodeSelectNum = 10;

lamda = 10;
trainround = 100;

for roundcnt = 1:trainround
    h=waitbar(0,['round:' num2str(roundcnt) ' progress...']);
    for traincnt = 1:inputnum
        %prepare the input data
        input = inputset(:,:,traincnt);

        %simulation on the network
        [map] = TestMapCell(map, input);

        %find the top nodes
        response = map.response;
        reslist = response(:);
        [~, index] = sort(reslist);
        nodelist = index(1:nodeSelectNum);

        map = UpdateNodes(map, input, nodelist);

        if(mod(traincnt, lamda)==0)
            imagesc(map.response); drawnow
            waitbar(traincnt/inputnum,h);
        end
    end
    close(h)
end
