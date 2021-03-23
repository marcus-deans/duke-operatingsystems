
obj/user/test4:     file format elf32-i386


Disassembly of section .text:

00800020 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800020:	55                   	push   %ebp
  800021:	89 e5                	mov    %esp,%ebp
  800023:	53                   	push   %ebx
  800024:	83 ec 0c             	sub    $0xc,%esp
  800027:	e8 27 00 00 00       	call   800053 <__x86.get_pc_thunk.bx>
  80002c:	81 c3 d4 1f 00 00    	add    $0x1fd4,%ebx
	char* mem = (char*)0xB8000;
	char a = *mem;
	cprintf("succesfully access video memory at 0xB8000! The value is %c\n", a);
  800032:	0f be 05 00 80 0b 00 	movsbl 0xb8000,%eax
  800039:	50                   	push   %eax
  80003a:	8d 83 9c ed ff ff    	lea    -0x1264(%ebx),%eax
  800040:	50                   	push   %eax
  800041:	e8 e3 00 00 00       	call   800129 <cprintf>

	exit();
  800046:	e8 0c 00 00 00       	call   800057 <exit>
}
  80004b:	83 c4 10             	add    $0x10,%esp
  80004e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <__x86.get_pc_thunk.bx>:
  800053:	8b 1c 24             	mov    (%esp),%ebx
  800056:	c3                   	ret    

00800057 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800057:	55                   	push   %ebp
  800058:	89 e5                	mov    %esp,%ebp
  80005a:	53                   	push   %ebx
  80005b:	83 ec 10             	sub    $0x10,%esp
  80005e:	e8 f0 ff ff ff       	call   800053 <__x86.get_pc_thunk.bx>
  800063:	81 c3 9d 1f 00 00    	add    $0x1f9d,%ebx
	sys_env_destroy(0);
  800069:	6a 00                	push   $0x0
  80006b:	e8 5d 0a 00 00       	call   800acd <sys_env_destroy>
}
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800076:	c9                   	leave  
  800077:	c3                   	ret    

00800078 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	56                   	push   %esi
  80007c:	53                   	push   %ebx
  80007d:	e8 d1 ff ff ff       	call   800053 <__x86.get_pc_thunk.bx>
  800082:	81 c3 7e 1f 00 00    	add    $0x1f7e,%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  80008b:	8b 16                	mov    (%esi),%edx
  80008d:	8d 42 01             	lea    0x1(%edx),%eax
  800090:	89 06                	mov    %eax,(%esi)
  800092:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800095:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  800099:	3d ff 00 00 00       	cmp    $0xff,%eax
  80009e:	74 0b                	je     8000ab <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000a0:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ab:	83 ec 08             	sub    $0x8,%esp
  8000ae:	68 ff 00 00 00       	push   $0xff
  8000b3:	8d 46 08             	lea    0x8(%esi),%eax
  8000b6:	50                   	push   %eax
  8000b7:	e8 d4 09 00 00       	call   800a90 <sys_cputs>
		b->idx = 0;
  8000bc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	eb d9                	jmp    8000a0 <putch+0x28>

008000c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	53                   	push   %ebx
  8000cb:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000d1:	e8 7d ff ff ff       	call   800053 <__x86.get_pc_thunk.bx>
  8000d6:	81 c3 2a 1f 00 00    	add    $0x1f2a,%ebx
	struct printbuf b;

	b.idx = 0;
  8000dc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000e3:	00 00 00 
	b.cnt = 0;
  8000e6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000ed:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000f0:	ff 75 0c             	pushl  0xc(%ebp)
  8000f3:	ff 75 08             	pushl  0x8(%ebp)
  8000f6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8000fc:	50                   	push   %eax
  8000fd:	8d 83 78 e0 ff ff    	lea    -0x1f88(%ebx),%eax
  800103:	50                   	push   %eax
  800104:	e8 38 01 00 00       	call   800241 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800109:	83 c4 08             	add    $0x8,%esp
  80010c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800112:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800118:	50                   	push   %eax
  800119:	e8 72 09 00 00       	call   800a90 <sys_cputs>

	return b.cnt;
}
  80011e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800124:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80012f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800132:	50                   	push   %eax
  800133:	ff 75 08             	pushl  0x8(%ebp)
  800136:	e8 8c ff ff ff       	call   8000c7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    

0080013d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	57                   	push   %edi
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	83 ec 2c             	sub    $0x2c,%esp
  800146:	e8 cd 05 00 00       	call   800718 <__x86.get_pc_thunk.cx>
  80014b:	81 c1 b5 1e 00 00    	add    $0x1eb5,%ecx
  800151:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800154:	89 c7                	mov    %eax,%edi
  800156:	89 d6                	mov    %edx,%esi
  800158:	8b 45 08             	mov    0x8(%ebp),%eax
  80015b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80015e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800161:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800164:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800167:	bb 00 00 00 00       	mov    $0x0,%ebx
  80016c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  80016f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  800172:	39 d3                	cmp    %edx,%ebx
  800174:	72 09                	jb     80017f <printnum+0x42>
  800176:	39 45 10             	cmp    %eax,0x10(%ebp)
  800179:	0f 87 83 00 00 00    	ja     800202 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	ff 75 18             	pushl  0x18(%ebp)
  800185:	8b 45 14             	mov    0x14(%ebp),%eax
  800188:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80018b:	53                   	push   %ebx
  80018c:	ff 75 10             	pushl  0x10(%ebp)
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	ff 75 dc             	pushl  -0x24(%ebp)
  800195:	ff 75 d8             	pushl  -0x28(%ebp)
  800198:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019b:	ff 75 d0             	pushl  -0x30(%ebp)
  80019e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001a1:	e8 ba 09 00 00       	call   800b60 <__udivdi3>
  8001a6:	83 c4 18             	add    $0x18,%esp
  8001a9:	52                   	push   %edx
  8001aa:	50                   	push   %eax
  8001ab:	89 f2                	mov    %esi,%edx
  8001ad:	89 f8                	mov    %edi,%eax
  8001af:	e8 89 ff ff ff       	call   80013d <printnum>
  8001b4:	83 c4 20             	add    $0x20,%esp
  8001b7:	eb 13                	jmp    8001cc <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001b9:	83 ec 08             	sub    $0x8,%esp
  8001bc:	56                   	push   %esi
  8001bd:	ff 75 18             	pushl  0x18(%ebp)
  8001c0:	ff d7                	call   *%edi
  8001c2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001c5:	83 eb 01             	sub    $0x1,%ebx
  8001c8:	85 db                	test   %ebx,%ebx
  8001ca:	7f ed                	jg     8001b9 <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	56                   	push   %esi
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001dc:	ff 75 d0             	pushl  -0x30(%ebp)
  8001df:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8001e2:	89 f3                	mov    %esi,%ebx
  8001e4:	e8 97 0a 00 00       	call   800c80 <__umoddi3>
  8001e9:	83 c4 14             	add    $0x14,%esp
  8001ec:	0f be 84 06 dc ed ff 	movsbl -0x1224(%esi,%eax,1),%eax
  8001f3:	ff 
  8001f4:	50                   	push   %eax
  8001f5:	ff d7                	call   *%edi
}
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fd:	5b                   	pop    %ebx
  8001fe:	5e                   	pop    %esi
  8001ff:	5f                   	pop    %edi
  800200:	5d                   	pop    %ebp
  800201:	c3                   	ret    
  800202:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800205:	eb be                	jmp    8001c5 <printnum+0x88>

00800207 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80020d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800211:	8b 10                	mov    (%eax),%edx
  800213:	3b 50 04             	cmp    0x4(%eax),%edx
  800216:	73 0a                	jae    800222 <sprintputch+0x1b>
		*b->buf++ = ch;
  800218:	8d 4a 01             	lea    0x1(%edx),%ecx
  80021b:	89 08                	mov    %ecx,(%eax)
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	88 02                	mov    %al,(%edx)
}
  800222:	5d                   	pop    %ebp
  800223:	c3                   	ret    

00800224 <printfmt>:
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80022a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80022d:	50                   	push   %eax
  80022e:	ff 75 10             	pushl  0x10(%ebp)
  800231:	ff 75 0c             	pushl  0xc(%ebp)
  800234:	ff 75 08             	pushl  0x8(%ebp)
  800237:	e8 05 00 00 00       	call   800241 <vprintfmt>
}
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <vprintfmt>:
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	83 ec 2c             	sub    $0x2c,%esp
  80024a:	e8 04 fe ff ff       	call   800053 <__x86.get_pc_thunk.bx>
  80024f:	81 c3 b1 1d 00 00    	add    $0x1db1,%ebx
  800255:	8b 75 0c             	mov    0xc(%ebp),%esi
  800258:	8b 7d 10             	mov    0x10(%ebp),%edi
  80025b:	e9 8e 03 00 00       	jmp    8005ee <.L35+0x48>
		padc = ' ';
  800260:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800264:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80026b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800272:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800279:	b9 00 00 00 00       	mov    $0x0,%ecx
  80027e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800281:	8d 47 01             	lea    0x1(%edi),%eax
  800284:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800287:	0f b6 17             	movzbl (%edi),%edx
  80028a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80028d:	3c 55                	cmp    $0x55,%al
  80028f:	0f 87 e1 03 00 00    	ja     800676 <.L22>
  800295:	0f b6 c0             	movzbl %al,%eax
  800298:	89 d9                	mov    %ebx,%ecx
  80029a:	03 8c 83 6c ee ff ff 	add    -0x1194(%ebx,%eax,4),%ecx
  8002a1:	ff e1                	jmp    *%ecx

008002a3 <.L67>:
  8002a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a6:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002aa:	eb d5                	jmp    800281 <vprintfmt+0x40>

008002ac <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  8002ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002af:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b3:	eb cc                	jmp    800281 <vprintfmt+0x40>

008002b5 <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  8002b5:	0f b6 d2             	movzbl %dl,%edx
  8002b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bb:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  8002c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002c7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ca:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002cd:	83 f9 09             	cmp    $0x9,%ecx
  8002d0:	77 55                	ja     800327 <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  8002d2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002d5:	eb e9                	jmp    8002c0 <.L29+0xb>

008002d7 <.L26>:
			precision = va_arg(ap, int);
  8002d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002da:	8b 00                	mov    (%eax),%eax
  8002dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002df:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e2:	8d 40 04             	lea    0x4(%eax),%eax
  8002e5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002ef:	79 90                	jns    800281 <vprintfmt+0x40>
				width = precision, precision = -1;
  8002f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002fe:	eb 81                	jmp    800281 <vprintfmt+0x40>

00800300 <.L27>:
  800300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800303:	85 c0                	test   %eax,%eax
  800305:	ba 00 00 00 00       	mov    $0x0,%edx
  80030a:	0f 49 d0             	cmovns %eax,%edx
  80030d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800313:	e9 69 ff ff ff       	jmp    800281 <vprintfmt+0x40>

00800318 <.L23>:
  800318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80031b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800322:	e9 5a ff ff ff       	jmp    800281 <vprintfmt+0x40>
  800327:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80032a:	eb bf                	jmp    8002eb <.L26+0x14>

0080032c <.L33>:
			lflag++;
  80032c:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800333:	e9 49 ff ff ff       	jmp    800281 <vprintfmt+0x40>

00800338 <.L30>:
			putch(va_arg(ap, int), putdat);
  800338:	8b 45 14             	mov    0x14(%ebp),%eax
  80033b:	8d 78 04             	lea    0x4(%eax),%edi
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	56                   	push   %esi
  800342:	ff 30                	pushl  (%eax)
  800344:	ff 55 08             	call   *0x8(%ebp)
			break;
  800347:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80034a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80034d:	e9 99 02 00 00       	jmp    8005eb <.L35+0x45>

00800352 <.L32>:
			err = va_arg(ap, int);
  800352:	8b 45 14             	mov    0x14(%ebp),%eax
  800355:	8d 78 04             	lea    0x4(%eax),%edi
  800358:	8b 00                	mov    (%eax),%eax
  80035a:	99                   	cltd   
  80035b:	31 d0                	xor    %edx,%eax
  80035d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80035f:	83 f8 06             	cmp    $0x6,%eax
  800362:	7f 27                	jg     80038b <.L32+0x39>
  800364:	8b 94 83 0c 00 00 00 	mov    0xc(%ebx,%eax,4),%edx
  80036b:	85 d2                	test   %edx,%edx
  80036d:	74 1c                	je     80038b <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  80036f:	52                   	push   %edx
  800370:	8d 83 fd ed ff ff    	lea    -0x1203(%ebx),%eax
  800376:	50                   	push   %eax
  800377:	56                   	push   %esi
  800378:	ff 75 08             	pushl  0x8(%ebp)
  80037b:	e8 a4 fe ff ff       	call   800224 <printfmt>
  800380:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800383:	89 7d 14             	mov    %edi,0x14(%ebp)
  800386:	e9 60 02 00 00       	jmp    8005eb <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  80038b:	50                   	push   %eax
  80038c:	8d 83 f4 ed ff ff    	lea    -0x120c(%ebx),%eax
  800392:	50                   	push   %eax
  800393:	56                   	push   %esi
  800394:	ff 75 08             	pushl  0x8(%ebp)
  800397:	e8 88 fe ff ff       	call   800224 <printfmt>
  80039c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a2:	e9 44 02 00 00       	jmp    8005eb <.L35+0x45>

008003a7 <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8003a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003aa:	83 c0 04             	add    $0x4,%eax
  8003ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003b5:	85 ff                	test   %edi,%edi
  8003b7:	8d 83 ed ed ff ff    	lea    -0x1213(%ebx),%eax
  8003bd:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c4:	0f 8e b5 00 00 00    	jle    80047f <.L36+0xd8>
  8003ca:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003ce:	75 08                	jne    8003d8 <.L36+0x31>
  8003d0:	89 75 0c             	mov    %esi,0xc(%ebp)
  8003d3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003d6:	eb 6d                	jmp    800445 <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	ff 75 d0             	pushl  -0x30(%ebp)
  8003de:	57                   	push   %edi
  8003df:	e8 50 03 00 00       	call   800734 <strnlen>
  8003e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003e7:	29 c2                	sub    %eax,%edx
  8003e9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  8003ec:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003ef:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003f9:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fb:	eb 10                	jmp    80040d <.L36+0x66>
					putch(padc, putdat);
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	56                   	push   %esi
  800401:	ff 75 e0             	pushl  -0x20(%ebp)
  800404:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800407:	83 ef 01             	sub    $0x1,%edi
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	85 ff                	test   %edi,%edi
  80040f:	7f ec                	jg     8003fd <.L36+0x56>
  800411:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800414:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800417:	85 d2                	test   %edx,%edx
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
  80041e:	0f 49 c2             	cmovns %edx,%eax
  800421:	29 c2                	sub    %eax,%edx
  800423:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800426:	89 75 0c             	mov    %esi,0xc(%ebp)
  800429:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80042c:	eb 17                	jmp    800445 <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  80042e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800432:	75 30                	jne    800464 <.L36+0xbd>
					putch(ch, putdat);
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	ff 75 0c             	pushl  0xc(%ebp)
  80043a:	50                   	push   %eax
  80043b:	ff 55 08             	call   *0x8(%ebp)
  80043e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800441:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  800445:	83 c7 01             	add    $0x1,%edi
  800448:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80044c:	0f be c2             	movsbl %dl,%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	74 52                	je     8004a5 <.L36+0xfe>
  800453:	85 f6                	test   %esi,%esi
  800455:	78 d7                	js     80042e <.L36+0x87>
  800457:	83 ee 01             	sub    $0x1,%esi
  80045a:	79 d2                	jns    80042e <.L36+0x87>
  80045c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80045f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800462:	eb 32                	jmp    800496 <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  800464:	0f be d2             	movsbl %dl,%edx
  800467:	83 ea 20             	sub    $0x20,%edx
  80046a:	83 fa 5e             	cmp    $0x5e,%edx
  80046d:	76 c5                	jbe    800434 <.L36+0x8d>
					putch('?', putdat);
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	ff 75 0c             	pushl  0xc(%ebp)
  800475:	6a 3f                	push   $0x3f
  800477:	ff 55 08             	call   *0x8(%ebp)
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	eb c2                	jmp    800441 <.L36+0x9a>
  80047f:	89 75 0c             	mov    %esi,0xc(%ebp)
  800482:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800485:	eb be                	jmp    800445 <.L36+0x9e>
				putch(' ', putdat);
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	56                   	push   %esi
  80048b:	6a 20                	push   $0x20
  80048d:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  800490:	83 ef 01             	sub    $0x1,%edi
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	85 ff                	test   %edi,%edi
  800498:	7f ed                	jg     800487 <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  80049a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80049d:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a0:	e9 46 01 00 00       	jmp    8005eb <.L35+0x45>
  8004a5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ab:	eb e9                	jmp    800496 <.L36+0xef>

008004ad <.L31>:
  8004ad:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  8004b0:	83 f9 01             	cmp    $0x1,%ecx
  8004b3:	7e 40                	jle    8004f5 <.L31+0x48>
		return va_arg(*ap, long long);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 50 04             	mov    0x4(%eax),%edx
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8d 40 08             	lea    0x8(%eax),%eax
  8004c9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d0:	79 55                	jns    800527 <.L31+0x7a>
				putch('-', putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	56                   	push   %esi
  8004d6:	6a 2d                	push   $0x2d
  8004d8:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8004db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e1:	f7 da                	neg    %edx
  8004e3:	83 d1 00             	adc    $0x0,%ecx
  8004e6:	f7 d9                	neg    %ecx
  8004e8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f0:	e9 db 00 00 00       	jmp    8005d0 <.L35+0x2a>
	else if (lflag)
  8004f5:	85 c9                	test   %ecx,%ecx
  8004f7:	75 17                	jne    800510 <.L31+0x63>
		return va_arg(*ap, int);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	99                   	cltd   
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 04             	lea    0x4(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
  80050e:	eb bc                	jmp    8004cc <.L31+0x1f>
		return va_arg(*ap, long);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	99                   	cltd   
  800519:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8d 40 04             	lea    0x4(%eax),%eax
  800522:	89 45 14             	mov    %eax,0x14(%ebp)
  800525:	eb a5                	jmp    8004cc <.L31+0x1f>
			num = getint(&ap, lflag);
  800527:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800532:	e9 99 00 00 00       	jmp    8005d0 <.L35+0x2a>

00800537 <.L37>:
  800537:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  80053a:	83 f9 01             	cmp    $0x1,%ecx
  80053d:	7e 15                	jle    800554 <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8b 10                	mov    (%eax),%edx
  800544:	8b 48 04             	mov    0x4(%eax),%ecx
  800547:	8d 40 08             	lea    0x8(%eax),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80054d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800552:	eb 7c                	jmp    8005d0 <.L35+0x2a>
	else if (lflag)
  800554:	85 c9                	test   %ecx,%ecx
  800556:	75 17                	jne    80056f <.L37+0x38>
		return va_arg(*ap, unsigned int);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 10                	mov    (%eax),%edx
  80055d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800562:	8d 40 04             	lea    0x4(%eax),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800568:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056d:	eb 61                	jmp    8005d0 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 10                	mov    (%eax),%edx
  800574:	b9 00 00 00 00       	mov    $0x0,%ecx
  800579:	8d 40 04             	lea    0x4(%eax),%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800584:	eb 4a                	jmp    8005d0 <.L35+0x2a>

00800586 <.L34>:
			putch('X', putdat);
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	56                   	push   %esi
  80058a:	6a 58                	push   $0x58
  80058c:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  80058f:	83 c4 08             	add    $0x8,%esp
  800592:	56                   	push   %esi
  800593:	6a 58                	push   $0x58
  800595:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  800598:	83 c4 08             	add    $0x8,%esp
  80059b:	56                   	push   %esi
  80059c:	6a 58                	push   $0x58
  80059e:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	eb 45                	jmp    8005eb <.L35+0x45>

008005a6 <.L35>:
			putch('0', putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	56                   	push   %esi
  8005aa:	6a 30                	push   $0x30
  8005ac:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8005af:	83 c4 08             	add    $0x8,%esp
  8005b2:	56                   	push   %esi
  8005b3:	6a 78                	push   $0x78
  8005b5:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8b 10                	mov    (%eax),%edx
  8005bd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005c2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005cb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005d0:	83 ec 0c             	sub    $0xc,%esp
  8005d3:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005d7:	57                   	push   %edi
  8005d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005db:	50                   	push   %eax
  8005dc:	51                   	push   %ecx
  8005dd:	52                   	push   %edx
  8005de:	89 f2                	mov    %esi,%edx
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	e8 55 fb ff ff       	call   80013d <printnum>
			break;
  8005e8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ee:	83 c7 01             	add    $0x1,%edi
  8005f1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005f5:	83 f8 25             	cmp    $0x25,%eax
  8005f8:	0f 84 62 fc ff ff    	je     800260 <vprintfmt+0x1f>
			if (ch == '\0')
  8005fe:	85 c0                	test   %eax,%eax
  800600:	0f 84 91 00 00 00    	je     800697 <.L22+0x21>
			putch(ch, putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	56                   	push   %esi
  80060a:	50                   	push   %eax
  80060b:	ff 55 08             	call   *0x8(%ebp)
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	eb db                	jmp    8005ee <.L35+0x48>

00800613 <.L38>:
  800613:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  800616:	83 f9 01             	cmp    $0x1,%ecx
  800619:	7e 15                	jle    800630 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 10                	mov    (%eax),%edx
  800620:	8b 48 04             	mov    0x4(%eax),%ecx
  800623:	8d 40 08             	lea    0x8(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800629:	b8 10 00 00 00       	mov    $0x10,%eax
  80062e:	eb a0                	jmp    8005d0 <.L35+0x2a>
	else if (lflag)
  800630:	85 c9                	test   %ecx,%ecx
  800632:	75 17                	jne    80064b <.L38+0x38>
		return va_arg(*ap, unsigned int);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 10                	mov    (%eax),%edx
  800639:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063e:	8d 40 04             	lea    0x4(%eax),%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800644:	b8 10 00 00 00       	mov    $0x10,%eax
  800649:	eb 85                	jmp    8005d0 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 10                	mov    (%eax),%edx
  800650:	b9 00 00 00 00       	mov    $0x0,%ecx
  800655:	8d 40 04             	lea    0x4(%eax),%eax
  800658:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065b:	b8 10 00 00 00       	mov    $0x10,%eax
  800660:	e9 6b ff ff ff       	jmp    8005d0 <.L35+0x2a>

00800665 <.L25>:
			putch(ch, putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	56                   	push   %esi
  800669:	6a 25                	push   $0x25
  80066b:	ff 55 08             	call   *0x8(%ebp)
			break;
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	e9 75 ff ff ff       	jmp    8005eb <.L35+0x45>

00800676 <.L22>:
			putch('%', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	56                   	push   %esi
  80067a:	6a 25                	push   $0x25
  80067c:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 f8                	mov    %edi,%eax
  800684:	eb 03                	jmp    800689 <.L22+0x13>
  800686:	83 e8 01             	sub    $0x1,%eax
  800689:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80068d:	75 f7                	jne    800686 <.L22+0x10>
  80068f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800692:	e9 54 ff ff ff       	jmp    8005eb <.L35+0x45>
}
  800697:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069a:	5b                   	pop    %ebx
  80069b:	5e                   	pop    %esi
  80069c:	5f                   	pop    %edi
  80069d:	5d                   	pop    %ebp
  80069e:	c3                   	ret    

0080069f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	53                   	push   %ebx
  8006a3:	83 ec 14             	sub    $0x14,%esp
  8006a6:	e8 a8 f9 ff ff       	call   800053 <__x86.get_pc_thunk.bx>
  8006ab:	81 c3 55 19 00 00    	add    $0x1955,%ebx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ba:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 2b                	je     8006f7 <vsnprintf+0x58>
  8006cc:	85 d2                	test   %edx,%edx
  8006ce:	7e 27                	jle    8006f7 <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d0:	ff 75 14             	pushl  0x14(%ebp)
  8006d3:	ff 75 10             	pushl  0x10(%ebp)
  8006d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	8d 83 07 e2 ff ff    	lea    -0x1df9(%ebx),%eax
  8006e0:	50                   	push   %eax
  8006e1:	e8 5b fb ff ff       	call   800241 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ef:	83 c4 10             	add    $0x10,%esp
}
  8006f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f5:	c9                   	leave  
  8006f6:	c3                   	ret    
		return -E_INVAL;
  8006f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fc:	eb f4                	jmp    8006f2 <vsnprintf+0x53>

008006fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800704:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800707:	50                   	push   %eax
  800708:	ff 75 10             	pushl  0x10(%ebp)
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	ff 75 08             	pushl  0x8(%ebp)
  800711:	e8 89 ff ff ff       	call   80069f <vsnprintf>
	va_end(ap);

	return rc;
}
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <__x86.get_pc_thunk.cx>:
  800718:	8b 0c 24             	mov    (%esp),%ecx
  80071b:	c3                   	ret    

0080071c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800722:	b8 00 00 00 00       	mov    $0x0,%eax
  800727:	eb 03                	jmp    80072c <strlen+0x10>
		n++;
  800729:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80072c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800730:	75 f7                	jne    800729 <strlen+0xd>
	return n;
}
  800732:	5d                   	pop    %ebp
  800733:	c3                   	ret    

00800734 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80073a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80073d:	b8 00 00 00 00       	mov    $0x0,%eax
  800742:	eb 03                	jmp    800747 <strnlen+0x13>
		n++;
  800744:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800747:	39 d0                	cmp    %edx,%eax
  800749:	74 06                	je     800751 <strnlen+0x1d>
  80074b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80074f:	75 f3                	jne    800744 <strnlen+0x10>
	return n;
}
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	53                   	push   %ebx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80075d:	89 c2                	mov    %eax,%edx
  80075f:	83 c1 01             	add    $0x1,%ecx
  800762:	83 c2 01             	add    $0x1,%edx
  800765:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800769:	88 5a ff             	mov    %bl,-0x1(%edx)
  80076c:	84 db                	test   %bl,%bl
  80076e:	75 ef                	jne    80075f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800770:	5b                   	pop    %ebx
  800771:	5d                   	pop    %ebp
  800772:	c3                   	ret    

00800773 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	53                   	push   %ebx
  800777:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80077a:	53                   	push   %ebx
  80077b:	e8 9c ff ff ff       	call   80071c <strlen>
  800780:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	01 d8                	add    %ebx,%eax
  800788:	50                   	push   %eax
  800789:	e8 c5 ff ff ff       	call   800753 <strcpy>
	return dst;
}
  80078e:	89 d8                	mov    %ebx,%eax
  800790:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800793:	c9                   	leave  
  800794:	c3                   	ret    

00800795 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800795:	55                   	push   %ebp
  800796:	89 e5                	mov    %esp,%ebp
  800798:	56                   	push   %esi
  800799:	53                   	push   %ebx
  80079a:	8b 75 08             	mov    0x8(%ebp),%esi
  80079d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a0:	89 f3                	mov    %esi,%ebx
  8007a2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007a5:	89 f2                	mov    %esi,%edx
  8007a7:	eb 0f                	jmp    8007b8 <strncpy+0x23>
		*dst++ = *src;
  8007a9:	83 c2 01             	add    $0x1,%edx
  8007ac:	0f b6 01             	movzbl (%ecx),%eax
  8007af:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007b2:	80 39 01             	cmpb   $0x1,(%ecx)
  8007b5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007b8:	39 da                	cmp    %ebx,%edx
  8007ba:	75 ed                	jne    8007a9 <strncpy+0x14>
	}
	return ret;
}
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	5b                   	pop    %ebx
  8007bf:	5e                   	pop    %esi
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	56                   	push   %esi
  8007c6:	53                   	push   %ebx
  8007c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007d0:	89 f0                	mov    %esi,%eax
  8007d2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007d6:	85 c9                	test   %ecx,%ecx
  8007d8:	75 0b                	jne    8007e5 <strlcpy+0x23>
  8007da:	eb 17                	jmp    8007f3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007dc:	83 c2 01             	add    $0x1,%edx
  8007df:	83 c0 01             	add    $0x1,%eax
  8007e2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007e5:	39 d8                	cmp    %ebx,%eax
  8007e7:	74 07                	je     8007f0 <strlcpy+0x2e>
  8007e9:	0f b6 0a             	movzbl (%edx),%ecx
  8007ec:	84 c9                	test   %cl,%cl
  8007ee:	75 ec                	jne    8007dc <strlcpy+0x1a>
		*dst = '\0';
  8007f0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007f3:	29 f0                	sub    %esi,%eax
}
  8007f5:	5b                   	pop    %ebx
  8007f6:	5e                   	pop    %esi
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800802:	eb 06                	jmp    80080a <strcmp+0x11>
		p++, q++;
  800804:	83 c1 01             	add    $0x1,%ecx
  800807:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80080a:	0f b6 01             	movzbl (%ecx),%eax
  80080d:	84 c0                	test   %al,%al
  80080f:	74 04                	je     800815 <strcmp+0x1c>
  800811:	3a 02                	cmp    (%edx),%al
  800813:	74 ef                	je     800804 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800815:	0f b6 c0             	movzbl %al,%eax
  800818:	0f b6 12             	movzbl (%edx),%edx
  80081b:	29 d0                	sub    %edx,%eax
}
  80081d:	5d                   	pop    %ebp
  80081e:	c3                   	ret    

0080081f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	53                   	push   %ebx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
  800829:	89 c3                	mov    %eax,%ebx
  80082b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80082e:	eb 06                	jmp    800836 <strncmp+0x17>
		n--, p++, q++;
  800830:	83 c0 01             	add    $0x1,%eax
  800833:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800836:	39 d8                	cmp    %ebx,%eax
  800838:	74 16                	je     800850 <strncmp+0x31>
  80083a:	0f b6 08             	movzbl (%eax),%ecx
  80083d:	84 c9                	test   %cl,%cl
  80083f:	74 04                	je     800845 <strncmp+0x26>
  800841:	3a 0a                	cmp    (%edx),%cl
  800843:	74 eb                	je     800830 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800845:	0f b6 00             	movzbl (%eax),%eax
  800848:	0f b6 12             	movzbl (%edx),%edx
  80084b:	29 d0                	sub    %edx,%eax
}
  80084d:	5b                   	pop    %ebx
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    
		return 0;
  800850:	b8 00 00 00 00       	mov    $0x0,%eax
  800855:	eb f6                	jmp    80084d <strncmp+0x2e>

00800857 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800861:	0f b6 10             	movzbl (%eax),%edx
  800864:	84 d2                	test   %dl,%dl
  800866:	74 09                	je     800871 <strchr+0x1a>
		if (*s == c)
  800868:	38 ca                	cmp    %cl,%dl
  80086a:	74 0a                	je     800876 <strchr+0x1f>
	for (; *s; s++)
  80086c:	83 c0 01             	add    $0x1,%eax
  80086f:	eb f0                	jmp    800861 <strchr+0xa>
			return (char *) s;
	return 0;
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800882:	eb 03                	jmp    800887 <strfind+0xf>
  800884:	83 c0 01             	add    $0x1,%eax
  800887:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80088a:	38 ca                	cmp    %cl,%dl
  80088c:	74 04                	je     800892 <strfind+0x1a>
  80088e:	84 d2                	test   %dl,%dl
  800890:	75 f2                	jne    800884 <strfind+0xc>
			break;
	return (char *) s;
}
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	57                   	push   %edi
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80089d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008a0:	85 c9                	test   %ecx,%ecx
  8008a2:	74 13                	je     8008b7 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008a4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008aa:	75 05                	jne    8008b1 <memset+0x1d>
  8008ac:	f6 c1 03             	test   $0x3,%cl
  8008af:	74 0d                	je     8008be <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	fc                   	cld    
  8008b5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008b7:	89 f8                	mov    %edi,%eax
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5f                   	pop    %edi
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    
		c &= 0xFF;
  8008be:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008c2:	89 d3                	mov    %edx,%ebx
  8008c4:	c1 e3 08             	shl    $0x8,%ebx
  8008c7:	89 d0                	mov    %edx,%eax
  8008c9:	c1 e0 18             	shl    $0x18,%eax
  8008cc:	89 d6                	mov    %edx,%esi
  8008ce:	c1 e6 10             	shl    $0x10,%esi
  8008d1:	09 f0                	or     %esi,%eax
  8008d3:	09 c2                	or     %eax,%edx
  8008d5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008d7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008da:	89 d0                	mov    %edx,%eax
  8008dc:	fc                   	cld    
  8008dd:	f3 ab                	rep stos %eax,%es:(%edi)
  8008df:	eb d6                	jmp    8008b7 <memset+0x23>

008008e1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	57                   	push   %edi
  8008e5:	56                   	push   %esi
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008ef:	39 c6                	cmp    %eax,%esi
  8008f1:	73 35                	jae    800928 <memmove+0x47>
  8008f3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008f6:	39 c2                	cmp    %eax,%edx
  8008f8:	76 2e                	jbe    800928 <memmove+0x47>
		s += n;
		d += n;
  8008fa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008fd:	89 d6                	mov    %edx,%esi
  8008ff:	09 fe                	or     %edi,%esi
  800901:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800907:	74 0c                	je     800915 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800909:	83 ef 01             	sub    $0x1,%edi
  80090c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80090f:	fd                   	std    
  800910:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800912:	fc                   	cld    
  800913:	eb 21                	jmp    800936 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800915:	f6 c1 03             	test   $0x3,%cl
  800918:	75 ef                	jne    800909 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80091a:	83 ef 04             	sub    $0x4,%edi
  80091d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800920:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800923:	fd                   	std    
  800924:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800926:	eb ea                	jmp    800912 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800928:	89 f2                	mov    %esi,%edx
  80092a:	09 c2                	or     %eax,%edx
  80092c:	f6 c2 03             	test   $0x3,%dl
  80092f:	74 09                	je     80093a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800931:	89 c7                	mov    %eax,%edi
  800933:	fc                   	cld    
  800934:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800936:	5e                   	pop    %esi
  800937:	5f                   	pop    %edi
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093a:	f6 c1 03             	test   $0x3,%cl
  80093d:	75 f2                	jne    800931 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80093f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800942:	89 c7                	mov    %eax,%edi
  800944:	fc                   	cld    
  800945:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800947:	eb ed                	jmp    800936 <memmove+0x55>

00800949 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80094c:	ff 75 10             	pushl  0x10(%ebp)
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	ff 75 08             	pushl  0x8(%ebp)
  800955:	e8 87 ff ff ff       	call   8008e1 <memmove>
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	56                   	push   %esi
  800960:	53                   	push   %ebx
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 55 0c             	mov    0xc(%ebp),%edx
  800967:	89 c6                	mov    %eax,%esi
  800969:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80096c:	39 f0                	cmp    %esi,%eax
  80096e:	74 1c                	je     80098c <memcmp+0x30>
		if (*s1 != *s2)
  800970:	0f b6 08             	movzbl (%eax),%ecx
  800973:	0f b6 1a             	movzbl (%edx),%ebx
  800976:	38 d9                	cmp    %bl,%cl
  800978:	75 08                	jne    800982 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	83 c2 01             	add    $0x1,%edx
  800980:	eb ea                	jmp    80096c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800982:	0f b6 c1             	movzbl %cl,%eax
  800985:	0f b6 db             	movzbl %bl,%ebx
  800988:	29 d8                	sub    %ebx,%eax
  80098a:	eb 05                	jmp    800991 <memcmp+0x35>
	}

	return 0;
  80098c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800991:	5b                   	pop    %ebx
  800992:	5e                   	pop    %esi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80099e:	89 c2                	mov    %eax,%edx
  8009a0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009a3:	39 d0                	cmp    %edx,%eax
  8009a5:	73 09                	jae    8009b0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009a7:	38 08                	cmp    %cl,(%eax)
  8009a9:	74 05                	je     8009b0 <memfind+0x1b>
	for (; s < ends; s++)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	eb f3                	jmp    8009a3 <memfind+0xe>
			break;
	return (void *) s;
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	57                   	push   %edi
  8009b6:	56                   	push   %esi
  8009b7:	53                   	push   %ebx
  8009b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009be:	eb 03                	jmp    8009c3 <strtol+0x11>
		s++;
  8009c0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009c3:	0f b6 01             	movzbl (%ecx),%eax
  8009c6:	3c 20                	cmp    $0x20,%al
  8009c8:	74 f6                	je     8009c0 <strtol+0xe>
  8009ca:	3c 09                	cmp    $0x9,%al
  8009cc:	74 f2                	je     8009c0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009ce:	3c 2b                	cmp    $0x2b,%al
  8009d0:	74 2e                	je     800a00 <strtol+0x4e>
	int neg = 0;
  8009d2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009d7:	3c 2d                	cmp    $0x2d,%al
  8009d9:	74 2f                	je     800a0a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009db:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009e1:	75 05                	jne    8009e8 <strtol+0x36>
  8009e3:	80 39 30             	cmpb   $0x30,(%ecx)
  8009e6:	74 2c                	je     800a14 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009e8:	85 db                	test   %ebx,%ebx
  8009ea:	75 0a                	jne    8009f6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009ec:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009f1:	80 39 30             	cmpb   $0x30,(%ecx)
  8009f4:	74 28                	je     800a1e <strtol+0x6c>
		base = 10;
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009fe:	eb 50                	jmp    800a50 <strtol+0x9e>
		s++;
  800a00:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a03:	bf 00 00 00 00       	mov    $0x0,%edi
  800a08:	eb d1                	jmp    8009db <strtol+0x29>
		s++, neg = 1;
  800a0a:	83 c1 01             	add    $0x1,%ecx
  800a0d:	bf 01 00 00 00       	mov    $0x1,%edi
  800a12:	eb c7                	jmp    8009db <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a14:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a18:	74 0e                	je     800a28 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a1a:	85 db                	test   %ebx,%ebx
  800a1c:	75 d8                	jne    8009f6 <strtol+0x44>
		s++, base = 8;
  800a1e:	83 c1 01             	add    $0x1,%ecx
  800a21:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a26:	eb ce                	jmp    8009f6 <strtol+0x44>
		s += 2, base = 16;
  800a28:	83 c1 02             	add    $0x2,%ecx
  800a2b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a30:	eb c4                	jmp    8009f6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a32:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a35:	89 f3                	mov    %esi,%ebx
  800a37:	80 fb 19             	cmp    $0x19,%bl
  800a3a:	77 29                	ja     800a65 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a3c:	0f be d2             	movsbl %dl,%edx
  800a3f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a42:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a45:	7d 30                	jge    800a77 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a47:	83 c1 01             	add    $0x1,%ecx
  800a4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a4e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a50:	0f b6 11             	movzbl (%ecx),%edx
  800a53:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a56:	89 f3                	mov    %esi,%ebx
  800a58:	80 fb 09             	cmp    $0x9,%bl
  800a5b:	77 d5                	ja     800a32 <strtol+0x80>
			dig = *s - '0';
  800a5d:	0f be d2             	movsbl %dl,%edx
  800a60:	83 ea 30             	sub    $0x30,%edx
  800a63:	eb dd                	jmp    800a42 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a65:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a68:	89 f3                	mov    %esi,%ebx
  800a6a:	80 fb 19             	cmp    $0x19,%bl
  800a6d:	77 08                	ja     800a77 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a6f:	0f be d2             	movsbl %dl,%edx
  800a72:	83 ea 37             	sub    $0x37,%edx
  800a75:	eb cb                	jmp    800a42 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7b:	74 05                	je     800a82 <strtol+0xd0>
		*endptr = (char *) s;
  800a7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a80:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a82:	89 c2                	mov    %eax,%edx
  800a84:	f7 da                	neg    %edx
  800a86:	85 ff                	test   %edi,%edi
  800a88:	0f 45 c2             	cmovne %edx,%eax
}
  800a8b:	5b                   	pop    %ebx
  800a8c:	5e                   	pop    %esi
  800a8d:	5f                   	pop    %edi
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	57                   	push   %edi
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa1:	89 c3                	mov    %eax,%ebx
  800aa3:	89 c7                	mov    %eax,%edi
  800aa5:	89 c6                	mov    %eax,%esi
  800aa7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aa9:	5b                   	pop    %ebx
  800aaa:	5e                   	pop    %esi
  800aab:	5f                   	pop    %edi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <sys_cgetc>:

int
sys_cgetc(void)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	57                   	push   %edi
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  800abe:	89 d1                	mov    %edx,%ecx
  800ac0:	89 d3                	mov    %edx,%ebx
  800ac2:	89 d7                	mov    %edx,%edi
  800ac4:	89 d6                	mov    %edx,%esi
  800ac6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ac8:	5b                   	pop    %ebx
  800ac9:	5e                   	pop    %esi
  800aca:	5f                   	pop    %edi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	57                   	push   %edi
  800ad1:	56                   	push   %esi
  800ad2:	53                   	push   %ebx
  800ad3:	83 ec 1c             	sub    $0x1c,%esp
  800ad6:	e8 78 f5 ff ff       	call   800053 <__x86.get_pc_thunk.bx>
  800adb:	81 c3 25 15 00 00    	add    $0x1525,%ebx
  800ae1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	asm volatile("int %1\n"
  800ae4:	be 00 00 00 00       	mov    $0x0,%esi
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	b8 03 00 00 00       	mov    $0x3,%eax
  800af1:	89 f1                	mov    %esi,%ecx
  800af3:	89 f3                	mov    %esi,%ebx
  800af5:	89 f7                	mov    %esi,%edi
  800af7:	cd 30                	int    $0x30
  800af9:	89 c6                	mov    %eax,%esi
	if(check && ret > 0) {
  800afb:	85 c0                	test   %eax,%eax
  800afd:	7e 18                	jle    800b17 <sys_env_destroy+0x4a>
		cprintf("syscall %d returned %d (> 0)", num, ret);
  800aff:	83 ec 04             	sub    $0x4,%esp
  800b02:	50                   	push   %eax
  800b03:	6a 03                	push   $0x3
  800b05:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800b08:	8d 83 c4 ef ff ff    	lea    -0x103c(%ebx),%eax
  800b0e:	50                   	push   %eax
  800b0f:	e8 15 f6 ff ff       	call   800129 <cprintf>
  800b14:	83 c4 10             	add    $0x10,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b17:	89 f0                	mov    %esi,%eax
  800b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5f                   	pop    %edi
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	57                   	push   %edi
  800b25:	56                   	push   %esi
  800b26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b27:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2c:	b8 02 00 00 00       	mov    $0x2,%eax
  800b31:	89 d1                	mov    %edx,%ecx
  800b33:	89 d3                	mov    %edx,%ebx
  800b35:	89 d7                	mov    %edx,%edi
  800b37:	89 d6                	mov    %edx,%esi
  800b39:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b3b:	5b                   	pop    %ebx
  800b3c:	5e                   	pop    %esi
  800b3d:	5f                   	pop    %edi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <sys_test>:

void
sys_test(void)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	57                   	push   %edi
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4b:	b8 04 00 00 00       	mov    $0x4,%eax
  800b50:	89 d1                	mov    %edx,%ecx
  800b52:	89 d3                	mov    %edx,%ebx
  800b54:	89 d7                	mov    %edx,%edi
  800b56:	89 d6                	mov    %edx,%esi
  800b58:	cd 30                	int    $0x30
		syscall(SYS_test, 0, 0, 0, 0, 0, 0);
}
  800b5a:	5b                   	pop    %ebx
  800b5b:	5e                   	pop    %esi
  800b5c:	5f                   	pop    %edi
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    
  800b5f:	90                   	nop

00800b60 <__udivdi3>:
  800b60:	55                   	push   %ebp
  800b61:	57                   	push   %edi
  800b62:	56                   	push   %esi
  800b63:	53                   	push   %ebx
  800b64:	83 ec 1c             	sub    $0x1c,%esp
  800b67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800b6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800b6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800b73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800b77:	85 d2                	test   %edx,%edx
  800b79:	75 35                	jne    800bb0 <__udivdi3+0x50>
  800b7b:	39 f3                	cmp    %esi,%ebx
  800b7d:	0f 87 bd 00 00 00    	ja     800c40 <__udivdi3+0xe0>
  800b83:	85 db                	test   %ebx,%ebx
  800b85:	89 d9                	mov    %ebx,%ecx
  800b87:	75 0b                	jne    800b94 <__udivdi3+0x34>
  800b89:	b8 01 00 00 00       	mov    $0x1,%eax
  800b8e:	31 d2                	xor    %edx,%edx
  800b90:	f7 f3                	div    %ebx
  800b92:	89 c1                	mov    %eax,%ecx
  800b94:	31 d2                	xor    %edx,%edx
  800b96:	89 f0                	mov    %esi,%eax
  800b98:	f7 f1                	div    %ecx
  800b9a:	89 c6                	mov    %eax,%esi
  800b9c:	89 e8                	mov    %ebp,%eax
  800b9e:	89 f7                	mov    %esi,%edi
  800ba0:	f7 f1                	div    %ecx
  800ba2:	89 fa                	mov    %edi,%edx
  800ba4:	83 c4 1c             	add    $0x1c,%esp
  800ba7:	5b                   	pop    %ebx
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    
  800bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800bb0:	39 f2                	cmp    %esi,%edx
  800bb2:	77 7c                	ja     800c30 <__udivdi3+0xd0>
  800bb4:	0f bd fa             	bsr    %edx,%edi
  800bb7:	83 f7 1f             	xor    $0x1f,%edi
  800bba:	0f 84 98 00 00 00    	je     800c58 <__udivdi3+0xf8>
  800bc0:	89 f9                	mov    %edi,%ecx
  800bc2:	b8 20 00 00 00       	mov    $0x20,%eax
  800bc7:	29 f8                	sub    %edi,%eax
  800bc9:	d3 e2                	shl    %cl,%edx
  800bcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bcf:	89 c1                	mov    %eax,%ecx
  800bd1:	89 da                	mov    %ebx,%edx
  800bd3:	d3 ea                	shr    %cl,%edx
  800bd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800bd9:	09 d1                	or     %edx,%ecx
  800bdb:	89 f2                	mov    %esi,%edx
  800bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800be1:	89 f9                	mov    %edi,%ecx
  800be3:	d3 e3                	shl    %cl,%ebx
  800be5:	89 c1                	mov    %eax,%ecx
  800be7:	d3 ea                	shr    %cl,%edx
  800be9:	89 f9                	mov    %edi,%ecx
  800beb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bef:	d3 e6                	shl    %cl,%esi
  800bf1:	89 eb                	mov    %ebp,%ebx
  800bf3:	89 c1                	mov    %eax,%ecx
  800bf5:	d3 eb                	shr    %cl,%ebx
  800bf7:	09 de                	or     %ebx,%esi
  800bf9:	89 f0                	mov    %esi,%eax
  800bfb:	f7 74 24 08          	divl   0x8(%esp)
  800bff:	89 d6                	mov    %edx,%esi
  800c01:	89 c3                	mov    %eax,%ebx
  800c03:	f7 64 24 0c          	mull   0xc(%esp)
  800c07:	39 d6                	cmp    %edx,%esi
  800c09:	72 0c                	jb     800c17 <__udivdi3+0xb7>
  800c0b:	89 f9                	mov    %edi,%ecx
  800c0d:	d3 e5                	shl    %cl,%ebp
  800c0f:	39 c5                	cmp    %eax,%ebp
  800c11:	73 5d                	jae    800c70 <__udivdi3+0x110>
  800c13:	39 d6                	cmp    %edx,%esi
  800c15:	75 59                	jne    800c70 <__udivdi3+0x110>
  800c17:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800c1a:	31 ff                	xor    %edi,%edi
  800c1c:	89 fa                	mov    %edi,%edx
  800c1e:	83 c4 1c             	add    $0x1c,%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
  800c26:	8d 76 00             	lea    0x0(%esi),%esi
  800c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800c30:	31 ff                	xor    %edi,%edi
  800c32:	31 c0                	xor    %eax,%eax
  800c34:	89 fa                	mov    %edi,%edx
  800c36:	83 c4 1c             	add    $0x1c,%esp
  800c39:	5b                   	pop    %ebx
  800c3a:	5e                   	pop    %esi
  800c3b:	5f                   	pop    %edi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    
  800c3e:	66 90                	xchg   %ax,%ax
  800c40:	31 ff                	xor    %edi,%edi
  800c42:	89 e8                	mov    %ebp,%eax
  800c44:	89 f2                	mov    %esi,%edx
  800c46:	f7 f3                	div    %ebx
  800c48:	89 fa                	mov    %edi,%edx
  800c4a:	83 c4 1c             	add    $0x1c,%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    
  800c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800c58:	39 f2                	cmp    %esi,%edx
  800c5a:	72 06                	jb     800c62 <__udivdi3+0x102>
  800c5c:	31 c0                	xor    %eax,%eax
  800c5e:	39 eb                	cmp    %ebp,%ebx
  800c60:	77 d2                	ja     800c34 <__udivdi3+0xd4>
  800c62:	b8 01 00 00 00       	mov    $0x1,%eax
  800c67:	eb cb                	jmp    800c34 <__udivdi3+0xd4>
  800c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800c70:	89 d8                	mov    %ebx,%eax
  800c72:	31 ff                	xor    %edi,%edi
  800c74:	eb be                	jmp    800c34 <__udivdi3+0xd4>
  800c76:	66 90                	xchg   %ax,%ax
  800c78:	66 90                	xchg   %ax,%ax
  800c7a:	66 90                	xchg   %ax,%ax
  800c7c:	66 90                	xchg   %ax,%ax
  800c7e:	66 90                	xchg   %ax,%ax

00800c80 <__umoddi3>:
  800c80:	55                   	push   %ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 1c             	sub    $0x1c,%esp
  800c87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800c8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800c8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800c97:	85 ed                	test   %ebp,%ebp
  800c99:	89 f0                	mov    %esi,%eax
  800c9b:	89 da                	mov    %ebx,%edx
  800c9d:	75 19                	jne    800cb8 <__umoddi3+0x38>
  800c9f:	39 df                	cmp    %ebx,%edi
  800ca1:	0f 86 b1 00 00 00    	jbe    800d58 <__umoddi3+0xd8>
  800ca7:	f7 f7                	div    %edi
  800ca9:	89 d0                	mov    %edx,%eax
  800cab:	31 d2                	xor    %edx,%edx
  800cad:	83 c4 1c             	add    $0x1c,%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    
  800cb5:	8d 76 00             	lea    0x0(%esi),%esi
  800cb8:	39 dd                	cmp    %ebx,%ebp
  800cba:	77 f1                	ja     800cad <__umoddi3+0x2d>
  800cbc:	0f bd cd             	bsr    %ebp,%ecx
  800cbf:	83 f1 1f             	xor    $0x1f,%ecx
  800cc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cc6:	0f 84 b4 00 00 00    	je     800d80 <__umoddi3+0x100>
  800ccc:	b8 20 00 00 00       	mov    $0x20,%eax
  800cd1:	89 c2                	mov    %eax,%edx
  800cd3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800cd7:	29 c2                	sub    %eax,%edx
  800cd9:	89 c1                	mov    %eax,%ecx
  800cdb:	89 f8                	mov    %edi,%eax
  800cdd:	d3 e5                	shl    %cl,%ebp
  800cdf:	89 d1                	mov    %edx,%ecx
  800ce1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ce5:	d3 e8                	shr    %cl,%eax
  800ce7:	09 c5                	or     %eax,%ebp
  800ce9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ced:	89 c1                	mov    %eax,%ecx
  800cef:	d3 e7                	shl    %cl,%edi
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800cf7:	89 df                	mov    %ebx,%edi
  800cf9:	d3 ef                	shr    %cl,%edi
  800cfb:	89 c1                	mov    %eax,%ecx
  800cfd:	89 f0                	mov    %esi,%eax
  800cff:	d3 e3                	shl    %cl,%ebx
  800d01:	89 d1                	mov    %edx,%ecx
  800d03:	89 fa                	mov    %edi,%edx
  800d05:	d3 e8                	shr    %cl,%eax
  800d07:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800d0c:	09 d8                	or     %ebx,%eax
  800d0e:	f7 f5                	div    %ebp
  800d10:	d3 e6                	shl    %cl,%esi
  800d12:	89 d1                	mov    %edx,%ecx
  800d14:	f7 64 24 08          	mull   0x8(%esp)
  800d18:	39 d1                	cmp    %edx,%ecx
  800d1a:	89 c3                	mov    %eax,%ebx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	72 06                	jb     800d26 <__umoddi3+0xa6>
  800d20:	75 0e                	jne    800d30 <__umoddi3+0xb0>
  800d22:	39 c6                	cmp    %eax,%esi
  800d24:	73 0a                	jae    800d30 <__umoddi3+0xb0>
  800d26:	2b 44 24 08          	sub    0x8(%esp),%eax
  800d2a:	19 ea                	sbb    %ebp,%edx
  800d2c:	89 d7                	mov    %edx,%edi
  800d2e:	89 c3                	mov    %eax,%ebx
  800d30:	89 ca                	mov    %ecx,%edx
  800d32:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800d37:	29 de                	sub    %ebx,%esi
  800d39:	19 fa                	sbb    %edi,%edx
  800d3b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800d3f:	89 d0                	mov    %edx,%eax
  800d41:	d3 e0                	shl    %cl,%eax
  800d43:	89 d9                	mov    %ebx,%ecx
  800d45:	d3 ee                	shr    %cl,%esi
  800d47:	d3 ea                	shr    %cl,%edx
  800d49:	09 f0                	or     %esi,%eax
  800d4b:	83 c4 1c             	add    $0x1c,%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
  800d53:	90                   	nop
  800d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d58:	85 ff                	test   %edi,%edi
  800d5a:	89 f9                	mov    %edi,%ecx
  800d5c:	75 0b                	jne    800d69 <__umoddi3+0xe9>
  800d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d63:	31 d2                	xor    %edx,%edx
  800d65:	f7 f7                	div    %edi
  800d67:	89 c1                	mov    %eax,%ecx
  800d69:	89 d8                	mov    %ebx,%eax
  800d6b:	31 d2                	xor    %edx,%edx
  800d6d:	f7 f1                	div    %ecx
  800d6f:	89 f0                	mov    %esi,%eax
  800d71:	f7 f1                	div    %ecx
  800d73:	e9 31 ff ff ff       	jmp    800ca9 <__umoddi3+0x29>
  800d78:	90                   	nop
  800d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d80:	39 dd                	cmp    %ebx,%ebp
  800d82:	72 08                	jb     800d8c <__umoddi3+0x10c>
  800d84:	39 f7                	cmp    %esi,%edi
  800d86:	0f 87 21 ff ff ff    	ja     800cad <__umoddi3+0x2d>
  800d8c:	89 da                	mov    %ebx,%edx
  800d8e:	89 f0                	mov    %esi,%eax
  800d90:	29 f8                	sub    %edi,%eax
  800d92:	19 ea                	sbb    %ebp,%edx
  800d94:	e9 14 ff ff ff       	jmp    800cad <__umoddi3+0x2d>
