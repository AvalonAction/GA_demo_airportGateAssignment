close all;
clear all;
clc;
%BasePath  =  I:\研究生\研究\他人成果\sjy\论文\codes
%%数据导入
%{
hangbanData
列
1：  航班号
2：  航班号序列号（以按到达时间排序!!!）
3：  航班机型（具体型号）
4：  匹配机位类型（具体型号归类成机位类型）
5：  到达时间    为当日0点后分钟数
6：  出发时间
7：  降落跑道
8:   起飞跑道
%}
hangbanData = load('DATA_hangbanData.txt');
hangbanData = sortrows(hangbanData,5);
[m,n] = size(hangbanData);
for i=1:m
    hangbanData(i,2) = i;
end
%{
机位信息
positionData
列
1：机位号
2：机位类型(1<2<3...    1型飞机可停>=1型的机位,大飞机不可停小机位)
3：远近flag（1靠桥 2非靠桥 ）
4: 空闲开始时间
%}
positionData = load('DATA_positionData.txt');
[p,q] = size(positionData);
%{
oilCostData
列
1：耗油计算参考机型
2：平均每分钟耗油
%}
oilCost = load('DATA_oilCost.txt');
%滑行速度(km/h)
speed = 15;
%{
距离矩阵
distanse
   A: a跑道与各机位距离 B: b跑道与各机位距离(一般机场最多1-3条跑道)
列
1：机位号
2-~：跑道号
%}
distanse = load('DATA_distanse.txt');
[~,ww]=size(distanse);
time = distanse(:,2:ww)/speed*60;

%相邻两航班之间的最小安全时间间隔(min)
timeInter = 20;

%%解结构，参数设定 =======================================

%种群，染色体组成

config = load('config.txt');
%最大迭代次数
Maxgen = config(1,1);
%种群大小
Y = config(1,2);
%交叉算子
croPos = config(1,3);
%变异算子
mutPos = config(1,4);
%权重
w1 = config(1,5);
w2 = config(1,6);
%单目标or多目标
goal = config(1,7);
chroms = cell(1,Y);
%============================================
%计时开始

tic;
%初始化，构建初始方案/种群
for i=1:Y
    structchroms.HangbanSeNum = hangbanData(1:m, 2)';
    structchroms.Position = zeros(1,m);
    structchroms.unappropriated = hangbanData(1:m, 2)';
    structchroms.fitness1 = 0;
    structchroms.fitness2 = 0;
    structchroms.fitness = 0;
    chroms{1,i} = structchroms;
    %{
      chroms{1,i}= struct('HangbanSeNum',hangbanData(1:m, 2)',...% 航班序列号，不变只作参考，如果性能不足，可直接去掉
                   'Position',zeros(1,m),... % 停机位号
              'unappropriated',hangbanData(1:m, 2)',...
              'fitness1',0,...%目标函数值1:油耗
              'fitness2',0,...%目标函数值2:靠桥率
              'fitness',0);   %多目标函数值

    %}
end;
disp('分配机位');
%分配机位
chroms = position(chroms,'first',hangbanData,positionData,timeInter,time);

chroms{1,1}.Position
chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, goal);
chroms{1,1}.Position
%{%}
%适应度值排序

chroms = sortByFitness(chroms,goal);

%每代精英策略
chromBest = chroms{1,1};
%历史记录
trace=zeros(3,Maxgen);
disp('迭代开始');
%迭代开始
k=1;


while(k<=Maxgen)
    STR=sprintf('%s%d','进化代数',k);
    disp(STR);
    
    %选择
    chroms = selection(chroms,goal);
    %交叉
    chroms = crossover(chroms, croPos);%%%%%%%%%%%%%%
    %变异
    chroms = mutation(chroms, positionData, mutPos);
    %计算fitness
    chroms = position(chroms,'else',hangbanData,positionData,timeInter,time);
    chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, goal);
    %适应度值排序
    chroms = sortByFitness(chroms,chromBest,goal);
    %统计，取出精英
    chromBest = chroms{1,1};
    trace(1,k) = chroms{1,1}.fitness1;
    trace(2,k) = chroms{1,1}.fitness2;
    trace(3,k) = chroms{1,1}.fitness;
    k = k + 1;
    %迭代结束
end;
%计时结束
toc;

%输出结果
%格式：最优个体行1：航班序列号 2：机位号 3适应度值1 4：适应度值1  5: 适应度值2  6：适应度值多
disp('航班序列号');
chroms{1,1}.HangbanSeNum
disp('机位号');
chroms{1,1}.Position
%{%}
switch(goal)
    case 1
        disp('单目标：油耗');
        chroms{1,1}.fitness1
        %画出迭代图目标函数1
        figure(1)
        
        plot(trace(1,:))
        hold on, grid;
        xlabel('进化代数');
        ylabel('最优解变化');
        title('单目标：油耗')
        
    case 2
        disp('单目标：靠桥率');
        chroms{1,1}.fitness2
        %画出迭代图目标标函数2
        figure(2)
        plot(trace(2,:))
        hold on, grid;
        xlabel('进化代数');
        ylabel('最优解变化');
        title('单目标：靠桥率')
    case 0
        disp('目标1：油耗');
        chroms{1,1}.fitness1
        disp('目标二：靠桥率');
        chroms{1,1}.fitness2
        disp('总目标');
        chroms{1,1}.fitness
        %画图
         figure(1)
        
        plot(trace(1,:))
        hold on, grid;
        xlabel('进化代数');
        ylabel('最优解变化');
        title('单目标：油耗')
        
        figure(2)
        plot(trace(2,:))
        hold on, grid;
        xlabel('进化代数');
        ylabel('最优解变化');
        title('单目标：靠桥率')
        %画出迭代图总目标
        figure(3)
        title('总目标')
        plot(trace(3,:))
        hold on, grid;
        xlabel('进化代数');
        ylabel('最优解变化');
        title('总目标')
        
    otherwise
        fprintf('单目标or多目标？参数仔细再看看\n' );
end

%日期还原
% for i=1:n
%     hangbanData(i,5) = timeTransf(hangbanData(i,5),2);
%     hangbanData(i,6) = timeTransf(hangbanData(i,6),2);
% end

%甘特图？？？？
ganttest(chroms{1,1},hangbanData,positionData,time);
%{
disp('目标1：油耗');
        chroms{1,1}.fitness1
        disp('目标二：靠桥率');
        chroms{1,1}.fitness2
        disp('总目标');
        chroms{1,1}.fitness
%}







