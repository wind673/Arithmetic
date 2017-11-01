#include <stdint.h>
#include <math.h>
#include "FFT.h"


float sin_table[FFT_LENGTH_MAX];
float cos_table[FFT_LENGTH_MAX];


/*
 * Return:      void
 * Parameters:  Databuff:输入数据; N:长度
 * Description: 基2FFT变换
 */
void fft(FFT_E *Databuff, uint32_t N)
{
    uint32_t m = fftLog2(N);
    static uint32_t N_temp = 0;
    uint32_t i, j = N / 2, l, j_down;
    uint32_t x, y = N / 2, X_number, Y_number;
    FFT_E temp, Wnk;

    if(N_temp != N)
    {
        for(i=0; i<N; ++i)
        {
            sin_table[i] = sin(2.0f * FFT_PI * i / N);
            cos_table[i] = cos(2.0f * FFT_PI * i / N);
        }

        N_temp = N;
    }


    /* 倒序排序 */
    for(i=1; i<N; ++i)
    {
        if(i < j)
        {
            temp = Databuff[i];
            Databuff[i] = Databuff[j];
            Databuff[j] = temp;
        }
        x = y;
        while(j & x)
        {
            j -= x;
            x >>= 1;
        }
        j |= x;
    }

    /* FFT核心蝶形算法 */
    for(l=0; l<m; ++l)                  //一重循环对m级的级数做循环
    {
        X_number = 1 << l;              //当前l级下有X_number种类型旋转因子
        Y_number = 1 << (m - l - 1);    //当前l级下有Y_number组相同的旋转因子
        i = 0;                          //i置0，每个l级开始做蝶形运算时都是从第0号元素开始

        for(x=0; x<X_number; ++x)       //二重循环计算每个l级下的每个不同旋转因子
        {
            /* 参与两个蝶形运算数据的下标 */
            j = i;
            j_down = j + X_number;

            /* 旋转因子变换 */
            Wnk.real = cos_table[x * Y_number];     //Wnk.real = cos(2.0 * FFT_PI / N * x * Y_number);
            Wnk.imag = -sin_table[x * Y_number];    //Wnk.imag = -sin(2.0 * FFT_PI / N * x * Y_number);

            for(y=0; y<Y_number; ++y)   //三重循环对每个相应的旋转因子做蝶形运算
            {
                /* 蝶形运算 */
                temp.real = Databuff[j_down].real * Wnk.real - Databuff[j_down].imag * Wnk.imag;
                temp.imag = Databuff[j_down].real * Wnk.imag + Databuff[j_down].imag * Wnk.real;
                Databuff[j_down].real = Databuff[j].real - temp.real;
                Databuff[j_down].imag = Databuff[j].imag - temp.imag;
                Databuff[j].real += temp.real;
                Databuff[j].imag += temp.imag;

                /* 两个蝶形运算的下标 */
                j += (X_number << 1);   //下个相同的旋转因子是在当前号元素标号上加X_number的两倍
                j_down = j + X_number;
            }

            ++i;                        //当前l级的下组不同的旋转因子开始标号是在当前旋转因子开始标号上加1
        }
    }
}

/*
 * Return:      void
 * Parameters:  Databuff:输入数据; N:长度
 * Description: 基2FFT逆变换
 */
void ifft(FFT_E *Databuff, uint32_t N)
{
    uint32_t i;

    /* 变换为共轭对 */
    for(i=0; i<N; ++i)
    {
        Databuff[i].imag = -Databuff[i].imag;
    }

    /* FFT变换 */
    fft(Databuff, N);

    /* 变换为共轭对后，再除以序列长度 */
    for(i=0; i<N; ++i)
    {
        Databuff[i].real = Databuff[i].real / N;
        Databuff[i].imag = -Databuff[i].imag / N;
    }
}

/*
 * Return:      log2(N)
 * Parameters:  N:长度
 * Description: 求log2(N)
 */
uint32_t fftLog2(uint32_t N)
{
    uint32_t i = 0;

    while(N >>= 1)
        ++i;

    return i;
}
