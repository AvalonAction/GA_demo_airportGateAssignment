function [] = ganttest(chrom,hangbanData,positionData,time)
%fileName:mt06_final.mt06
%fileDescription:create a Gantt chart whith the data given
%creator:by mnmlist
%Version:1.0
%last edit time：06-05-2015 
figure(9)
hangbannum = size(hangbanData,1);%航班数目
posNum = size(positionData,1);%机位数目
axis([0,24,0,posNum+1]);%x轴 y轴的范围
set(gca,'xtick',0:1:24) ;%x轴的增长幅度
set(gca,'ytick',0:1:posNum) ;%y轴的增长幅度
xlabel('时间'),ylabel('机位号');%x轴 y轴的名称
title('停机位分配（占用）甘特图');%图形的标题
%x轴 对应于画图位置的起始坐标x
n_start_time=zeros(1,hangbannum);
for i=1:hangbannum
    temp = hangbanData(i,5)+time(chrom.Position(i),hangbanData(i,7));
    n_start_time(i) = temp/60;
end
n_duration_time=zeros(1,hangbannum);
for i=1:hangbannum
    temp = hangbanData(i,6)- hangbanData(i,5)-time(chrom.Position(i),hangbanData(i,7));
    n_duration_time(i) = temp/60;
end


n_bay_start = chrom.Position;
rec=[0,0,0,0];%temp data space for every rectangle  
color=['r','g','b','c','m','y'];
for i =1:hangbannum  
  rec(1) = n_start_time(i);%矩形的横坐标
  rec(2) = n_bay_start(i)+0.7-1;  %矩形的纵坐标
  rec(3) = n_duration_time(i);  %矩形的x轴方向的长度
  rec(4) = 0.6; 
  txt=sprintf('%d',hangbanData(i,2));
   rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(floor(rand*4+1)));%draw every rectangle  
   text(n_start_time(i)+0.2,(n_bay_start(i)),txt,'FontWeight','Bold','FontSize',14);%label the id of every task  ，字体的坐标和其它特性
end