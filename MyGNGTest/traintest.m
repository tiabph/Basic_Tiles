%train a map cell
addpath('..\ImageGeneration\');
inputsize = [5 5];
%Create a new map
map = CreateMapCell([25 25], inputsize);

inputnum = 10000;
nodeSelectNum = ceil(map.mapsize(1).^2*0.05);
connnodeSelectNum = nodeSelectNum*5;

lamda = 300;
trainround = 1000;
% h=waitbar(0,['round:' num2str(roundcnt) ' progress...']);
% hfigure = figure(1);
for roundcnt = 1:trainround
    inputset = GenSampleBuf(inputsize,inputnum);
    inputset = inputset./max(inputset(:));
%     waitbar(0,h, ['round:' num2str(roundcnt) ' progress...']);
    fwrite(1,['R' num2str(roundcnt) ' :']);
    for traincnt = 1:inputnum
        %prepare the input data
        input = inputset(:,:,traincnt);

        %simulation on the network
        [map] = TestMapCell(map, input);

        %find the top nodes
        response = map.response;
        reslist = response(:);
        [~, index] = sort(reslist,'descend');
        nodelist = index(1:nodeSelectNum);
        
        %find the top connected nodes
        connresponse = map.connresponse;
        connreslist = connresponse(:);
        [~, index] = sort(connreslist,'descend');
        connnodelist = index(1:connnodeSelectNum);

        map = UpdateNodes(map, input, nodelist, connnodelist);

        if(mod(traincnt, lamda)==0)
%             hist(map.response(:),-1:0.05:1); drawnow
            subplot(2,2,1); hist(map.error(:),20); title('error'); drawnow
            subplot(2,2,2); hist(map.age(:)); title('age'); drawnow
            subplot(2,2,3); imagesc(input); drawnow
            subplot(2,2,4); imagesc(map.response); drawnow
%             waitbar(traincnt/inputnum, h);
            fwrite(1,'.');
        end
    end
    disp('Done.');
end

% close(h)