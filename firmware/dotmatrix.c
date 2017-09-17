#include <stdlib.h>
#include <avr/io.h>
#include <util/delay.h>
#include "dotmatrix.h"

uchar display_rows[ROWS_COUNT] = {
	0b00011111,
	0b00011111,
	0b00011111,
	0b00011111,
	0b00011111,
	0b00011111,
	0b00011111,
};

void display__init_cols()
{
	col_ports[0] = &PORTD; col_pins[0] = PD4; DDRD |= _BV(PD4); // COLUMN 1 *5*  [2]
	col_ports[1] = &PORTC; col_pins[1] = PC1; DDRC |= _BV(PC1); // COLUMN 2 *1*  [24]
	col_ports[2] = &PORTA; col_pins[2] = PA2; DDRA |= _BV(PA2); // COLUMN 3 *8*  [3]
	col_ports[3] = &PORTC; col_pins[3] = PC2; DDRC |= _BV(PC2); // COLUMN 4 *14* [25]
	col_ports[4] = &PORTC; col_pins[4] = PC3; DDRC |= _BV(PC3); // COLUMN 5 *13* [26]

	cols_off();
}

void display__init_rows()
{
	row_ports[0] = &PORTC; row_pins[0] = PC0; DDRC |= _BV(PC0); // ROW 1 *2*  [23]
	row_ports[1] = &PORTC; row_pins[1] = PC4; DDRC |= _BV(PC4); // ROW 2 *12* [27]
	row_ports[2] = &PORTA; row_pins[2] = PA1; DDRA |= _BV(PA1); // ROW 3 *3*  [22]
	row_ports[3] = &PORTD; row_pins[3] = PD1; DDRD |= _BV(PD1); // ROW 4 *4*  [31]
	row_ports[4] = &PORTC; row_pins[4] = PC5; DDRC |= _BV(PC5); // ROW 5 *11* [28]
	row_ports[5] = &PORTD; row_pins[5] = PD0; DDRD |= _BV(PD0); // ROW 6 *10* [30]
	row_ports[6] = &PORTD; row_pins[6] = PD2; DDRD |= _BV(PD2); // ROW 7 *9*  [32]

	rows_off();
}

void col_on(uchar i) { *(col_ports[i]) |= _BV(col_pins[i]); }
void row_on(uchar i) { *(row_ports[i]) |= _BV(row_pins[i]); }
void col_off(uchar i) { *(col_ports[i]) &= ~_BV(col_pins[i]); }
void row_off(uchar i) { *(row_ports[i]) &= ~_BV(row_pins[i]); }

void cols_off()
{
	uchar c;
	for (c = 0; c < COLS_COUNT; c++) {
		col_off(c);
	}
}

void rows_off()
{
	uchar r;
	for (r = 0; r < ROWS_COUNT; r++) {
		row_off(r);
	}
}

uchar display__bit_get(uchar r, uchar c) { return display_rows[r] & _BV(MAX_COL_INDEX - c); }
void  display__bit_set(uchar r, uchar c) { display_rows[r] |= _BV(MAX_COL_INDEX - c); }
void  display__bit_clr(uchar r, uchar c) { display_rows[r] &= ~_BV(MAX_COL_INDEX - c); }

uchar display__row_get(uchar r, uchar c) { return display_rows[r]; }
void  display__row_set(uchar r, uchar row_byte) { display_rows[r] = row_byte; }
void  display__row_clear(uchar r) { display_rows[r] = 0; }

void display__clear()
{
	uchar r;
	for (r = 0; r < ROWS_COUNT; r++) {
		display__row_clear(r);
	}
}

void display__scroll_down()
{
	uchar r;
	for (r = 6; r > 0; r--) {
		display_rows[r] = display_rows[r-1];
	}

	display__row_clear(0);
}

void display__flush()
{
	uchar r;
	uchar c;

	for (r = 0; r < ROWS_COUNT; r++) {
		for (c = 0; c < COLS_COUNT; c++) {
			if (display__bit_get(r, c)) {
				col_on(c);
			} else {
				col_off(c);
			}
		}
		row_off(r);
		_delay_us(5);
		row_on(r);
	}
}
