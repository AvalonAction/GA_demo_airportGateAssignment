function chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, goal)
disp('fitness executing...');
%�ͺ�+������
[~,n] = size(chroms);
[~,m] = size(chroms{1,1}.HangbanSeNum);
chromsIndex = 1;
while chromsIndex<=n
    HangbanIndex = 1;
    kaoqiaohbNum = 0;
    cost = 0;
    
    while HangbanIndex<=m
        
        Pos = chroms{1,chromsIndex}.Position(HangbanIndex);
       
        %����
        if positionData(Pos,3)==1
            kaoqiaohbNum = kaoqiaohbNum + 1;
        end
        %�ͺ�
        timeCos = time(Pos,hangbanData(HangbanIndex, 7)) + time(Pos,hangbanData(HangbanIndex, 8));
        cost = cost + timeCos*oilCost(hangbanData(HangbanIndex, 3),2);
        HangbanIndex = HangbanIndex+1;
    end
    switch (goal)
        case 1
            %���ͺ�
            chroms{1,chromsIndex}.fitness1 = cost;
        case 2
            %������
            chroms{1,chromsIndex}.fitness2 = kaoqiaohbNum/m;
        case 0
            %���ͺ�
            chroms{1,chromsIndex}.fitness1 = cost;
            %������
            chroms{1,chromsIndex}.fitness2 = kaoqiaohbNum/m;
            
            %��Ŀ��===================
            fitness1 = cost;
            fitness2 = 1/chroms{1,chromsIndex}.fitness2;%��󻯱���С����ȡ����
            %%��һ��=====================
            fit0 = max([fitness1, fitness2]);  %����������ĸ
            chroms{1,chromsIndex}.fitness = w1*fitness1/fit0 + w2*fitness2/fit0;%��Ŀ�꺯����ʽ
        otherwise
            fprintf('��Ŀ��or��Ŀ�ꣿ������ϸ�ٿ���\n' );
    end  
    chromsIndex = chromsIndex + 1;
end




end