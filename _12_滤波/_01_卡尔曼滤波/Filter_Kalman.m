%*******************************(C) COPYRIGHT 2016 Wind（谢玉伸）*********************************%
%{
===========================================================================
@FileName    : 卡尔曼滤波
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
Main_Sin_Vpp = 3.3;
Main_Freq = 100;

% 数据产生处理 ------------------------------------
x = 1:1:X_LENTH; %0~X_LENTH步进1
y = sin(2*pi*x*Main_Freq/X_LENTH)*Main_Sin_Vpp; 
y1 = awgn(y,8,'measured');%加15dB噪声  

y2 = y1;

C = 0;
P = 0.8;
Q = 0.02;
Kg = 1; 
temp_value = 0;
temp_max = -100;
temp_min = 100;
for i = 1:30 
    temp_value = temp_value + y1(i);
    if temp_max < y1(i)
       temp_max = y1(i);
    end 
    if temp_min > y1(i)
       temp_min = y1(i);
    end 
    
end
temp_value = temp_value / 30;
R = 0.5/(abs(temp_max - temp_value)+1); %此处的R是固定的，可以根据具体情况改成自适应版本 

% 卡尔曼滤波
for i = 2:X_LENTH 
    if abs(y1(i) - y2(i-1)) >0
        Q = abs(y1(i) - y2(i-1));
    end 
    Kg = sqrt(P*P/(P*P+Q*Q));
    C = y2(i-1);%预测值
    y2(i) = Kg*y1(i) + (1-Kg)*C;
    P = P*sqrt(1-Kg) + R; %更新P值
end  

 
% 画图处理 ------------------------------------ 
left = 2;
right = 10000;
up = Main_Sin_Vpp*1*3.5;
down = - up;

% subplot(3,1,1);
plot(x,y,'black'); %画出波形
hold on;%保持 
% subplot(3,1,2);
plot(x,y1,'red'); %画出波形
hold on;%保持 
% subplot(3,1,3);
plot(x,y2,'blue'); %画出波形
hold on;%保持 
% plot(x,y4,'blue.'); %画出波形
% hold on;%保持 
title('卡尔曼滤波');%写标题
legend('真实','测量','滤波'); 
set(gca,'XLim',[left,right]);%X轴的数据显示范围
set(gca,'YLim',[down,up]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',left:(right - left)/10:right);%设置X轴坐标间隔
set(gca,'YTick',down:(up - down)/8:up);%设置Y轴坐标间隔
hold on;%保持
 







