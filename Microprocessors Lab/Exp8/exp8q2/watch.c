#include "lcd.h"
#include "watch.h"

#define _DIFF LCD_last-LCD_first

typedef unsigned char uchar;

int dayData[]={0x15,0x15,0x14,4,0x24,5,0x54};
code int maxDayData[]={0x59,0x59,0x23,7,0x24,12,0x99};
code int minDayData[]={0,0,0,1,1,1,0};
code int daysInAMonth[]={31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
code uchar* days[]={"MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"};
code uchar* months[]={"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};
code uchar first_offsets[]={0, 5, 8, 12, _DIFF+4, _DIFF+7, _DIFF+10};
code uchar lengths[]={3, 2, 3, 4, 2, 2, 2};

char temp[3];

void init_watch(_watch_state* watch_state) {
	watch_state->state=-1;
	watch_state->disapp=0;
	watch_state->oldModePin=mode;
	watch_state->oldIncPin=inc;
}

void disp_watch(_watch_state* watch_state) {
	int index;
	lcd_command(LCD_first);
	lcd_string(days[dayData[3]-1]);
	lcd_string(", ");
	sprintf(temp,"%x",dayData[4]);
	temp[2]='\0';
	lcd_string(temp);
	lcd_string(" ");
	lcd_string(months[dayData[5]-1]);
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
	
	if(watch_state->state != -1) {
		if(watch_state->disapp == 1) {
			lcd_command(LCD_first+first_offsets[watch_state->state]);
			for(index=0;index<lengths[watch_state->state];index++) {
				lcd_string(" ");
			}
		}
	}
}

void update_watch(_watch_state* watch_state) {
	int index;
	if(watch_state->oldModePin!=mode) {
		watch_state->state=(watch_state->state+1>6)?-1:watch_state->state+1;
		watch_state->oldModePin=mode;
	}
	watch_state->disapp=1-watch_state->disapp;
	for(index=0;index<MS;index++) {
		if(watch_state->oldIncPin!=inc) {
			if(watch_state->state!=4) {
				dayData[watch_state->state]=(dayData[watch_state->state]+1>maxDayData[watch_state->state])?minDayData[watch_state->state]:dayData[watch_state->state]+1;
			}
			else {
				dayData[4]=(dayData[5]!=2)?daysInAMonth[dayData[5]]:((dayData[6]%4==0)?29:28);
			}
			watch_state->oldIncPin=inc;
			break;
		}
	}
}