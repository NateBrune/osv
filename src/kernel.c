#include "monitor.h"
#include "descriptor_tables.h"
#include "timer.h"
#include "paging.h"

int kmain(struct multiboot *mboot_ptr)
{
    monitor_clear();
    monitor_write("\n\n", white);
    monitor_write_center("Welcome to ImperitOS\n\n\n", white);
    monitor_write("Initializing descriptors... ", white); init_descriptor_tables(); monitor_write("ok\n", green);
    monitor_write("Initializing PIT... ", white); init_timer(100); monitor_write("ok\n", green);
    monitor_write("Initializing paging... ", white); initialise_paging(100); monitor_write("ok\n", green);
    u32int *ptr = (u32int*)0xA0000000;
    u32int do_page_fault = *ptr;
    return do_page_fault;
}
