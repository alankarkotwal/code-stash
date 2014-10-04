#include <regx51.h>
#include "delay.h"
#include "watch.h"
#include "lcd.h"
#include "twi_lib.h"

#define MS 245

_watch_state watch_state;

int temp;
char string[3]="00\0";

int main() {
	init_lcd();
	twi_lib_init();
	//disp_watch(&watch_state);
	P1 = 0x0F;										// LEDs as outputs, switches as inputs.
	//twi_putchar()
	while(1) {
		twi_putchar(0xd0, 0);
		temp=twi_getchar(0xd0);  // 0xd0 0 0x80 0x30 0x09 0x02 0x07 0x09 0x09
		sprintf(string, "%x", temp);
		string[2]='\0';
		lcd_command(LCD_first);
		lcd_string(string);
		//disp_watch(&watch_state);
	}
}