#ifndef _LCD_H
#define _LCD_H

#include<regx51.h>
#include"delay.h"

#define LCD_data	P2		// LCD Data port
#define LCD_cont  P0 		// LCD Control port
#define LCD_rs		0  		// LCD Register Select
#define LCD_rw		1  		// LCD Read/Write
#define LCD_en		2  		// LCD Enable
#define LCD_first	0x80  // First line command
#define LCD_last 	0xC0  // Last line command

void init_lcd();
void lcd_command(int);
void lcd_data(int);
void lcd_string(char*);

#endif