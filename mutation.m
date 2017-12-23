function chroms = mutation(chroms, positionData, mutPos)
%变异 单点变异
disp('mutation executing...');
[~,n] = size(chroms);
[~,m] = size(chroms{1,1}.HangbanSeNum);
[q,~] = size(positionData);

indexC = 1;
while indexC<n
    if(randi([1 10],1,1)*mutPos == 1)
        indexj = randi([1 m],1,1);%随机生成变异点
        flag = 1;
        while flag == 1
            tt = randi([1 q],1,1);%随机生成机位号
            if tt == chroms{1,indexC}.Position(indexj)
                continue;
            end
            chroms{1,indexC}.Position(indexj) = tt;
            flag = 0;
        end
    end
    indexC = indexC+1;
end
end