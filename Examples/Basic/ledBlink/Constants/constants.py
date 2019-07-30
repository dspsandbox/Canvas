INCREMENT=10 
PERIOD=1 #seconds
DUTY_CYCLE=0.5 # 50% duty ccycle

const32Bit[1]=INCREMENT 
const32Bit[2]= PERIOD*INCREMENT*125e6 
const32Bit[0]=DUTY_CYCLE*const32Bit[2] 


