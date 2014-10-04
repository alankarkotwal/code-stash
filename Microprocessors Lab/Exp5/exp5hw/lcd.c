#include"lcd.h"

void init_lcd() {
	lcd_command(0x38);
	lcd_command(0x0C);
	lcd_command(0x01);
	lcd_command(0x06);
}

void lcd_command(int cmd) {
	LCD_data=cmd;
	LCD_cont&=~(1<<LCD_rs);
	LCD_cont&=~(1<<LCD_rw);
	LCD_cont|=(1<<LCD_en);
	software_delay(1);
	LCD_cont&=~(1<<LCD_en);
	software_delay(1);
}

void lcd_data(int dat) {
	LCD_data=dat;
	LCD_cont|=(1<<LCD_rs);
	LCD_cont&=~(1<<LCD_rw);
	LCD_cont|=(1<<LCD_en);
	software_delay(1);
	LCD_cont&=~(1<<LCD_en);
	software_delay(2);
}

void lcd_string(char* ptr) {
	int i=0;
	while(ptr[i]!='\0') {
		lcd_data(ptr[i]);
		i=i+1;
	}
}