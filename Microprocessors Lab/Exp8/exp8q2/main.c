#include <regx51.h>
#include "delay.h"
#include "watch.h"
#include "lcd.h"

_watch_state watch_state;

int main() {
	init_lcd();
	init_watch(&watch_state);
	disp_watch(&watch_state);
	P1 = 0x0F;										// LEDs as outputs, switches as inputs.
	while(1) {
		update_watch(&watch_state);
		disp_watch(&watch_state);
	}
}