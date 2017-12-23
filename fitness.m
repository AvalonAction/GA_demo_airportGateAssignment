function chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, goal)
disp('fitness executing...');
%油耗+靠桥率
[~,n] = size(chroms);
[~,m] = size(chroms{1,1}.HangbanSeNum);
chromsIndex = 1;
while chromsIndex<=n
    HangbanIndex = 1;
    kaoqiaohbNum = 0;
    cost = 0;
    
    while HangbanIndex<=m
        
        Pos = chroms{1,chromsIndex}.Position(HangbanIndex);
       
        %靠桥
        if positionData(Pos,3)==1
            kaoqiaohbNum = kaoqiaohbNum + 1;
        end
        %油耗
        timeCos = time(Pos,hangbanData(HangbanIndex, 7)) + time(Pos,hangbanData(HangbanIndex, 8));
        cost = cost + timeCos*oilCost(hangbanData(HangbanIndex, 3),2);
        HangbanIndex = HangbanIndex+1;
    end
    switch (goal)
        case 1
            %总油耗
            chroms{1,chromsIndex}.fitness1 = cost;
        case 2
            %靠桥率
            chroms{1,chromsIndex}.fitness2 = kaoqiaohbNum/m;
        case 0
            %总油耗
            chroms{1,chromsIndex}.fitness1 = cost;
            %靠桥率
            chroms{1,chromsIndex}.fitness2 = kaoqiaohbNum/m;
            
            %多目标===================
            fitness1 = cost;
            fitness2 = 1/chroms{1,chromsIndex}.fitness2;%最大化变最小化；取倒数
            %%归一化=====================
            fit0 = max([fitness1, fitness2]);  %求最大的作分母
            chroms{1,chromsIndex}.fitness = w1*fitness1/fit0 + w2*fitness2/fit0;%总目标函数公式
        otherwise
            fprintf('单目标or多目标？参数仔细再看看\n' );
    end  
    chromsIndex = chromsIndex + 1;
end




end