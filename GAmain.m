close all;
clear all;
clc;
%BasePath  =  I:\�о���\�о�\���˳ɹ�\sjy\����\codes
%%���ݵ���
%{
hangbanData
��
1��  �����
2��  ��������кţ��԰�����ʱ������!!!��
3��  ������ͣ������ͺţ�
4��  ƥ���λ���ͣ������ͺŹ���ɻ�λ���ͣ�
5��  ����ʱ��    Ϊ����0��������
6��  ����ʱ��
7��  �����ܵ�
8:   ����ܵ�
%}
hangbanData = load('DATA_hangbanData.txt');
hangbanData = sortrows(hangbanData,5);
[m,n] = size(hangbanData);
for i=1:m
    hangbanData(i,2) = i;
end
%{
��λ��Ϣ
positionData
��
1����λ��
2����λ����(1<2<3...    1�ͷɻ���ͣ>=1�͵Ļ�λ,��ɻ�����ͣС��λ)
3��Զ��flag��1���� 2�ǿ��� ��
4: ���п�ʼʱ��
%}
positionData = load('DATA_positionData.txt');
[p,q] = size(positionData);
%{
oilCostData
��
1�����ͼ���ο�����
2��ƽ��ÿ���Ӻ���
%}
oilCost = load('DATA_oilCost.txt');
%�����ٶ�(km/h)
speed = 15;
%{
�������
distanse
   A: a�ܵ������λ���� B: b�ܵ������λ����(һ��������1-3���ܵ�)
��
1����λ��
2-~���ܵ���
%}
distanse = load('DATA_distanse.txt');
[~,ww]=size(distanse);
time = distanse(:,2:ww)/speed*60;

%����������֮�����С��ȫʱ����(min)
timeInter = 20;

%%��ṹ�������趨 =======================================

%��Ⱥ��Ⱦɫ�����

config = load('config.txt');
%����������
Maxgen = config(1,1);
%��Ⱥ��С
Y = config(1,2);
%��������
croPos = config(1,3);
%��������
mutPos = config(1,4);
%Ȩ��
w1 = config(1,5);
w2 = config(1,6);
%��Ŀ��or��Ŀ��
goal = config(1,7);
chroms = cell(1,Y);
%============================================
%��ʱ��ʼ

tic;
%��ʼ����������ʼ����/��Ⱥ
for i=1:Y
    structchroms.HangbanSeNum = hangbanData(1:m, 2)';
    structchroms.Position = zeros(1,m);
    structchroms.unappropriated = hangbanData(1:m, 2)';
    structchroms.fitness1 = 0;
    structchroms.fitness2 = 0;
    structchroms.fitness = 0;
    chroms{1,i} = structchroms;
    %{
      chroms{1,i}= struct('HangbanSeNum',hangbanData(1:m, 2)',...% �������кţ�����ֻ���ο���������ܲ��㣬��ֱ��ȥ��
                   'Position',zeros(1,m),... % ͣ��λ��
              'unappropriated',hangbanData(1:m, 2)',...
              'fitness1',0,...%Ŀ�꺯��ֵ1:�ͺ�
              'fitness2',0,...%Ŀ�꺯��ֵ2:������
              'fitness',0);   %��Ŀ�꺯��ֵ

    %}
end;
disp('�����λ');
%�����λ
chroms = position(chroms,'first',hangbanData,positionData,timeInter,time);

chroms{1,1}.Position
chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, goal);
chroms{1,1}.Position
%{%}
%��Ӧ��ֵ����

chroms = sortByFitness(chroms,goal);

%ÿ����Ӣ����
chromBest = chroms{1,1};
%��ʷ��¼
trace=zeros(3,Maxgen);
disp('������ʼ');
%������ʼ
k=1;


while(k<=Maxgen)
    STR=sprintf('%s%d','��������',k);
    disp(STR);
    
    %ѡ��
    chroms = selection(chroms,goal);
    %����
    chroms = crossover(chroms, croPos);%%%%%%%%%%%%%%
    %����
    chroms = mutation(chroms, positionData, mutPos);
    %����fitness
    chroms = position(chroms,'else',hangbanData,positionData,timeInter,time);
    chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, goal);
    %��Ӧ��ֵ����
    chroms = sortByFitness(chroms,chromBest,goal);
    %ͳ�ƣ�ȡ����Ӣ
    chromBest = chroms{1,1};
    trace(1,k) = chroms{1,1}.fitness1;
    trace(2,k) = chroms{1,1}.fitness2;
    trace(3,k) = chroms{1,1}.fitness;
    k = k + 1;
    %��������
end;
%��ʱ����
toc;

%������
%��ʽ�����Ÿ�����1���������к� 2����λ�� 3��Ӧ��ֵ1 4����Ӧ��ֵ1  5: ��Ӧ��ֵ2  6����Ӧ��ֵ��
disp('�������к�');
chroms{1,1}.HangbanSeNum
disp('��λ��');
chroms{1,1}.Position
%{%}
switch(goal)
    case 1
        disp('��Ŀ�꣺�ͺ�');
        chroms{1,1}.fitness1
        %��������ͼĿ�꺯��1
        figure(1)
        
        plot(trace(1,:))
        hold on, grid;
        xlabel('��������');
        ylabel('���Ž�仯');
        title('��Ŀ�꣺�ͺ�')
        
    case 2
        disp('��Ŀ�꣺������');
        chroms{1,1}.fitness2
        %��������ͼĿ��꺯��2
        figure(2)
        plot(trace(2,:))
        hold on, grid;
        xlabel('��������');
        ylabel('���Ž�仯');
        title('��Ŀ�꣺������')
    case 0
        disp('Ŀ��1���ͺ�');
        chroms{1,1}.fitness1
        disp('Ŀ�����������');
        chroms{1,1}.fitness2
        disp('��Ŀ��');
        chroms{1,1}.fitness
        %��ͼ
         figure(1)
        
        plot(trace(1,:))
        hold on, grid;
        xlabel('��������');
        ylabel('���Ž�仯');
        title('��Ŀ�꣺�ͺ�')
        
        figure(2)
        plot(trace(2,:))
        hold on, grid;
        xlabel('��������');
        ylabel('���Ž�仯');
        title('��Ŀ�꣺������')
        %��������ͼ��Ŀ��
        figure(3)
        title('��Ŀ��')
        plot(trace(3,:))
        hold on, grid;
        xlabel('��������');
        ylabel('���Ž�仯');
        title('��Ŀ��')
        
    otherwise
        fprintf('��Ŀ��or��Ŀ�ꣿ������ϸ�ٿ���\n' );
end

%���ڻ�ԭ
% for i=1:n
%     hangbanData(i,5) = timeTransf(hangbanData(i,5),2);
%     hangbanData(i,6) = timeTransf(hangbanData(i,6),2);
% end

%����ͼ��������
ganttest(chroms{1,1},hangbanData,positionData,time);
%{
disp('Ŀ��1���ͺ�');
        chroms{1,1}.fitness1
        disp('Ŀ�����������');
        chroms{1,1}.fitness2
        disp('��Ŀ��');
        chroms{1,1}.fitness
%}







