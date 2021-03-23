
obj/boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.set CR0_PE_ON,      0x1         # protected mode enable flag

.globl start
start:
  .code16                     # Assemble for 16-bit mode
  cli                         # Disable interrupts
    7c00:	fa                   	cli    
  cld                         # String operations increment
    7c01:	fc                   	cld    

  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0c:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c16:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1c:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	64 7c 0f             	fs jl  7c33 <protcseg+0x1>
  movl    %cr0, %eax
    7c24:	20 c0                	and    %al,%al
  orl     $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0
  
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:

  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call bootmain
    7c45:	e8 ec 00 00 00       	call   7d36 <bootmain>

00007c4a <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    7c4a:	eb fe                	jmp    7c4a <spin>

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00                   	.byte 0x0
    7c61:	92                   	xchg   %eax,%edx
    7c62:	cf                   	iret   
	...

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
	...

00007c6a <putchar>:
	// note: does not return!
	((void (*)(void)) (ELFHDR->e_entry))();
	
}

void putchar(char val, int row, int col) {
    7c6a:	55                   	push   %ebp
    7c6b:	89 e5                	mov    %esp,%ebp
	// TODO: YOUR CODE HERE
	
	int reli = (80*(row-1) + col)*2;
    7c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
	char* output_pos = VIDEO_MEMORY + reli;
	*output_pos = val;
    7c70:	8b 55 08             	mov    0x8(%ebp),%edx
	int reli = (80*(row-1) + col)*2;
    7c73:	48                   	dec    %eax
    7c74:	6b c0 50             	imul   $0x50,%eax,%eax
    7c77:	03 45 10             	add    0x10(%ebp),%eax
    7c7a:	01 c0                	add    %eax,%eax
	*output_pos = val;
    7c7c:	88 90 00 80 0b 00    	mov    %dl,0xb8000(%eax)
	*(output_pos +1) = 0x7;
    7c82:	c6 80 01 80 0b 00 07 	movb   $0x7,0xb8001(%eax)
}
    7c89:	5d                   	pop    %ebp
    7c8a:	c3                   	ret    

00007c8b <waitdisk>:
	}
}

void
waitdisk(void)
{
    7c8b:	55                   	push   %ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c8c:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c91:	89 e5                	mov    %esp,%ebp
    7c93:	ec                   	in     (%dx),%al
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c94:	83 e0 c0             	and    $0xffffffc0,%eax
    7c97:	3c 40                	cmp    $0x40,%al
    7c99:	75 f8                	jne    7c93 <waitdisk+0x8>
		/* do nothing */;
}
    7c9b:	5d                   	pop    %ebp
    7c9c:	c3                   	ret    

00007c9d <readsect>:

void
readsect(void *dst, uint32_t offset)
{
    7c9d:	55                   	push   %ebp
    7c9e:	89 e5                	mov    %esp,%ebp
    7ca0:	57                   	push   %edi
    7ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	// wait for disk to be ready
	waitdisk();
    7ca4:	e8 e2 ff ff ff       	call   7c8b <waitdisk>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7ca9:	b0 01                	mov    $0x1,%al
    7cab:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cb0:	ee                   	out    %al,(%dx)
    7cb1:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cb6:	88 c8                	mov    %cl,%al
    7cb8:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
    7cb9:	89 c8                	mov    %ecx,%eax
    7cbb:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cc0:	c1 e8 08             	shr    $0x8,%eax
    7cc3:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
    7cc4:	89 c8                	mov    %ecx,%eax
    7cc6:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7ccb:	c1 e8 10             	shr    $0x10,%eax
    7cce:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
    7ccf:	89 c8                	mov    %ecx,%eax
    7cd1:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cd6:	c1 e8 18             	shr    $0x18,%eax
    7cd9:	83 c8 e0             	or     $0xffffffe0,%eax
    7cdc:	ee                   	out    %al,(%dx)
    7cdd:	b0 20                	mov    $0x20,%al
    7cdf:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ce4:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
    7ce5:	e8 a1 ff ff ff       	call   7c8b <waitdisk>
	asm volatile("cld\n\trepne\n\tinsl"
    7cea:	8b 7d 08             	mov    0x8(%ebp),%edi
    7ced:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cf2:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cf7:	fc                   	cld    
    7cf8:	f2 6d                	repnz insl (%dx),%es:(%edi)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
    7cfa:	5f                   	pop    %edi
    7cfb:	5d                   	pop    %ebp
    7cfc:	c3                   	ret    

00007cfd <readseg>:
{
    7cfd:	55                   	push   %ebp
    7cfe:	89 e5                	mov    %esp,%ebp
    7d00:	57                   	push   %edi
    7d01:	56                   	push   %esi
	offset = (offset / SECTSIZE) + 1;
    7d02:	8b 7d 10             	mov    0x10(%ebp),%edi
{
    7d05:	53                   	push   %ebx
	end_pa = pa + count;
    7d06:	8b 75 0c             	mov    0xc(%ebp),%esi
{
    7d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	offset = (offset / SECTSIZE) + 1;
    7d0c:	c1 ef 09             	shr    $0x9,%edi
	end_pa = pa + count;
    7d0f:	01 de                	add    %ebx,%esi
	offset = (offset / SECTSIZE) + 1;
    7d11:	47                   	inc    %edi
	pa &= ~(SECTSIZE - 1);
    7d12:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
	while (pa < end_pa) {
    7d18:	39 f3                	cmp    %esi,%ebx
    7d1a:	73 12                	jae    7d2e <readseg+0x31>
		readsect((uint8_t*) pa, offset);
    7d1c:	57                   	push   %edi
    7d1d:	53                   	push   %ebx
		offset++;
    7d1e:	47                   	inc    %edi
		pa += SECTSIZE;
    7d1f:	81 c3 00 02 00 00    	add    $0x200,%ebx
		readsect((uint8_t*) pa, offset);
    7d25:	e8 73 ff ff ff       	call   7c9d <readsect>
		offset++;
    7d2a:	58                   	pop    %eax
    7d2b:	5a                   	pop    %edx
    7d2c:	eb ea                	jmp    7d18 <readseg+0x1b>
}
    7d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d31:	5b                   	pop    %ebx
    7d32:	5e                   	pop    %esi
    7d33:	5f                   	pop    %edi
    7d34:	5d                   	pop    %ebp
    7d35:	c3                   	ret    

00007d36 <bootmain>:
{
    7d36:	55                   	push   %ebp
    7d37:	89 e5                	mov    %esp,%ebp
    7d39:	56                   	push   %esi
    7d3a:	53                   	push   %ebx
	*output_pos = val;
    7d3b:	66 c7 05 c0 8d 0b 00 	movw   $0x731,0xb8dc0
    7d42:	31 07 
	readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7d44:	6a 00                	push   $0x0
    7d46:	68 00 10 00 00       	push   $0x1000
    7d4b:	68 00 00 01 00       	push   $0x10000
    7d50:	e8 a8 ff ff ff       	call   7cfd <readseg>
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d55:	83 c4 0c             	add    $0xc,%esp
    7d58:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d5f:	45 4c 46 
	*output_pos = val;
    7d62:	66 c7 05 c2 8d 0b 00 	movw   $0x732,0xb8dc2
    7d69:	32 07 
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d6b:	75 4f                	jne    7dbc <bootmain+0x86>
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d6d:	a1 1c 00 01 00       	mov    0x1001c,%eax
	eph = ph + ELFHDR->e_phnum;
    7d72:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
	*output_pos = val;
    7d79:	66 c7 05 c4 8d 0b 00 	movw   $0x733,0xb8dc4
    7d80:	33 07 
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d82:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
	eph = ph + ELFHDR->e_phnum;
    7d88:	c1 e6 05             	shl    $0x5,%esi
    7d8b:	01 de                	add    %ebx,%esi
	for (; ph < eph; ph++)
    7d8d:	39 f3                	cmp    %esi,%ebx
    7d8f:	73 16                	jae    7da7 <bootmain+0x71>
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d91:	ff 73 04             	pushl  0x4(%ebx)
    7d94:	ff 73 14             	pushl  0x14(%ebx)
	for (; ph < eph; ph++)
    7d97:	83 c3 20             	add    $0x20,%ebx
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d9a:	ff 73 ec             	pushl  -0x14(%ebx)
    7d9d:	e8 5b ff ff ff       	call   7cfd <readseg>
	for (; ph < eph; ph++)
    7da2:	83 c4 0c             	add    $0xc,%esp
    7da5:	eb e6                	jmp    7d8d <bootmain+0x57>
	*output_pos = val;
    7da7:	66 c7 05 c6 8d 0b 00 	movw   $0x734,0xb8dc6
    7dae:	34 07 
}
    7db0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    7db3:	5b                   	pop    %ebx
    7db4:	5e                   	pop    %esi
    7db5:	5d                   	pop    %ebp
	((void (*)(void)) (ELFHDR->e_entry))();
    7db6:	ff 25 18 00 01 00    	jmp    *0x10018
}
    7dbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    7dbf:	5b                   	pop    %ebx
    7dc0:	5e                   	pop    %esi
    7dc1:	5d                   	pop    %ebp
    7dc2:	c3                   	ret    
