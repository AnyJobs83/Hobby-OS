#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>

#define VGA_COLS 80
#define VGA_ROWS 25
#define VGA_START_PTR (volatile unsigned short *)0xB8000;

volatile unsigned short *pVGA = VGA_START_PTR;
int currentCol = 0;
int currentRow = 0;
bool inFormatMode = false;

void vga_print_char(char c) {
    *pVGA = 0x0F00 | c;
    pVGA++;

    currentCol++;
    if (currentCol >= VGA_COLS) {
        currentCol = 0;

        currentRow++;
        if (currentRow >= VGA_ROWS) {
            currentRow = 0;
            pVGA = VGA_START_PTR;
        }
    }
}
void vga_print_uint(unsigned int num) {
    if (num > 10) {
        vga_print_uint(num / 10);
    }
    vga_print_char('0' + (num % 10));
}
void vga_print_ubin(unsigned int num) {
    if (num > 2) {
        vga_print_ubin(num / 2);
    }
    vga_print_char('0' + (num % 2));
}
void vga_print_uhex(unsigned int num) {
    if (num > 16) {
        vga_print_uhex(num / 16);
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
            inFormatMode = !inFormatMode;
            switch (c) {
                case ('s'):
                    printf(va_arg(args, char*));
                    break;
                case ('u'):
                    vga_print_uint(va_arg(args, unsigned int));
                    break;
                case ('x'):
                    vga_print_char('0');
                    vga_print_char('x');
                    vga_print_uhex(va_arg(args, unsigned int));
                    break;
                case ('b'):
                    vga_print_char('0');
                    vga_print_char('b');
                    vga_print_ubin(va_arg(args, unsigned int));
                default:
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