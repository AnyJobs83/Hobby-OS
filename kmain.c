#include <stdint.h>

void _kmain() {
    volatile unsigned int *VGA = (volatile unsigned int *)0xB8000;

    *VGA = 0x0F41; // White on black, 'A'
}


struct IDTEntry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attr;
    uint16_t offset_high;
} __attribute__((packed));