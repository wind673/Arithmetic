
#define _KP 		(150.0f) //比例放大系数
#define _KI 		(0.00f) //积分放大系数
#define _KD 		(0.00f) //微分放大系数
#define _U0 		(500)  //基值
#define _ET 		(3 - Angle_Filtrate)  //误差

int EasyPID(void)
{   
	static double integral_error = 0.0f; 
	static double differential_error = 0.0f; 
	static double last = 0.0f; 
	
	integral_error += (_ET); //误差积分
	differential_error = _ET - last; //误差微分
	
	PWM_Value = _U0 + _ET*_KP + integral_error*_KI + differential_error*_KD;//PID	
	
	PWM_Set(PWM_Value); 
	
	last = _ET;
	
	return 0;
}
