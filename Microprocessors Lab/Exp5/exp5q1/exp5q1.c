#include<regx51.h>

sbit pin=P1^4;

int timer0Interrupt_enable=1;
int timer0_reloadValue=0xF82F;

void timer0() interrupt 1 {
	if(timer0Interrupt_enable==1) {
		pin=~pin;
		TH0=(0xFFFF-timer0_reloadValue)/256;
		TL0=(0xFFFF-timer0_reloadValue) & (0xFF);
		TR0=1;
	}
}

int main() {
	TMOD |= 0x01;
	IE |= 0x82;
	pin=0;
	TH0=(0xFFFF-timer0_reloadValue)/256;
	TL0=(0xFFFF-timer0_reloadValue) & (0xFF);
	TR0=1;
	while(1);
	return 0;
}
