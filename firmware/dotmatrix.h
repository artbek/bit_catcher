#define uchar unsigned char

#define ROWS_COUNT 7
#define MAX_ROW_INDEX 6

#define COLS_COUNT 5
#define MAX_COL_INDEX 4

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


uchar display_rows[ROWS_COUNT];
uchar display__digits[10][ROWS_COUNT];

volatile uint8_t *row_ports[ROWS_COUNT];
volatile uint8_t *col_ports[COLS_COUNT];
uchar row_pins[ROWS_COUNT];
uchar col_pins[COLS_COUNT];

void cols_off();
void rows_off();

uchar display__bit_get(uchar r, uchar c);
void  display__bit_set(uchar r, uchar c);
void  display__bit_clr(uchar r, uchar c);

void display__init_cols();
void display__init_rows();

void col_on(uchar i);
void row_on(uchar i);
void col_off(uchar i);
void row_off(uchar i);

uchar display__bit_get(uchar r, uchar c);
void  display__bit_set(uchar r, uchar c);
void  display__bit_clr(uchar r, uchar c);

uchar display__row_get(uchar r);
void  display__row_set(uchar r, uchar row_byte);
void  display__row_clear(uchar r);

void display__clear();
void display__scroll_down();
void display__flush();


// Horizontal buffer.

uchar display__buffer[25];
uchar display__buffer_cursor_left;
uchar display__buffer_cursor_right;
uchar display__buffer_cursor_max;

void send_display_buffer_to_display();

void display__scroll_left();
void display__scroll_right();

uchar display__can_scroll_left();
uchar display__can_scroll_right();

void display__buffer__column_set(uchar column_index, uchar column_byte);

