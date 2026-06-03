#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>

#define VGA_COLS 80

volatile unsigned short *pVGA = (volatile unsigned short *)0xB8000;
int currentCol = 0;
bool inFormatMode = false;

void vga_print_char(char c) {
    *pVGA = 0x0F00 | c;
    pVGA++;

    currentCol++;
    if (currentCol == VGA_COLS) {
        currentCol = 0;
    }
}
void printf(char* str) {
    while (*str) {
        char c = *str;

        if (inFormatMode) {
            switch (c) {
                case ('s'):
                    vga_print_char('s');
                    break;
                case ('f'):
                    vga_print_char('f');
                default:
                    vga_print_char('?');
            }

            inFormatMode = !inFormatMode;
        } else {
            if (c == '%') {
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
        }
        str++;
    }
}