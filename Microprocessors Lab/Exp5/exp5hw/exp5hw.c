#include<regx51.h>
#include<stdio.h>
#include"lcd.h"
#include"delay.h"

const int half_periods[]={3900, 3681, 3476, 3279, 3096, 2925, 2757, 2600, 2456, 2319, 2189, 2066};
const int durations[]		={200, 100, 100, 100, 200, 100, 100, 200, 100, 200, 100, 100, 200, 100, 100, 100, 200, 00};
const int notes[]				={0, 2, 4, 5, 7, 9, 11, 16, 64, 16, 11, 9, 7, 5, 4, 2, 0, 0};
int note_index=0;

int curr_hp, curr_dur, curr_note, note_high, note_low;

void main() {
	char ascii[5];
	P2=0x00;
	software_delay(2);
	init_lcd();
	software_delay(3);
	lcd_command(LCD_first);
	software_delay(1);
	while(1) {
		curr_dur=durations[note_index];
		if(curr_dur==0) break;
		curr_note=notes[note_index];
		note_high=curr_note & 0xF0;
		note_high=note_high/16;
		note_low=curr_note & 0x0F;
		curr_hp=half_periods[note_low];
		switch(note_high) {
			case 0:
				break;
			case 1:
				curr_hp=curr_hp/2;
				break;
			case 2:
				curr_hp=0xFF;
				break;
			default:
				break;
		}
		lcd_string("Note=");
		sprintf(ascii,"%x",curr_note);
		lcd_string(ascii);
		lcd_string(", D=");
		sprintf(ascii,"%x",curr_dur);
		lcd_string(ascii);
		lcd_command(LCD_last);
		lcd_string("Oct=");
		sprintf(ascii,"%x",note_high);
		lcd_string(ascii);
		lcd_string(", HP=");
		sprintf(ascii,"%x",curr_hp);
		lcd_string(ascii);
		note_index=note_index+1;
		lcd_command(LCD_first);
		software_delay(5*curr_dur);
	}
	while(1);
}
