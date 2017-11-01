#ifndef MAIN_H_INCLUDED
#define MAIN_H_INCLUDED

double ddsTriangleWave(uint32_t N, uint32_t k, double Duty);
double ddsSawtoothWave(uint32_t N, uint32_t k, double Duty);
double ddsSquareWave(uint32_t N, uint32_t k, double Duty);
double ddsSinWave(uint32_t N, uint32_t k, double Duty);
double ddsHalfWave(uint32_t N, uint32_t k, double Duty);
double ddsFullWave(uint32_t N, uint32_t k, double Duty);

#endif // MAIN_H_INCLUDED
