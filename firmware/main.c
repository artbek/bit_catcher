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

#define SAUCER_ROW_INDEX MAX_ROW_INDEX

#define GAME_INTRO 0
#define GAME_PLAY 1
#define GAME_OVER 2

uchar game_stage = GAME_INTRO;

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

void ping(uchar value)
{
	if (value) {
		PORTB |= _BV(PB2);
		_delay_ms(100);
		PORTB &= ~_BV(PB2);
		_delay_ms(20);
		PORTB |= _BV(PB2);
		_delay_ms(100);
		PORTB &= ~_BV(PB2);
		_delay_ms(20);
	} else {
		PORTB |= _BV(PB2);
		_delay_ms(200);
		PORTB &= ~_BV(PB2);
		_delay_ms(20);
	}
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

uchar counter = 0;
uchar new_drop_counter = 0;

uchar saucer_shape = 0b00011000;


uchar current_drop_shape;
uchar current_drop_row_position = 0;

void add_new_drop()
{
	current_drop_shape = row_variants[positions[position_index]];
	current_drop_row_position = 0;

	position_index++;
	if (position_index >= 100) {
		position_index = 0;
	}
}


void draw_drop()
{
	uchar current_row = display__row_get(current_drop_row_position);
	display__row_set(current_drop_row_position, current_drop_shape | current_row);
}

void draw_saucer()
{
	uchar current_row = display__row_get(SAUCER_ROW_INDEX);
	display__row_set(SAUCER_ROW_INDEX, saucer_shape | current_row);
}


uchar is_button_left_pressed()
{
	uchar is_pressed = 0;

	if (is_left_busy && bit_is_set(INPUT_LEFT_PORT, INPUT_LEFT)) {
		is_left_busy = 0;
		_delay_ms(1);
	} else if (! is_left_busy && bit_is_clear(INPUT_LEFT_PORT, INPUT_LEFT)) {
		is_left_busy = 1;
		is_pressed = 1;
		_delay_ms(1);
	}

	return is_pressed;
}

uchar is_button_right_pressed()
{
	uchar is_pressed = 0;

	if (is_right_busy && bit_is_set(INPUT_RIGHT_PORT, INPUT_RIGHT)) {
		is_right_busy = 0;
		_delay_ms(1);
	} else if (! is_right_busy && bit_is_clear(INPUT_RIGHT_PORT, INPUT_RIGHT)) {
		is_right_busy = 1;
		is_pressed = 1;
		_delay_ms(1);
	}

	return is_pressed;
}


uchar RAIN_SPEED = 100; // Higher value = slower speed.

uchar score = 0;
uchar score__digits_count = 0;
uchar score__actual_digits[5] = {0, 0, 0, 0, 0};


void prepare_display_buffer()
{
	uchar c;
	uchar r;
	char digit_index;
	uchar temp_column = 0b00000000;

	display__buffer_cursor_max = 0;

	for (digit_index = score__digits_count; digit_index >= 0; digit_index--) {
		uchar actual_digit = score__actual_digits[digit_index];

		for (c = 0; c < COLS_COUNT; c++) {
			temp_column = 0b00000000;

			for (r = 0; r < ROWS_COUNT; r++) {
				if (display__digits[actual_digit][r] & _BV(MAX_COL_INDEX - c)) {
					//ping(1);
					temp_column |= _BV(MAX_ROW_INDEX - r);
				} else {
					//ping(0);
				}
			}

			display__buffer__column_set(display__buffer_cursor_max, temp_column);
			display__buffer_cursor_max++;
		}

		//add spacer
		if (digit_index) {
			display__buffer__column_set(display__buffer_cursor_max, 0b00000000);
			display__buffer_cursor_max++;
		}
	}

	display__buffer_cursor_max--;
}


void increment_score()
{
	if (game_stage != GAME_PLAY) return;

	// If any drops on the saucer row.
	if (current_drop_shape && current_drop_row_position == SAUCER_ROW_INDEX) {

		// If the drop overlaps saucer.
		if (current_drop_shape & saucer_shape) {
			score++;
			current_drop_shape = 0b00000000;
		} else {
			game_stage = GAME_OVER;

			//score = 3190;

			uchar temp_score = score;
			while (temp_score / 10) {
				score__actual_digits[score__digits_count] = temp_score % 10;
				score__digits_count++;
				temp_score = temp_score / 10;
			}

			score__actual_digits[score__digits_count] = temp_score;

			prepare_display_buffer();
		}
	}
}


void game_intro()
{
	counter++;

	if (counter >= RAIN_SPEED) {
		counter = 0;
		uchar r;
		for (r = 0; r < ROWS_COUNT; r++) {
			display__row_set(r, ~display__row_get(r));
		}
	}

	if (is_button_left_pressed() || is_button_right_pressed()) {
		// transition animation and then change the game stage
		display__clear();
		add_new_drop();
		game_stage = GAME_PLAY;
	}

}

long long int b;

void game_play()
{
	counter++;

	if (counter >= RAIN_SPEED) {
		counter = 0;

		current_drop_row_position++;
		if (current_drop_row_position > MAX_ROW_INDEX) {
			add_new_drop();
		}
	}

	increment_score();

	if (is_button_left_pressed()) {
		if (saucer_shape < 0b00011000) {
			saucer_shape = saucer_shape << 1;
		}
	}

	if (is_button_right_pressed()) {
		if (saucer_shape > 0b00000011) {
			saucer_shape = saucer_shape >> 1;
		}
	}

	display__clear();
	draw_drop();
	draw_saucer();
}


uchar is_scroll_direction_left = 1;

void game_over()
{
	counter++;
	if (counter < RAIN_SPEED) return;
	counter = 0;

	send_display_buffer_to_display();

	if (is_scroll_direction_left) {

		if (display__can_scroll_left()) {
			display__scroll_left();
		} else {
			is_scroll_direction_left = 0;
		}

	} else {

		if (display__can_scroll_right()) {
			display__scroll_right();
		} else {
			is_scroll_direction_left = 1;
		}

	}
}


/*** MAIN ***/

int __attribute__((noreturn)) main(void)
{
	display__init_cols();
	display__init_rows();
	inputs_init();

	DDRB |= _BV(PB2);
	PORTB &= ~_BV(PB2);

	while (1) {

		switch (game_stage) {

			case GAME_INTRO:
				game_intro();
				break;

			case GAME_PLAY:
				game_play();
				break;

			case GAME_OVER:
				game_over();
				break;

		}

		display__flush();
	}

}
