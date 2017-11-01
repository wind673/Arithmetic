%*******************************(C) COPYRIGHT 2016 Wind（谢玉伸）*********************************%
%{
===========================================================================
@FileName    : PID
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
X_LENTH = 10000;
Main_Sin_Vpp = 60;
Main_Freq = 6;  

% 数据产生处理 ------------------------------------
x = 1:1:X_LENTH; %0~X_LENTH步进1  

input = x*Main_Sin_Vpp;  
real = input; 
%P调节
for i = 1:X_LENTH   
    if i < X_LENTH  
        P = -input(i)*0.03;
        output = P;
        input(i+1) = input(i) + output;%下一次的值等于这次的值 + P调节
        real(i) = input(i);
    end
end  
y = real;
 
input = x*Main_Sin_Vpp;  
real = input; 
%PI调节
P = 0;
I = 0;
sPI = 0;
for i = 1:X_LENTH   
    if i < X_LENTH  
        P = -input(i);
        I = I + 0 - input(i);
        sPI = P*0.03 + I*0.02;
        output = sPI;
        input(i+1) = input(i) + output;%下一次的值等于这次的值 + P调节
        real(i) = input(i);
    end
end  
y1 = real; 



% 画图处理 ------------------------------------
left = 2;
right = 500;
up = Main_Sin_Vpp*2.5;
down = - up;

% subplot(2,1,1);
plot(x,y,'blue'); %画出波形
hold on;%保持 
plot(x,y1,'red'); %画出波形
hold on;%保持 
% plot(x,y2,'black'); %画出波形
% hold on;%保持 
% plot(x,y4,'blue.'); %画出波形
% hold on;%保持 
title('PI调节','Color','blue');%写标题
legend('P','PI'); 
set(gca,'XLim',[left,right]);%X轴的数据显示范围
set(gca,'YLim',[down,up]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',left:(right - left)/10:right);%设置X轴坐标间隔
set(gca,'YTick',down:(up - down)/8:up);%设置Y轴坐标间隔
hold on;%保持
 
% 
% subplot(2,1,2);
% plot(x,y1,'blue'); %画出波形
% hold on;%保持 
% % plot(x,y2,'red'); %画出波形
% % hold on;%保持 
% % plot(x,y3,'black'); %画出波形
% % hold on;%保持 
% % plot(x,y4,'blue.'); %画出波形
% % hold on;%保持 
% title('PID调节','Color','blue');%写标题
% set(gca,'XLim',[left,right]);%X轴的数据显示范围
% set(gca,'YLim',[down,up]);%Y轴的数据显示范围
% % text(950,0,'string');%图形里面写字
% set(gca,'XTick',left:(right - left)/10:right);%设置X轴坐标间隔
% set(gca,'YTick',down:(up - down)/5:up);%设置Y轴坐标间隔
% hold on;%保持
% 







