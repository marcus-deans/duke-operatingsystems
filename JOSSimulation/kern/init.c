/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/elf.h>
#include <inc/magic.h>
#include <kern/console.h>
#include <kern/env.h>
#include <kern/trap.h>
#include <kern/ide.h>

struct Trapframe nTrap;

uint8_t binary_to_load[SECTSIZE*MAX_RW];

void (*load_code())(uint8_t *binary);

void
i386_init(void)
{
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();

	cprintf(OS_START);
	env_init();
	trap_init();

	// TODO: YOUR CODE HERE
	ide_read(2000, binary_to_load, MAX_RW);
	struct Elf *header = (struct Elf*) binary_to_load;
	if(header->e_magic == ELF_MAGIC) {
		cprintf("I found the ELF header!");
	}

	void (*loaded_start_func)()  = load_code(binary_to_load);
	initialize_new_trapframe(&nTrap, *loaded_start_func);
	run_trapframe(&nTrap);
	loaded_start_func();
	// this infinite loop prevents your OS from panicing when
	// we're getting started.  Put your code before it!
	while(1);
		
	panic("we should not return from init");
}

void (*load_code(uint8_t *binary))()
{
	// Hints:
	//  Load each program segment into virtual memory
	//  at the address specified in the ELF segment header.
	//  You should only load segments with ph->p_type == ELF_PROG_LOAD.
	//  Each segment's virtual address can be found in ph->p_va
	//  and its size in memory can be found in ph->p_memsz.
	//  The ph->p_filesz bytes from the ELF binary, starting at
	//  'binary + ph->p_offset', should be copied to virtual address
	//  ph->p_va.  Any remaining memory bytes should be cleared to zero.
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
	//

	struct Elf *header = (struct Elf*) binary;
	if(header->e_magic != ELF_MAGIC) {
		panic("not a an elf header");
	}
	struct Proghdr* ph = (void*) binary + header->e_phoff;
	
	for(int i = 0; i < header->e_phnum; i++) {
		if(ph[i].p_type != ELF_PROG_LOAD) continue;
		if(ph[i].p_va < 0x800000  ||  ph[i].p_va > USTACKTOP) {
			panic("trying to load memory region outside correct region!\n");
		}
		// TODO: YOUR CODE HERE
		int a = 0;
		uint32_t* virta = (uint32_t*) ph[i].p_va;
		memset(virta, a, ph[i].p_memsz);
		uint32_t temp = (uint32_t)binary;
		uint32_t fina = temp + ph[i].p_offset;
		uint32_t* loca = (uint32_t*) fina;
		memcpy(virta, loca, ph[i].p_filesz);
		/*if(ph[i].p_filesz <= ph[i].p_memsz){

		}*/
	}
	return (void (*)()) header->e_entry;

}


/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	if (panicstr)
		goto dead;
	panicstr = fmt;

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);

dead:
	shutdown();
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);
}
