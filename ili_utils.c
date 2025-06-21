// ili_utils.c
#include <linux/module.h>
#include <linux/kernel.h>
#include <asm/desc.h>

//
// טיפוסי הנתונים והפונקציות החיצוניות
//
extern void my_ili_handler(void);
void *old_ili_handler = NULL;
EXPORT_SYMBOL(old_ili_handler);

void my_store_idt(struct desc_ptr *idtr) {
    asm volatile("sidt %0" : "=m" (*idtr));
}

void my_load_idt(struct desc_ptr *idtr) {
    asm volatile("lidt %0" : : "m" (*idtr));
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
    gate->offset_low    = addr & 0xFFFF;
    gate->offset_middle = (addr >> 16) & 0xFFFF;
    gate->offset_high   = (addr >> 32);
}

unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned long offset = gate->offset_high;
    offset <<= 16;
    offset |= (unsigned long)gate->offset_middle;
    offset <<= 16;
    offset |= (unsigned long)gate->offset_low;
    return offset;
}
