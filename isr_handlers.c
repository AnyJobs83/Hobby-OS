#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include "vga_printer.h"
#include "isr_handlers.h"

extern void _send_eoi_to_master(void);
extern void _send_eoi_to_slave(void);
extern uint8_t _read_scancode(void);
extern uint8_t _read_ps2_status(void);

volatile int counter = 0;

void isr_32_timer() {
    //printf("%u", counter);

    _read_scancode();

    //printf("timer");
}
void isr_33_keyboard() {
    //volatile unsigned int reads = 0;
    //while (_read_ps2_status() & 1) {
        uint8_t scancode = _read_scancode();
        // counter++;
        // reads++;
        // if (reads > 1) {
        //     printf("Why the hell is reads reading more than once");
        // }
        printf("Keyboard %u        ", (uint32_t)scancode);
    //}
}

void isr_handler(struct IDT_handler_registers args) {
    if (args.int_vector != 32) {
        //printf("hello interrupt #%u", stack.int_vector);
    }
    switch (args.int_vector) {
        case (8):
            printf("Double fault");
            break;
        case (13):
            printf("General Protection fault");
            break;
        case (14):
            printf("Page fault");
            break;
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
    if (args.int_vector >= 32 && args.int_vector < 48) {
        if (args.int_vector >= 40) {
            printf("slave");
            _send_eoi_to_slave();
        }

        _send_eoi_to_master();
        //if (args.int_vector != 32) printf("master");
    }
}