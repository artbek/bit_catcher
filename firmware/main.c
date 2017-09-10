#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <avr/interrupt.h>

#define F_CPU 1000000

#define uchar unsigned char
#define uint unsigned int
#define ROWS_COUNT 7
#define COLS_COUNT 5

//#define INPUT_LEFT PCX


static uchar row_pins[ROWS_COUNT];
static volatile uint8_t *row_ports[ROWS_COUNT];
static uchar col_pins[COLS_COUNT];
static volatile uint8_t *col_ports[COLS_COUNT];

void col_on(uchar i) { *(col_ports[i]) |= _BV(col_pins[i]); }
void row_on(uchar i) { *(row_ports[i]) |= _BV(row_pins[i]); }
void col_off(uchar i) { *(col_ports[i]) &= ~_BV(col_pins[i]); }
void row_off(uchar i) { *(row_ports[i]) &= ~_BV(row_pins[i]); }

static uchar display[ROWS_COUNT][COLS_COUNT] = {
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0 }
};

/**
 *       --------
 *   1 --        -- 14
 *   2 --        -- 13
 *   3 --  5x7   -- 12
 *   4 --   dot  -- 11
 *   5 -- matrix -- 10
 *      -        -- 9
 *   7 --        -- 8
 *       --------
 */

void init_cols()
{
	col_ports[0] = &PORTD; col_pins[0] = PD4; DDRD |= _BV(PD4); // COLUMN 1 *5*  [2]
	col_ports[1] = &PORTC; col_pins[1] = PC1; DDRC |= _BV(PC1); // COLUMN 2 *1*  [24]
	col_ports[2] = &PORTA; col_pins[2] = PA2; DDRA |= _BV(PA2); // COLUMN 3 *8*  [3]
	col_ports[3] = &PORTC; col_pins[3] = PC2; DDRC |= _BV(PC2); // COLUMN 4 *14* [25]
	col_ports[4] = &PORTC; col_pins[4] = PC3; DDRC |= _BV(PC3); // COLUMN 5 *13* [26]

	uchar c;
	for (c = 0; c < COLS_COUNT; c++) {
		col_off(c);
	}
}

void init_rows()
{
	row_ports[0] = &PORTC; row_pins[0] = PC0; DDRC |= _BV(PC0); // ROW 1 *2*  [23]
	row_ports[1] = &PORTC; row_pins[1] = PC4; DDRC |= _BV(PC4); // ROW 2 *12* [27]
	row_ports[2] = &PORTA; row_pins[2] = PA1; DDRA |= _BV(PA1); // ROW 3 *3*  [22]
	row_ports[3] = &PORTD; row_pins[3] = PD1; DDRD |= _BV(PD1); // ROW 4 *4*  [31]
	row_ports[4] = &PORTC; row_pins[4] = PC5; DDRC |= _BV(PC5); // ROW 5 *11* [28]
	row_ports[5] = &PORTD; row_pins[5] = PD0; DDRD |= _BV(PD0); // ROW 6 *10* [30]
	row_ports[6] = &PORTD; row_pins[6] = PD2; DDRD |= _BV(PD2); // ROW 7 *9*  [32]

	uchar r;
	for (r = 0; r < ROWS_COUNT; r++) {
		row_off(r);
	}
}


void flush_display()
{
	uchar r;
	uchar c;

	for (r = 0; r < ROWS_COUNT; r++) {
		for (c = 0; c < COLS_COUNT; c++) {
			if (display[r][c]) {
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

static signed char pos_r = 1;
static signed char pos_c = 2;

static signed char delta_r = 1;
static signed char delta_c = 1;

static uchar counter = 0;


void cls()
{
	uchar r;
	uchar c;

	for (r = 0; r < ROWS_COUNT; r++) {
		for (c = 0; c < COLS_COUNT; c++) {
			display[r][c] = 0;
		}
	}
}

void draw()
{
	counter++;

	if (counter > 25) {
		counter = 0;

		if (pos_c >= (COLS_COUNT - 1)) {
			delta_c *= -1;
			pos_c = COLS_COUNT - 1;
		} else if (pos_c <= 0) {
			delta_c *= -1;
			pos_c = 0;
		}

		if (pos_r >= (ROWS_COUNT - 1)) {
			delta_r *= -1;
			pos_r = ROWS_COUNT - 1;
		} else if (pos_r <= 0) {
			delta_r *= -1;
			pos_r = 0;
		}

		pos_c += delta_c;
		pos_r += delta_r;

		cls();
		display[pos_r][pos_c] = 1;
	}
}


/*** MAIN ***/

int __attribute__((noreturn)) main(void)
{
	init_cols();
	init_rows();

	while (1) {
		draw();
		flush_display();
	}
}
