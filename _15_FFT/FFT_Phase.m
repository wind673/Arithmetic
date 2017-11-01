%*******************************(C) COPYRIGHT 2016 Wind（谢玉伸）*********************************%
%{
===========================================================================
@FileName    : FFT
@Description : None
@Date        : 2017/7/27
@By          : Wind（谢玉伸）
@Email       : 1659567673@ qq.com
@Platform    : Matlab 2017a
@Explain     : None
===========================================================================
%}

% 窗口1 -------------------------------------------------------------------

% 参数设置 ------------------------------------
Main_Sin_Vpp = 36;
Main_Freq = 50;

as_Main_T = 8;%采n个周期
as_Main_N = 64;%每个周期N个点
as2_Main_T_gap = (1000000/Main_Freq)/(as_Main_N); %每个点的采样时间间隔 us
as2_Main_T_sum = as2_Main_T_gap*as_Main_T*as_Main_N/1000; %每次采样时间长 ms  
as_Main_N_Rev = mod((as2_Main_T_gap-floor(as2_Main_T_gap))*as_Main_T*as_Main_N,as_Main_N);%泄露点数
as1_Main_Phase = 130;%相移 °


if as_Main_N_Rev > as_Main_N/2
    as_Main_N_Rev = abs(as_Main_N - as_Main_N_Rev);
end

fprintf("信号频率 %0.2f Hz \n",Main_Freq);
fprintf("采 %d 个周期 - ",as_Main_T);
fprintf("每个周期 %d 点 - ",as_Main_N);
fprintf("FFT点数 %d \n",as_Main_N*as_Main_T);
fprintf("泄露点数 %0.2f - ",as_Main_N_Rev);
fprintf("泄露比 %0.2f %%\n",as_Main_N_Rev*100/(as_Main_N*as_Main_T));
fprintf("每个点的采样时间间隔 %0.2f us(以%0.1fHz为例) \n",as2_Main_T_gap,Main_Freq);
fprintf("每次采样时间长 %0.2f ms \n",as2_Main_T_sum);   
fprintf("实际相移 %0.4f° \n",as1_Main_Phase); 


X_LENTH = as_Main_T*as_Main_N - as_Main_N_Rev;
% 数据产生处理 ------------------------------------
x = 0:1:X_LENTH; %0~X_LENTH步进1 
y1 = sin(2*pi*x*as_Main_T/X_LENTH+ 0/360*2*pi)*Main_Sin_Vpp + sin(2*pi*x*as_Main_T*10/X_LENTH+ 66/360*2*pi)*Main_Sin_Vpp*0.1; 
y2 = sawtooth((2*pi*x*as_Main_T/X_LENTH + (as1_Main_Phase+90)/360*2*pi),0.5)*Main_Sin_Vpp*0.1 + sin(2*pi*x*as_Main_T*17/X_LENTH+ 66/360*2*pi)*Main_Sin_Vpp*0.03; 
y1 = awgn(y1,30,'measured');%加噪声  
y2 = awgn(y2,30,'measured');%加噪声  

FFT1 = fft(y1); 
FFT2 = fft(y2); 
 
max1 = 0;
max1_X = 0; 
max1_real = 0;
max1_imag = 0;
for i=1:X_LENTH/2 
    if abs(real(FFT1(i))) > max1
       max1 = sqrt(real(FFT1(i))*real(FFT1(i))+imag(FFT1(i))*imag(FFT1(i)));
       max1_X = i;
       max1_real = real(FFT1(i));
       max1_imag = imag(FFT1(i)); 
    end 
end
phase1 = atan2(max1_imag,max1_real)/pi*180;

max2 = 0;
max2_X = 0; 
max2_real = 0;
max2_imag = 0;
for i=1:X_LENTH/2
    if abs(real(FFT2(i))) > max2
       max2 = sqrt(real(FFT2(i))*real(FFT2(i))+imag(FFT2(i))*imag(FFT2(i)));
       max2_X = i;
       max2_real = real(FFT2(i));
       max2_imag = imag(FFT2(i)); 
    end 
end
phase2 = atan2(max2_imag,max2_real)/pi*180;
 
if phase2 - phase1 > 180
    as1_phase = -360 + phase2 - phase1;
    
end

if  phase2 - phase1 <= 180
    as1_phase = phase2 - phase1;
end

fprintf("测得相移 %0.4f° \n",as1_phase); 
fprintf("误差 %0.4f° (130°误差最大) \n",abs(as1_Main_Phase - as1_phase));
fprintf("------------------------------\n");


% 画图处理 ------------------------------------ 
figure(1);
left = 0;
right = X_LENTH;
up = Main_Sin_Vpp*2;
down = - up;
 
plot(x,y1,'blue'); %画出波形
hold on;%保持  
plot(x,y2,'red'); %画出波形
hold on;%保持   
title('所测信号');%写标题
legend('电压','电流'); 
set(gca,'XLim',[left,right]);%X轴的数据显示范围
set(gca,'YLim',[down,up]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',left:(right - left)/10:right);%设置X轴坐标间隔
set(gca,'YTick',down:(up - down)/8:up);%设置Y轴坐标间隔
hold on;%保持 
grid;

% 画图处理 ------------------------------------ 
figure(2);
left = 0;
right = X_LENTH;
up = Main_Sin_Vpp*300;
down = - up;

subplot(2,1,1);
plot(x,real(FFT1),'blue'); %画出波形
hold on;%保持  
plot(x,imag(FFT1),'red'); %画出波形
hold on;%保持   
title('电压FFT');%写标题
legend('real','imag'); 
set(gca,'XLim',[left,right]);%X轴的数据显示范围
set(gca,'YLim',[down,up]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',left:(right - left)/10:right);%设置X轴坐标间隔
set(gca,'YTick',down:(up - down)/8:up);%设置Y轴坐标间隔
hold on;%保持
grid;

left = 0;
right = X_LENTH;
up = Main_Sin_Vpp*30;
down = - up;
subplot(2,1,2);
plot(x,real(FFT2),'blue'); %画出波形
hold on;%保持  
plot(x,imag(FFT2),'red'); %画出波形
hold on;%保持   
title('电流FFT');%写标题
legend('real','imag'); 
set(gca,'XLim',[left,right]);%X轴的数据显示范围
set(gca,'YLim',[down,up]);%Y轴的数据显示范围
% text(950,0,'string');%图形里面写字
set(gca,'XTick',left:(right - left)/10:right);%设置X轴坐标间隔
set(gca,'YTick',down:(up - down)/8:up);%设置Y轴坐标间隔
hold on;%保持
grid;


