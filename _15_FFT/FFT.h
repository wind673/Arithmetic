#ifndef _FFT_H_
#define _FFT_H_

#define FFT_LENGTH_MAX 8192

#define FFT_PI 3.141593f

typedef struct{
    float real;
    float imag;
}FFT_E;

void fft(FFT_E *Databuff, uint32_t N);
void ifft(FFT_E *Databuff, uint32_t N);
uint32_t fftLog2(uint32_t N);

#endif // FFT_H_INCLUDED
