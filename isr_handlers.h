#ifndef isr_handlers
#define isr_hadnlers

#include <stdint.h>

struct IDT_handler_registers {
    uint32_t int_vector;
    uint16_t GS;
    uint16_t FS;
    uint16_t ES;
    uint16_t DS;
    uint32_t EDI;
    uint32_t ESI;
    uint32_t EBP;
    uint32_t ESP;
    uint32_t EBX;
    uint32_t EDX;
    uint32_t ECX;
    uint32_t EAX;
    uint32_t error_code;
    uint32_t EIP;
    uint32_t CS;
    uint32_t E_flags;
}__attribute__((packed));

void isr_handler(struct IDT_handler_registers stack);

#endif