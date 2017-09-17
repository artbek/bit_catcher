#include <stdlib.h>
#include <avr/io.h>
#include <util/delay.h>
#include "dotmatrix.h"

#define F_CPU 1000000

#define uchar unsigned char
#define uint unsigned int

#define INPUT_LEFT PD7
#define INPUT_RIGHT PD6
#define INPUT_LEFT_PORT PIND
#define INPUT_RIGHT_PORT PIND

uchar is_left_busy;
uchar is_right_busy;

static void inputs_init()
{
	DDRD &= ~_BV(PD7);
	DDRD &= ~_BV(PD6);

	PORTD |= _BV(PD7);
	PORTD |= _BV(PD6);

	is_left_busy = 0;
	is_right_busy = 0;
}


uchar position_index = 0;

uchar positions[100] = {
	1, 1, 0, 2, 4, 3, 0, 0, 4, 0, 2, 1, 0, 4, 1, 2, 4, 0, 1, 2,
	4, 3, 4, 1, 4, 1, 4, 2, 2, 1, 4, 0, 3, 3, 1, 2, 1, 3, 0, 1,
	2, 2, 1, 1, 2, 4, 4, 2, 3, 3, 0, 1, 4, 3, 1, 3, 3, 0, 0, 2,
	4, 3, 0, 4, 1, 0, 4, 1, 4, 1, 0, 4, 0, 1, 4, 0, 3, 0, 3, 2,
	0, 3, 4, 2, 3, 4, 3, 0, 0, 2, 2, 1, 2, 4, 4, 0, 0, 3, 0, 3
};

static uchar row_variants[5] = {
	0b00010000,
	0b00001000,
	0b00000100,
	0b00000010,
	0b00000001,
};

void add_new_drop()
{
	display__row_set(0, row_variants[positions[position_index]]);

	position_index++;
	if (position_index >= 100) {
		position_index = 0;
	}
}

uchar counter = 0;
uchar new_drop_counter = 0;

uchar saucer = 0b00011000;


void process_button_left()
{
	if (is_left_busy && bit_is_set(INPUT_LEFT_PORT, INPUT_LEFT)) {
		is_left_busy = 0;
		_delay_ms(1);
	} else if (! is_left_busy && bit_is_clear(INPUT_LEFT_PORT, INPUT_LEFT)) {
		is_left_busy = 1;
		if (saucer < 0b00011000) {
			saucer = saucer << 1;
			_delay_ms(1);
		}
	}
}

void process_button_right()
{
	if (is_right_busy && bit_is_set(INPUT_RIGHT_PORT, INPUT_RIGHT)) {
		is_right_busy = 0;
		_delay_ms(1);
	} else if (! is_right_busy && bit_is_clear(INPUT_RIGHT_PORT, INPUT_RIGHT)) {
		is_right_busy = 1;
		if (saucer > 0b00000011) {
			saucer = saucer >> 1;
			_delay_ms(1);
		}
	}
}


/*** MAIN ***/

int __attribute__((noreturn)) main(void)
{
	display__init_cols();
	display__init_rows();
	inputs_init();

	while (1) {

		counter++;

		if (counter >= 30) {
			new_drop_counter++;

			display__scroll_down();
			counter = 0;

			if (new_drop_counter > 5) {
				add_new_drop();
				new_drop_counter = 0;
			}
		}

		process_button_left();
		process_button_right();

		display__row_set(MAX_ROW_INDEX, saucer);

		display__flush();

	}

}
