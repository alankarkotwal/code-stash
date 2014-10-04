#include<regx51.h>

int timer0Interrupt_enable=1;
int timer0_reloadValue=0xF82F;

sbit pin=P0^4;


const int half_periods[]={3900, 3681, 3476, 3279, 3096, 2925, 2757, 2600, 2456, 2319, 2189, 2066};
const int durations[]		={200, 100, 100, 100, 200, 100, 100, 200, 100, 200, 100, 100, 200, 100, 100, 100, 200, 00};
const int notes[]				={0, 2, 4, 5, 7, 9, 11, 16, 64, 16, 11, 9, 7, 5, 4, 2, 0, 0};
int note_index=0;

int curr_hp, curr_dur, curr_note, note_high, note_low;

void timer0() interrupt 1 {
	if(timer0Interrupt_enable==1) {
		pin=~pin;
		TH0=(0xFFFF-timer0_reloadValue)/256;
		TL0=(0xFFFF-timer0_reloadValue) & (0xFF);
		TR0=1;
	}
}

void main() {
	int j;
	P1=0x00;
	TMOD |= 0x11;
	IE |= 0x82;
	pin=0;
	TH0=(0xFFFF-timer0_reloadValue)/256;
	TL0=(0xFFFF-timer0_reloadValue) & (0xFF);
	TR0=1;
	TR1=1;
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
				timer0Interrupt_enable=1;
				break;
			case 2:
				curr_hp=curr_hp*2;
				timer0Interrupt_enable=1;
				break;
			default:
				curr_hp=0xFFFF;
				timer0Interrupt_enable=0;
				break;
		}
		timer0_reloadValue=curr_hp;
		TF1=0;
		for(j=0;j<5*curr_dur;j++) {
			TH1=0xF0;
			TL1=0x5F;
			while(!TF1);
			TF1=0;
		}
		note_index++;
	}
	timer0Interrupt_enable=0;
	while(1);
}
