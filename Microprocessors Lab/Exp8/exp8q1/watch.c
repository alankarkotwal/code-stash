#include "lcd.h"
#include "watch.h"

#define _DIFF LCD_last-LCD_first

typedef unsigned char uchar;

int dayData[]={0x37,0x43,0x14,4,0x24,5,0x54};
code uchar* days[]={"MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"};
code uchar* months[]={"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};
code uchar first_offsets[]={0, 5, 8, 14, _DIFF+4, _DIFF+7, _DIFF+10};
code uchar lengths[]={3, 2, 3, 2, 2, 2, 2};

char _temp[3];

void disp_watch(_watch_state* watch_state) {
	int index;
	lcd_command(LCD_first);
	lcd_string(days[dayData[3]-1]);
	lcd_string(", ");
	sprintf(_temp,"%x",dayData[4]);
	_temp[2]='\0';
	lcd_string(_temp);
	lcd_string(" ");
	lcd_string(months[dayData[5]-1]);
	lcd_string(" 20");
	sprintf(_temp,"%x",dayData[6]);
	_temp[2]='\0';
	lcd_string(_temp);
	
	lcd_command(LCD_last+4);
	
	sprintf(_temp,"%x",dayData[2]);
	_temp[2]='\0';
	lcd_string(_temp);
	
	lcd_string(":");
	sprintf(_temp,"%x",dayData[1]);
	_temp[2]='\0';
	lcd_string(_temp);
	
	lcd_string(":");
	sprintf(_temp,"%x",dayData[0]);
	_temp[2]='\0';
	lcd_string(_temp);
	
	if(watch_state->state != -1) {
		if(watch_state->disapp == 1) {
			lcd_command(LCD_first+first_offsets[watch_state->state]);
			for(index=0;index<lengths[watch_state->state];index++) {
				lcd_string(" ");
			}
		}
	}
}

void update_watch() {
	
}