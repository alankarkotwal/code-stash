#include <regx51.h>
#include "lcd.h"
#include <stdio.h>

code unsigned char dayData[]={0x37,0x43,0x14,4,0x24,5,0x54};
char temp[3];

int main() {
	init_lcd();
	lcd_command(LCD_first);
	switch(dayData[3]) {
		case 1: lcd_string("MON"); break;
		case 2: lcd_string("TUE"); break;
		case 3: lcd_string("WED"); break;
		case 4: lcd_string("THU"); break;
		case 5: lcd_string("FRI"); break;
		case 6: lcd_string("SAT"); break;
		case 7: lcd_string("SUN"); break;
	}
	lcd_string(" ");
	sprintf(temp,"%x",dayData[4]);
	temp[2]='\0';
	lcd_string(temp);
	lcd_string(" ");
	switch(dayData[5]) {
		case 1: lcd_string("JAN"); break;
		case 2: lcd_string("FEB"); break;
		case 3: lcd_string("MAR"); break;
		case 4: lcd_string("APR"); break;
		case 5: lcd_string("MAY"); break;
		case 6: lcd_string("JUN"); break;
		case 7: lcd_string("JUL"); break;
		case 8: lcd_string("AUG"); break;
		case 9: lcd_string("SEP"); break;
		case 10: lcd_string("OCT"); break;
		case 11: lcd_string("NOV"); break;
		case 12: lcd_string("DEC"); break;
	}
	lcd_string(" 20");
	sprintf(temp,"%x",dayData[6]);
	temp[2]='\0';
	lcd_string(temp);
	
	lcd_command(LCD_last+4);
	
	sprintf(temp,"%x",dayData[2]);
	temp[2]='\0';
	lcd_string(temp);
	
	lcd_string(":");
	sprintf(temp,"%x",dayData[1]);
	temp[2]='\0';
	lcd_string(temp);
	
	lcd_string(":");
	sprintf(temp,"%x",dayData[0]);
	temp[2]='\0';
	lcd_string(temp);
	
	while(1);
}