#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "FFT.h"
#include "main.h"


/* 采样频率 */
#define FRE_FS      64
/* 采样长度 */
#define FFT_LENGTH  64



FFT_E Extern_Databuff[FFT_LENGTH];

int main(void)
{
    uint32_t i, j = 0;
    double Real, Imag;

/* 混合波形生成 */
#if 1

    for(i=0; i<FFT_LENGTH; ++i)
    {
        Extern_Databuff[i].real = 3
                                + 1.0 * cos(2 * M_PI * i / FRE_FS * 6 - 10.0 / 180.0 * M_PI)
                                + 3.0 * sin(2 * M_PI * i / FRE_FS * 7 + 30.0 / 180.0 * M_PI)
                                + 5.0 * cos(2 * M_PI * i / FRE_FS * 8 + 63.0 / 180.0 * M_PI)
                                + 7.0 * sin(2 * M_PI * i / FRE_FS * 9 - 90.0 / 180.0 * M_PI)
                                + 9.0 * cos(2 * M_PI * i / FRE_FS * 10 + 71.0 / 180.0 * M_PI)
                                + 2.0 * sin(2 * M_PI * i / FRE_FS * 11 - 83.0 / 180.0 * M_PI)
                                + 4.0 * cos(2 * M_PI * i / FRE_FS * 12 - 97.0 / 180.0 * M_PI);
        Extern_Databuff[i].imag = 0.0;
    }

/* 特殊波形生成 */
#elif 1

    for(i=0; i<FFT_LENGTH; ++i)
    {
        Extern_Databuff[i].real = ddsHalfWave(FFT_LENGTH, i + 0.0 * FFT_LENGTH, 0.5) * 5.0;
        Extern_Databuff[i].imag = 0.0;
    }

#endif // 0

    printf("\n\n原序列：");
    for(i=0; i<FFT_LENGTH; ++i)
    {
        if(i % 8 == 0)
            printf("\n");

        Real = Extern_Databuff[i].real;
        Imag = Extern_Databuff[i].imag;
        printf("%.2f\t", sqrt((Real * Real) + (Imag * Imag)));
    }

    fft(Extern_Databuff, FFT_LENGTH);

    printf("\n\nFFT变换序列：");
    for(i=0; i<FFT_LENGTH; ++i)
    {
        if(i % 8 == 0)
            printf("\n");
        printf("%.2f\t", Extern_Databuff[i].real);
    }

    printf("\n\nFFT变换得相应频率对应幅度：\n");
    for(i=0; i<FFT_LENGTH/2; ++i)
    {
        Real = Extern_Databuff[i].real/(FFT_LENGTH/2.0);
        Imag = Extern_Databuff[i].imag/(FFT_LENGTH/2.0);

        if((fabs(Real) > 0.02) || (fabs(Imag) > 0.02))
        {
            printf("频率：%.3lf\t幅度：%.3lf\t相位：%.3lf\n",
                   (double)i*FRE_FS/FFT_LENGTH,
                   sqrt((Real * Real) + (Imag * Imag)),
                   atan2(Imag, Real)/M_PI*180.0);
        }
    }

    ifft(Extern_Databuff, FFT_LENGTH);

    printf("\n逆FFT变换后的序列：");
    for(i=0; i<FFT_LENGTH; ++i)
    {
        if(i % 8 == 0)
            printf("\n");
        printf("%.2f\t", Extern_Databuff[i].real);
    }

    return 0;
}

/*
 * Return:      void
 * Parameters:  N:当前周期长度; k:本周期内的当前位置
 * Description: 三角波计算
 */
double ddsTriangleWave(uint32_t N, uint32_t k, double Duty)
{
	k %= N;

	if(k < (N / 2))
		return 4.0 * k / N - 1.0;
	else
		return -4.0 * k / N + 3.0;
}

/*
 * Return:      void
 * Parameters:  N:当前周期长度; k:本周期内的当前位置
 * Description: 锯齿波计算
 */
double ddsSawtoothWave(uint32_t N, uint32_t k, double Duty)
{
	k %= N;

	return 2.0 * k / N - 1.0;
}

/*
 * Return:      void
 * Parameters:  N:当前周期长度; k:本周期内的当前位置
 * Description: 方波计算
 */
double ddsSquareWave(uint32_t N, uint32_t k, double Duty)
{
	k %= N;

	if(k < (N * Duty))
		return 1.0;

	return -1.0;
}

/*
 * Return:      void
 * Parameters:  N:当前周期长度; k:本周期内的当前位置
 * Description: 正弦波计算
 */
double ddsSinWave(uint32_t N, uint32_t k, double Duty)
{
	k %= N;

	return sin(2 * 3.14159265358979 * k / N);
}


/*
 * Return:      void
 * Parameters:  N:当前周期长度; k:本周期内的当前位置
 * Description: 半波计算
 */
double ddsHalfWave(uint32_t N, uint32_t k, double Duty)
{
	double temp;

	k %= N;

	temp = sin(2 * 3.14159265358979 * k / N);

	if(temp < 0.0)
		temp = 0.0;

	return temp * 2.0 - 1.0;
}

/*
 * Return:      void
 * Parameters:  N:当前周期长度; k:本周期内的当前位置
 * Description: 全波计算
 */
double ddsFullWave(uint32_t N, uint32_t k, double Duty)
{
	double temp;

	k %= N;

	temp = sin(2 * 3.14159265358979 * k / N);

	if(temp < 0.0)
		temp = -temp;

	return temp * 2.0 - 1.0;
}
