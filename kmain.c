#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include "vga_printer.h"
#include "idt.h"

void _kmain() {
    printf("Hello world %s string %x hex\n", "test", 0xABCF);
    idt_main();
}