%*******************************(C) COPYRIGHT 2016 Wind（谢玉伸）*********************************%
%{
===========================================================================
@FileName    : 画波形
@Description : None
@Date        : 2017/7/23
@By          : Wind（谢玉伸）
@Email       : 1659567673@ qq.com
@Platform    : Matlab 2017a
@Explain     : None
===========================================================================
%}
% 窗口1 -------------------------------------------------------------------
figure(1);

% 参数设置 ------------------------------------
X_LENTH = 4096;
Main_Sin_Vpp = 3.3;
Main_Freq = 100;

% 数据产生处理 ------------------------------------
x = 1:1:X_LENTH; %0~X_LENTH步进1
y = sin(2*pi*x*Main_Freq/X_LENTH)*Main_Sin_Vpp;
y1 = awgn(y,15,'measured');%加15dB噪声


y2 = zeros(1,X_LENTH);%预分配内存
%平滑滤波
for i = 1:X_LENTH
    temp = 0;
    for j = 1:Filter_Deep
        if i>Filter_Deep
            temp = temp + y1(i-j);
        end
    end
    y2(i) = temp/(Filter_Deep);
end  




% 画图处理 ------------------------------------
subplot(3,1,1);
plot(x,y,'black'); %画出波形
title('原始信号','Color','blue');%写标题
set(gca,'XLim',[920,1060]);%X轴的数据显示范围
set(gca,'YLim',[-5,5]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',0:15:1060);%设置X轴坐标间隔
set(gca,'YTick',-5:2:5);%设置Y轴坐标间隔
hold on;%保持

subplot(3,1,2);
plot(x,y1,'red'); %画出波形
title('加噪声信号','Color','blue');%写标题
set(gca,'XLim',[920,1060]);%X轴的数据显示范围
set(gca,'YLim',[-5,5]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',0:15:1060);%设置X轴坐标间隔
set(gca,'YTick',-5:2:5);%设置Y轴坐标间隔
hold on;%保持 

subplot(3,1,3);
plot(x,y2,'black'); %画出波形
hold on;%保持 
plot(x,y3,'red'); %画出波形
hold on;%保持 
plot(x,y4,'blue'); %画出波形
hold on;%保持 
plot(x,y5,'blue.'); %画出波形
hold on;%保持 
title('滤波后的信号','Color','blue');%写标题
set(gca,'XLim',[920,1060]);%X轴的数据显示范围
set(gca,'YLim',[-5,5]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',0:15:1060);%设置X轴坐标间隔
set(gca,'YTick',-5:2:5);%设置Y轴坐标间隔
hold on;%保持








