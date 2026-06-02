int main() {
    volatile unsigned int *VGA = (volatile unsigned int *)0xB8000;

    *VGA = 0x0F41; // White on black, 'A'

    return 0;
}