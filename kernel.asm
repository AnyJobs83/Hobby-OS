global _kmain

_kmain:
    mov eax, 0xB8000
    mov byte [eax], 'H'
    mov byte [eax + 1], 0x0F
    jmp $