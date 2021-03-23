
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

00400000 <_start-0xc>:
.globl		_start
_start = entry

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
  400000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  400006:	00 00                	add    %al,(%eax)
  400008:	fe 4f 52             	decb   0x52(%edi)
  40000b:	e4                   	.byte 0xe4

0040000c <_start>:
  40000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  400013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(entry_pgdir), %eax
  400015:	b8 00 60 41 00       	mov    $0x416000,%eax
	movl	%eax, %cr3
  40001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
  40001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
  400020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
  400025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
  400028:	b8 2f 00 40 00       	mov    $0x40002f,%eax
	jmp	*%eax
  40002d:	ff e0                	jmp    *%eax

0040002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
  40002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
  400034:	bc 00 20 41 00       	mov    $0x412000,%esp

	# now to C code
	call	i386_init
  400039:	e8 34 01 00 00       	call   400172 <i386_init>

0040003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
  40003e:	eb fe                	jmp    40003e <spin>

00400040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  400040:	55                   	push   %ebp
  400041:	89 e5                	mov    %esp,%ebp
  400043:	57                   	push   %edi
  400044:	56                   	push   %esi
  400045:	53                   	push   %ebx
  400046:	83 ec 0c             	sub    $0xc,%esp
  400049:	e8 15 02 00 00       	call   400263 <__x86.get_pc_thunk.bx>
  40004e:	81 c3 e6 52 01 00    	add    $0x152e6,%ebx
  400054:	8b 7d 10             	mov    0x10(%ebp),%edi
	va_list ap;

	if (panicstr)
  400057:	c7 c0 c0 7f 41 00    	mov    $0x417fc0,%eax
  40005d:	83 38 00             	cmpl   $0x0,(%eax)
  400060:	74 0e                	je     400070 <_panic+0x30>
}

static inline void
outw(int port, uint16_t data)
{
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  400062:	b8 00 20 00 00       	mov    $0x2000,%eax
  400067:	ba 04 06 00 00       	mov    $0x604,%edx
  40006c:	66 ef                	out    %ax,(%dx)
  40006e:	eb fe                	jmp    40006e <_panic+0x2e>
		goto dead;
	panicstr = fmt;
  400070:	89 38                	mov    %edi,(%eax)

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");
  400072:	fa                   	cli    
  400073:	fc                   	cld    

	va_start(ap, fmt);
  400074:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel panic at %s:%d: ", file, line);
  400077:	83 ec 04             	sub    $0x4,%esp
  40007a:	ff 75 0c             	pushl  0xc(%ebp)
  40007d:	ff 75 08             	pushl  0x8(%ebp)
  400080:	8d 83 8c cd fe ff    	lea    -0x13274(%ebx),%eax
  400086:	50                   	push   %eax
  400087:	e8 6f 08 00 00       	call   4008fb <cprintf>
	vcprintf(fmt, ap);
  40008c:	83 c4 08             	add    $0x8,%esp
  40008f:	56                   	push   %esi
  400090:	57                   	push   %edi
  400091:	e8 2e 08 00 00       	call   4008c4 <vcprintf>
	cprintf("\n");
  400096:	8d 83 cf cd fe ff    	lea    -0x13231(%ebx),%eax
  40009c:	89 04 24             	mov    %eax,(%esp)
  40009f:	e8 57 08 00 00       	call   4008fb <cprintf>
  4000a4:	83 c4 10             	add    $0x10,%esp
  4000a7:	eb b9                	jmp    400062 <_panic+0x22>

004000a9 <load_code>:
{
  4000a9:	55                   	push   %ebp
  4000aa:	89 e5                	mov    %esp,%ebp
  4000ac:	57                   	push   %edi
  4000ad:	56                   	push   %esi
  4000ae:	53                   	push   %ebx
  4000af:	83 ec 1c             	sub    $0x1c,%esp
  4000b2:	e8 ac 01 00 00       	call   400263 <__x86.get_pc_thunk.bx>
  4000b7:	81 c3 7d 52 01 00    	add    $0x1527d,%ebx
	if(header->e_magic != ELF_MAGIC) {
  4000bd:	8b 45 08             	mov    0x8(%ebp),%eax
  4000c0:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
  4000c6:	75 0f                	jne    4000d7 <load_code+0x2e>
  4000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  4000cb:	89 c7                	mov    %eax,%edi
  4000cd:	03 78 1c             	add    0x1c(%eax),%edi
	for(int i = 0; i < header->e_phnum; i++) {
  4000d0:	be 00 00 00 00       	mov    $0x0,%esi
  4000d5:	eb 36                	jmp    40010d <load_code+0x64>
		panic("not a an elf header");
  4000d7:	83 ec 04             	sub    $0x4,%esp
  4000da:	8d 83 a4 cd fe ff    	lea    -0x1325c(%ebx),%eax
  4000e0:	50                   	push   %eax
  4000e1:	6a 48                	push   $0x48
  4000e3:	8d 83 b8 cd fe ff    	lea    -0x13248(%ebx),%eax
  4000e9:	50                   	push   %eax
  4000ea:	e8 51 ff ff ff       	call   400040 <_panic>
			panic("trying to load memory region outside correct region!\n");
  4000ef:	83 ec 04             	sub    $0x4,%esp
  4000f2:	8d 83 04 ce fe ff    	lea    -0x131fc(%ebx),%eax
  4000f8:	50                   	push   %eax
  4000f9:	6a 4f                	push   $0x4f
  4000fb:	8d 83 b8 cd fe ff    	lea    -0x13248(%ebx),%eax
  400101:	50                   	push   %eax
  400102:	e8 39 ff ff ff       	call   400040 <_panic>
	for(int i = 0; i < header->e_phnum; i++) {
  400107:	83 c6 01             	add    $0x1,%esi
  40010a:	83 c7 20             	add    $0x20,%edi
  40010d:	8b 45 08             	mov    0x8(%ebp),%eax
  400110:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  400114:	39 f0                	cmp    %esi,%eax
  400116:	7e 4c                	jle    400164 <load_code+0xbb>
  400118:	89 7d e4             	mov    %edi,-0x1c(%ebp)
		if(ph[i].p_type != ELF_PROG_LOAD) continue;
  40011b:	83 3f 01             	cmpl   $0x1,(%edi)
  40011e:	75 e7                	jne    400107 <load_code+0x5e>
		if(ph[i].p_va < 0x800000  ||  ph[i].p_va > USTACKTOP) {
  400120:	8b 47 08             	mov    0x8(%edi),%eax
  400123:	89 45 e0             	mov    %eax,-0x20(%ebp)
  400126:	2d 00 00 80 00       	sub    $0x800000,%eax
  40012b:	3d 00 e0 2f 00       	cmp    $0x2fe000,%eax
  400130:	77 bd                	ja     4000ef <load_code+0x46>
		memset(virta, a, ph[i].p_memsz);
  400132:	83 ec 04             	sub    $0x4,%esp
  400135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  400138:	ff 70 14             	pushl  0x14(%eax)
  40013b:	6a 00                	push   $0x0
  40013d:	ff 75 e0             	pushl  -0x20(%ebp)
  400140:	e8 25 1b 00 00       	call   401c6a <memset>
		memcpy(virta, loca, ph[i].p_filesz);
  400145:	83 c4 0c             	add    $0xc,%esp
  400148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  40014b:	ff 70 10             	pushl  0x10(%eax)
		uint32_t fina = temp + ph[i].p_offset;
  40014e:	89 c2                	mov    %eax,%edx
  400150:	8b 45 08             	mov    0x8(%ebp),%eax
  400153:	03 42 04             	add    0x4(%edx),%eax
		memcpy(virta, loca, ph[i].p_filesz);
  400156:	50                   	push   %eax
  400157:	ff 75 e0             	pushl  -0x20(%ebp)
  40015a:	e8 c0 1b 00 00       	call   401d1f <memcpy>
  40015f:	83 c4 10             	add    $0x10,%esp
  400162:	eb a3                	jmp    400107 <load_code+0x5e>
	return (void (*)()) header->e_entry;
  400164:	8b 45 08             	mov    0x8(%ebp),%eax
  400167:	8b 40 18             	mov    0x18(%eax),%eax
}
  40016a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40016d:	5b                   	pop    %ebx
  40016e:	5e                   	pop    %esi
  40016f:	5f                   	pop    %edi
  400170:	5d                   	pop    %ebp
  400171:	c3                   	ret    

00400172 <i386_init>:
{
  400172:	55                   	push   %ebp
  400173:	89 e5                	mov    %esp,%ebp
  400175:	56                   	push   %esi
  400176:	53                   	push   %ebx
  400177:	e8 e7 00 00 00       	call   400263 <__x86.get_pc_thunk.bx>
  40017c:	81 c3 b8 51 01 00    	add    $0x151b8,%ebx
	memset(edata, 0, end - edata);
  400182:	83 ec 04             	sub    $0x4,%esp
  400185:	c7 c2 c0 70 41 00    	mov    $0x4170c0,%edx
  40018b:	c7 c0 a0 7f 41 00    	mov    $0x417fa0,%eax
  400191:	29 d0                	sub    %edx,%eax
  400193:	50                   	push   %eax
  400194:	6a 00                	push   $0x0
  400196:	52                   	push   %edx
  400197:	e8 ce 1a 00 00       	call   401c6a <memset>
	cons_init();
  40019c:	e8 17 05 00 00       	call   4006b8 <cons_init>
	cprintf(OS_START);
  4001a1:	8d 83 c4 cd fe ff    	lea    -0x1323c(%ebx),%eax
  4001a7:	89 04 24             	mov    %eax,(%esp)
  4001aa:	e8 4c 07 00 00       	call   4008fb <cprintf>
	env_init();
  4001af:	e8 55 06 00 00       	call   400809 <env_init>
	trap_init();
  4001b4:	e8 f5 07 00 00       	call   4009ae <trap_init>
	ide_read(2000, binary_to_load, MAX_RW);
  4001b9:	83 c4 0c             	add    $0xc,%esp
  4001bc:	68 ff 00 00 00       	push   $0xff
  4001c1:	c7 c6 e0 7f 41 00    	mov    $0x417fe0,%esi
  4001c7:	56                   	push   %esi
  4001c8:	68 d0 07 00 00       	push   $0x7d0
  4001cd:	e8 b2 10 00 00       	call   401284 <ide_read>
	if(header->e_magic == ELF_MAGIC) {
  4001d2:	83 c4 10             	add    $0x10,%esp
  4001d5:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  4001db:	74 26                	je     400203 <i386_init+0x91>
	void (*loaded_start_func)()  = load_code(binary_to_load);
  4001dd:	83 ec 0c             	sub    $0xc,%esp
  4001e0:	ff b3 fc ff ff ff    	pushl  -0x4(%ebx)
  4001e6:	e8 be fe ff ff       	call   4000a9 <load_code>
	initialize_new_trapframe(&nTrap, *loaded_start_func);
  4001eb:	83 c4 08             	add    $0x8,%esp
  4001ee:	50                   	push   %eax
  4001ef:	c7 c6 e0 7d 43 00    	mov    $0x437de0,%esi
  4001f5:	56                   	push   %esi
  4001f6:	e8 49 06 00 00       	call   400844 <initialize_new_trapframe>
	run_trapframe(&nTrap);
  4001fb:	89 34 24             	mov    %esi,(%esp)
  4001fe:	e8 6e 06 00 00       	call   400871 <run_trapframe>
		cprintf("I found the ELF header!");
  400203:	83 ec 0c             	sub    $0xc,%esp
  400206:	8d 83 d1 cd fe ff    	lea    -0x1322f(%ebx),%eax
  40020c:	50                   	push   %eax
  40020d:	e8 e9 06 00 00       	call   4008fb <cprintf>
  400212:	83 c4 10             	add    $0x10,%esp
  400215:	eb c6                	jmp    4001dd <i386_init+0x6b>

00400217 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
  400217:	55                   	push   %ebp
  400218:	89 e5                	mov    %esp,%ebp
  40021a:	56                   	push   %esi
  40021b:	53                   	push   %ebx
  40021c:	e8 42 00 00 00       	call   400263 <__x86.get_pc_thunk.bx>
  400221:	81 c3 13 51 01 00    	add    $0x15113,%ebx
	va_list ap;

	va_start(ap, fmt);
  400227:	8d 75 14             	lea    0x14(%ebp),%esi
	cprintf("kernel warning at %s:%d: ", file, line);
  40022a:	83 ec 04             	sub    $0x4,%esp
  40022d:	ff 75 0c             	pushl  0xc(%ebp)
  400230:	ff 75 08             	pushl  0x8(%ebp)
  400233:	8d 83 e9 cd fe ff    	lea    -0x13217(%ebx),%eax
  400239:	50                   	push   %eax
  40023a:	e8 bc 06 00 00       	call   4008fb <cprintf>
	vcprintf(fmt, ap);
  40023f:	83 c4 08             	add    $0x8,%esp
  400242:	56                   	push   %esi
  400243:	ff 75 10             	pushl  0x10(%ebp)
  400246:	e8 79 06 00 00       	call   4008c4 <vcprintf>
	cprintf("\n");
  40024b:	8d 83 cf cd fe ff    	lea    -0x13231(%ebx),%eax
  400251:	89 04 24             	mov    %eax,(%esp)
  400254:	e8 a2 06 00 00       	call   4008fb <cprintf>
	va_end(ap);
}
  400259:	83 c4 10             	add    $0x10,%esp
  40025c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  40025f:	5b                   	pop    %ebx
  400260:	5e                   	pop    %esi
  400261:	5d                   	pop    %ebp
  400262:	c3                   	ret    

00400263 <__x86.get_pc_thunk.bx>:
  400263:	8b 1c 24             	mov    (%esp),%ebx
  400266:	c3                   	ret    

00400267 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
  400267:	55                   	push   %ebp
  400268:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  40026a:	ba fd 03 00 00       	mov    $0x3fd,%edx
  40026f:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
  400270:	a8 01                	test   $0x1,%al
  400272:	74 0b                	je     40027f <serial_proc_data+0x18>
  400274:	ba f8 03 00 00       	mov    $0x3f8,%edx
  400279:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
  40027a:	0f b6 c0             	movzbl %al,%eax
}
  40027d:	5d                   	pop    %ebp
  40027e:	c3                   	ret    
		return -1;
  40027f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  400284:	eb f7                	jmp    40027d <serial_proc_data+0x16>

00400286 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
  400286:	55                   	push   %ebp
  400287:	89 e5                	mov    %esp,%ebp
  400289:	56                   	push   %esi
  40028a:	53                   	push   %ebx
  40028b:	e8 d3 ff ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  400290:	81 c3 a4 50 01 00    	add    $0x150a4,%ebx
  400296:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
  400298:	ff d6                	call   *%esi
  40029a:	83 f8 ff             	cmp    $0xffffffff,%eax
  40029d:	74 2e                	je     4002cd <cons_intr+0x47>
		if (c == 0)
  40029f:	85 c0                	test   %eax,%eax
  4002a1:	74 f5                	je     400298 <cons_intr+0x12>
			continue;
		cons.buf[cons.wpos++] = c;
  4002a3:	8b 8b b0 1f 00 00    	mov    0x1fb0(%ebx),%ecx
  4002a9:	8d 51 01             	lea    0x1(%ecx),%edx
  4002ac:	89 93 b0 1f 00 00    	mov    %edx,0x1fb0(%ebx)
  4002b2:	88 84 0b ac 1d 00 00 	mov    %al,0x1dac(%ebx,%ecx,1)
		if (cons.wpos == CONSBUFSIZE)
  4002b9:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  4002bf:	75 d7                	jne    400298 <cons_intr+0x12>
			cons.wpos = 0;
  4002c1:	c7 83 b0 1f 00 00 00 	movl   $0x0,0x1fb0(%ebx)
  4002c8:	00 00 00 
  4002cb:	eb cb                	jmp    400298 <cons_intr+0x12>
	}
}
  4002cd:	5b                   	pop    %ebx
  4002ce:	5e                   	pop    %esi
  4002cf:	5d                   	pop    %ebp
  4002d0:	c3                   	ret    

004002d1 <kbd_proc_data>:
{
  4002d1:	55                   	push   %ebp
  4002d2:	89 e5                	mov    %esp,%ebp
  4002d4:	56                   	push   %esi
  4002d5:	53                   	push   %ebx
  4002d6:	e8 88 ff ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  4002db:	81 c3 59 50 01 00    	add    $0x15059,%ebx
  4002e1:	ba 64 00 00 00       	mov    $0x64,%edx
  4002e6:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
  4002e7:	a8 01                	test   $0x1,%al
  4002e9:	0f 84 06 01 00 00    	je     4003f5 <kbd_proc_data+0x124>
	if (stat & KBS_TERR)
  4002ef:	a8 20                	test   $0x20,%al
  4002f1:	0f 85 05 01 00 00    	jne    4003fc <kbd_proc_data+0x12b>
  4002f7:	ba 60 00 00 00       	mov    $0x60,%edx
  4002fc:	ec                   	in     (%dx),%al
  4002fd:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
  4002ff:	3c e0                	cmp    $0xe0,%al
  400301:	0f 84 93 00 00 00    	je     40039a <kbd_proc_data+0xc9>
	} else if (data & 0x80) {
  400307:	84 c0                	test   %al,%al
  400309:	0f 88 a0 00 00 00    	js     4003af <kbd_proc_data+0xde>
	} else if (shift & E0ESC) {
  40030f:	8b 8b 8c 1d 00 00    	mov    0x1d8c(%ebx),%ecx
  400315:	f6 c1 40             	test   $0x40,%cl
  400318:	74 0e                	je     400328 <kbd_proc_data+0x57>
		data |= 0x80;
  40031a:	83 c8 80             	or     $0xffffff80,%eax
  40031d:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
  40031f:	83 e1 bf             	and    $0xffffffbf,%ecx
  400322:	89 8b 8c 1d 00 00    	mov    %ecx,0x1d8c(%ebx)
	shift |= shiftcode[data];
  400328:	0f b6 d2             	movzbl %dl,%edx
  40032b:	0f b6 84 13 6c cf fe 	movzbl -0x13094(%ebx,%edx,1),%eax
  400332:	ff 
  400333:	0b 83 8c 1d 00 00    	or     0x1d8c(%ebx),%eax
	shift ^= togglecode[data];
  400339:	0f b6 8c 13 6c ce fe 	movzbl -0x13194(%ebx,%edx,1),%ecx
  400340:	ff 
  400341:	31 c8                	xor    %ecx,%eax
  400343:	89 83 8c 1d 00 00    	mov    %eax,0x1d8c(%ebx)
	c = charcode[shift & (CTL | SHIFT)][data];
  400349:	89 c1                	mov    %eax,%ecx
  40034b:	83 e1 03             	and    $0x3,%ecx
  40034e:	8b 8c 8b ec 1c 00 00 	mov    0x1cec(%ebx,%ecx,4),%ecx
  400355:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
  400359:	0f b6 f2             	movzbl %dl,%esi
	if (shift & CAPSLOCK) {
  40035c:	a8 08                	test   $0x8,%al
  40035e:	74 0d                	je     40036d <kbd_proc_data+0x9c>
		if ('a' <= c && c <= 'z')
  400360:	89 f2                	mov    %esi,%edx
  400362:	8d 4e 9f             	lea    -0x61(%esi),%ecx
  400365:	83 f9 19             	cmp    $0x19,%ecx
  400368:	77 7a                	ja     4003e4 <kbd_proc_data+0x113>
			c += 'A' - 'a';
  40036a:	83 ee 20             	sub    $0x20,%esi
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  40036d:	f7 d0                	not    %eax
  40036f:	a8 06                	test   $0x6,%al
  400371:	75 33                	jne    4003a6 <kbd_proc_data+0xd5>
  400373:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
  400379:	75 2b                	jne    4003a6 <kbd_proc_data+0xd5>
		cprintf("Rebooting!\n");
  40037b:	83 ec 0c             	sub    $0xc,%esp
  40037e:	8d 83 3a ce fe ff    	lea    -0x131c6(%ebx),%eax
  400384:	50                   	push   %eax
  400385:	e8 71 05 00 00       	call   4008fb <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  40038a:	b8 03 00 00 00       	mov    $0x3,%eax
  40038f:	ba 92 00 00 00       	mov    $0x92,%edx
  400394:	ee                   	out    %al,(%dx)
  400395:	83 c4 10             	add    $0x10,%esp
  400398:	eb 0c                	jmp    4003a6 <kbd_proc_data+0xd5>
		shift |= E0ESC;
  40039a:	83 8b 8c 1d 00 00 40 	orl    $0x40,0x1d8c(%ebx)
		return 0;
  4003a1:	be 00 00 00 00       	mov    $0x0,%esi
}
  4003a6:	89 f0                	mov    %esi,%eax
  4003a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  4003ab:	5b                   	pop    %ebx
  4003ac:	5e                   	pop    %esi
  4003ad:	5d                   	pop    %ebp
  4003ae:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
  4003af:	8b 8b 8c 1d 00 00    	mov    0x1d8c(%ebx),%ecx
  4003b5:	89 ce                	mov    %ecx,%esi
  4003b7:	83 e6 40             	and    $0x40,%esi
  4003ba:	83 e0 7f             	and    $0x7f,%eax
  4003bd:	85 f6                	test   %esi,%esi
  4003bf:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
  4003c2:	0f b6 d2             	movzbl %dl,%edx
  4003c5:	0f b6 84 13 6c cf fe 	movzbl -0x13094(%ebx,%edx,1),%eax
  4003cc:	ff 
  4003cd:	83 c8 40             	or     $0x40,%eax
  4003d0:	0f b6 c0             	movzbl %al,%eax
  4003d3:	f7 d0                	not    %eax
  4003d5:	21 c8                	and    %ecx,%eax
  4003d7:	89 83 8c 1d 00 00    	mov    %eax,0x1d8c(%ebx)
		return 0;
  4003dd:	be 00 00 00 00       	mov    $0x0,%esi
  4003e2:	eb c2                	jmp    4003a6 <kbd_proc_data+0xd5>
		else if ('A' <= c && c <= 'Z')
  4003e4:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
  4003e7:	8d 4e 20             	lea    0x20(%esi),%ecx
  4003ea:	83 fa 1a             	cmp    $0x1a,%edx
  4003ed:	0f 42 f1             	cmovb  %ecx,%esi
  4003f0:	e9 78 ff ff ff       	jmp    40036d <kbd_proc_data+0x9c>
		return -1;
  4003f5:	be ff ff ff ff       	mov    $0xffffffff,%esi
  4003fa:	eb aa                	jmp    4003a6 <kbd_proc_data+0xd5>
		return -1;
  4003fc:	be ff ff ff ff       	mov    $0xffffffff,%esi
  400401:	eb a3                	jmp    4003a6 <kbd_proc_data+0xd5>

00400403 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
  400403:	55                   	push   %ebp
  400404:	89 e5                	mov    %esp,%ebp
  400406:	57                   	push   %edi
  400407:	56                   	push   %esi
  400408:	53                   	push   %ebx
  400409:	83 ec 1c             	sub    $0x1c,%esp
  40040c:	e8 52 fe ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  400411:	81 c3 23 4f 01 00    	add    $0x14f23,%ebx
  400417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0;
  40041a:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  40041f:	bf fd 03 00 00       	mov    $0x3fd,%edi
  400424:	b9 84 00 00 00       	mov    $0x84,%ecx
  400429:	eb 09                	jmp    400434 <cons_putc+0x31>
  40042b:	89 ca                	mov    %ecx,%edx
  40042d:	ec                   	in     (%dx),%al
  40042e:	ec                   	in     (%dx),%al
  40042f:	ec                   	in     (%dx),%al
  400430:	ec                   	in     (%dx),%al
	     i++)
  400431:	83 c6 01             	add    $0x1,%esi
  400434:	89 fa                	mov    %edi,%edx
  400436:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  400437:	a8 20                	test   $0x20,%al
  400439:	75 08                	jne    400443 <cons_putc+0x40>
  40043b:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  400441:	7e e8                	jle    40042b <cons_putc+0x28>
	outb(COM1 + COM_TX, c);
  400443:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  400446:	89 f8                	mov    %edi,%eax
  400448:	88 45 e3             	mov    %al,-0x1d(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  40044b:	ba f8 03 00 00       	mov    $0x3f8,%edx
  400450:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
  400451:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  400456:	bf 79 03 00 00       	mov    $0x379,%edi
  40045b:	b9 84 00 00 00       	mov    $0x84,%ecx
  400460:	eb 09                	jmp    40046b <cons_putc+0x68>
  400462:	89 ca                	mov    %ecx,%edx
  400464:	ec                   	in     (%dx),%al
  400465:	ec                   	in     (%dx),%al
  400466:	ec                   	in     (%dx),%al
  400467:	ec                   	in     (%dx),%al
  400468:	83 c6 01             	add    $0x1,%esi
  40046b:	89 fa                	mov    %edi,%edx
  40046d:	ec                   	in     (%dx),%al
  40046e:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  400474:	7f 04                	jg     40047a <cons_putc+0x77>
  400476:	84 c0                	test   %al,%al
  400478:	79 e8                	jns    400462 <cons_putc+0x5f>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  40047a:	ba 78 03 00 00       	mov    $0x378,%edx
  40047f:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  400483:	ee                   	out    %al,(%dx)
  400484:	ba 7a 03 00 00       	mov    $0x37a,%edx
  400489:	b8 0d 00 00 00       	mov    $0xd,%eax
  40048e:	ee                   	out    %al,(%dx)
  40048f:	b8 08 00 00 00       	mov    $0x8,%eax
  400494:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
  400495:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  400498:	89 fa                	mov    %edi,%edx
  40049a:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
  4004a0:	89 f8                	mov    %edi,%eax
  4004a2:	80 cc 07             	or     $0x7,%ah
  4004a5:	85 d2                	test   %edx,%edx
  4004a7:	0f 45 c7             	cmovne %edi,%eax
  4004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	switch (c & 0xff) {
  4004ad:	0f b6 c0             	movzbl %al,%eax
  4004b0:	83 f8 09             	cmp    $0x9,%eax
  4004b3:	0f 84 b9 00 00 00    	je     400572 <cons_putc+0x16f>
  4004b9:	83 f8 09             	cmp    $0x9,%eax
  4004bc:	7e 74                	jle    400532 <cons_putc+0x12f>
  4004be:	83 f8 0a             	cmp    $0xa,%eax
  4004c1:	0f 84 9e 00 00 00    	je     400565 <cons_putc+0x162>
  4004c7:	83 f8 0d             	cmp    $0xd,%eax
  4004ca:	0f 85 d9 00 00 00    	jne    4005a9 <cons_putc+0x1a6>
		crt_pos -= (crt_pos % CRT_COLS);
  4004d0:	0f b7 83 b4 1f 00 00 	movzwl 0x1fb4(%ebx),%eax
  4004d7:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  4004dd:	c1 e8 16             	shr    $0x16,%eax
  4004e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  4004e3:	c1 e0 04             	shl    $0x4,%eax
  4004e6:	66 89 83 b4 1f 00 00 	mov    %ax,0x1fb4(%ebx)
	if (crt_pos >= CRT_SIZE) {
  4004ed:	66 81 bb b4 1f 00 00 	cmpw   $0x7cf,0x1fb4(%ebx)
  4004f4:	cf 07 
  4004f6:	0f 87 d4 00 00 00    	ja     4005d0 <cons_putc+0x1cd>
	outb(addr_6845, 14);
  4004fc:	8b 8b bc 1f 00 00    	mov    0x1fbc(%ebx),%ecx
  400502:	b8 0e 00 00 00       	mov    $0xe,%eax
  400507:	89 ca                	mov    %ecx,%edx
  400509:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
  40050a:	0f b7 9b b4 1f 00 00 	movzwl 0x1fb4(%ebx),%ebx
  400511:	8d 71 01             	lea    0x1(%ecx),%esi
  400514:	89 d8                	mov    %ebx,%eax
  400516:	66 c1 e8 08          	shr    $0x8,%ax
  40051a:	89 f2                	mov    %esi,%edx
  40051c:	ee                   	out    %al,(%dx)
  40051d:	b8 0f 00 00 00       	mov    $0xf,%eax
  400522:	89 ca                	mov    %ecx,%edx
  400524:	ee                   	out    %al,(%dx)
  400525:	89 d8                	mov    %ebx,%eax
  400527:	89 f2                	mov    %esi,%edx
  400529:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
  40052a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40052d:	5b                   	pop    %ebx
  40052e:	5e                   	pop    %esi
  40052f:	5f                   	pop    %edi
  400530:	5d                   	pop    %ebp
  400531:	c3                   	ret    
	switch (c & 0xff) {
  400532:	83 f8 08             	cmp    $0x8,%eax
  400535:	75 72                	jne    4005a9 <cons_putc+0x1a6>
		if (crt_pos > 0) {
  400537:	0f b7 83 b4 1f 00 00 	movzwl 0x1fb4(%ebx),%eax
  40053e:	66 85 c0             	test   %ax,%ax
  400541:	74 b9                	je     4004fc <cons_putc+0xf9>
			crt_pos--;
  400543:	83 e8 01             	sub    $0x1,%eax
  400546:	66 89 83 b4 1f 00 00 	mov    %ax,0x1fb4(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
  40054d:	0f b7 c0             	movzwl %ax,%eax
  400550:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  400554:	b2 00                	mov    $0x0,%dl
  400556:	83 ca 20             	or     $0x20,%edx
  400559:	8b 8b b8 1f 00 00    	mov    0x1fb8(%ebx),%ecx
  40055f:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
  400563:	eb 88                	jmp    4004ed <cons_putc+0xea>
		crt_pos += CRT_COLS;
  400565:	66 83 83 b4 1f 00 00 	addw   $0x50,0x1fb4(%ebx)
  40056c:	50 
  40056d:	e9 5e ff ff ff       	jmp    4004d0 <cons_putc+0xcd>
		cons_putc(' ');
  400572:	b8 20 00 00 00       	mov    $0x20,%eax
  400577:	e8 87 fe ff ff       	call   400403 <cons_putc>
		cons_putc(' ');
  40057c:	b8 20 00 00 00       	mov    $0x20,%eax
  400581:	e8 7d fe ff ff       	call   400403 <cons_putc>
		cons_putc(' ');
  400586:	b8 20 00 00 00       	mov    $0x20,%eax
  40058b:	e8 73 fe ff ff       	call   400403 <cons_putc>
		cons_putc(' ');
  400590:	b8 20 00 00 00       	mov    $0x20,%eax
  400595:	e8 69 fe ff ff       	call   400403 <cons_putc>
		cons_putc(' ');
  40059a:	b8 20 00 00 00       	mov    $0x20,%eax
  40059f:	e8 5f fe ff ff       	call   400403 <cons_putc>
  4005a4:	e9 44 ff ff ff       	jmp    4004ed <cons_putc+0xea>
		crt_buf[crt_pos++] = c;		/* write the character */
  4005a9:	0f b7 83 b4 1f 00 00 	movzwl 0x1fb4(%ebx),%eax
  4005b0:	8d 50 01             	lea    0x1(%eax),%edx
  4005b3:	66 89 93 b4 1f 00 00 	mov    %dx,0x1fb4(%ebx)
  4005ba:	0f b7 c0             	movzwl %ax,%eax
  4005bd:	8b 93 b8 1f 00 00    	mov    0x1fb8(%ebx),%edx
  4005c3:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
  4005c7:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
  4005cb:	e9 1d ff ff ff       	jmp    4004ed <cons_putc+0xea>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  4005d0:	8b 83 b8 1f 00 00    	mov    0x1fb8(%ebx),%eax
  4005d6:	83 ec 04             	sub    $0x4,%esp
  4005d9:	68 00 0f 00 00       	push   $0xf00
  4005de:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  4005e4:	52                   	push   %edx
  4005e5:	50                   	push   %eax
  4005e6:	e8 cc 16 00 00       	call   401cb7 <memmove>
			crt_buf[i] = 0x0700 | ' ';
  4005eb:	8b 93 b8 1f 00 00    	mov    0x1fb8(%ebx),%edx
  4005f1:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
  4005f7:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
  4005fd:	83 c4 10             	add    $0x10,%esp
  400600:	66 c7 00 20 07       	movw   $0x720,(%eax)
  400605:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  400608:	39 d0                	cmp    %edx,%eax
  40060a:	75 f4                	jne    400600 <cons_putc+0x1fd>
		crt_pos -= CRT_COLS;
  40060c:	66 83 ab b4 1f 00 00 	subw   $0x50,0x1fb4(%ebx)
  400613:	50 
  400614:	e9 e3 fe ff ff       	jmp    4004fc <cons_putc+0xf9>

00400619 <serial_intr>:
{
  400619:	e8 e7 01 00 00       	call   400805 <__x86.get_pc_thunk.ax>
  40061e:	05 16 4d 01 00       	add    $0x14d16,%eax
	if (serial_exists)
  400623:	80 b8 c0 1f 00 00 00 	cmpb   $0x0,0x1fc0(%eax)
  40062a:	75 02                	jne    40062e <serial_intr+0x15>
  40062c:	f3 c3                	repz ret 
{
  40062e:	55                   	push   %ebp
  40062f:	89 e5                	mov    %esp,%ebp
  400631:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
  400634:	8d 80 33 af fe ff    	lea    -0x150cd(%eax),%eax
  40063a:	e8 47 fc ff ff       	call   400286 <cons_intr>
}
  40063f:	c9                   	leave  
  400640:	c3                   	ret    

00400641 <kbd_intr>:
{
  400641:	55                   	push   %ebp
  400642:	89 e5                	mov    %esp,%ebp
  400644:	83 ec 08             	sub    $0x8,%esp
  400647:	e8 b9 01 00 00       	call   400805 <__x86.get_pc_thunk.ax>
  40064c:	05 e8 4c 01 00       	add    $0x14ce8,%eax
	cons_intr(kbd_proc_data);
  400651:	8d 80 9d af fe ff    	lea    -0x15063(%eax),%eax
  400657:	e8 2a fc ff ff       	call   400286 <cons_intr>
}
  40065c:	c9                   	leave  
  40065d:	c3                   	ret    

0040065e <cons_getc>:
{
  40065e:	55                   	push   %ebp
  40065f:	89 e5                	mov    %esp,%ebp
  400661:	53                   	push   %ebx
  400662:	83 ec 04             	sub    $0x4,%esp
  400665:	e8 f9 fb ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  40066a:	81 c3 ca 4c 01 00    	add    $0x14cca,%ebx
	serial_intr();
  400670:	e8 a4 ff ff ff       	call   400619 <serial_intr>
	kbd_intr();
  400675:	e8 c7 ff ff ff       	call   400641 <kbd_intr>
	if (cons.rpos != cons.wpos) {
  40067a:	8b 93 ac 1f 00 00    	mov    0x1fac(%ebx),%edx
	return 0;
  400680:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
  400685:	3b 93 b0 1f 00 00    	cmp    0x1fb0(%ebx),%edx
  40068b:	74 19                	je     4006a6 <cons_getc+0x48>
		c = cons.buf[cons.rpos++];
  40068d:	8d 4a 01             	lea    0x1(%edx),%ecx
  400690:	89 8b ac 1f 00 00    	mov    %ecx,0x1fac(%ebx)
  400696:	0f b6 84 13 ac 1d 00 	movzbl 0x1dac(%ebx,%edx,1),%eax
  40069d:	00 
		if (cons.rpos == CONSBUFSIZE)
  40069e:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  4006a4:	74 06                	je     4006ac <cons_getc+0x4e>
}
  4006a6:	83 c4 04             	add    $0x4,%esp
  4006a9:	5b                   	pop    %ebx
  4006aa:	5d                   	pop    %ebp
  4006ab:	c3                   	ret    
			cons.rpos = 0;
  4006ac:	c7 83 ac 1f 00 00 00 	movl   $0x0,0x1fac(%ebx)
  4006b3:	00 00 00 
  4006b6:	eb ee                	jmp    4006a6 <cons_getc+0x48>

004006b8 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
  4006b8:	55                   	push   %ebp
  4006b9:	89 e5                	mov    %esp,%ebp
  4006bb:	57                   	push   %edi
  4006bc:	56                   	push   %esi
  4006bd:	53                   	push   %ebx
  4006be:	83 ec 1c             	sub    $0x1c,%esp
  4006c1:	e8 9d fb ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  4006c6:	81 c3 6e 4c 01 00    	add    $0x14c6e,%ebx
	was = *cp;
  4006cc:	0f b7 15 00 80 0b 00 	movzwl 0xb8000,%edx
	*cp = (uint16_t) 0xA55A;
  4006d3:	66 c7 05 00 80 0b 00 	movw   $0xa55a,0xb8000
  4006da:	5a a5 
	if (*cp != 0xA55A) {
  4006dc:	0f b7 05 00 80 0b 00 	movzwl 0xb8000,%eax
  4006e3:	66 3d 5a a5          	cmp    $0xa55a,%ax
  4006e7:	0f 84 bc 00 00 00    	je     4007a9 <cons_init+0xf1>
		addr_6845 = MONO_BASE;
  4006ed:	c7 83 bc 1f 00 00 b4 	movl   $0x3b4,0x1fbc(%ebx)
  4006f4:	03 00 00 
		cp = (uint16_t*) MONO_BUF;
  4006f7:	c7 45 e4 00 00 0b 00 	movl   $0xb0000,-0x1c(%ebp)
	outb(addr_6845, 14);
  4006fe:	8b bb bc 1f 00 00    	mov    0x1fbc(%ebx),%edi
  400704:	b8 0e 00 00 00       	mov    $0xe,%eax
  400709:	89 fa                	mov    %edi,%edx
  40070b:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
  40070c:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  40070f:	89 ca                	mov    %ecx,%edx
  400711:	ec                   	in     (%dx),%al
  400712:	0f b6 f0             	movzbl %al,%esi
  400715:	c1 e6 08             	shl    $0x8,%esi
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  400718:	b8 0f 00 00 00       	mov    $0xf,%eax
  40071d:	89 fa                	mov    %edi,%edx
  40071f:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  400720:	89 ca                	mov    %ecx,%edx
  400722:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
  400723:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  400726:	89 bb b8 1f 00 00    	mov    %edi,0x1fb8(%ebx)
	pos |= inb(addr_6845 + 1);
  40072c:	0f b6 c0             	movzbl %al,%eax
  40072f:	09 c6                	or     %eax,%esi
	crt_pos = pos;
  400731:	66 89 b3 b4 1f 00 00 	mov    %si,0x1fb4(%ebx)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  400738:	b9 00 00 00 00       	mov    $0x0,%ecx
  40073d:	89 c8                	mov    %ecx,%eax
  40073f:	ba fa 03 00 00       	mov    $0x3fa,%edx
  400744:	ee                   	out    %al,(%dx)
  400745:	bf fb 03 00 00       	mov    $0x3fb,%edi
  40074a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  40074f:	89 fa                	mov    %edi,%edx
  400751:	ee                   	out    %al,(%dx)
  400752:	b8 0c 00 00 00       	mov    $0xc,%eax
  400757:	ba f8 03 00 00       	mov    $0x3f8,%edx
  40075c:	ee                   	out    %al,(%dx)
  40075d:	be f9 03 00 00       	mov    $0x3f9,%esi
  400762:	89 c8                	mov    %ecx,%eax
  400764:	89 f2                	mov    %esi,%edx
  400766:	ee                   	out    %al,(%dx)
  400767:	b8 03 00 00 00       	mov    $0x3,%eax
  40076c:	89 fa                	mov    %edi,%edx
  40076e:	ee                   	out    %al,(%dx)
  40076f:	ba fc 03 00 00       	mov    $0x3fc,%edx
  400774:	89 c8                	mov    %ecx,%eax
  400776:	ee                   	out    %al,(%dx)
  400777:	b8 01 00 00 00       	mov    $0x1,%eax
  40077c:	89 f2                	mov    %esi,%edx
  40077e:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  40077f:	ba fd 03 00 00       	mov    $0x3fd,%edx
  400784:	ec                   	in     (%dx),%al
  400785:	89 c1                	mov    %eax,%ecx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
  400787:	3c ff                	cmp    $0xff,%al
  400789:	0f 95 83 c0 1f 00 00 	setne  0x1fc0(%ebx)
  400790:	ba fa 03 00 00       	mov    $0x3fa,%edx
  400795:	ec                   	in     (%dx),%al
  400796:	ba f8 03 00 00       	mov    $0x3f8,%edx
  40079b:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
  40079c:	80 f9 ff             	cmp    $0xff,%cl
  40079f:	74 25                	je     4007c6 <cons_init+0x10e>
		cprintf("Serial port does not exist!\n");
}
  4007a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  4007a4:	5b                   	pop    %ebx
  4007a5:	5e                   	pop    %esi
  4007a6:	5f                   	pop    %edi
  4007a7:	5d                   	pop    %ebp
  4007a8:	c3                   	ret    
		*cp = was;
  4007a9:	66 89 15 00 80 0b 00 	mov    %dx,0xb8000
		addr_6845 = CGA_BASE;
  4007b0:	c7 83 bc 1f 00 00 d4 	movl   $0x3d4,0x1fbc(%ebx)
  4007b7:	03 00 00 
	cp = (uint16_t*) CGA_BUF;
  4007ba:	c7 45 e4 00 80 0b 00 	movl   $0xb8000,-0x1c(%ebp)
  4007c1:	e9 38 ff ff ff       	jmp    4006fe <cons_init+0x46>
		cprintf("Serial port does not exist!\n");
  4007c6:	83 ec 0c             	sub    $0xc,%esp
  4007c9:	8d 83 46 ce fe ff    	lea    -0x131ba(%ebx),%eax
  4007cf:	50                   	push   %eax
  4007d0:	e8 26 01 00 00       	call   4008fb <cprintf>
  4007d5:	83 c4 10             	add    $0x10,%esp
}
  4007d8:	eb c7                	jmp    4007a1 <cons_init+0xe9>

004007da <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
  4007da:	55                   	push   %ebp
  4007db:	89 e5                	mov    %esp,%ebp
  4007dd:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
  4007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  4007e3:	e8 1b fc ff ff       	call   400403 <cons_putc>
}
  4007e8:	c9                   	leave  
  4007e9:	c3                   	ret    

004007ea <getchar>:

int
getchar(void)
{
  4007ea:	55                   	push   %ebp
  4007eb:	89 e5                	mov    %esp,%ebp
  4007ed:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
  4007f0:	e8 69 fe ff ff       	call   40065e <cons_getc>
  4007f5:	85 c0                	test   %eax,%eax
  4007f7:	74 f7                	je     4007f0 <getchar+0x6>
		/* do nothing */;
	return c;
}
  4007f9:	c9                   	leave  
  4007fa:	c3                   	ret    

004007fb <iscons>:

int
iscons(int fdnum)
{
  4007fb:	55                   	push   %ebp
  4007fc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
  4007fe:	b8 01 00 00 00       	mov    $0x1,%eax
  400803:	5d                   	pop    %ebp
  400804:	c3                   	ret    

00400805 <__x86.get_pc_thunk.ax>:
  400805:	8b 04 24             	mov    (%esp),%eax
  400808:	c3                   	ret    

00400809 <env_init>:
};


void
env_init(void)
{
  400809:	55                   	push   %ebp
  40080a:	89 e5                	mov    %esp,%ebp
  40080c:	e8 f4 ff ff ff       	call   400805 <__x86.get_pc_thunk.ax>
  400811:	05 23 4b 01 00       	add    $0x14b23,%eax
}

static inline void
lgdt(void *p)
{
	asm volatile("lgdt (%0)" : : "r" (p));
  400816:	8d 80 cc 1c 00 00    	lea    0x1ccc(%eax),%eax
  40081c:	0f 01 10             	lgdtl  (%eax)
	
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
  40081f:	b8 23 00 00 00       	mov    $0x23,%eax
  400824:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
  400826:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
  400828:	b8 10 00 00 00       	mov    $0x10,%eax
  40082d:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
  40082f:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
  400831:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
  400833:	ea 3a 08 40 00 08 00 	ljmp   $0x8,$0x40083a
}

static inline void
lldt(uint16_t sel)
{
	asm volatile("lldt %0" : : "r" (sel));
  40083a:	b8 00 00 00 00       	mov    $0x0,%eax
  40083f:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
  400842:	5d                   	pop    %ebp
  400843:	c3                   	ret    

00400844 <initialize_new_trapframe>:


void initialize_new_trapframe(struct Trapframe *tf, void (*entry_point)()) {
  400844:	55                   	push   %ebp
  400845:	89 e5                	mov    %esp,%ebp
  400847:	8b 45 08             	mov    0x8(%ebp),%eax

	// set the stack to the universal stack top
	tf->tf_esp = USTACKTOP;
  40084a:	c7 40 3c 00 e0 af 00 	movl   $0xafe000,0x3c(%eax)
	
	// Set all the segment registers so that this code runs in
	// user rather than kernel mode
	tf->tf_ds = GD_UD | 3;
  400851:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
	tf->tf_es = GD_UD | 3;
  400857:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
	tf->tf_ss = GD_UD | 3;
  40085d:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
	tf->tf_cs = GD_UT | 3;
  400863:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)

	// Set the instruction pointer to the entry point
	tf->tf_eip = (uintptr_t) entry_point;
  400869:	8b 55 0c             	mov    0xc(%ebp),%edx
  40086c:	89 50 30             	mov    %edx,0x30(%eax)
}
  40086f:	5d                   	pop    %ebp
  400870:	c3                   	ret    

00400871 <run_trapframe>:
//
// This function does not return.
//
void
run_trapframe(struct Trapframe *tf)
{
  400871:	55                   	push   %ebp
  400872:	89 e5                	mov    %esp,%ebp
  400874:	53                   	push   %ebx
  400875:	83 ec 08             	sub    $0x8,%esp
  400878:	e8 e6 f9 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  40087d:	81 c3 b7 4a 01 00    	add    $0x14ab7,%ebx
	asm volatile(
  400883:	8b 65 08             	mov    0x8(%ebp),%esp
  400886:	61                   	popa   
  400887:	07                   	pop    %es
  400888:	1f                   	pop    %ds
  400889:	83 c4 08             	add    $0x8,%esp
  40088c:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
  40088d:	8d 83 6c d0 fe ff    	lea    -0x12f94(%ebx),%eax
  400893:	50                   	push   %eax
  400894:	6a 71                	push   $0x71
  400896:	8d 83 78 d0 fe ff    	lea    -0x12f88(%ebx),%eax
  40089c:	50                   	push   %eax
  40089d:	e8 9e f7 ff ff       	call   400040 <_panic>

004008a2 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
  4008a2:	55                   	push   %ebp
  4008a3:	89 e5                	mov    %esp,%ebp
  4008a5:	53                   	push   %ebx
  4008a6:	83 ec 10             	sub    $0x10,%esp
  4008a9:	e8 b5 f9 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  4008ae:	81 c3 86 4a 01 00    	add    $0x14a86,%ebx
	cputchar(ch);
  4008b4:	ff 75 08             	pushl  0x8(%ebp)
  4008b7:	e8 1e ff ff ff       	call   4007da <cputchar>
	*cnt++;
}
  4008bc:	83 c4 10             	add    $0x10,%esp
  4008bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4008c2:	c9                   	leave  
  4008c3:	c3                   	ret    

004008c4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  4008c4:	55                   	push   %ebp
  4008c5:	89 e5                	mov    %esp,%ebp
  4008c7:	53                   	push   %ebx
  4008c8:	83 ec 14             	sub    $0x14,%esp
  4008cb:	e8 93 f9 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  4008d0:	81 c3 64 4a 01 00    	add    $0x14a64,%ebx
	int cnt = 0;
  4008d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
  4008dd:	ff 75 0c             	pushl  0xc(%ebp)
  4008e0:	ff 75 08             	pushl  0x8(%ebp)
  4008e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  4008e6:	50                   	push   %eax
  4008e7:	8d 83 6e b5 fe ff    	lea    -0x14a92(%ebx),%eax
  4008ed:	50                   	push   %eax
  4008ee:	e8 27 0c 00 00       	call   40151a <vprintfmt>
	return cnt;
}
  4008f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4008f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4008f9:	c9                   	leave  
  4008fa:	c3                   	ret    

004008fb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  4008fb:	55                   	push   %ebp
  4008fc:	89 e5                	mov    %esp,%ebp
  4008fe:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  400901:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  400904:	50                   	push   %eax
  400905:	ff 75 08             	pushl  0x8(%ebp)
  400908:	e8 b7 ff ff ff       	call   4008c4 <vcprintf>
	va_end(ap);

	return cnt;
}
  40090d:	c9                   	leave  
  40090e:	c3                   	ret    

0040090f <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
  40090f:	55                   	push   %ebp
  400910:	89 e5                	mov    %esp,%ebp
  400912:	57                   	push   %edi
  400913:	56                   	push   %esi
  400914:	53                   	push   %ebx
  400915:	83 ec 04             	sub    $0x4,%esp
  400918:	e8 46 f9 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  40091d:	81 c3 17 4a 01 00    	add    $0x14a17,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
  400923:	c7 83 f0 27 00 00 00 	movl   $0x400000,0x27f0(%ebx)
  40092a:	00 40 00 
	ts.ts_ss0 = GD_KD;
  40092d:	66 c7 83 f4 27 00 00 	movw   $0x10,0x27f4(%ebx)
  400934:	10 00 
	ts.ts_iomb = sizeof(struct Taskstate);
  400936:	66 c7 83 52 28 00 00 	movw   $0x68,0x2852(%ebx)
  40093d:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
  40093f:	c7 c0 00 53 41 00    	mov    $0x415300,%eax
  400945:	66 c7 40 28 67 00    	movw   $0x67,0x28(%eax)
  40094b:	8d b3 ec 27 00 00    	lea    0x27ec(%ebx),%esi
  400951:	66 89 70 2a          	mov    %si,0x2a(%eax)
  400955:	89 f2                	mov    %esi,%edx
  400957:	c1 ea 10             	shr    $0x10,%edx
  40095a:	88 50 2c             	mov    %dl,0x2c(%eax)
  40095d:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
  400961:	83 e2 f0             	and    $0xfffffff0,%edx
  400964:	83 ca 09             	or     $0x9,%edx
  400967:	83 e2 9f             	and    $0xffffff9f,%edx
  40096a:	83 ca 80             	or     $0xffffff80,%edx
  40096d:	88 55 f3             	mov    %dl,-0xd(%ebp)
  400970:	88 50 2d             	mov    %dl,0x2d(%eax)
  400973:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
  400977:	83 e1 c0             	and    $0xffffffc0,%ecx
  40097a:	83 c9 40             	or     $0x40,%ecx
  40097d:	83 e1 7f             	and    $0x7f,%ecx
  400980:	88 48 2e             	mov    %cl,0x2e(%eax)
  400983:	c1 ee 18             	shr    $0x18,%esi
  400986:	89 f1                	mov    %esi,%ecx
  400988:	88 48 2f             	mov    %cl,0x2f(%eax)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;
  40098b:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
  40098f:	83 e2 ef             	and    $0xffffffef,%edx
  400992:	88 50 2d             	mov    %dl,0x2d(%eax)
}

static inline void
ltr(uint16_t sel)
{
	asm volatile("ltr %0" : : "r" (sel));
  400995:	b8 28 00 00 00       	mov    $0x28,%eax
  40099a:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
  40099d:	8d 83 d4 1c 00 00    	lea    0x1cd4(%ebx),%eax
  4009a3:	0f 01 18             	lidtl  (%eax)
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}
  4009a6:	83 c4 04             	add    $0x4,%esp
  4009a9:	5b                   	pop    %ebx
  4009aa:	5e                   	pop    %esi
  4009ab:	5f                   	pop    %edi
  4009ac:	5d                   	pop    %ebp
  4009ad:	c3                   	ret    

004009ae <trap_init>:
{
  4009ae:	55                   	push   %ebp
  4009af:	89 e5                	mov    %esp,%ebp
  4009b1:	56                   	push   %esi
  4009b2:	53                   	push   %ebx
  4009b3:	e8 88 07 00 00       	call   401140 <__x86.get_pc_thunk.dx>
  4009b8:	81 c2 7c 49 01 00    	add    $0x1497c,%edx
		SETGATE(idt[i], 0, GD_KT, unktraphandler, 0);
  4009be:	c7 c3 44 11 40 00    	mov    $0x401144,%ebx
  4009c4:	c1 eb 10             	shr    $0x10,%ebx
	for(int i = 0; i <= 255; i++) {
  4009c7:	b8 00 00 00 00       	mov    $0x0,%eax
		SETGATE(idt[i], 0, GD_KT, unktraphandler, 0);
  4009cc:	c7 c6 44 11 40 00    	mov    $0x401144,%esi
  4009d2:	66 89 b4 c2 cc 1f 00 	mov    %si,0x1fcc(%edx,%eax,8)
  4009d9:	00 
  4009da:	8d 8c c2 cc 1f 00 00 	lea    0x1fcc(%edx,%eax,8),%ecx
  4009e1:	66 c7 41 02 08 00    	movw   $0x8,0x2(%ecx)
  4009e7:	c6 84 c2 d0 1f 00 00 	movb   $0x0,0x1fd0(%edx,%eax,8)
  4009ee:	00 
  4009ef:	c6 84 c2 d1 1f 00 00 	movb   $0x8e,0x1fd1(%edx,%eax,8)
  4009f6:	8e 
  4009f7:	66 89 59 06          	mov    %bx,0x6(%ecx)
	for(int i = 0; i <= 255; i++) {
  4009fb:	83 c0 01             	add    $0x1,%eax
  4009fe:	3d 00 01 00 00       	cmp    $0x100,%eax
  400a03:	75 cd                	jne    4009d2 <trap_init+0x24>
	SETGATE(idt[0], 0, GD_KT, th0, 0);
  400a05:	c7 c0 4a 11 40 00    	mov    $0x40114a,%eax
  400a0b:	66 89 82 cc 1f 00 00 	mov    %ax,0x1fcc(%edx)
  400a12:	66 c7 82 ce 1f 00 00 	movw   $0x8,0x1fce(%edx)
  400a19:	08 00 
  400a1b:	c6 82 d0 1f 00 00 00 	movb   $0x0,0x1fd0(%edx)
  400a22:	c6 82 d1 1f 00 00 8e 	movb   $0x8e,0x1fd1(%edx)
  400a29:	c1 e8 10             	shr    $0x10,%eax
  400a2c:	66 89 82 d2 1f 00 00 	mov    %ax,0x1fd2(%edx)
	SETGATE(idt[1], 0, GD_KT, th1, 0);
  400a33:	c7 c0 50 11 40 00    	mov    $0x401150,%eax
  400a39:	66 89 82 d4 1f 00 00 	mov    %ax,0x1fd4(%edx)
  400a40:	66 c7 82 d6 1f 00 00 	movw   $0x8,0x1fd6(%edx)
  400a47:	08 00 
  400a49:	c6 82 d8 1f 00 00 00 	movb   $0x0,0x1fd8(%edx)
  400a50:	c6 82 d9 1f 00 00 8e 	movb   $0x8e,0x1fd9(%edx)
  400a57:	c1 e8 10             	shr    $0x10,%eax
  400a5a:	66 89 82 da 1f 00 00 	mov    %ax,0x1fda(%edx)
	SETGATE(idt[2], 0, GD_KT, th2, 0);
  400a61:	c7 c0 56 11 40 00    	mov    $0x401156,%eax
  400a67:	66 89 82 dc 1f 00 00 	mov    %ax,0x1fdc(%edx)
  400a6e:	66 c7 82 de 1f 00 00 	movw   $0x8,0x1fde(%edx)
  400a75:	08 00 
  400a77:	c6 82 e0 1f 00 00 00 	movb   $0x0,0x1fe0(%edx)
  400a7e:	c6 82 e1 1f 00 00 8e 	movb   $0x8e,0x1fe1(%edx)
  400a85:	c1 e8 10             	shr    $0x10,%eax
  400a88:	66 89 82 e2 1f 00 00 	mov    %ax,0x1fe2(%edx)
	SETGATE(idt[3], 1, GD_KT, th3, 3);
  400a8f:	c7 c0 5a 11 40 00    	mov    $0x40115a,%eax
  400a95:	66 89 82 e4 1f 00 00 	mov    %ax,0x1fe4(%edx)
  400a9c:	66 c7 82 e6 1f 00 00 	movw   $0x8,0x1fe6(%edx)
  400aa3:	08 00 
  400aa5:	c6 82 e8 1f 00 00 00 	movb   $0x0,0x1fe8(%edx)
  400aac:	c6 82 e9 1f 00 00 ef 	movb   $0xef,0x1fe9(%edx)
  400ab3:	c1 e8 10             	shr    $0x10,%eax
  400ab6:	66 89 82 ea 1f 00 00 	mov    %ax,0x1fea(%edx)
	SETGATE(idt[4], 0, GD_KT, th4, 0);
  400abd:	c7 c0 60 11 40 00    	mov    $0x401160,%eax
  400ac3:	66 89 82 ec 1f 00 00 	mov    %ax,0x1fec(%edx)
  400aca:	66 c7 82 ee 1f 00 00 	movw   $0x8,0x1fee(%edx)
  400ad1:	08 00 
  400ad3:	c6 82 f0 1f 00 00 00 	movb   $0x0,0x1ff0(%edx)
  400ada:	c6 82 f1 1f 00 00 8e 	movb   $0x8e,0x1ff1(%edx)
  400ae1:	c1 e8 10             	shr    $0x10,%eax
  400ae4:	66 89 82 f2 1f 00 00 	mov    %ax,0x1ff2(%edx)
	SETGATE(idt[5], 0, GD_KT, th5, 0);
  400aeb:	c7 c0 64 11 40 00    	mov    $0x401164,%eax
  400af1:	66 89 82 f4 1f 00 00 	mov    %ax,0x1ff4(%edx)
  400af8:	66 c7 82 f6 1f 00 00 	movw   $0x8,0x1ff6(%edx)
  400aff:	08 00 
  400b01:	c6 82 f8 1f 00 00 00 	movb   $0x0,0x1ff8(%edx)
  400b08:	c6 82 f9 1f 00 00 8e 	movb   $0x8e,0x1ff9(%edx)
  400b0f:	c1 e8 10             	shr    $0x10,%eax
  400b12:	66 89 82 fa 1f 00 00 	mov    %ax,0x1ffa(%edx)
	SETGATE(idt[6], 0, GD_KT, th6, 0);
  400b19:	c7 c0 68 11 40 00    	mov    $0x401168,%eax
  400b1f:	66 89 82 fc 1f 00 00 	mov    %ax,0x1ffc(%edx)
  400b26:	66 c7 82 fe 1f 00 00 	movw   $0x8,0x1ffe(%edx)
  400b2d:	08 00 
  400b2f:	c6 82 00 20 00 00 00 	movb   $0x0,0x2000(%edx)
  400b36:	c6 82 01 20 00 00 8e 	movb   $0x8e,0x2001(%edx)
  400b3d:	c1 e8 10             	shr    $0x10,%eax
  400b40:	66 89 82 02 20 00 00 	mov    %ax,0x2002(%edx)
	SETGATE(idt[7], 0, GD_KT, th7, 0);
  400b47:	c7 c0 6c 11 40 00    	mov    $0x40116c,%eax
  400b4d:	66 89 82 04 20 00 00 	mov    %ax,0x2004(%edx)
  400b54:	66 c7 82 06 20 00 00 	movw   $0x8,0x2006(%edx)
  400b5b:	08 00 
  400b5d:	c6 82 08 20 00 00 00 	movb   $0x0,0x2008(%edx)
  400b64:	c6 82 09 20 00 00 8e 	movb   $0x8e,0x2009(%edx)
  400b6b:	c1 e8 10             	shr    $0x10,%eax
  400b6e:	66 89 82 0a 20 00 00 	mov    %ax,0x200a(%edx)
	SETGATE(idt[8], 0, GD_KT, th8, 0);
  400b75:	c7 c0 70 11 40 00    	mov    $0x401170,%eax
  400b7b:	66 89 82 0c 20 00 00 	mov    %ax,0x200c(%edx)
  400b82:	66 c7 82 0e 20 00 00 	movw   $0x8,0x200e(%edx)
  400b89:	08 00 
  400b8b:	c6 82 10 20 00 00 00 	movb   $0x0,0x2010(%edx)
  400b92:	c6 82 11 20 00 00 8e 	movb   $0x8e,0x2011(%edx)
  400b99:	c1 e8 10             	shr    $0x10,%eax
  400b9c:	66 89 82 12 20 00 00 	mov    %ax,0x2012(%edx)
	SETGATE(idt[10], 0, GD_KT, th10, 0);
  400ba3:	c7 c0 74 11 40 00    	mov    $0x401174,%eax
  400ba9:	66 89 82 1c 20 00 00 	mov    %ax,0x201c(%edx)
  400bb0:	66 c7 82 1e 20 00 00 	movw   $0x8,0x201e(%edx)
  400bb7:	08 00 
  400bb9:	c6 82 20 20 00 00 00 	movb   $0x0,0x2020(%edx)
  400bc0:	c6 82 21 20 00 00 8e 	movb   $0x8e,0x2021(%edx)
  400bc7:	c1 e8 10             	shr    $0x10,%eax
  400bca:	66 89 82 22 20 00 00 	mov    %ax,0x2022(%edx)
	SETGATE(idt[11], 0, GD_KT, th11, 0);
  400bd1:	c7 c0 78 11 40 00    	mov    $0x401178,%eax
  400bd7:	66 89 82 24 20 00 00 	mov    %ax,0x2024(%edx)
  400bde:	66 c7 82 26 20 00 00 	movw   $0x8,0x2026(%edx)
  400be5:	08 00 
  400be7:	c6 82 28 20 00 00 00 	movb   $0x0,0x2028(%edx)
  400bee:	c6 82 29 20 00 00 8e 	movb   $0x8e,0x2029(%edx)
  400bf5:	c1 e8 10             	shr    $0x10,%eax
  400bf8:	66 89 82 2a 20 00 00 	mov    %ax,0x202a(%edx)
	SETGATE(idt[12], 0, GD_KT, th12, 0);
  400bff:	c7 c0 7c 11 40 00    	mov    $0x40117c,%eax
  400c05:	66 89 82 2c 20 00 00 	mov    %ax,0x202c(%edx)
  400c0c:	66 c7 82 2e 20 00 00 	movw   $0x8,0x202e(%edx)
  400c13:	08 00 
  400c15:	c6 82 30 20 00 00 00 	movb   $0x0,0x2030(%edx)
  400c1c:	c6 82 31 20 00 00 8e 	movb   $0x8e,0x2031(%edx)
  400c23:	c1 e8 10             	shr    $0x10,%eax
  400c26:	66 89 82 32 20 00 00 	mov    %ax,0x2032(%edx)
	SETGATE(idt[13], 0, GD_KT, th13, 0);
  400c2d:	c7 c0 80 11 40 00    	mov    $0x401180,%eax
  400c33:	66 89 82 34 20 00 00 	mov    %ax,0x2034(%edx)
  400c3a:	66 c7 82 36 20 00 00 	movw   $0x8,0x2036(%edx)
  400c41:	08 00 
  400c43:	c6 82 38 20 00 00 00 	movb   $0x0,0x2038(%edx)
  400c4a:	c6 82 39 20 00 00 8e 	movb   $0x8e,0x2039(%edx)
  400c51:	c1 e8 10             	shr    $0x10,%eax
  400c54:	66 89 82 3a 20 00 00 	mov    %ax,0x203a(%edx)
	SETGATE(idt[14], 0, GD_KT, th14, 0);
  400c5b:	c7 c0 84 11 40 00    	mov    $0x401184,%eax
  400c61:	66 89 82 3c 20 00 00 	mov    %ax,0x203c(%edx)
  400c68:	66 c7 82 3e 20 00 00 	movw   $0x8,0x203e(%edx)
  400c6f:	08 00 
  400c71:	c6 82 40 20 00 00 00 	movb   $0x0,0x2040(%edx)
  400c78:	c6 82 41 20 00 00 8e 	movb   $0x8e,0x2041(%edx)
  400c7f:	c1 e8 10             	shr    $0x10,%eax
  400c82:	66 89 82 42 20 00 00 	mov    %ax,0x2042(%edx)
	SETGATE(idt[16], 0, GD_KT, th16, 0);
  400c89:	c7 c0 88 11 40 00    	mov    $0x401188,%eax
  400c8f:	66 89 82 4c 20 00 00 	mov    %ax,0x204c(%edx)
  400c96:	66 c7 82 4e 20 00 00 	movw   $0x8,0x204e(%edx)
  400c9d:	08 00 
  400c9f:	c6 82 50 20 00 00 00 	movb   $0x0,0x2050(%edx)
  400ca6:	c6 82 51 20 00 00 8e 	movb   $0x8e,0x2051(%edx)
  400cad:	c1 e8 10             	shr    $0x10,%eax
  400cb0:	66 89 82 52 20 00 00 	mov    %ax,0x2052(%edx)
	SETGATE(idt[17], 0, GD_KT, th17, 0);
  400cb7:	c7 c0 8c 11 40 00    	mov    $0x40118c,%eax
  400cbd:	66 89 82 54 20 00 00 	mov    %ax,0x2054(%edx)
  400cc4:	66 c7 82 56 20 00 00 	movw   $0x8,0x2056(%edx)
  400ccb:	08 00 
  400ccd:	c6 82 58 20 00 00 00 	movb   $0x0,0x2058(%edx)
  400cd4:	c6 82 59 20 00 00 8e 	movb   $0x8e,0x2059(%edx)
  400cdb:	c1 e8 10             	shr    $0x10,%eax
  400cde:	66 89 82 5a 20 00 00 	mov    %ax,0x205a(%edx)
	SETGATE(idt[18], 0, GD_KT, th18, 0);
  400ce5:	c7 c0 90 11 40 00    	mov    $0x401190,%eax
  400ceb:	66 89 82 5c 20 00 00 	mov    %ax,0x205c(%edx)
  400cf2:	66 c7 82 5e 20 00 00 	movw   $0x8,0x205e(%edx)
  400cf9:	08 00 
  400cfb:	c6 82 60 20 00 00 00 	movb   $0x0,0x2060(%edx)
  400d02:	c6 82 61 20 00 00 8e 	movb   $0x8e,0x2061(%edx)
  400d09:	c1 e8 10             	shr    $0x10,%eax
  400d0c:	66 89 82 62 20 00 00 	mov    %ax,0x2062(%edx)
	SETGATE(idt[19], 0, GD_KT, th19, 0);
  400d13:	c7 c0 94 11 40 00    	mov    $0x401194,%eax
  400d19:	66 89 82 64 20 00 00 	mov    %ax,0x2064(%edx)
  400d20:	66 c7 82 66 20 00 00 	movw   $0x8,0x2066(%edx)
  400d27:	08 00 
  400d29:	c6 82 68 20 00 00 00 	movb   $0x0,0x2068(%edx)
  400d30:	c6 82 69 20 00 00 8e 	movb   $0x8e,0x2069(%edx)
  400d37:	c1 e8 10             	shr    $0x10,%eax
  400d3a:	66 89 82 6a 20 00 00 	mov    %ax,0x206a(%edx)
	SETGATE(idt[48], 0, GD_KT, th48, 3);
  400d41:	c7 c0 98 11 40 00    	mov    $0x401198,%eax
  400d47:	66 89 82 4c 21 00 00 	mov    %ax,0x214c(%edx)
  400d4e:	66 c7 82 4e 21 00 00 	movw   $0x8,0x214e(%edx)
  400d55:	08 00 
  400d57:	c6 82 50 21 00 00 00 	movb   $0x0,0x2150(%edx)
  400d5e:	c6 82 51 21 00 00 ee 	movb   $0xee,0x2151(%edx)
  400d65:	c1 e8 10             	shr    $0x10,%eax
  400d68:	66 89 82 52 21 00 00 	mov    %ax,0x2152(%edx)
	trap_init_percpu();
  400d6f:	e8 9b fb ff ff       	call   40090f <trap_init_percpu>
}
  400d74:	5b                   	pop    %ebx
  400d75:	5e                   	pop    %esi
  400d76:	5d                   	pop    %ebp
  400d77:	c3                   	ret    

00400d78 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
  400d78:	55                   	push   %ebp
  400d79:	89 e5                	mov    %esp,%ebp
  400d7b:	56                   	push   %esi
  400d7c:	53                   	push   %ebx
  400d7d:	e8 e1 f4 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  400d82:	81 c3 b2 45 01 00    	add    $0x145b2,%ebx
  400d88:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("  edi  0x%08x\n", regs->reg_edi);
  400d8b:	83 ec 08             	sub    $0x8,%esp
  400d8e:	ff 36                	pushl  (%esi)
  400d90:	8d 83 83 d0 fe ff    	lea    -0x12f7d(%ebx),%eax
  400d96:	50                   	push   %eax
  400d97:	e8 5f fb ff ff       	call   4008fb <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
  400d9c:	83 c4 08             	add    $0x8,%esp
  400d9f:	ff 76 04             	pushl  0x4(%esi)
  400da2:	8d 83 92 d0 fe ff    	lea    -0x12f6e(%ebx),%eax
  400da8:	50                   	push   %eax
  400da9:	e8 4d fb ff ff       	call   4008fb <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  400dae:	83 c4 08             	add    $0x8,%esp
  400db1:	ff 76 08             	pushl  0x8(%esi)
  400db4:	8d 83 a1 d0 fe ff    	lea    -0x12f5f(%ebx),%eax
  400dba:	50                   	push   %eax
  400dbb:	e8 3b fb ff ff       	call   4008fb <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  400dc0:	83 c4 08             	add    $0x8,%esp
  400dc3:	ff 76 0c             	pushl  0xc(%esi)
  400dc6:	8d 83 b0 d0 fe ff    	lea    -0x12f50(%ebx),%eax
  400dcc:	50                   	push   %eax
  400dcd:	e8 29 fb ff ff       	call   4008fb <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  400dd2:	83 c4 08             	add    $0x8,%esp
  400dd5:	ff 76 10             	pushl  0x10(%esi)
  400dd8:	8d 83 bf d0 fe ff    	lea    -0x12f41(%ebx),%eax
  400dde:	50                   	push   %eax
  400ddf:	e8 17 fb ff ff       	call   4008fb <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
  400de4:	83 c4 08             	add    $0x8,%esp
  400de7:	ff 76 14             	pushl  0x14(%esi)
  400dea:	8d 83 ce d0 fe ff    	lea    -0x12f32(%ebx),%eax
  400df0:	50                   	push   %eax
  400df1:	e8 05 fb ff ff       	call   4008fb <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  400df6:	83 c4 08             	add    $0x8,%esp
  400df9:	ff 76 18             	pushl  0x18(%esi)
  400dfc:	8d 83 dd d0 fe ff    	lea    -0x12f23(%ebx),%eax
  400e02:	50                   	push   %eax
  400e03:	e8 f3 fa ff ff       	call   4008fb <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
  400e08:	83 c4 08             	add    $0x8,%esp
  400e0b:	ff 76 1c             	pushl  0x1c(%esi)
  400e0e:	8d 83 ec d0 fe ff    	lea    -0x12f14(%ebx),%eax
  400e14:	50                   	push   %eax
  400e15:	e8 e1 fa ff ff       	call   4008fb <cprintf>
}
  400e1a:	83 c4 10             	add    $0x10,%esp
  400e1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  400e20:	5b                   	pop    %ebx
  400e21:	5e                   	pop    %esi
  400e22:	5d                   	pop    %ebp
  400e23:	c3                   	ret    

00400e24 <print_trapframe>:
{
  400e24:	55                   	push   %ebp
  400e25:	89 e5                	mov    %esp,%ebp
  400e27:	57                   	push   %edi
  400e28:	56                   	push   %esi
  400e29:	53                   	push   %ebx
  400e2a:	83 ec 14             	sub    $0x14,%esp
  400e2d:	e8 31 f4 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  400e32:	81 c3 02 45 01 00    	add    $0x14502,%ebx
  400e38:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("TRAP frame at %p\n", tf);
  400e3b:	56                   	push   %esi
  400e3c:	8d 83 74 d2 fe ff    	lea    -0x12d8c(%ebx),%eax
  400e42:	50                   	push   %eax
  400e43:	e8 b3 fa ff ff       	call   4008fb <cprintf>
	print_regs(&tf->tf_regs);
  400e48:	89 34 24             	mov    %esi,(%esp)
  400e4b:	e8 28 ff ff ff       	call   400d78 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
  400e50:	83 c4 08             	add    $0x8,%esp
  400e53:	0f b7 46 20          	movzwl 0x20(%esi),%eax
  400e57:	50                   	push   %eax
  400e58:	8d 83 3d d1 fe ff    	lea    -0x12ec3(%ebx),%eax
  400e5e:	50                   	push   %eax
  400e5f:	e8 97 fa ff ff       	call   4008fb <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
  400e64:	83 c4 08             	add    $0x8,%esp
  400e67:	0f b7 46 24          	movzwl 0x24(%esi),%eax
  400e6b:	50                   	push   %eax
  400e6c:	8d 83 50 d1 fe ff    	lea    -0x12eb0(%ebx),%eax
  400e72:	50                   	push   %eax
  400e73:	e8 83 fa ff ff       	call   4008fb <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  400e78:	8b 56 28             	mov    0x28(%esi),%edx
	if (trapno < ARRAY_SIZE(excnames))
  400e7b:	83 c4 10             	add    $0x10,%esp
  400e7e:	83 fa 13             	cmp    $0x13,%edx
  400e81:	0f 86 e9 00 00 00    	jbe    400f70 <print_trapframe+0x14c>
	return "(unknown trap)";
  400e87:	83 fa 30             	cmp    $0x30,%edx
  400e8a:	8d 83 fb d0 fe ff    	lea    -0x12f05(%ebx),%eax
  400e90:	8d 8b 07 d1 fe ff    	lea    -0x12ef9(%ebx),%ecx
  400e96:	0f 45 c1             	cmovne %ecx,%eax
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  400e99:	83 ec 04             	sub    $0x4,%esp
  400e9c:	50                   	push   %eax
  400e9d:	52                   	push   %edx
  400e9e:	8d 83 63 d1 fe ff    	lea    -0x12e9d(%ebx),%eax
  400ea4:	50                   	push   %eax
  400ea5:	e8 51 fa ff ff       	call   4008fb <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
  400eaa:	83 c4 10             	add    $0x10,%esp
  400ead:	39 b3 cc 27 00 00    	cmp    %esi,0x27cc(%ebx)
  400eb3:	0f 84 c3 00 00 00    	je     400f7c <print_trapframe+0x158>
	cprintf("  err  0x%08x", tf->tf_err);
  400eb9:	83 ec 08             	sub    $0x8,%esp
  400ebc:	ff 76 2c             	pushl  0x2c(%esi)
  400ebf:	8d 83 84 d1 fe ff    	lea    -0x12e7c(%ebx),%eax
  400ec5:	50                   	push   %eax
  400ec6:	e8 30 fa ff ff       	call   4008fb <cprintf>
	if (tf->tf_trapno == T_PGFLT)
  400ecb:	83 c4 10             	add    $0x10,%esp
  400ece:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
  400ed2:	0f 85 c9 00 00 00    	jne    400fa1 <print_trapframe+0x17d>
			tf->tf_err & 1 ? "protection" : "not-present");
  400ed8:	8b 46 2c             	mov    0x2c(%esi),%eax
		cprintf(" [%s, %s, %s]\n",
  400edb:	89 c2                	mov    %eax,%edx
  400edd:	83 e2 01             	and    $0x1,%edx
  400ee0:	8d 8b 16 d1 fe ff    	lea    -0x12eea(%ebx),%ecx
  400ee6:	8d 93 21 d1 fe ff    	lea    -0x12edf(%ebx),%edx
  400eec:	0f 44 ca             	cmove  %edx,%ecx
  400eef:	89 c2                	mov    %eax,%edx
  400ef1:	83 e2 02             	and    $0x2,%edx
  400ef4:	8d 93 2d d1 fe ff    	lea    -0x12ed3(%ebx),%edx
  400efa:	8d bb 33 d1 fe ff    	lea    -0x12ecd(%ebx),%edi
  400f00:	0f 44 d7             	cmove  %edi,%edx
  400f03:	83 e0 04             	and    $0x4,%eax
  400f06:	8d 83 38 d1 fe ff    	lea    -0x12ec8(%ebx),%eax
  400f0c:	8d bb 98 d2 fe ff    	lea    -0x12d68(%ebx),%edi
  400f12:	0f 44 c7             	cmove  %edi,%eax
  400f15:	51                   	push   %ecx
  400f16:	52                   	push   %edx
  400f17:	50                   	push   %eax
  400f18:	8d 83 92 d1 fe ff    	lea    -0x12e6e(%ebx),%eax
  400f1e:	50                   	push   %eax
  400f1f:	e8 d7 f9 ff ff       	call   4008fb <cprintf>
  400f24:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
  400f27:	83 ec 08             	sub    $0x8,%esp
  400f2a:	ff 76 30             	pushl  0x30(%esi)
  400f2d:	8d 83 a1 d1 fe ff    	lea    -0x12e5f(%ebx),%eax
  400f33:	50                   	push   %eax
  400f34:	e8 c2 f9 ff ff       	call   4008fb <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
  400f39:	83 c4 08             	add    $0x8,%esp
  400f3c:	0f b7 46 34          	movzwl 0x34(%esi),%eax
  400f40:	50                   	push   %eax
  400f41:	8d 83 b0 d1 fe ff    	lea    -0x12e50(%ebx),%eax
  400f47:	50                   	push   %eax
  400f48:	e8 ae f9 ff ff       	call   4008fb <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
  400f4d:	83 c4 08             	add    $0x8,%esp
  400f50:	ff 76 38             	pushl  0x38(%esi)
  400f53:	8d 83 c3 d1 fe ff    	lea    -0x12e3d(%ebx),%eax
  400f59:	50                   	push   %eax
  400f5a:	e8 9c f9 ff ff       	call   4008fb <cprintf>
	if ((tf->tf_cs & 3) != 0) {
  400f5f:	83 c4 10             	add    $0x10,%esp
  400f62:	f6 46 34 03          	testb  $0x3,0x34(%esi)
  400f66:	75 50                	jne    400fb8 <print_trapframe+0x194>
}
  400f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  400f6b:	5b                   	pop    %ebx
  400f6c:	5e                   	pop    %esi
  400f6d:	5f                   	pop    %edi
  400f6e:	5d                   	pop    %ebp
  400f6f:	c3                   	ret    
		return excnames[trapno];
  400f70:	8b 84 93 0c 1d 00 00 	mov    0x1d0c(%ebx,%edx,4),%eax
  400f77:	e9 1d ff ff ff       	jmp    400e99 <print_trapframe+0x75>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
  400f7c:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
  400f80:	0f 85 33 ff ff ff    	jne    400eb9 <print_trapframe+0x95>

static inline uint32_t
rcr2(void)
{
	uint32_t val;
	asm volatile("movl %%cr2,%0" : "=r" (val));
  400f86:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
  400f89:	83 ec 08             	sub    $0x8,%esp
  400f8c:	50                   	push   %eax
  400f8d:	8d 83 75 d1 fe ff    	lea    -0x12e8b(%ebx),%eax
  400f93:	50                   	push   %eax
  400f94:	e8 62 f9 ff ff       	call   4008fb <cprintf>
  400f99:	83 c4 10             	add    $0x10,%esp
  400f9c:	e9 18 ff ff ff       	jmp    400eb9 <print_trapframe+0x95>
		cprintf("\n");
  400fa1:	83 ec 0c             	sub    $0xc,%esp
  400fa4:	8d 83 cf cd fe ff    	lea    -0x13231(%ebx),%eax
  400faa:	50                   	push   %eax
  400fab:	e8 4b f9 ff ff       	call   4008fb <cprintf>
  400fb0:	83 c4 10             	add    $0x10,%esp
  400fb3:	e9 6f ff ff ff       	jmp    400f27 <print_trapframe+0x103>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
  400fb8:	83 ec 08             	sub    $0x8,%esp
  400fbb:	ff 76 3c             	pushl  0x3c(%esi)
  400fbe:	8d 83 d2 d1 fe ff    	lea    -0x12e2e(%ebx),%eax
  400fc4:	50                   	push   %eax
  400fc5:	e8 31 f9 ff ff       	call   4008fb <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
  400fca:	83 c4 08             	add    $0x8,%esp
  400fcd:	0f b7 46 40          	movzwl 0x40(%esi),%eax
  400fd1:	50                   	push   %eax
  400fd2:	8d 83 e1 d1 fe ff    	lea    -0x12e1f(%ebx),%eax
  400fd8:	50                   	push   %eax
  400fd9:	e8 1d f9 ff ff       	call   4008fb <cprintf>
  400fde:	83 c4 10             	add    $0x10,%esp
}
  400fe1:	eb 85                	jmp    400f68 <print_trapframe+0x144>

00400fe3 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
  400fe3:	55                   	push   %ebp
  400fe4:	89 e5                	mov    %esp,%ebp
  400fe6:	56                   	push   %esi
  400fe7:	53                   	push   %ebx
  400fe8:	e8 76 f2 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  400fed:	81 c3 47 43 01 00    	add    $0x14347,%ebx
  400ff3:	8b 75 08             	mov    0x8(%ebp),%esi
  400ff6:	0f 20 d0             	mov    %cr2,%eax

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Destroy the environment that caused the fault.
	cprintf("user fault va %08x ip %08x\n",
  400ff9:	83 ec 04             	sub    $0x4,%esp
  400ffc:	ff 76 30             	pushl  0x30(%esi)
  400fff:	50                   	push   %eax
  401000:	8d 83 f4 d1 fe ff    	lea    -0x12e0c(%ebx),%eax
  401006:	50                   	push   %eax
  401007:	e8 ef f8 ff ff       	call   4008fb <cprintf>
		fault_va, tf->tf_eip);
	print_trapframe(tf);
  40100c:	89 34 24             	mov    %esi,(%esp)
  40100f:	e8 10 fe ff ff       	call   400e24 <print_trapframe>
	cprintf(PAGE_FAULT);
  401014:	8d 83 10 d2 fe ff    	lea    -0x12df0(%ebx),%eax
  40101a:	89 04 24             	mov    %eax,(%esp)
  40101d:	e8 d9 f8 ff ff       	call   4008fb <cprintf>
	panic("unhanlded page fault");
  401022:	83 c4 0c             	add    $0xc,%esp
  401025:	8d 83 1c d2 fe ff    	lea    -0x12de4(%ebx),%eax
  40102b:	50                   	push   %eax
  40102c:	68 1e 01 00 00       	push   $0x11e
  401031:	8d 83 31 d2 fe ff    	lea    -0x12dcf(%ebx),%eax
  401037:	50                   	push   %eax
  401038:	e8 03 f0 ff ff       	call   400040 <_panic>

0040103d <trap>:
{
  40103d:	55                   	push   %ebp
  40103e:	89 e5                	mov    %esp,%ebp
  401040:	57                   	push   %edi
  401041:	56                   	push   %esi
  401042:	53                   	push   %ebx
  401043:	83 ec 0c             	sub    $0xc,%esp
  401046:	e8 18 f2 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  40104b:	81 c3 e9 42 01 00    	add    $0x142e9,%ebx
  401051:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
  401054:	fc                   	cld    

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  401055:	9c                   	pushf  
  401056:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
  401057:	f6 c4 02             	test   $0x2,%ah
  40105a:	74 1f                	je     40107b <trap+0x3e>
  40105c:	8d 83 3d d2 fe ff    	lea    -0x12dc3(%ebx),%eax
  401062:	50                   	push   %eax
  401063:	8d 83 56 d2 fe ff    	lea    -0x12daa(%ebx),%eax
  401069:	50                   	push   %eax
  40106a:	68 f1 00 00 00       	push   $0xf1
  40106f:	8d 83 31 d2 fe ff    	lea    -0x12dcf(%ebx),%eax
  401075:	50                   	push   %eax
  401076:	e8 c5 ef ff ff       	call   400040 <_panic>
	cprintf("Incoming TRAP frame at %p\n", tf);
  40107b:	83 ec 08             	sub    $0x8,%esp
  40107e:	56                   	push   %esi
  40107f:	8d 83 6b d2 fe ff    	lea    -0x12d95(%ebx),%eax
  401085:	50                   	push   %eax
  401086:	e8 70 f8 ff ff       	call   4008fb <cprintf>
	if ((tf->tf_cs & 3) == 3) {
  40108b:	0f b7 46 34          	movzwl 0x34(%esi),%eax
  40108f:	83 e0 03             	and    $0x3,%eax
  401092:	83 c4 10             	add    $0x10,%esp
  401095:	66 83 f8 03          	cmp    $0x3,%ax
  401099:	74 41                	je     4010dc <trap+0x9f>
	last_tf = tf;
  40109b:	89 b3 cc 27 00 00    	mov    %esi,0x27cc(%ebx)
	switch(tf->tf_trapno) {
  4010a1:	8b 46 28             	mov    0x28(%esi),%eax
  4010a4:	83 f8 0e             	cmp    $0xe,%eax
  4010a7:	74 46                	je     4010ef <trap+0xb2>
  4010a9:	83 f8 30             	cmp    $0x30,%eax
  4010ac:	74 4a                	je     4010f8 <trap+0xbb>
	print_trapframe(tf);
  4010ae:	83 ec 0c             	sub    $0xc,%esp
  4010b1:	56                   	push   %esi
  4010b2:	e8 6d fd ff ff       	call   400e24 <print_trapframe>
	if (tf->tf_cs == GD_KT)
  4010b7:	83 c4 10             	add    $0x10,%esp
  4010ba:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
  4010bf:	74 64                	je     401125 <trap+0xe8>
		panic("unhandled trap in user code");
  4010c1:	83 ec 04             	sub    $0x4,%esp
  4010c4:	8d 83 9f d2 fe ff    	lea    -0x12d61(%ebx),%eax
  4010ca:	50                   	push   %eax
  4010cb:	68 e3 00 00 00       	push   $0xe3
  4010d0:	8d 83 31 d2 fe ff    	lea    -0x12dcf(%ebx),%eax
  4010d6:	50                   	push   %eax
  4010d7:	e8 64 ef ff ff       	call   400040 <_panic>
		env_tf = *tf;
  4010dc:	c7 c0 40 7e 43 00    	mov    $0x437e40,%eax
  4010e2:	b9 11 00 00 00       	mov    $0x11,%ecx
  4010e7:	89 c7                	mov    %eax,%edi
  4010e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &env_tf;
  4010eb:	89 c6                	mov    %eax,%esi
  4010ed:	eb ac                	jmp    40109b <trap+0x5e>
		page_fault_handler(tf);
  4010ef:	83 ec 0c             	sub    $0xc,%esp
  4010f2:	56                   	push   %esi
  4010f3:	e8 eb fe ff ff       	call   400fe3 <page_fault_handler>
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,
  4010f8:	83 ec 08             	sub    $0x8,%esp
  4010fb:	ff 76 04             	pushl  0x4(%esi)
  4010fe:	ff 36                	pushl  (%esi)
  401100:	ff 76 10             	pushl  0x10(%esi)
  401103:	ff 76 18             	pushl  0x18(%esi)
  401106:	ff 76 14             	pushl  0x14(%esi)
  401109:	ff 76 1c             	pushl  0x1c(%esi)
  40110c:	e8 9c 00 00 00       	call   4011ad <syscall>
  401111:	89 46 1c             	mov    %eax,0x1c(%esi)
		if(tf->tf_regs.reg_eax != -E_INVAL) {
  401114:	83 c4 20             	add    $0x20,%esp
  401117:	83 f8 fd             	cmp    $0xfffffffd,%eax
  40111a:	74 92                	je     4010ae <trap+0x71>
	run_trapframe(tf);
  40111c:	83 ec 0c             	sub    $0xc,%esp
  40111f:	56                   	push   %esi
  401120:	e8 4c f7 ff ff       	call   400871 <run_trapframe>
		panic("unhandled trap in kernel");
  401125:	83 ec 04             	sub    $0x4,%esp
  401128:	8d 83 86 d2 fe ff    	lea    -0x12d7a(%ebx),%eax
  40112e:	50                   	push   %eax
  40112f:	68 e1 00 00 00       	push   $0xe1
  401134:	8d 83 31 d2 fe ff    	lea    -0x12dcf(%ebx),%eax
  40113a:	50                   	push   %eax
  40113b:	e8 00 ef ff ff       	call   400040 <_panic>

00401140 <__x86.get_pc_thunk.dx>:
  401140:	8b 14 24             	mov    (%esp),%edx
  401143:	c3                   	ret    

00401144 <unktraphandler>:

.globl unktraphandler;
.type unktraphandler, @function;
	.align 2;		
unktraphandler:			
	pushl $0;
  401144:	6a 00                	push   $0x0
	pushl $9;
  401146:	6a 09                	push   $0x9
	jmp _alltraps;
  401148:	eb 54                	jmp    40119e <_alltraps>

0040114a <th0>:
	TRAPHANDLER(div0handler, T_DEBUG)	
	TRAPHANDLER(nmihandler, T_NMI)
	TRAPHANDLER(nmihandler, T_NMI)
	TRAPHANDLER(syscallhandler, T_SYSCALL) */

	TRAPHANDLER_NOEC(th0, 0)
  40114a:	6a 00                	push   $0x0
  40114c:	6a 00                	push   $0x0
  40114e:	eb 4e                	jmp    40119e <_alltraps>

00401150 <th1>:
	TRAPHANDLER_NOEC(th1, 1)
  401150:	6a 00                	push   $0x0
  401152:	6a 01                	push   $0x1
  401154:	eb 48                	jmp    40119e <_alltraps>

00401156 <th2>:
	TRAPHANDLER(th2, 2)
  401156:	6a 02                	push   $0x2
  401158:	eb 44                	jmp    40119e <_alltraps>

0040115a <th3>:
	TRAPHANDLER_NOEC(th3, 3)
  40115a:	6a 00                	push   $0x0
  40115c:	6a 03                	push   $0x3
  40115e:	eb 3e                	jmp    40119e <_alltraps>

00401160 <th4>:
	TRAPHANDLER(th4, 4)
  401160:	6a 04                	push   $0x4
  401162:	eb 3a                	jmp    40119e <_alltraps>

00401164 <th5>:
	TRAPHANDLER(th5, 5)
  401164:	6a 05                	push   $0x5
  401166:	eb 36                	jmp    40119e <_alltraps>

00401168 <th6>:
	TRAPHANDLER(th6, 6)
  401168:	6a 06                	push   $0x6
  40116a:	eb 32                	jmp    40119e <_alltraps>

0040116c <th7>:
	TRAPHANDLER(th7, 7)
  40116c:	6a 07                	push   $0x7
  40116e:	eb 2e                	jmp    40119e <_alltraps>

00401170 <th8>:
	TRAPHANDLER(th8, 8)
  401170:	6a 08                	push   $0x8
  401172:	eb 2a                	jmp    40119e <_alltraps>

00401174 <th10>:
	//TRAPHANDLER(th9, 9)
	TRAPHANDLER(th10, 10)
  401174:	6a 0a                	push   $0xa
  401176:	eb 26                	jmp    40119e <_alltraps>

00401178 <th11>:
	TRAPHANDLER(th11, 11)
  401178:	6a 0b                	push   $0xb
  40117a:	eb 22                	jmp    40119e <_alltraps>

0040117c <th12>:
	TRAPHANDLER(th12, 12)
  40117c:	6a 0c                	push   $0xc
  40117e:	eb 1e                	jmp    40119e <_alltraps>

00401180 <th13>:
	TRAPHANDLER(th13, 13)
  401180:	6a 0d                	push   $0xd
  401182:	eb 1a                	jmp    40119e <_alltraps>

00401184 <th14>:
	TRAPHANDLER(th14, 14)
  401184:	6a 0e                	push   $0xe
  401186:	eb 16                	jmp    40119e <_alltraps>

00401188 <th16>:
	//TRAPHANDLER(th15, 15)
	TRAPHANDLER(th16, 16)
  401188:	6a 10                	push   $0x10
  40118a:	eb 12                	jmp    40119e <_alltraps>

0040118c <th17>:
	TRAPHANDLER(th17, 17)
  40118c:	6a 11                	push   $0x11
  40118e:	eb 0e                	jmp    40119e <_alltraps>

00401190 <th18>:
	TRAPHANDLER(th18, 18)
  401190:	6a 12                	push   $0x12
  401192:	eb 0a                	jmp    40119e <_alltraps>

00401194 <th19>:
	TRAPHANDLER(th19, 19)
  401194:	6a 13                	push   $0x13
  401196:	eb 06                	jmp    40119e <_alltraps>

00401198 <th48>:
	TRAPHANDLER_NOEC(th48, 48)
  401198:	6a 00                	push   $0x0
  40119a:	6a 30                	push   $0x30
  40119c:	eb 00                	jmp    40119e <_alltraps>

0040119e <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */


_alltraps:
	pushl %ds;
  40119e:	1e                   	push   %ds
	pushl %es;
  40119f:	06                   	push   %es
	pushal;
  4011a0:	60                   	pusha  
	pushl $GD_KD;
  4011a1:	6a 10                	push   $0x10
	popl %ds;
  4011a3:	1f                   	pop    %ds
	pushl $GD_KD;
  4011a4:	6a 10                	push   $0x10
	popl %es;
  4011a6:	07                   	pop    %es
	pushl %esp;
  4011a7:	54                   	push   %esp
	call trap;
  4011a8:	e8 90 fe ff ff       	call   40103d <trap>

004011ad <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  4011ad:	55                   	push   %ebp
  4011ae:	89 e5                	mov    %esp,%ebp
  4011b0:	53                   	push   %ebx
  4011b1:	83 ec 04             	sub    $0x4,%esp
  4011b4:	e8 aa f0 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  4011b9:	81 c3 7b 41 01 00    	add    $0x1417b,%ebx
  4011bf:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	
	switch (syscallno) {
  4011c2:	83 f8 03             	cmp    $0x3,%eax
  4011c5:	74 67                	je     40122e <syscall+0x81>
  4011c7:	83 f8 04             	cmp    $0x4,%eax
  4011ca:	74 70                	je     40123c <syscall+0x8f>
  4011cc:	85 c0                	test   %eax,%eax
  4011ce:	74 1a                	je     4011ea <syscall+0x3d>
	case SYS_test:
		sys_test();
		return 0;

	}
	cprintf("Kernel got unexpected system call %d\n", syscallno);
  4011d0:	83 ec 08             	sub    $0x8,%esp
  4011d3:	50                   	push   %eax
  4011d4:	8d 83 24 d4 fe ff    	lea    -0x12bdc(%ebx),%eax
  4011da:	50                   	push   %eax
  4011db:	e8 1b f7 ff ff       	call   4008fb <cprintf>
	return -E_INVAL;
  4011e0:	83 c4 10             	add    $0x10,%esp
  4011e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  4011e8:	eb 69                	jmp    401253 <syscall+0xa6>
	if(bravo < 0x800000  ||  bravo+len >= USTACKTOP) {
  4011ea:	81 7d 0c ff ff 7f 00 	cmpl   $0x7fffff,0xc(%ebp)
  4011f1:	76 0d                	jbe    401200 <syscall+0x53>
  4011f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  4011f6:	03 45 10             	add    0x10(%ebp),%eax
  4011f9:	3d ff df af 00       	cmp    $0xafdfff,%eax
  4011fe:	76 19                	jbe    401219 <syscall+0x6c>
		cprintf(INVALID_POINTER);
  401200:	83 ec 0c             	sub    $0xc,%esp
  401203:	8d 83 fe d3 fe ff    	lea    -0x12c02(%ebx),%eax
  401209:	50                   	push   %eax
  40120a:	e8 ec f6 ff ff       	call   4008fb <cprintf>
  40120f:	83 c4 10             	add    $0x10,%esp
		return 0;
  401212:	b8 00 00 00 00       	mov    $0x0,%eax
  401217:	eb 3a                	jmp    401253 <syscall+0xa6>
		cprintf(s);
  401219:	83 ec 0c             	sub    $0xc,%esp
  40121c:	ff 75 0c             	pushl  0xc(%ebp)
  40121f:	e8 d7 f6 ff ff       	call   4008fb <cprintf>
  401224:	83 c4 10             	add    $0x10,%esp
		return 0;
  401227:	b8 00 00 00 00       	mov    $0x0,%eax
  40122c:	eb 25                	jmp    401253 <syscall+0xa6>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  40122e:	b8 00 20 00 00       	mov    $0x2000,%eax
  401233:	ba 04 06 00 00       	mov    $0x604,%edx
  401238:	66 ef                	out    %ax,(%dx)
  40123a:	eb fe                	jmp    40123a <syscall+0x8d>
	cprintf(SYS_TEST);
  40123c:	83 ec 0c             	sub    $0xc,%esp
  40123f:	8d 83 0f d4 fe ff    	lea    -0x12bf1(%ebx),%eax
  401245:	50                   	push   %eax
  401246:	e8 b0 f6 ff ff       	call   4008fb <cprintf>
  40124b:	83 c4 10             	add    $0x10,%esp
		return 0;
  40124e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  401256:	c9                   	leave  
  401257:	c3                   	ret    

00401258 <ide_wait_ready>:

static int diskno = 0; // we only use one disk

static int
ide_wait_ready(bool check_error)
{
  401258:	55                   	push   %ebp
  401259:	89 e5                	mov    %esp,%ebp
  40125b:	53                   	push   %ebx
  40125c:	89 c1                	mov    %eax,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  40125e:	ba f7 01 00 00       	mov    $0x1f7,%edx
  401263:	ec                   	in     (%dx),%al
  401264:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  401266:	83 e0 c0             	and    $0xffffffc0,%eax
  401269:	3c 40                	cmp    $0x40,%al
  40126b:	75 f6                	jne    401263 <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  40126d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  401272:	84 c9                	test   %cl,%cl
  401274:	74 0b                	je     401281 <ide_wait_ready+0x29>
  401276:	f6 c3 21             	test   $0x21,%bl
  401279:	0f 95 c0             	setne  %al
  40127c:	0f b6 c0             	movzbl %al,%eax
  40127f:	f7 d8                	neg    %eax
}
  401281:	5b                   	pop    %ebx
  401282:	5d                   	pop    %ebp
  401283:	c3                   	ret    

00401284 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  401284:	55                   	push   %ebp
  401285:	89 e5                	mov    %esp,%ebp
  401287:	57                   	push   %edi
  401288:	56                   	push   %esi
  401289:	53                   	push   %ebx
  40128a:	83 ec 0c             	sub    $0xc,%esp
  40128d:	e8 73 f5 ff ff       	call   400805 <__x86.get_pc_thunk.ax>
  401292:	05 a2 40 01 00       	add    $0x140a2,%eax
  401297:	8b 7d 08             	mov    0x8(%ebp),%edi
  40129a:	8b 75 0c             	mov    0xc(%ebp),%esi
  40129d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  4012a0:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  4012a6:	77 7a                	ja     401322 <ide_read+0x9e>

	ide_wait_ready(0);
  4012a8:	b8 00 00 00 00       	mov    $0x0,%eax
  4012ad:	e8 a6 ff ff ff       	call   401258 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  4012b2:	ba f2 01 00 00       	mov    $0x1f2,%edx
  4012b7:	89 d8                	mov    %ebx,%eax
  4012b9:	ee                   	out    %al,(%dx)
  4012ba:	ba f3 01 00 00       	mov    $0x1f3,%edx
  4012bf:	89 f8                	mov    %edi,%eax
  4012c1:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  4012c2:	89 f8                	mov    %edi,%eax
  4012c4:	c1 e8 08             	shr    $0x8,%eax
  4012c7:	ba f4 01 00 00       	mov    $0x1f4,%edx
  4012cc:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  4012cd:	89 f8                	mov    %edi,%eax
  4012cf:	c1 e8 10             	shr    $0x10,%eax
  4012d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
  4012d7:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  4012d8:	89 f8                	mov    %edi,%eax
  4012da:	c1 e8 18             	shr    $0x18,%eax
  4012dd:	83 e0 0f             	and    $0xf,%eax
  4012e0:	83 c8 e0             	or     $0xffffffe0,%eax
  4012e3:	ba f6 01 00 00       	mov    $0x1f6,%edx
  4012e8:	ee                   	out    %al,(%dx)
  4012e9:	b8 20 00 00 00       	mov    $0x20,%eax
  4012ee:	ba f7 01 00 00       	mov    $0x1f7,%edx
  4012f3:	ee                   	out    %al,(%dx)
  4012f4:	c1 e3 09             	shl    $0x9,%ebx
  4012f7:	01 f3                	add    %esi,%ebx
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  4012f9:	39 f3                	cmp    %esi,%ebx
  4012fb:	74 43                	je     401340 <ide_read+0xbc>
		if ((r = ide_wait_ready(1)) < 0)
  4012fd:	b8 01 00 00 00       	mov    $0x1,%eax
  401302:	e8 51 ff ff ff       	call   401258 <ide_wait_ready>
  401307:	85 c0                	test   %eax,%eax
  401309:	78 3a                	js     401345 <ide_read+0xc1>
	asm volatile("cld\n\trepne\n\tinsl"
  40130b:	89 f7                	mov    %esi,%edi
  40130d:	b9 80 00 00 00       	mov    $0x80,%ecx
  401312:	ba f0 01 00 00       	mov    $0x1f0,%edx
  401317:	fc                   	cld    
  401318:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  40131a:	81 c6 00 02 00 00    	add    $0x200,%esi
  401320:	eb d7                	jmp    4012f9 <ide_read+0x75>
	assert(nsecs <= 256);
  401322:	8d 90 4c d4 fe ff    	lea    -0x12bb4(%eax),%edx
  401328:	52                   	push   %edx
  401329:	8d 90 56 d2 fe ff    	lea    -0x12daa(%eax),%edx
  40132f:	52                   	push   %edx
  401330:	6a 23                	push   $0x23
  401332:	8d 90 59 d4 fe ff    	lea    -0x12ba7(%eax),%edx
  401338:	52                   	push   %edx
  401339:	89 c3                	mov    %eax,%ebx
  40133b:	e8 00 ed ff ff       	call   400040 <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  401340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401345:	8d 65 f4             	lea    -0xc(%ebp),%esp
  401348:	5b                   	pop    %ebx
  401349:	5e                   	pop    %esi
  40134a:	5f                   	pop    %edi
  40134b:	5d                   	pop    %ebp
  40134c:	c3                   	ret    

0040134d <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  40134d:	55                   	push   %ebp
  40134e:	89 e5                	mov    %esp,%ebp
  401350:	57                   	push   %edi
  401351:	56                   	push   %esi
  401352:	53                   	push   %ebx
  401353:	83 ec 0c             	sub    $0xc,%esp
  401356:	e8 aa f4 ff ff       	call   400805 <__x86.get_pc_thunk.ax>
  40135b:	05 d9 3f 01 00       	add    $0x13fd9,%eax
  401360:	8b 75 08             	mov    0x8(%ebp),%esi
  401363:	8b 7d 0c             	mov    0xc(%ebp),%edi
  401366:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  401369:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  40136f:	77 7a                	ja     4013eb <ide_write+0x9e>

	ide_wait_ready(0);
  401371:	b8 00 00 00 00       	mov    $0x0,%eax
  401376:	e8 dd fe ff ff       	call   401258 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  40137b:	ba f2 01 00 00       	mov    $0x1f2,%edx
  401380:	89 d8                	mov    %ebx,%eax
  401382:	ee                   	out    %al,(%dx)
  401383:	ba f3 01 00 00       	mov    $0x1f3,%edx
  401388:	89 f0                	mov    %esi,%eax
  40138a:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  40138b:	89 f0                	mov    %esi,%eax
  40138d:	c1 e8 08             	shr    $0x8,%eax
  401390:	ba f4 01 00 00       	mov    $0x1f4,%edx
  401395:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  401396:	89 f0                	mov    %esi,%eax
  401398:	c1 e8 10             	shr    $0x10,%eax
  40139b:	ba f5 01 00 00       	mov    $0x1f5,%edx
  4013a0:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  4013a1:	89 f0                	mov    %esi,%eax
  4013a3:	c1 e8 18             	shr    $0x18,%eax
  4013a6:	83 e0 0f             	and    $0xf,%eax
  4013a9:	83 c8 e0             	or     $0xffffffe0,%eax
  4013ac:	ba f6 01 00 00       	mov    $0x1f6,%edx
  4013b1:	ee                   	out    %al,(%dx)
  4013b2:	b8 30 00 00 00       	mov    $0x30,%eax
  4013b7:	ba f7 01 00 00       	mov    $0x1f7,%edx
  4013bc:	ee                   	out    %al,(%dx)
  4013bd:	c1 e3 09             	shl    $0x9,%ebx
  4013c0:	01 fb                	add    %edi,%ebx
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  4013c2:	39 fb                	cmp    %edi,%ebx
  4013c4:	74 43                	je     401409 <ide_write+0xbc>
		if ((r = ide_wait_ready(1)) < 0)
  4013c6:	b8 01 00 00 00       	mov    $0x1,%eax
  4013cb:	e8 88 fe ff ff       	call   401258 <ide_wait_ready>
  4013d0:	85 c0                	test   %eax,%eax
  4013d2:	78 3a                	js     40140e <ide_write+0xc1>
	asm volatile("cld\n\trepne\n\toutsl"
  4013d4:	89 fe                	mov    %edi,%esi
  4013d6:	b9 80 00 00 00       	mov    $0x80,%ecx
  4013db:	ba f0 01 00 00       	mov    $0x1f0,%edx
  4013e0:	fc                   	cld    
  4013e1:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  4013e3:	81 c7 00 02 00 00    	add    $0x200,%edi
  4013e9:	eb d7                	jmp    4013c2 <ide_write+0x75>
	assert(nsecs <= 256);
  4013eb:	8d 90 4c d4 fe ff    	lea    -0x12bb4(%eax),%edx
  4013f1:	52                   	push   %edx
  4013f2:	8d 90 56 d2 fe ff    	lea    -0x12daa(%eax),%edx
  4013f8:	52                   	push   %edx
  4013f9:	6a 3c                	push   $0x3c
  4013fb:	8d 90 59 d4 fe ff    	lea    -0x12ba7(%eax),%edx
  401401:	52                   	push   %edx
  401402:	89 c3                	mov    %eax,%ebx
  401404:	e8 37 ec ff ff       	call   400040 <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  401409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  40140e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  401411:	5b                   	pop    %ebx
  401412:	5e                   	pop    %esi
  401413:	5f                   	pop    %edi
  401414:	5d                   	pop    %ebp
  401415:	c3                   	ret    

00401416 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  401416:	55                   	push   %ebp
  401417:	89 e5                	mov    %esp,%ebp
  401419:	57                   	push   %edi
  40141a:	56                   	push   %esi
  40141b:	53                   	push   %ebx
  40141c:	83 ec 2c             	sub    $0x2c,%esp
  40141f:	e8 cd 05 00 00       	call   4019f1 <__x86.get_pc_thunk.cx>
  401424:	81 c1 10 3f 01 00    	add    $0x13f10,%ecx
  40142a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  40142d:	89 c7                	mov    %eax,%edi
  40142f:	89 d6                	mov    %edx,%esi
  401431:	8b 45 08             	mov    0x8(%ebp),%eax
  401434:	8b 55 0c             	mov    0xc(%ebp),%edx
  401437:	89 45 d0             	mov    %eax,-0x30(%ebp)
  40143a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  40143d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  401440:	bb 00 00 00 00       	mov    $0x0,%ebx
  401445:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  401448:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  40144b:	39 d3                	cmp    %edx,%ebx
  40144d:	72 09                	jb     401458 <printnum+0x42>
  40144f:	39 45 10             	cmp    %eax,0x10(%ebp)
  401452:	0f 87 83 00 00 00    	ja     4014db <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  401458:	83 ec 0c             	sub    $0xc,%esp
  40145b:	ff 75 18             	pushl  0x18(%ebp)
  40145e:	8b 45 14             	mov    0x14(%ebp),%eax
  401461:	8d 58 ff             	lea    -0x1(%eax),%ebx
  401464:	53                   	push   %ebx
  401465:	ff 75 10             	pushl  0x10(%ebp)
  401468:	83 ec 08             	sub    $0x8,%esp
  40146b:	ff 75 dc             	pushl  -0x24(%ebp)
  40146e:	ff 75 d8             	pushl  -0x28(%ebp)
  401471:	ff 75 d4             	pushl  -0x2c(%ebp)
  401474:	ff 75 d0             	pushl  -0x30(%ebp)
  401477:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  40147a:	e8 f1 09 00 00       	call   401e70 <__udivdi3>
  40147f:	83 c4 18             	add    $0x18,%esp
  401482:	52                   	push   %edx
  401483:	50                   	push   %eax
  401484:	89 f2                	mov    %esi,%edx
  401486:	89 f8                	mov    %edi,%eax
  401488:	e8 89 ff ff ff       	call   401416 <printnum>
  40148d:	83 c4 20             	add    $0x20,%esp
  401490:	eb 13                	jmp    4014a5 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  401492:	83 ec 08             	sub    $0x8,%esp
  401495:	56                   	push   %esi
  401496:	ff 75 18             	pushl  0x18(%ebp)
  401499:	ff d7                	call   *%edi
  40149b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  40149e:	83 eb 01             	sub    $0x1,%ebx
  4014a1:	85 db                	test   %ebx,%ebx
  4014a3:	7f ed                	jg     401492 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  4014a5:	83 ec 08             	sub    $0x8,%esp
  4014a8:	56                   	push   %esi
  4014a9:	83 ec 04             	sub    $0x4,%esp
  4014ac:	ff 75 dc             	pushl  -0x24(%ebp)
  4014af:	ff 75 d8             	pushl  -0x28(%ebp)
  4014b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  4014b5:	ff 75 d0             	pushl  -0x30(%ebp)
  4014b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  4014bb:	89 f3                	mov    %esi,%ebx
  4014bd:	e8 ce 0a 00 00       	call   401f90 <__umoddi3>
  4014c2:	83 c4 14             	add    $0x14,%esp
  4014c5:	0f be 84 06 64 d4 fe 	movsbl -0x12b9c(%esi,%eax,1),%eax
  4014cc:	ff 
  4014cd:	50                   	push   %eax
  4014ce:	ff d7                	call   *%edi
}
  4014d0:	83 c4 10             	add    $0x10,%esp
  4014d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  4014d6:	5b                   	pop    %ebx
  4014d7:	5e                   	pop    %esi
  4014d8:	5f                   	pop    %edi
  4014d9:	5d                   	pop    %ebp
  4014da:	c3                   	ret    
  4014db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  4014de:	eb be                	jmp    40149e <printnum+0x88>

004014e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  4014e0:	55                   	push   %ebp
  4014e1:	89 e5                	mov    %esp,%ebp
  4014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  4014e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  4014ea:	8b 10                	mov    (%eax),%edx
  4014ec:	3b 50 04             	cmp    0x4(%eax),%edx
  4014ef:	73 0a                	jae    4014fb <sprintputch+0x1b>
		*b->buf++ = ch;
  4014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  4014f4:	89 08                	mov    %ecx,(%eax)
  4014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  4014f9:	88 02                	mov    %al,(%edx)
}
  4014fb:	5d                   	pop    %ebp
  4014fc:	c3                   	ret    

004014fd <printfmt>:
{
  4014fd:	55                   	push   %ebp
  4014fe:	89 e5                	mov    %esp,%ebp
  401500:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  401503:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  401506:	50                   	push   %eax
  401507:	ff 75 10             	pushl  0x10(%ebp)
  40150a:	ff 75 0c             	pushl  0xc(%ebp)
  40150d:	ff 75 08             	pushl  0x8(%ebp)
  401510:	e8 05 00 00 00       	call   40151a <vprintfmt>
}
  401515:	83 c4 10             	add    $0x10,%esp
  401518:	c9                   	leave  
  401519:	c3                   	ret    

0040151a <vprintfmt>:
{
  40151a:	55                   	push   %ebp
  40151b:	89 e5                	mov    %esp,%ebp
  40151d:	57                   	push   %edi
  40151e:	56                   	push   %esi
  40151f:	53                   	push   %ebx
  401520:	83 ec 2c             	sub    $0x2c,%esp
  401523:	e8 3b ed ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  401528:	81 c3 0c 3e 01 00    	add    $0x13e0c,%ebx
  40152e:	8b 75 0c             	mov    0xc(%ebp),%esi
  401531:	8b 7d 10             	mov    0x10(%ebp),%edi
  401534:	e9 8e 03 00 00       	jmp    4018c7 <.L35+0x48>
		padc = ' ';
  401539:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  40153d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  401544:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  40154b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  401552:	b9 00 00 00 00       	mov    $0x0,%ecx
  401557:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  40155a:	8d 47 01             	lea    0x1(%edi),%eax
  40155d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  401560:	0f b6 17             	movzbl (%edi),%edx
  401563:	8d 42 dd             	lea    -0x23(%edx),%eax
  401566:	3c 55                	cmp    $0x55,%al
  401568:	0f 87 e1 03 00 00    	ja     40194f <.L22>
  40156e:	0f b6 c0             	movzbl %al,%eax
  401571:	89 d9                	mov    %ebx,%ecx
  401573:	03 8c 83 f0 d4 fe ff 	add    -0x12b10(%ebx,%eax,4),%ecx
  40157a:	ff e1                	jmp    *%ecx

0040157c <.L67>:
  40157c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  40157f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  401583:	eb d5                	jmp    40155a <vprintfmt+0x40>

00401585 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  401585:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  401588:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  40158c:	eb cc                	jmp    40155a <vprintfmt+0x40>

0040158e <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  40158e:	0f b6 d2             	movzbl %dl,%edx
  401591:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  401594:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  401599:	8d 04 80             	lea    (%eax,%eax,4),%eax
  40159c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  4015a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  4015a3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  4015a6:	83 f9 09             	cmp    $0x9,%ecx
  4015a9:	77 55                	ja     401600 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  4015ab:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  4015ae:	eb e9                	jmp    401599 <.L29+0xb>

004015b0 <.L26>:
			precision = va_arg(ap, int);
  4015b0:	8b 45 14             	mov    0x14(%ebp),%eax
  4015b3:	8b 00                	mov    (%eax),%eax
  4015b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  4015b8:	8b 45 14             	mov    0x14(%ebp),%eax
  4015bb:	8d 40 04             	lea    0x4(%eax),%eax
  4015be:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  4015c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  4015c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  4015c8:	79 90                	jns    40155a <vprintfmt+0x40>
				width = precision, precision = -1;
  4015ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  4015cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  4015d0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  4015d7:	eb 81                	jmp    40155a <vprintfmt+0x40>

004015d9 <.L27>:
  4015d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  4015dc:	85 c0                	test   %eax,%eax
  4015de:	ba 00 00 00 00       	mov    $0x0,%edx
  4015e3:	0f 49 d0             	cmovns %eax,%edx
  4015e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  4015e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  4015ec:	e9 69 ff ff ff       	jmp    40155a <vprintfmt+0x40>

004015f1 <.L23>:
  4015f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  4015f4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  4015fb:	e9 5a ff ff ff       	jmp    40155a <vprintfmt+0x40>
  401600:	89 45 d0             	mov    %eax,-0x30(%ebp)
  401603:	eb bf                	jmp    4015c4 <.L26+0x14>

00401605 <.L33>:
			lflag++;
  401605:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  401609:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  40160c:	e9 49 ff ff ff       	jmp    40155a <vprintfmt+0x40>

00401611 <.L30>:
			putch(va_arg(ap, int), putdat);
  401611:	8b 45 14             	mov    0x14(%ebp),%eax
  401614:	8d 78 04             	lea    0x4(%eax),%edi
  401617:	83 ec 08             	sub    $0x8,%esp
  40161a:	56                   	push   %esi
  40161b:	ff 30                	pushl  (%eax)
  40161d:	ff 55 08             	call   *0x8(%ebp)
			break;
  401620:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  401623:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  401626:	e9 99 02 00 00       	jmp    4018c4 <.L35+0x45>

0040162b <.L32>:
			err = va_arg(ap, int);
  40162b:	8b 45 14             	mov    0x14(%ebp),%eax
  40162e:	8d 78 04             	lea    0x4(%eax),%edi
  401631:	8b 00                	mov    (%eax),%eax
  401633:	99                   	cltd   
  401634:	31 d0                	xor    %edx,%eax
  401636:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  401638:	83 f8 06             	cmp    $0x6,%eax
  40163b:	7f 27                	jg     401664 <.L32+0x39>
  40163d:	8b 94 83 5c 1d 00 00 	mov    0x1d5c(%ebx,%eax,4),%edx
  401644:	85 d2                	test   %edx,%edx
  401646:	74 1c                	je     401664 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  401648:	52                   	push   %edx
  401649:	8d 83 68 d2 fe ff    	lea    -0x12d98(%ebx),%eax
  40164f:	50                   	push   %eax
  401650:	56                   	push   %esi
  401651:	ff 75 08             	pushl  0x8(%ebp)
  401654:	e8 a4 fe ff ff       	call   4014fd <printfmt>
  401659:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  40165c:	89 7d 14             	mov    %edi,0x14(%ebp)
  40165f:	e9 60 02 00 00       	jmp    4018c4 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  401664:	50                   	push   %eax
  401665:	8d 83 7c d4 fe ff    	lea    -0x12b84(%ebx),%eax
  40166b:	50                   	push   %eax
  40166c:	56                   	push   %esi
  40166d:	ff 75 08             	pushl  0x8(%ebp)
  401670:	e8 88 fe ff ff       	call   4014fd <printfmt>
  401675:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  401678:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  40167b:	e9 44 02 00 00       	jmp    4018c4 <.L35+0x45>

00401680 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  401680:	8b 45 14             	mov    0x14(%ebp),%eax
  401683:	83 c0 04             	add    $0x4,%eax
  401686:	89 45 cc             	mov    %eax,-0x34(%ebp)
  401689:	8b 45 14             	mov    0x14(%ebp),%eax
  40168c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  40168e:	85 ff                	test   %edi,%edi
  401690:	8d 83 75 d4 fe ff    	lea    -0x12b8b(%ebx),%eax
  401696:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  401699:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  40169d:	0f 8e b5 00 00 00    	jle    401758 <.L36+0xd8>
  4016a3:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  4016a7:	75 08                	jne    4016b1 <.L36+0x31>
  4016a9:	89 75 0c             	mov    %esi,0xc(%ebp)
  4016ac:	8b 75 d0             	mov    -0x30(%ebp),%esi
  4016af:	eb 6d                	jmp    40171e <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  4016b1:	83 ec 08             	sub    $0x8,%esp
  4016b4:	ff 75 d0             	pushl  -0x30(%ebp)
  4016b7:	57                   	push   %edi
  4016b8:	e8 4d 04 00 00       	call   401b0a <strnlen>
  4016bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  4016c0:	29 c2                	sub    %eax,%edx
  4016c2:	89 55 c8             	mov    %edx,-0x38(%ebp)
  4016c5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  4016c8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  4016cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  4016cf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  4016d2:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  4016d4:	eb 10                	jmp    4016e6 <.L36+0x66>
					putch(padc, putdat);
  4016d6:	83 ec 08             	sub    $0x8,%esp
  4016d9:	56                   	push   %esi
  4016da:	ff 75 e0             	pushl  -0x20(%ebp)
  4016dd:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  4016e0:	83 ef 01             	sub    $0x1,%edi
  4016e3:	83 c4 10             	add    $0x10,%esp
  4016e6:	85 ff                	test   %edi,%edi
  4016e8:	7f ec                	jg     4016d6 <.L36+0x56>
  4016ea:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  4016ed:	8b 55 c8             	mov    -0x38(%ebp),%edx
  4016f0:	85 d2                	test   %edx,%edx
  4016f2:	b8 00 00 00 00       	mov    $0x0,%eax
  4016f7:	0f 49 c2             	cmovns %edx,%eax
  4016fa:	29 c2                	sub    %eax,%edx
  4016fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  4016ff:	89 75 0c             	mov    %esi,0xc(%ebp)
  401702:	8b 75 d0             	mov    -0x30(%ebp),%esi
  401705:	eb 17                	jmp    40171e <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  401707:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  40170b:	75 30                	jne    40173d <.L36+0xbd>
					putch(ch, putdat);
  40170d:	83 ec 08             	sub    $0x8,%esp
  401710:	ff 75 0c             	pushl  0xc(%ebp)
  401713:	50                   	push   %eax
  401714:	ff 55 08             	call   *0x8(%ebp)
  401717:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  40171a:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  40171e:	83 c7 01             	add    $0x1,%edi
  401721:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  401725:	0f be c2             	movsbl %dl,%eax
  401728:	85 c0                	test   %eax,%eax
  40172a:	74 52                	je     40177e <.L36+0xfe>
  40172c:	85 f6                	test   %esi,%esi
  40172e:	78 d7                	js     401707 <.L36+0x87>
  401730:	83 ee 01             	sub    $0x1,%esi
  401733:	79 d2                	jns    401707 <.L36+0x87>
  401735:	8b 75 0c             	mov    0xc(%ebp),%esi
  401738:	8b 7d e0             	mov    -0x20(%ebp),%edi
  40173b:	eb 32                	jmp    40176f <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  40173d:	0f be d2             	movsbl %dl,%edx
  401740:	83 ea 20             	sub    $0x20,%edx
  401743:	83 fa 5e             	cmp    $0x5e,%edx
  401746:	76 c5                	jbe    40170d <.L36+0x8d>
					putch('?', putdat);
  401748:	83 ec 08             	sub    $0x8,%esp
  40174b:	ff 75 0c             	pushl  0xc(%ebp)
  40174e:	6a 3f                	push   $0x3f
  401750:	ff 55 08             	call   *0x8(%ebp)
  401753:	83 c4 10             	add    $0x10,%esp
  401756:	eb c2                	jmp    40171a <.L36+0x9a>
  401758:	89 75 0c             	mov    %esi,0xc(%ebp)
  40175b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  40175e:	eb be                	jmp    40171e <.L36+0x9e>
				putch(' ', putdat);
  401760:	83 ec 08             	sub    $0x8,%esp
  401763:	56                   	push   %esi
  401764:	6a 20                	push   $0x20
  401766:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  401769:	83 ef 01             	sub    $0x1,%edi
  40176c:	83 c4 10             	add    $0x10,%esp
  40176f:	85 ff                	test   %edi,%edi
  401771:	7f ed                	jg     401760 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  401773:	8b 45 cc             	mov    -0x34(%ebp),%eax
  401776:	89 45 14             	mov    %eax,0x14(%ebp)
  401779:	e9 46 01 00 00       	jmp    4018c4 <.L35+0x45>
  40177e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  401781:	8b 75 0c             	mov    0xc(%ebp),%esi
  401784:	eb e9                	jmp    40176f <.L36+0xef>

00401786 <.L31>:
  401786:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  401789:	83 f9 01             	cmp    $0x1,%ecx
  40178c:	7e 40                	jle    4017ce <.L31+0x48>
		return va_arg(*ap, long long);
  40178e:	8b 45 14             	mov    0x14(%ebp),%eax
  401791:	8b 50 04             	mov    0x4(%eax),%edx
  401794:	8b 00                	mov    (%eax),%eax
  401796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  401799:	89 55 dc             	mov    %edx,-0x24(%ebp)
  40179c:	8b 45 14             	mov    0x14(%ebp),%eax
  40179f:	8d 40 08             	lea    0x8(%eax),%eax
  4017a2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  4017a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  4017a9:	79 55                	jns    401800 <.L31+0x7a>
				putch('-', putdat);
  4017ab:	83 ec 08             	sub    $0x8,%esp
  4017ae:	56                   	push   %esi
  4017af:	6a 2d                	push   $0x2d
  4017b1:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  4017b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  4017b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  4017ba:	f7 da                	neg    %edx
  4017bc:	83 d1 00             	adc    $0x0,%ecx
  4017bf:	f7 d9                	neg    %ecx
  4017c1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  4017c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  4017c9:	e9 db 00 00 00       	jmp    4018a9 <.L35+0x2a>
	else if (lflag)
  4017ce:	85 c9                	test   %ecx,%ecx
  4017d0:	75 17                	jne    4017e9 <.L31+0x63>
		return va_arg(*ap, int);
  4017d2:	8b 45 14             	mov    0x14(%ebp),%eax
  4017d5:	8b 00                	mov    (%eax),%eax
  4017d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  4017da:	99                   	cltd   
  4017db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  4017de:	8b 45 14             	mov    0x14(%ebp),%eax
  4017e1:	8d 40 04             	lea    0x4(%eax),%eax
  4017e4:	89 45 14             	mov    %eax,0x14(%ebp)
  4017e7:	eb bc                	jmp    4017a5 <.L31+0x1f>
		return va_arg(*ap, long);
  4017e9:	8b 45 14             	mov    0x14(%ebp),%eax
  4017ec:	8b 00                	mov    (%eax),%eax
  4017ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  4017f1:	99                   	cltd   
  4017f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  4017f5:	8b 45 14             	mov    0x14(%ebp),%eax
  4017f8:	8d 40 04             	lea    0x4(%eax),%eax
  4017fb:	89 45 14             	mov    %eax,0x14(%ebp)
  4017fe:	eb a5                	jmp    4017a5 <.L31+0x1f>
			num = getint(&ap, lflag);
  401800:	8b 55 d8             	mov    -0x28(%ebp),%edx
  401803:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  401806:	b8 0a 00 00 00       	mov    $0xa,%eax
  40180b:	e9 99 00 00 00       	jmp    4018a9 <.L35+0x2a>

00401810 <.L37>:
  401810:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  401813:	83 f9 01             	cmp    $0x1,%ecx
  401816:	7e 15                	jle    40182d <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
  401818:	8b 45 14             	mov    0x14(%ebp),%eax
  40181b:	8b 10                	mov    (%eax),%edx
  40181d:	8b 48 04             	mov    0x4(%eax),%ecx
  401820:	8d 40 08             	lea    0x8(%eax),%eax
  401823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  401826:	b8 0a 00 00 00       	mov    $0xa,%eax
  40182b:	eb 7c                	jmp    4018a9 <.L35+0x2a>
	else if (lflag)
  40182d:	85 c9                	test   %ecx,%ecx
  40182f:	75 17                	jne    401848 <.L37+0x38>
		return va_arg(*ap, unsigned int);
  401831:	8b 45 14             	mov    0x14(%ebp),%eax
  401834:	8b 10                	mov    (%eax),%edx
  401836:	b9 00 00 00 00       	mov    $0x0,%ecx
  40183b:	8d 40 04             	lea    0x4(%eax),%eax
  40183e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  401841:	b8 0a 00 00 00       	mov    $0xa,%eax
  401846:	eb 61                	jmp    4018a9 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  401848:	8b 45 14             	mov    0x14(%ebp),%eax
  40184b:	8b 10                	mov    (%eax),%edx
  40184d:	b9 00 00 00 00       	mov    $0x0,%ecx
  401852:	8d 40 04             	lea    0x4(%eax),%eax
  401855:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  401858:	b8 0a 00 00 00       	mov    $0xa,%eax
  40185d:	eb 4a                	jmp    4018a9 <.L35+0x2a>

0040185f <.L34>:
			putch('X', putdat);
  40185f:	83 ec 08             	sub    $0x8,%esp
  401862:	56                   	push   %esi
  401863:	6a 58                	push   $0x58
  401865:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  401868:	83 c4 08             	add    $0x8,%esp
  40186b:	56                   	push   %esi
  40186c:	6a 58                	push   $0x58
  40186e:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  401871:	83 c4 08             	add    $0x8,%esp
  401874:	56                   	push   %esi
  401875:	6a 58                	push   $0x58
  401877:	ff 55 08             	call   *0x8(%ebp)
			break;
  40187a:	83 c4 10             	add    $0x10,%esp
  40187d:	eb 45                	jmp    4018c4 <.L35+0x45>

0040187f <.L35>:
			putch('0', putdat);
  40187f:	83 ec 08             	sub    $0x8,%esp
  401882:	56                   	push   %esi
  401883:	6a 30                	push   $0x30
  401885:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  401888:	83 c4 08             	add    $0x8,%esp
  40188b:	56                   	push   %esi
  40188c:	6a 78                	push   $0x78
  40188e:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  401891:	8b 45 14             	mov    0x14(%ebp),%eax
  401894:	8b 10                	mov    (%eax),%edx
  401896:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  40189b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  40189e:	8d 40 04             	lea    0x4(%eax),%eax
  4018a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  4018a4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  4018a9:	83 ec 0c             	sub    $0xc,%esp
  4018ac:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  4018b0:	57                   	push   %edi
  4018b1:	ff 75 e0             	pushl  -0x20(%ebp)
  4018b4:	50                   	push   %eax
  4018b5:	51                   	push   %ecx
  4018b6:	52                   	push   %edx
  4018b7:	89 f2                	mov    %esi,%edx
  4018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  4018bc:	e8 55 fb ff ff       	call   401416 <printnum>
			break;
  4018c1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  4018c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  4018c7:	83 c7 01             	add    $0x1,%edi
  4018ca:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  4018ce:	83 f8 25             	cmp    $0x25,%eax
  4018d1:	0f 84 62 fc ff ff    	je     401539 <vprintfmt+0x1f>
			if (ch == '\0')
  4018d7:	85 c0                	test   %eax,%eax
  4018d9:	0f 84 91 00 00 00    	je     401970 <.L22+0x21>
			putch(ch, putdat);
  4018df:	83 ec 08             	sub    $0x8,%esp
  4018e2:	56                   	push   %esi
  4018e3:	50                   	push   %eax
  4018e4:	ff 55 08             	call   *0x8(%ebp)
  4018e7:	83 c4 10             	add    $0x10,%esp
  4018ea:	eb db                	jmp    4018c7 <.L35+0x48>

004018ec <.L38>:
  4018ec:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  4018ef:	83 f9 01             	cmp    $0x1,%ecx
  4018f2:	7e 15                	jle    401909 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  4018f4:	8b 45 14             	mov    0x14(%ebp),%eax
  4018f7:	8b 10                	mov    (%eax),%edx
  4018f9:	8b 48 04             	mov    0x4(%eax),%ecx
  4018fc:	8d 40 08             	lea    0x8(%eax),%eax
  4018ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  401902:	b8 10 00 00 00       	mov    $0x10,%eax
  401907:	eb a0                	jmp    4018a9 <.L35+0x2a>
	else if (lflag)
  401909:	85 c9                	test   %ecx,%ecx
  40190b:	75 17                	jne    401924 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  40190d:	8b 45 14             	mov    0x14(%ebp),%eax
  401910:	8b 10                	mov    (%eax),%edx
  401912:	b9 00 00 00 00       	mov    $0x0,%ecx
  401917:	8d 40 04             	lea    0x4(%eax),%eax
  40191a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  40191d:	b8 10 00 00 00       	mov    $0x10,%eax
  401922:	eb 85                	jmp    4018a9 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  401924:	8b 45 14             	mov    0x14(%ebp),%eax
  401927:	8b 10                	mov    (%eax),%edx
  401929:	b9 00 00 00 00       	mov    $0x0,%ecx
  40192e:	8d 40 04             	lea    0x4(%eax),%eax
  401931:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  401934:	b8 10 00 00 00       	mov    $0x10,%eax
  401939:	e9 6b ff ff ff       	jmp    4018a9 <.L35+0x2a>

0040193e <.L25>:
			putch(ch, putdat);
  40193e:	83 ec 08             	sub    $0x8,%esp
  401941:	56                   	push   %esi
  401942:	6a 25                	push   $0x25
  401944:	ff 55 08             	call   *0x8(%ebp)
			break;
  401947:	83 c4 10             	add    $0x10,%esp
  40194a:	e9 75 ff ff ff       	jmp    4018c4 <.L35+0x45>

0040194f <.L22>:
			putch('%', putdat);
  40194f:	83 ec 08             	sub    $0x8,%esp
  401952:	56                   	push   %esi
  401953:	6a 25                	push   $0x25
  401955:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  401958:	83 c4 10             	add    $0x10,%esp
  40195b:	89 f8                	mov    %edi,%eax
  40195d:	eb 03                	jmp    401962 <.L22+0x13>
  40195f:	83 e8 01             	sub    $0x1,%eax
  401962:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  401966:	75 f7                	jne    40195f <.L22+0x10>
  401968:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  40196b:	e9 54 ff ff ff       	jmp    4018c4 <.L35+0x45>
}
  401970:	8d 65 f4             	lea    -0xc(%ebp),%esp
  401973:	5b                   	pop    %ebx
  401974:	5e                   	pop    %esi
  401975:	5f                   	pop    %edi
  401976:	5d                   	pop    %ebp
  401977:	c3                   	ret    

00401978 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  401978:	55                   	push   %ebp
  401979:	89 e5                	mov    %esp,%ebp
  40197b:	53                   	push   %ebx
  40197c:	83 ec 14             	sub    $0x14,%esp
  40197f:	e8 df e8 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  401984:	81 c3 b0 39 01 00    	add    $0x139b0,%ebx
  40198a:	8b 45 08             	mov    0x8(%ebp),%eax
  40198d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  401990:	89 45 ec             	mov    %eax,-0x14(%ebp)
  401993:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  401997:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  40199a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  4019a1:	85 c0                	test   %eax,%eax
  4019a3:	74 2b                	je     4019d0 <vsnprintf+0x58>
  4019a5:	85 d2                	test   %edx,%edx
  4019a7:	7e 27                	jle    4019d0 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  4019a9:	ff 75 14             	pushl  0x14(%ebp)
  4019ac:	ff 75 10             	pushl  0x10(%ebp)
  4019af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  4019b2:	50                   	push   %eax
  4019b3:	8d 83 ac c1 fe ff    	lea    -0x13e54(%ebx),%eax
  4019b9:	50                   	push   %eax
  4019ba:	e8 5b fb ff ff       	call   40151a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  4019bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  4019c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  4019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4019c8:	83 c4 10             	add    $0x10,%esp
}
  4019cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4019ce:	c9                   	leave  
  4019cf:	c3                   	ret    
		return -E_INVAL;
  4019d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  4019d5:	eb f4                	jmp    4019cb <vsnprintf+0x53>

004019d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  4019d7:	55                   	push   %ebp
  4019d8:	89 e5                	mov    %esp,%ebp
  4019da:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  4019dd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  4019e0:	50                   	push   %eax
  4019e1:	ff 75 10             	pushl  0x10(%ebp)
  4019e4:	ff 75 0c             	pushl  0xc(%ebp)
  4019e7:	ff 75 08             	pushl  0x8(%ebp)
  4019ea:	e8 89 ff ff ff       	call   401978 <vsnprintf>
	va_end(ap);

	return rc;
}
  4019ef:	c9                   	leave  
  4019f0:	c3                   	ret    

004019f1 <__x86.get_pc_thunk.cx>:
  4019f1:	8b 0c 24             	mov    (%esp),%ecx
  4019f4:	c3                   	ret    

004019f5 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  4019f5:	55                   	push   %ebp
  4019f6:	89 e5                	mov    %esp,%ebp
  4019f8:	57                   	push   %edi
  4019f9:	56                   	push   %esi
  4019fa:	53                   	push   %ebx
  4019fb:	83 ec 1c             	sub    $0x1c,%esp
  4019fe:	e8 60 e8 ff ff       	call   400263 <__x86.get_pc_thunk.bx>
  401a03:	81 c3 31 39 01 00    	add    $0x13931,%ebx
  401a09:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
  401a0c:	85 c0                	test   %eax,%eax
  401a0e:	74 13                	je     401a23 <readline+0x2e>
		cprintf("%s", prompt);
  401a10:	83 ec 08             	sub    $0x8,%esp
  401a13:	50                   	push   %eax
  401a14:	8d 83 68 d2 fe ff    	lea    -0x12d98(%ebx),%eax
  401a1a:	50                   	push   %eax
  401a1b:	e8 db ee ff ff       	call   4008fb <cprintf>
  401a20:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
  401a23:	83 ec 0c             	sub    $0xc,%esp
  401a26:	6a 00                	push   $0x0
  401a28:	e8 ce ed ff ff       	call   4007fb <iscons>
  401a2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  401a30:	83 c4 10             	add    $0x10,%esp
	i = 0;
  401a33:	bf 00 00 00 00       	mov    $0x0,%edi
  401a38:	eb 46                	jmp    401a80 <readline+0x8b>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
  401a3a:	83 ec 08             	sub    $0x8,%esp
  401a3d:	50                   	push   %eax
  401a3e:	8d 83 48 d6 fe ff    	lea    -0x129b8(%ebx),%eax
  401a44:	50                   	push   %eax
  401a45:	e8 b1 ee ff ff       	call   4008fb <cprintf>
			return NULL;
  401a4a:	83 c4 10             	add    $0x10,%esp
  401a4d:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  401a52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  401a55:	5b                   	pop    %ebx
  401a56:	5e                   	pop    %esi
  401a57:	5f                   	pop    %edi
  401a58:	5d                   	pop    %ebp
  401a59:	c3                   	ret    
			if (echoing)
  401a5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  401a5e:	75 05                	jne    401a65 <readline+0x70>
			i--;
  401a60:	83 ef 01             	sub    $0x1,%edi
  401a63:	eb 1b                	jmp    401a80 <readline+0x8b>
				cputchar('\b');
  401a65:	83 ec 0c             	sub    $0xc,%esp
  401a68:	6a 08                	push   $0x8
  401a6a:	e8 6b ed ff ff       	call   4007da <cputchar>
  401a6f:	83 c4 10             	add    $0x10,%esp
  401a72:	eb ec                	jmp    401a60 <readline+0x6b>
			buf[i++] = c;
  401a74:	89 f0                	mov    %esi,%eax
  401a76:	88 84 3b 6c 28 00 00 	mov    %al,0x286c(%ebx,%edi,1)
  401a7d:	8d 7f 01             	lea    0x1(%edi),%edi
		c = getchar();
  401a80:	e8 65 ed ff ff       	call   4007ea <getchar>
  401a85:	89 c6                	mov    %eax,%esi
		if (c < 0) {
  401a87:	85 c0                	test   %eax,%eax
  401a89:	78 af                	js     401a3a <readline+0x45>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  401a8b:	83 f8 08             	cmp    $0x8,%eax
  401a8e:	0f 94 c2             	sete   %dl
  401a91:	83 f8 7f             	cmp    $0x7f,%eax
  401a94:	0f 94 c0             	sete   %al
  401a97:	08 c2                	or     %al,%dl
  401a99:	74 04                	je     401a9f <readline+0xaa>
  401a9b:	85 ff                	test   %edi,%edi
  401a9d:	7f bb                	jg     401a5a <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
  401a9f:	83 fe 1f             	cmp    $0x1f,%esi
  401aa2:	7e 1c                	jle    401ac0 <readline+0xcb>
  401aa4:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
  401aaa:	7f 14                	jg     401ac0 <readline+0xcb>
			if (echoing)
  401aac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  401ab0:	74 c2                	je     401a74 <readline+0x7f>
				cputchar(c);
  401ab2:	83 ec 0c             	sub    $0xc,%esp
  401ab5:	56                   	push   %esi
  401ab6:	e8 1f ed ff ff       	call   4007da <cputchar>
  401abb:	83 c4 10             	add    $0x10,%esp
  401abe:	eb b4                	jmp    401a74 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  401ac0:	83 fe 0a             	cmp    $0xa,%esi
  401ac3:	74 05                	je     401aca <readline+0xd5>
  401ac5:	83 fe 0d             	cmp    $0xd,%esi
  401ac8:	75 b6                	jne    401a80 <readline+0x8b>
			if (echoing)
  401aca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  401ace:	75 13                	jne    401ae3 <readline+0xee>
			buf[i] = 0;
  401ad0:	c6 84 3b 6c 28 00 00 	movb   $0x0,0x286c(%ebx,%edi,1)
  401ad7:	00 
			return buf;
  401ad8:	8d 83 6c 28 00 00    	lea    0x286c(%ebx),%eax
  401ade:	e9 6f ff ff ff       	jmp    401a52 <readline+0x5d>
				cputchar('\n');
  401ae3:	83 ec 0c             	sub    $0xc,%esp
  401ae6:	6a 0a                	push   $0xa
  401ae8:	e8 ed ec ff ff       	call   4007da <cputchar>
  401aed:	83 c4 10             	add    $0x10,%esp
  401af0:	eb de                	jmp    401ad0 <readline+0xdb>

00401af2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  401af2:	55                   	push   %ebp
  401af3:	89 e5                	mov    %esp,%ebp
  401af5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  401af8:	b8 00 00 00 00       	mov    $0x0,%eax
  401afd:	eb 03                	jmp    401b02 <strlen+0x10>
		n++;
  401aff:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  401b02:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  401b06:	75 f7                	jne    401aff <strlen+0xd>
	return n;
}
  401b08:	5d                   	pop    %ebp
  401b09:	c3                   	ret    

00401b0a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  401b0a:	55                   	push   %ebp
  401b0b:	89 e5                	mov    %esp,%ebp
  401b0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  401b10:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  401b13:	b8 00 00 00 00       	mov    $0x0,%eax
  401b18:	eb 03                	jmp    401b1d <strnlen+0x13>
		n++;
  401b1a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  401b1d:	39 d0                	cmp    %edx,%eax
  401b1f:	74 06                	je     401b27 <strnlen+0x1d>
  401b21:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  401b25:	75 f3                	jne    401b1a <strnlen+0x10>
	return n;
}
  401b27:	5d                   	pop    %ebp
  401b28:	c3                   	ret    

00401b29 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  401b29:	55                   	push   %ebp
  401b2a:	89 e5                	mov    %esp,%ebp
  401b2c:	53                   	push   %ebx
  401b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  401b30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  401b33:	89 c2                	mov    %eax,%edx
  401b35:	83 c1 01             	add    $0x1,%ecx
  401b38:	83 c2 01             	add    $0x1,%edx
  401b3b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  401b3f:	88 5a ff             	mov    %bl,-0x1(%edx)
  401b42:	84 db                	test   %bl,%bl
  401b44:	75 ef                	jne    401b35 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  401b46:	5b                   	pop    %ebx
  401b47:	5d                   	pop    %ebp
  401b48:	c3                   	ret    

00401b49 <strcat>:

char *
strcat(char *dst, const char *src)
{
  401b49:	55                   	push   %ebp
  401b4a:	89 e5                	mov    %esp,%ebp
  401b4c:	53                   	push   %ebx
  401b4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  401b50:	53                   	push   %ebx
  401b51:	e8 9c ff ff ff       	call   401af2 <strlen>
  401b56:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  401b59:	ff 75 0c             	pushl  0xc(%ebp)
  401b5c:	01 d8                	add    %ebx,%eax
  401b5e:	50                   	push   %eax
  401b5f:	e8 c5 ff ff ff       	call   401b29 <strcpy>
	return dst;
}
  401b64:	89 d8                	mov    %ebx,%eax
  401b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  401b69:	c9                   	leave  
  401b6a:	c3                   	ret    

00401b6b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  401b6b:	55                   	push   %ebp
  401b6c:	89 e5                	mov    %esp,%ebp
  401b6e:	56                   	push   %esi
  401b6f:	53                   	push   %ebx
  401b70:	8b 75 08             	mov    0x8(%ebp),%esi
  401b73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  401b76:	89 f3                	mov    %esi,%ebx
  401b78:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  401b7b:	89 f2                	mov    %esi,%edx
  401b7d:	eb 0f                	jmp    401b8e <strncpy+0x23>
		*dst++ = *src;
  401b7f:	83 c2 01             	add    $0x1,%edx
  401b82:	0f b6 01             	movzbl (%ecx),%eax
  401b85:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  401b88:	80 39 01             	cmpb   $0x1,(%ecx)
  401b8b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  401b8e:	39 da                	cmp    %ebx,%edx
  401b90:	75 ed                	jne    401b7f <strncpy+0x14>
	}
	return ret;
}
  401b92:	89 f0                	mov    %esi,%eax
  401b94:	5b                   	pop    %ebx
  401b95:	5e                   	pop    %esi
  401b96:	5d                   	pop    %ebp
  401b97:	c3                   	ret    

00401b98 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  401b98:	55                   	push   %ebp
  401b99:	89 e5                	mov    %esp,%ebp
  401b9b:	56                   	push   %esi
  401b9c:	53                   	push   %ebx
  401b9d:	8b 75 08             	mov    0x8(%ebp),%esi
  401ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  401ba3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  401ba6:	89 f0                	mov    %esi,%eax
  401ba8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  401bac:	85 c9                	test   %ecx,%ecx
  401bae:	75 0b                	jne    401bbb <strlcpy+0x23>
  401bb0:	eb 17                	jmp    401bc9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  401bb2:	83 c2 01             	add    $0x1,%edx
  401bb5:	83 c0 01             	add    $0x1,%eax
  401bb8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  401bbb:	39 d8                	cmp    %ebx,%eax
  401bbd:	74 07                	je     401bc6 <strlcpy+0x2e>
  401bbf:	0f b6 0a             	movzbl (%edx),%ecx
  401bc2:	84 c9                	test   %cl,%cl
  401bc4:	75 ec                	jne    401bb2 <strlcpy+0x1a>
		*dst = '\0';
  401bc6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  401bc9:	29 f0                	sub    %esi,%eax
}
  401bcb:	5b                   	pop    %ebx
  401bcc:	5e                   	pop    %esi
  401bcd:	5d                   	pop    %ebp
  401bce:	c3                   	ret    

00401bcf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  401bcf:	55                   	push   %ebp
  401bd0:	89 e5                	mov    %esp,%ebp
  401bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  401bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  401bd8:	eb 06                	jmp    401be0 <strcmp+0x11>
		p++, q++;
  401bda:	83 c1 01             	add    $0x1,%ecx
  401bdd:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  401be0:	0f b6 01             	movzbl (%ecx),%eax
  401be3:	84 c0                	test   %al,%al
  401be5:	74 04                	je     401beb <strcmp+0x1c>
  401be7:	3a 02                	cmp    (%edx),%al
  401be9:	74 ef                	je     401bda <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  401beb:	0f b6 c0             	movzbl %al,%eax
  401bee:	0f b6 12             	movzbl (%edx),%edx
  401bf1:	29 d0                	sub    %edx,%eax
}
  401bf3:	5d                   	pop    %ebp
  401bf4:	c3                   	ret    

00401bf5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  401bf5:	55                   	push   %ebp
  401bf6:	89 e5                	mov    %esp,%ebp
  401bf8:	53                   	push   %ebx
  401bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  401bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  401bff:	89 c3                	mov    %eax,%ebx
  401c01:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  401c04:	eb 06                	jmp    401c0c <strncmp+0x17>
		n--, p++, q++;
  401c06:	83 c0 01             	add    $0x1,%eax
  401c09:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  401c0c:	39 d8                	cmp    %ebx,%eax
  401c0e:	74 16                	je     401c26 <strncmp+0x31>
  401c10:	0f b6 08             	movzbl (%eax),%ecx
  401c13:	84 c9                	test   %cl,%cl
  401c15:	74 04                	je     401c1b <strncmp+0x26>
  401c17:	3a 0a                	cmp    (%edx),%cl
  401c19:	74 eb                	je     401c06 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  401c1b:	0f b6 00             	movzbl (%eax),%eax
  401c1e:	0f b6 12             	movzbl (%edx),%edx
  401c21:	29 d0                	sub    %edx,%eax
}
  401c23:	5b                   	pop    %ebx
  401c24:	5d                   	pop    %ebp
  401c25:	c3                   	ret    
		return 0;
  401c26:	b8 00 00 00 00       	mov    $0x0,%eax
  401c2b:	eb f6                	jmp    401c23 <strncmp+0x2e>

00401c2d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  401c2d:	55                   	push   %ebp
  401c2e:	89 e5                	mov    %esp,%ebp
  401c30:	8b 45 08             	mov    0x8(%ebp),%eax
  401c33:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  401c37:	0f b6 10             	movzbl (%eax),%edx
  401c3a:	84 d2                	test   %dl,%dl
  401c3c:	74 09                	je     401c47 <strchr+0x1a>
		if (*s == c)
  401c3e:	38 ca                	cmp    %cl,%dl
  401c40:	74 0a                	je     401c4c <strchr+0x1f>
	for (; *s; s++)
  401c42:	83 c0 01             	add    $0x1,%eax
  401c45:	eb f0                	jmp    401c37 <strchr+0xa>
			return (char *) s;
	return 0;
  401c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401c4c:	5d                   	pop    %ebp
  401c4d:	c3                   	ret    

00401c4e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  401c4e:	55                   	push   %ebp
  401c4f:	89 e5                	mov    %esp,%ebp
  401c51:	8b 45 08             	mov    0x8(%ebp),%eax
  401c54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  401c58:	eb 03                	jmp    401c5d <strfind+0xf>
  401c5a:	83 c0 01             	add    $0x1,%eax
  401c5d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  401c60:	38 ca                	cmp    %cl,%dl
  401c62:	74 04                	je     401c68 <strfind+0x1a>
  401c64:	84 d2                	test   %dl,%dl
  401c66:	75 f2                	jne    401c5a <strfind+0xc>
			break;
	return (char *) s;
}
  401c68:	5d                   	pop    %ebp
  401c69:	c3                   	ret    

00401c6a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  401c6a:	55                   	push   %ebp
  401c6b:	89 e5                	mov    %esp,%ebp
  401c6d:	57                   	push   %edi
  401c6e:	56                   	push   %esi
  401c6f:	53                   	push   %ebx
  401c70:	8b 7d 08             	mov    0x8(%ebp),%edi
  401c73:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  401c76:	85 c9                	test   %ecx,%ecx
  401c78:	74 13                	je     401c8d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  401c7a:	f7 c7 03 00 00 00    	test   $0x3,%edi
  401c80:	75 05                	jne    401c87 <memset+0x1d>
  401c82:	f6 c1 03             	test   $0x3,%cl
  401c85:	74 0d                	je     401c94 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  401c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  401c8a:	fc                   	cld    
  401c8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  401c8d:	89 f8                	mov    %edi,%eax
  401c8f:	5b                   	pop    %ebx
  401c90:	5e                   	pop    %esi
  401c91:	5f                   	pop    %edi
  401c92:	5d                   	pop    %ebp
  401c93:	c3                   	ret    
		c &= 0xFF;
  401c94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  401c98:	89 d3                	mov    %edx,%ebx
  401c9a:	c1 e3 08             	shl    $0x8,%ebx
  401c9d:	89 d0                	mov    %edx,%eax
  401c9f:	c1 e0 18             	shl    $0x18,%eax
  401ca2:	89 d6                	mov    %edx,%esi
  401ca4:	c1 e6 10             	shl    $0x10,%esi
  401ca7:	09 f0                	or     %esi,%eax
  401ca9:	09 c2                	or     %eax,%edx
  401cab:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  401cad:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  401cb0:	89 d0                	mov    %edx,%eax
  401cb2:	fc                   	cld    
  401cb3:	f3 ab                	rep stos %eax,%es:(%edi)
  401cb5:	eb d6                	jmp    401c8d <memset+0x23>

00401cb7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  401cb7:	55                   	push   %ebp
  401cb8:	89 e5                	mov    %esp,%ebp
  401cba:	57                   	push   %edi
  401cbb:	56                   	push   %esi
  401cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  401cbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  401cc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  401cc5:	39 c6                	cmp    %eax,%esi
  401cc7:	73 35                	jae    401cfe <memmove+0x47>
  401cc9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  401ccc:	39 c2                	cmp    %eax,%edx
  401cce:	76 2e                	jbe    401cfe <memmove+0x47>
		s += n;
		d += n;
  401cd0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401cd3:	89 d6                	mov    %edx,%esi
  401cd5:	09 fe                	or     %edi,%esi
  401cd7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  401cdd:	74 0c                	je     401ceb <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  401cdf:	83 ef 01             	sub    $0x1,%edi
  401ce2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  401ce5:	fd                   	std    
  401ce6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  401ce8:	fc                   	cld    
  401ce9:	eb 21                	jmp    401d0c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401ceb:	f6 c1 03             	test   $0x3,%cl
  401cee:	75 ef                	jne    401cdf <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  401cf0:	83 ef 04             	sub    $0x4,%edi
  401cf3:	8d 72 fc             	lea    -0x4(%edx),%esi
  401cf6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  401cf9:	fd                   	std    
  401cfa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  401cfc:	eb ea                	jmp    401ce8 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401cfe:	89 f2                	mov    %esi,%edx
  401d00:	09 c2                	or     %eax,%edx
  401d02:	f6 c2 03             	test   $0x3,%dl
  401d05:	74 09                	je     401d10 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  401d07:	89 c7                	mov    %eax,%edi
  401d09:	fc                   	cld    
  401d0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  401d0c:	5e                   	pop    %esi
  401d0d:	5f                   	pop    %edi
  401d0e:	5d                   	pop    %ebp
  401d0f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  401d10:	f6 c1 03             	test   $0x3,%cl
  401d13:	75 f2                	jne    401d07 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  401d15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  401d18:	89 c7                	mov    %eax,%edi
  401d1a:	fc                   	cld    
  401d1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  401d1d:	eb ed                	jmp    401d0c <memmove+0x55>

00401d1f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  401d1f:	55                   	push   %ebp
  401d20:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  401d22:	ff 75 10             	pushl  0x10(%ebp)
  401d25:	ff 75 0c             	pushl  0xc(%ebp)
  401d28:	ff 75 08             	pushl  0x8(%ebp)
  401d2b:	e8 87 ff ff ff       	call   401cb7 <memmove>
}
  401d30:	c9                   	leave  
  401d31:	c3                   	ret    

00401d32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  401d32:	55                   	push   %ebp
  401d33:	89 e5                	mov    %esp,%ebp
  401d35:	56                   	push   %esi
  401d36:	53                   	push   %ebx
  401d37:	8b 45 08             	mov    0x8(%ebp),%eax
  401d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  401d3d:	89 c6                	mov    %eax,%esi
  401d3f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  401d42:	39 f0                	cmp    %esi,%eax
  401d44:	74 1c                	je     401d62 <memcmp+0x30>
		if (*s1 != *s2)
  401d46:	0f b6 08             	movzbl (%eax),%ecx
  401d49:	0f b6 1a             	movzbl (%edx),%ebx
  401d4c:	38 d9                	cmp    %bl,%cl
  401d4e:	75 08                	jne    401d58 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  401d50:	83 c0 01             	add    $0x1,%eax
  401d53:	83 c2 01             	add    $0x1,%edx
  401d56:	eb ea                	jmp    401d42 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  401d58:	0f b6 c1             	movzbl %cl,%eax
  401d5b:	0f b6 db             	movzbl %bl,%ebx
  401d5e:	29 d8                	sub    %ebx,%eax
  401d60:	eb 05                	jmp    401d67 <memcmp+0x35>
	}

	return 0;
  401d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  401d67:	5b                   	pop    %ebx
  401d68:	5e                   	pop    %esi
  401d69:	5d                   	pop    %ebp
  401d6a:	c3                   	ret    

00401d6b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  401d6b:	55                   	push   %ebp
  401d6c:	89 e5                	mov    %esp,%ebp
  401d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  401d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  401d74:	89 c2                	mov    %eax,%edx
  401d76:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  401d79:	39 d0                	cmp    %edx,%eax
  401d7b:	73 09                	jae    401d86 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  401d7d:	38 08                	cmp    %cl,(%eax)
  401d7f:	74 05                	je     401d86 <memfind+0x1b>
	for (; s < ends; s++)
  401d81:	83 c0 01             	add    $0x1,%eax
  401d84:	eb f3                	jmp    401d79 <memfind+0xe>
			break;
	return (void *) s;
}
  401d86:	5d                   	pop    %ebp
  401d87:	c3                   	ret    

00401d88 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  401d88:	55                   	push   %ebp
  401d89:	89 e5                	mov    %esp,%ebp
  401d8b:	57                   	push   %edi
  401d8c:	56                   	push   %esi
  401d8d:	53                   	push   %ebx
  401d8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  401d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  401d94:	eb 03                	jmp    401d99 <strtol+0x11>
		s++;
  401d96:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  401d99:	0f b6 01             	movzbl (%ecx),%eax
  401d9c:	3c 20                	cmp    $0x20,%al
  401d9e:	74 f6                	je     401d96 <strtol+0xe>
  401da0:	3c 09                	cmp    $0x9,%al
  401da2:	74 f2                	je     401d96 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  401da4:	3c 2b                	cmp    $0x2b,%al
  401da6:	74 2e                	je     401dd6 <strtol+0x4e>
	int neg = 0;
  401da8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  401dad:	3c 2d                	cmp    $0x2d,%al
  401daf:	74 2f                	je     401de0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  401db1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  401db7:	75 05                	jne    401dbe <strtol+0x36>
  401db9:	80 39 30             	cmpb   $0x30,(%ecx)
  401dbc:	74 2c                	je     401dea <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  401dbe:	85 db                	test   %ebx,%ebx
  401dc0:	75 0a                	jne    401dcc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  401dc2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  401dc7:	80 39 30             	cmpb   $0x30,(%ecx)
  401dca:	74 28                	je     401df4 <strtol+0x6c>
		base = 10;
  401dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  401dd1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  401dd4:	eb 50                	jmp    401e26 <strtol+0x9e>
		s++;
  401dd6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  401dd9:	bf 00 00 00 00       	mov    $0x0,%edi
  401dde:	eb d1                	jmp    401db1 <strtol+0x29>
		s++, neg = 1;
  401de0:	83 c1 01             	add    $0x1,%ecx
  401de3:	bf 01 00 00 00       	mov    $0x1,%edi
  401de8:	eb c7                	jmp    401db1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  401dea:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  401dee:	74 0e                	je     401dfe <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  401df0:	85 db                	test   %ebx,%ebx
  401df2:	75 d8                	jne    401dcc <strtol+0x44>
		s++, base = 8;
  401df4:	83 c1 01             	add    $0x1,%ecx
  401df7:	bb 08 00 00 00       	mov    $0x8,%ebx
  401dfc:	eb ce                	jmp    401dcc <strtol+0x44>
		s += 2, base = 16;
  401dfe:	83 c1 02             	add    $0x2,%ecx
  401e01:	bb 10 00 00 00       	mov    $0x10,%ebx
  401e06:	eb c4                	jmp    401dcc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  401e08:	8d 72 9f             	lea    -0x61(%edx),%esi
  401e0b:	89 f3                	mov    %esi,%ebx
  401e0d:	80 fb 19             	cmp    $0x19,%bl
  401e10:	77 29                	ja     401e3b <strtol+0xb3>
			dig = *s - 'a' + 10;
  401e12:	0f be d2             	movsbl %dl,%edx
  401e15:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  401e18:	3b 55 10             	cmp    0x10(%ebp),%edx
  401e1b:	7d 30                	jge    401e4d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  401e1d:	83 c1 01             	add    $0x1,%ecx
  401e20:	0f af 45 10          	imul   0x10(%ebp),%eax
  401e24:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  401e26:	0f b6 11             	movzbl (%ecx),%edx
  401e29:	8d 72 d0             	lea    -0x30(%edx),%esi
  401e2c:	89 f3                	mov    %esi,%ebx
  401e2e:	80 fb 09             	cmp    $0x9,%bl
  401e31:	77 d5                	ja     401e08 <strtol+0x80>
			dig = *s - '0';
  401e33:	0f be d2             	movsbl %dl,%edx
  401e36:	83 ea 30             	sub    $0x30,%edx
  401e39:	eb dd                	jmp    401e18 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  401e3b:	8d 72 bf             	lea    -0x41(%edx),%esi
  401e3e:	89 f3                	mov    %esi,%ebx
  401e40:	80 fb 19             	cmp    $0x19,%bl
  401e43:	77 08                	ja     401e4d <strtol+0xc5>
			dig = *s - 'A' + 10;
  401e45:	0f be d2             	movsbl %dl,%edx
  401e48:	83 ea 37             	sub    $0x37,%edx
  401e4b:	eb cb                	jmp    401e18 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  401e4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  401e51:	74 05                	je     401e58 <strtol+0xd0>
		*endptr = (char *) s;
  401e53:	8b 75 0c             	mov    0xc(%ebp),%esi
  401e56:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  401e58:	89 c2                	mov    %eax,%edx
  401e5a:	f7 da                	neg    %edx
  401e5c:	85 ff                	test   %edi,%edi
  401e5e:	0f 45 c2             	cmovne %edx,%eax
}
  401e61:	5b                   	pop    %ebx
  401e62:	5e                   	pop    %esi
  401e63:	5f                   	pop    %edi
  401e64:	5d                   	pop    %ebp
  401e65:	c3                   	ret    
  401e66:	66 90                	xchg   %ax,%ax
  401e68:	66 90                	xchg   %ax,%ax
  401e6a:	66 90                	xchg   %ax,%ax
  401e6c:	66 90                	xchg   %ax,%ax
  401e6e:	66 90                	xchg   %ax,%ax

00401e70 <__udivdi3>:
  401e70:	55                   	push   %ebp
  401e71:	57                   	push   %edi
  401e72:	56                   	push   %esi
  401e73:	53                   	push   %ebx
  401e74:	83 ec 1c             	sub    $0x1c,%esp
  401e77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  401e7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  401e7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  401e83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  401e87:	85 d2                	test   %edx,%edx
  401e89:	75 35                	jne    401ec0 <__udivdi3+0x50>
  401e8b:	39 f3                	cmp    %esi,%ebx
  401e8d:	0f 87 bd 00 00 00    	ja     401f50 <__udivdi3+0xe0>
  401e93:	85 db                	test   %ebx,%ebx
  401e95:	89 d9                	mov    %ebx,%ecx
  401e97:	75 0b                	jne    401ea4 <__udivdi3+0x34>
  401e99:	b8 01 00 00 00       	mov    $0x1,%eax
  401e9e:	31 d2                	xor    %edx,%edx
  401ea0:	f7 f3                	div    %ebx
  401ea2:	89 c1                	mov    %eax,%ecx
  401ea4:	31 d2                	xor    %edx,%edx
  401ea6:	89 f0                	mov    %esi,%eax
  401ea8:	f7 f1                	div    %ecx
  401eaa:	89 c6                	mov    %eax,%esi
  401eac:	89 e8                	mov    %ebp,%eax
  401eae:	89 f7                	mov    %esi,%edi
  401eb0:	f7 f1                	div    %ecx
  401eb2:	89 fa                	mov    %edi,%edx
  401eb4:	83 c4 1c             	add    $0x1c,%esp
  401eb7:	5b                   	pop    %ebx
  401eb8:	5e                   	pop    %esi
  401eb9:	5f                   	pop    %edi
  401eba:	5d                   	pop    %ebp
  401ebb:	c3                   	ret    
  401ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  401ec0:	39 f2                	cmp    %esi,%edx
  401ec2:	77 7c                	ja     401f40 <__udivdi3+0xd0>
  401ec4:	0f bd fa             	bsr    %edx,%edi
  401ec7:	83 f7 1f             	xor    $0x1f,%edi
  401eca:	0f 84 98 00 00 00    	je     401f68 <__udivdi3+0xf8>
  401ed0:	89 f9                	mov    %edi,%ecx
  401ed2:	b8 20 00 00 00       	mov    $0x20,%eax
  401ed7:	29 f8                	sub    %edi,%eax
  401ed9:	d3 e2                	shl    %cl,%edx
  401edb:	89 54 24 08          	mov    %edx,0x8(%esp)
  401edf:	89 c1                	mov    %eax,%ecx
  401ee1:	89 da                	mov    %ebx,%edx
  401ee3:	d3 ea                	shr    %cl,%edx
  401ee5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  401ee9:	09 d1                	or     %edx,%ecx
  401eeb:	89 f2                	mov    %esi,%edx
  401eed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  401ef1:	89 f9                	mov    %edi,%ecx
  401ef3:	d3 e3                	shl    %cl,%ebx
  401ef5:	89 c1                	mov    %eax,%ecx
  401ef7:	d3 ea                	shr    %cl,%edx
  401ef9:	89 f9                	mov    %edi,%ecx
  401efb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  401eff:	d3 e6                	shl    %cl,%esi
  401f01:	89 eb                	mov    %ebp,%ebx
  401f03:	89 c1                	mov    %eax,%ecx
  401f05:	d3 eb                	shr    %cl,%ebx
  401f07:	09 de                	or     %ebx,%esi
  401f09:	89 f0                	mov    %esi,%eax
  401f0b:	f7 74 24 08          	divl   0x8(%esp)
  401f0f:	89 d6                	mov    %edx,%esi
  401f11:	89 c3                	mov    %eax,%ebx
  401f13:	f7 64 24 0c          	mull   0xc(%esp)
  401f17:	39 d6                	cmp    %edx,%esi
  401f19:	72 0c                	jb     401f27 <__udivdi3+0xb7>
  401f1b:	89 f9                	mov    %edi,%ecx
  401f1d:	d3 e5                	shl    %cl,%ebp
  401f1f:	39 c5                	cmp    %eax,%ebp
  401f21:	73 5d                	jae    401f80 <__udivdi3+0x110>
  401f23:	39 d6                	cmp    %edx,%esi
  401f25:	75 59                	jne    401f80 <__udivdi3+0x110>
  401f27:	8d 43 ff             	lea    -0x1(%ebx),%eax
  401f2a:	31 ff                	xor    %edi,%edi
  401f2c:	89 fa                	mov    %edi,%edx
  401f2e:	83 c4 1c             	add    $0x1c,%esp
  401f31:	5b                   	pop    %ebx
  401f32:	5e                   	pop    %esi
  401f33:	5f                   	pop    %edi
  401f34:	5d                   	pop    %ebp
  401f35:	c3                   	ret    
  401f36:	8d 76 00             	lea    0x0(%esi),%esi
  401f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  401f40:	31 ff                	xor    %edi,%edi
  401f42:	31 c0                	xor    %eax,%eax
  401f44:	89 fa                	mov    %edi,%edx
  401f46:	83 c4 1c             	add    $0x1c,%esp
  401f49:	5b                   	pop    %ebx
  401f4a:	5e                   	pop    %esi
  401f4b:	5f                   	pop    %edi
  401f4c:	5d                   	pop    %ebp
  401f4d:	c3                   	ret    
  401f4e:	66 90                	xchg   %ax,%ax
  401f50:	31 ff                	xor    %edi,%edi
  401f52:	89 e8                	mov    %ebp,%eax
  401f54:	89 f2                	mov    %esi,%edx
  401f56:	f7 f3                	div    %ebx
  401f58:	89 fa                	mov    %edi,%edx
  401f5a:	83 c4 1c             	add    $0x1c,%esp
  401f5d:	5b                   	pop    %ebx
  401f5e:	5e                   	pop    %esi
  401f5f:	5f                   	pop    %edi
  401f60:	5d                   	pop    %ebp
  401f61:	c3                   	ret    
  401f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  401f68:	39 f2                	cmp    %esi,%edx
  401f6a:	72 06                	jb     401f72 <__udivdi3+0x102>
  401f6c:	31 c0                	xor    %eax,%eax
  401f6e:	39 eb                	cmp    %ebp,%ebx
  401f70:	77 d2                	ja     401f44 <__udivdi3+0xd4>
  401f72:	b8 01 00 00 00       	mov    $0x1,%eax
  401f77:	eb cb                	jmp    401f44 <__udivdi3+0xd4>
  401f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  401f80:	89 d8                	mov    %ebx,%eax
  401f82:	31 ff                	xor    %edi,%edi
  401f84:	eb be                	jmp    401f44 <__udivdi3+0xd4>
  401f86:	66 90                	xchg   %ax,%ax
  401f88:	66 90                	xchg   %ax,%ax
  401f8a:	66 90                	xchg   %ax,%ax
  401f8c:	66 90                	xchg   %ax,%ax
  401f8e:	66 90                	xchg   %ax,%ax

00401f90 <__umoddi3>:
  401f90:	55                   	push   %ebp
  401f91:	57                   	push   %edi
  401f92:	56                   	push   %esi
  401f93:	53                   	push   %ebx
  401f94:	83 ec 1c             	sub    $0x1c,%esp
  401f97:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  401f9b:	8b 74 24 30          	mov    0x30(%esp),%esi
  401f9f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  401fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  401fa7:	85 ed                	test   %ebp,%ebp
  401fa9:	89 f0                	mov    %esi,%eax
  401fab:	89 da                	mov    %ebx,%edx
  401fad:	75 19                	jne    401fc8 <__umoddi3+0x38>
  401faf:	39 df                	cmp    %ebx,%edi
  401fb1:	0f 86 b1 00 00 00    	jbe    402068 <__umoddi3+0xd8>
  401fb7:	f7 f7                	div    %edi
  401fb9:	89 d0                	mov    %edx,%eax
  401fbb:	31 d2                	xor    %edx,%edx
  401fbd:	83 c4 1c             	add    $0x1c,%esp
  401fc0:	5b                   	pop    %ebx
  401fc1:	5e                   	pop    %esi
  401fc2:	5f                   	pop    %edi
  401fc3:	5d                   	pop    %ebp
  401fc4:	c3                   	ret    
  401fc5:	8d 76 00             	lea    0x0(%esi),%esi
  401fc8:	39 dd                	cmp    %ebx,%ebp
  401fca:	77 f1                	ja     401fbd <__umoddi3+0x2d>
  401fcc:	0f bd cd             	bsr    %ebp,%ecx
  401fcf:	83 f1 1f             	xor    $0x1f,%ecx
  401fd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  401fd6:	0f 84 b4 00 00 00    	je     402090 <__umoddi3+0x100>
  401fdc:	b8 20 00 00 00       	mov    $0x20,%eax
  401fe1:	89 c2                	mov    %eax,%edx
  401fe3:	8b 44 24 04          	mov    0x4(%esp),%eax
  401fe7:	29 c2                	sub    %eax,%edx
  401fe9:	89 c1                	mov    %eax,%ecx
  401feb:	89 f8                	mov    %edi,%eax
  401fed:	d3 e5                	shl    %cl,%ebp
  401fef:	89 d1                	mov    %edx,%ecx
  401ff1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  401ff5:	d3 e8                	shr    %cl,%eax
  401ff7:	09 c5                	or     %eax,%ebp
  401ff9:	8b 44 24 04          	mov    0x4(%esp),%eax
  401ffd:	89 c1                	mov    %eax,%ecx
  401fff:	d3 e7                	shl    %cl,%edi
  402001:	89 d1                	mov    %edx,%ecx
  402003:	89 7c 24 08          	mov    %edi,0x8(%esp)
  402007:	89 df                	mov    %ebx,%edi
  402009:	d3 ef                	shr    %cl,%edi
  40200b:	89 c1                	mov    %eax,%ecx
  40200d:	89 f0                	mov    %esi,%eax
  40200f:	d3 e3                	shl    %cl,%ebx
  402011:	89 d1                	mov    %edx,%ecx
  402013:	89 fa                	mov    %edi,%edx
  402015:	d3 e8                	shr    %cl,%eax
  402017:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  40201c:	09 d8                	or     %ebx,%eax
  40201e:	f7 f5                	div    %ebp
  402020:	d3 e6                	shl    %cl,%esi
  402022:	89 d1                	mov    %edx,%ecx
  402024:	f7 64 24 08          	mull   0x8(%esp)
  402028:	39 d1                	cmp    %edx,%ecx
  40202a:	89 c3                	mov    %eax,%ebx
  40202c:	89 d7                	mov    %edx,%edi
  40202e:	72 06                	jb     402036 <__umoddi3+0xa6>
  402030:	75 0e                	jne    402040 <__umoddi3+0xb0>
  402032:	39 c6                	cmp    %eax,%esi
  402034:	73 0a                	jae    402040 <__umoddi3+0xb0>
  402036:	2b 44 24 08          	sub    0x8(%esp),%eax
  40203a:	19 ea                	sbb    %ebp,%edx
  40203c:	89 d7                	mov    %edx,%edi
  40203e:	89 c3                	mov    %eax,%ebx
  402040:	89 ca                	mov    %ecx,%edx
  402042:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  402047:	29 de                	sub    %ebx,%esi
  402049:	19 fa                	sbb    %edi,%edx
  40204b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  40204f:	89 d0                	mov    %edx,%eax
  402051:	d3 e0                	shl    %cl,%eax
  402053:	89 d9                	mov    %ebx,%ecx
  402055:	d3 ee                	shr    %cl,%esi
  402057:	d3 ea                	shr    %cl,%edx
  402059:	09 f0                	or     %esi,%eax
  40205b:	83 c4 1c             	add    $0x1c,%esp
  40205e:	5b                   	pop    %ebx
  40205f:	5e                   	pop    %esi
  402060:	5f                   	pop    %edi
  402061:	5d                   	pop    %ebp
  402062:	c3                   	ret    
  402063:	90                   	nop
  402064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  402068:	85 ff                	test   %edi,%edi
  40206a:	89 f9                	mov    %edi,%ecx
  40206c:	75 0b                	jne    402079 <__umoddi3+0xe9>
  40206e:	b8 01 00 00 00       	mov    $0x1,%eax
  402073:	31 d2                	xor    %edx,%edx
  402075:	f7 f7                	div    %edi
  402077:	89 c1                	mov    %eax,%ecx
  402079:	89 d8                	mov    %ebx,%eax
  40207b:	31 d2                	xor    %edx,%edx
  40207d:	f7 f1                	div    %ecx
  40207f:	89 f0                	mov    %esi,%eax
  402081:	f7 f1                	div    %ecx
  402083:	e9 31 ff ff ff       	jmp    401fb9 <__umoddi3+0x29>
  402088:	90                   	nop
  402089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  402090:	39 dd                	cmp    %ebx,%ebp
  402092:	72 08                	jb     40209c <__umoddi3+0x10c>
  402094:	39 f7                	cmp    %esi,%edi
  402096:	0f 87 21 ff ff ff    	ja     401fbd <__umoddi3+0x2d>
  40209c:	89 da                	mov    %ebx,%edx
  40209e:	89 f0                	mov    %esi,%eax
  4020a0:	29 f8                	sub    %edi,%eax
  4020a2:	19 ea                	sbb    %ebp,%edx
  4020a4:	e9 14 ff ff ff       	jmp    401fbd <__umoddi3+0x2d>
