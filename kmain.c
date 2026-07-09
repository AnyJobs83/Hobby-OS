#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include "helpers/vga_printer.h"
#include "interrupts/idt.h"

void _start() {
    printf("Hello world %s string %x hex \n", "test", 0xABCF, 0b101);
    // printf("Testing printing   %5u \n", 123);
    // printf("Testing printing %5b \n", 0b101);
    // printf("Testing printing %5x \n", 0x101);
    idt_main();
}