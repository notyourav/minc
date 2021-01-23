#include "main.h"

//extern _sfrword gfx_begin;

void memcpy(void *dest, void *src, int size);
void memset(void *dest, u8 value, int size);

void main()
{
    printstr("init\n");

    // enable tilemap
    PRC_MODE |= MAP_ENABLE;
    PRC_MAP_HI = 0x1;
    memset(TILEMAP, 0, 0xC0);

    while (1)
    {
    }
}

void memcpy(void *dest, void *src, int size)
{
    u8 *d = dest;
    u8 *s = src;
    int i;

    for (i = 0; i < size; ++i)
    {
        *d = *s;
        ++s;
        ++d;
    }
}

void memset(void *dest, u8 value, int size)
{
    u8 *d = dest;
    int i;

    for (i = 0; i < size; ++i)
    {
        *d = value;
        ++d;
    }
}

void prc_frame_copy_irq(void) {}
void prc_render_irq(void) {}
void timer_2h_underflow_irq(void) {}
void timer_2l_underflow_irq(void) {}
void timer_1h_underflow_irq(void) {}
void timer_1l_underflow_irq(void) {}
void timer_3h_underflow_irq(void) {}
void timer_3_cmp_irq(void) {}
void timer_32hz_irq(void) {}
void timer_8hz_irq(void) {}
void timer_2hz_irq(void) {}
void timer_1hz_irq(void) {}
void ir_rx_irq(void) {}
void shake_irq(void) {}
void key_power_irq(void) {}
void key_right_irq(void) {}
void key_left_irq(void) {}
void key_down_irq(void) {}
void key_up_irq(void) {}
void key_c_irq(void) {}
void key_b_irq(void) {}
void key_a_irq(void) {}
void unknown_irq(void) {}
void cartridge_irq(void) {}
void _copytable(void) {}
void _exit(void) {}
