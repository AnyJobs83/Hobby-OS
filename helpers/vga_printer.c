#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>

#define VGA_COLS 80
#define VGA_ROWS 25

extern uint16_t VGA_START;

volatile uint16_t *pVGA = &VGA_START;
int currentCol = 0;
int currentRow = 0;

bool inFormatMode = false;

bool format_with_zeros = false;
int format_width = 0;

void vga_print_char(char c) {
    *pVGA = 0x0F00 | c;
    pVGA++;

    currentCol++;
    if (currentCol >= VGA_COLS) {
        currentCol = 0;

        currentRow++;
        if (currentRow >= VGA_ROWS) {
            currentRow = 0;
            pVGA = &VGA_START;
        }
    }
}
void vga_print_uint(unsigned int num, unsigned int digit_tally) {
    if (num >= 10) {
        vga_print_uint(num / 10, digit_tally + 1);
    } else {
        while (digit_tally < format_width) {
            digit_tally++;

            if (format_with_zeros) {
                vga_print_char('0');
            } else {
                vga_print_char(' ');
            }
        }
    }
    vga_print_char('0' + (num % 10));
}
void vga_print_ubin(unsigned int num, unsigned int digit_tally) {
    if (num >= 2) {
        vga_print_ubin(num / 2, digit_tally + 1);
    } else {
        while (digit_tally < format_width) {
            digit_tally++;

            if (format_with_zeros) {
                vga_print_char('0');
            } else {
                vga_print_char(' ');
            }
        }
    }
    vga_print_char('0' + (num % 2));
}
void vga_print_uhex(unsigned int num, unsigned int digit_tally) {
    if (num >= 16) {
        vga_print_uhex(num / 16, digit_tally + 1);
    } else {
        while (digit_tally < format_width) {
            digit_tally++;

            if (format_with_zeros) {
                vga_print_char('0');
            } else {
                vga_print_char(' ');
            }
        }
    }

    if ((num % 16) >= 10) {
        vga_print_char('A' + (num % 16 - 10));
    } else {
        vga_print_char('0' + (num % 16));
    }
}
void printf(char* str, ...) {
    va_list args;
    va_start(args, str);

    while (*str) {
        char c = *str;

        if (inFormatMode) {
            switch (c) {
                case ('0'):
                    if (format_width == 0) {
                        format_with_zeros = true;
                    } else {
                        format_width = format_width * 10;
                    }
                    break;
                case ('1'):
                case ('2'):
                case ('3'):
                case ('4'):
                case ('5'):
                case ('6'):
                case ('7'):
                case ('8'):
                case ('9'):
                    format_width = format_width * 10 + (c - '0');
                    break;
                case ('s'):
                    inFormatMode = !inFormatMode;
                    printf(va_arg(args, char*));
                    format_with_zeros = false;
                    format_width = 0;
                    break;
                case ('u'):
                    inFormatMode = !inFormatMode;
                    vga_print_uint(va_arg(args, unsigned int), 0);
                    format_with_zeros = false;
                    format_width = 0;
                    break;
                case ('x'):
                    inFormatMode = !inFormatMode;
                    vga_print_char('0');
                    vga_print_char('x');
                    vga_print_uhex(va_arg(args, unsigned int), 0);
                    format_with_zeros = false;
                    format_width = 0;
                    break;
                case ('b'):
                    inFormatMode = !inFormatMode;
                    vga_print_char('0');
                    vga_print_char('b');
                    vga_print_ubin(va_arg(args, unsigned int), 0);
                    format_with_zeros = false;
                    format_width = 0;
                    break;
                default:
                    inFormatMode = !inFormatMode;
                    printf("Format specifier not implemented");
            }
        } else if (c == '%') {
            inFormatMode = !inFormatMode;
        } else if (c == '\n') {
            for (int i = currentCol; i < VGA_COLS; i++) {
                vga_print_char(' ');
            }
        } else if (c == '\t') {
            vga_print_char(' ');
            vga_print_char(' ');
            vga_print_char(' ');
            vga_print_char(' ');
        } else {
            vga_print_char(c);
        }
        str++;
    }
    va_end(args);
}