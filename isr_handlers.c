#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include "vga_printer.h"
#include "isr_hadlers.h"

extern void _send_eoi_to_master(void);
extern void _send_eoi_to_slave(void);
extern uint8_t _read_scancode(void);

void isr_32_timer() {
    //printf("timer");
}
void isr_33_keyboard() {
    uint8_t scancode = _read_scancode();
    printf("Keyboard got pressed by %u", (uint32_t)scancode);
}

void isr_handler(struct IDT_handler_registers stack) {
    if (stack.int_vector != 32) {
        printf("hello interrupt #%u", stack.int_vector);
    }
    switch (stack.int_vector) {
        case (8):
            printf("Double fault");
            break;
        case (13):
            printf("General Protection fault");
            break;
        case (14):
            printf("Page fault");
        case (32):
            isr_32_timer();
            break;
        case (33):
            isr_33_keyboard();
            break;
        case (44):
            printf("mouse");
            break;
        default:
            printf("Unimplmented Interrupt");
    }

    // Send EOI's
    if (stack.int_vector >= 32 && stack.int_vector < 48) {
        if (stack.int_vector >= 40) {
            _send_eoi_to_slave();
        }

        _send_eoi_to_master();
    }
}