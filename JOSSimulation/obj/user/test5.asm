
obj/user/test5:     file format elf32-i386


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
  800027:	e8 2d 00 00 00       	call   800059 <__x86.get_pc_thunk.bx>
  80002c:	81 c3 d4 1f 00 00    	add    $0x1fd4,%ebx
	char* mem = (char*)0xB8000;
	sys_cputs(mem, 1);
  800032:	6a 01                	push   $0x1
  800034:	68 00 80 0b 00       	push   $0xb8000
  800039:	e8 58 0a 00 00       	call   800a96 <sys_cputs>
	cprintf("succesfully access video memory at 0xB8000!\n");
  80003e:	8d 83 ac ed ff ff    	lea    -0x1254(%ebx),%eax
  800044:	89 04 24             	mov    %eax,(%esp)
  800047:	e8 e3 00 00 00       	call   80012f <cprintf>

	exit();
  80004c:	e8 0c 00 00 00       	call   80005d <exit>
}
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <__x86.get_pc_thunk.bx>:
  800059:	8b 1c 24             	mov    (%esp),%ebx
  80005c:	c3                   	ret    

0080005d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	53                   	push   %ebx
  800061:	83 ec 10             	sub    $0x10,%esp
  800064:	e8 f0 ff ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800069:	81 c3 97 1f 00 00    	add    $0x1f97,%ebx
	sys_env_destroy(0);
  80006f:	6a 00                	push   $0x0
  800071:	e8 5d 0a 00 00       	call   800ad3 <sys_env_destroy>
}
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	56                   	push   %esi
  800082:	53                   	push   %ebx
  800083:	e8 d1 ff ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800088:	81 c3 78 1f 00 00    	add    $0x1f78,%ebx
  80008e:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
  800091:	8b 16                	mov    (%esi),%edx
  800093:	8d 42 01             	lea    0x1(%edx),%eax
  800096:	89 06                	mov    %eax,(%esi)
  800098:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80009b:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
	if (b->idx == 256-1) {
  80009f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000a4:	74 0b                	je     8000b1 <putch+0x33>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000a6:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8000aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ad:	5b                   	pop    %ebx
  8000ae:	5e                   	pop    %esi
  8000af:	5d                   	pop    %ebp
  8000b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000b1:	83 ec 08             	sub    $0x8,%esp
  8000b4:	68 ff 00 00 00       	push   $0xff
  8000b9:	8d 46 08             	lea    0x8(%esi),%eax
  8000bc:	50                   	push   %eax
  8000bd:	e8 d4 09 00 00       	call   800a96 <sys_cputs>
		b->idx = 0;
  8000c2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	eb d9                	jmp    8000a6 <putch+0x28>

008000cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	53                   	push   %ebx
  8000d1:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000d7:	e8 7d ff ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  8000dc:	81 c3 24 1f 00 00    	add    $0x1f24,%ebx
	struct printbuf b;

	b.idx = 0;
  8000e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000e9:	00 00 00 
	b.cnt = 0;
  8000ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000f6:	ff 75 0c             	pushl  0xc(%ebp)
  8000f9:	ff 75 08             	pushl  0x8(%ebp)
  8000fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	8d 83 7e e0 ff ff    	lea    -0x1f82(%ebx),%eax
  800109:	50                   	push   %eax
  80010a:	e8 38 01 00 00       	call   800247 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80010f:	83 c4 08             	add    $0x8,%esp
  800112:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800118:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 72 09 00 00       	call   800a96 <sys_cputs>

	return b.cnt;
}
  800124:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80012a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800135:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800138:	50                   	push   %eax
  800139:	ff 75 08             	pushl  0x8(%ebp)
  80013c:	e8 8c ff ff ff       	call   8000cd <vcprintf>
	va_end(ap);

	return cnt;
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
  800149:	83 ec 2c             	sub    $0x2c,%esp
  80014c:	e8 cd 05 00 00       	call   80071e <__x86.get_pc_thunk.cx>
  800151:	81 c1 af 1e 00 00    	add    $0x1eaf,%ecx
  800157:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80015a:	89 c7                	mov    %eax,%edi
  80015c:	89 d6                	mov    %edx,%esi
  80015e:	8b 45 08             	mov    0x8(%ebp),%eax
  800161:	8b 55 0c             	mov    0xc(%ebp),%edx
  800164:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800167:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80016a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80016d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800172:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800175:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  800178:	39 d3                	cmp    %edx,%ebx
  80017a:	72 09                	jb     800185 <printnum+0x42>
  80017c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80017f:	0f 87 83 00 00 00    	ja     800208 <printnum+0xc5>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	ff 75 18             	pushl  0x18(%ebp)
  80018b:	8b 45 14             	mov    0x14(%ebp),%eax
  80018e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800191:	53                   	push   %ebx
  800192:	ff 75 10             	pushl  0x10(%ebp)
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 dc             	pushl  -0x24(%ebp)
  80019b:	ff 75 d8             	pushl  -0x28(%ebp)
  80019e:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8001a4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001a7:	e8 c4 09 00 00       	call   800b70 <__udivdi3>
  8001ac:	83 c4 18             	add    $0x18,%esp
  8001af:	52                   	push   %edx
  8001b0:	50                   	push   %eax
  8001b1:	89 f2                	mov    %esi,%edx
  8001b3:	89 f8                	mov    %edi,%eax
  8001b5:	e8 89 ff ff ff       	call   800143 <printnum>
  8001ba:	83 c4 20             	add    $0x20,%esp
  8001bd:	eb 13                	jmp    8001d2 <printnum+0x8f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	56                   	push   %esi
  8001c3:	ff 75 18             	pushl  0x18(%ebp)
  8001c6:	ff d7                	call   *%edi
  8001c8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001cb:	83 eb 01             	sub    $0x1,%ebx
  8001ce:	85 db                	test   %ebx,%ebx
  8001d0:	7f ed                	jg     8001bf <printnum+0x7c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	56                   	push   %esi
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8001df:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001e2:	ff 75 d0             	pushl  -0x30(%ebp)
  8001e5:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8001e8:	89 f3                	mov    %esi,%ebx
  8001ea:	e8 a1 0a 00 00       	call   800c90 <__umoddi3>
  8001ef:	83 c4 14             	add    $0x14,%esp
  8001f2:	0f be 84 06 dc ed ff 	movsbl -0x1224(%esi,%eax,1),%eax
  8001f9:	ff 
  8001fa:	50                   	push   %eax
  8001fb:	ff d7                	call   *%edi
}
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    
  800208:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80020b:	eb be                	jmp    8001cb <printnum+0x88>

0080020d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80020d:	55                   	push   %ebp
  80020e:	89 e5                	mov    %esp,%ebp
  800210:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800213:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800217:	8b 10                	mov    (%eax),%edx
  800219:	3b 50 04             	cmp    0x4(%eax),%edx
  80021c:	73 0a                	jae    800228 <sprintputch+0x1b>
		*b->buf++ = ch;
  80021e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800221:	89 08                	mov    %ecx,(%eax)
  800223:	8b 45 08             	mov    0x8(%ebp),%eax
  800226:	88 02                	mov    %al,(%edx)
}
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    

0080022a <printfmt>:
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800230:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800233:	50                   	push   %eax
  800234:	ff 75 10             	pushl  0x10(%ebp)
  800237:	ff 75 0c             	pushl  0xc(%ebp)
  80023a:	ff 75 08             	pushl  0x8(%ebp)
  80023d:	e8 05 00 00 00       	call   800247 <vprintfmt>
}
  800242:	83 c4 10             	add    $0x10,%esp
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <vprintfmt>:
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 2c             	sub    $0x2c,%esp
  800250:	e8 04 fe ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800255:	81 c3 ab 1d 00 00    	add    $0x1dab,%ebx
  80025b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80025e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800261:	e9 8e 03 00 00       	jmp    8005f4 <.L35+0x48>
		padc = ' ';
  800266:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80026a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800271:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800278:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80027f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800284:	89 4d cc             	mov    %ecx,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800287:	8d 47 01             	lea    0x1(%edi),%eax
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028d:	0f b6 17             	movzbl (%edi),%edx
  800290:	8d 42 dd             	lea    -0x23(%edx),%eax
  800293:	3c 55                	cmp    $0x55,%al
  800295:	0f 87 e1 03 00 00    	ja     80067c <.L22>
  80029b:	0f b6 c0             	movzbl %al,%eax
  80029e:	89 d9                	mov    %ebx,%ecx
  8002a0:	03 8c 83 6c ee ff ff 	add    -0x1194(%ebx,%eax,4),%ecx
  8002a7:	ff e1                	jmp    *%ecx

008002a9 <.L67>:
  8002a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002ac:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002b0:	eb d5                	jmp    800287 <vprintfmt+0x40>

008002b2 <.L28>:
		switch (ch = *(unsigned char *) fmt++) {
  8002b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b5:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b9:	eb cc                	jmp    800287 <vprintfmt+0x40>

008002bb <.L29>:
		switch (ch = *(unsigned char *) fmt++) {
  8002bb:	0f b6 d2             	movzbl %dl,%edx
  8002be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002c1:	b8 00 00 00 00       	mov    $0x0,%eax
				precision = precision * 10 + ch - '0';
  8002c6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002cd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002d0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d3:	83 f9 09             	cmp    $0x9,%ecx
  8002d6:	77 55                	ja     80032d <.L23+0xf>
			for (precision = 0; ; ++fmt) {
  8002d8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002db:	eb e9                	jmp    8002c6 <.L29+0xb>

008002dd <.L26>:
			precision = va_arg(ap, int);
  8002dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e0:	8b 00                	mov    (%eax),%eax
  8002e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e8:	8d 40 04             	lea    0x4(%eax),%eax
  8002eb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f5:	79 90                	jns    800287 <vprintfmt+0x40>
				width = precision, precision = -1;
  8002f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800304:	eb 81                	jmp    800287 <vprintfmt+0x40>

00800306 <.L27>:
  800306:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	ba 00 00 00 00       	mov    $0x0,%edx
  800310:	0f 49 d0             	cmovns %eax,%edx
  800313:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800319:	e9 69 ff ff ff       	jmp    800287 <vprintfmt+0x40>

0080031e <.L23>:
  80031e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800321:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800328:	e9 5a ff ff ff       	jmp    800287 <vprintfmt+0x40>
  80032d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800330:	eb bf                	jmp    8002f1 <.L26+0x14>

00800332 <.L33>:
			lflag++;
  800332:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800336:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800339:	e9 49 ff ff ff       	jmp    800287 <vprintfmt+0x40>

0080033e <.L30>:
			putch(va_arg(ap, int), putdat);
  80033e:	8b 45 14             	mov    0x14(%ebp),%eax
  800341:	8d 78 04             	lea    0x4(%eax),%edi
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	56                   	push   %esi
  800348:	ff 30                	pushl  (%eax)
  80034a:	ff 55 08             	call   *0x8(%ebp)
			break;
  80034d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800350:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800353:	e9 99 02 00 00       	jmp    8005f1 <.L35+0x45>

00800358 <.L32>:
			err = va_arg(ap, int);
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8d 78 04             	lea    0x4(%eax),%edi
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	99                   	cltd   
  800361:	31 d0                	xor    %edx,%eax
  800363:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800365:	83 f8 06             	cmp    $0x6,%eax
  800368:	7f 27                	jg     800391 <.L32+0x39>
  80036a:	8b 94 83 0c 00 00 00 	mov    0xc(%ebx,%eax,4),%edx
  800371:	85 d2                	test   %edx,%edx
  800373:	74 1c                	je     800391 <.L32+0x39>
				printfmt(putch, putdat, "%s", p);
  800375:	52                   	push   %edx
  800376:	8d 83 fd ed ff ff    	lea    -0x1203(%ebx),%eax
  80037c:	50                   	push   %eax
  80037d:	56                   	push   %esi
  80037e:	ff 75 08             	pushl  0x8(%ebp)
  800381:	e8 a4 fe ff ff       	call   80022a <printfmt>
  800386:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800389:	89 7d 14             	mov    %edi,0x14(%ebp)
  80038c:	e9 60 02 00 00       	jmp    8005f1 <.L35+0x45>
				printfmt(putch, putdat, "error %d", err);
  800391:	50                   	push   %eax
  800392:	8d 83 f4 ed ff ff    	lea    -0x120c(%ebx),%eax
  800398:	50                   	push   %eax
  800399:	56                   	push   %esi
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 88 fe ff ff       	call   80022a <printfmt>
  8003a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a8:	e9 44 02 00 00       	jmp    8005f1 <.L35+0x45>

008003ad <.L36>:
			if ((p = va_arg(ap, char *)) == NULL)
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	83 c0 04             	add    $0x4,%eax
  8003b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003bb:	85 ff                	test   %edi,%edi
  8003bd:	8d 83 ed ed ff ff    	lea    -0x1213(%ebx),%eax
  8003c3:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ca:	0f 8e b5 00 00 00    	jle    800485 <.L36+0xd8>
  8003d0:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003d4:	75 08                	jne    8003de <.L36+0x31>
  8003d6:	89 75 0c             	mov    %esi,0xc(%ebp)
  8003d9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003dc:	eb 6d                	jmp    80044b <.L36+0x9e>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e4:	57                   	push   %edi
  8003e5:	e8 50 03 00 00       	call   80073a <strnlen>
  8003ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ed:	29 c2                	sub    %eax,%edx
  8003ef:	89 55 c8             	mov    %edx,-0x38(%ebp)
  8003f2:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003ff:	89 d7                	mov    %edx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800401:	eb 10                	jmp    800413 <.L36+0x66>
					putch(padc, putdat);
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	56                   	push   %esi
  800407:	ff 75 e0             	pushl  -0x20(%ebp)
  80040a:	ff 55 08             	call   *0x8(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80040d:	83 ef 01             	sub    $0x1,%edi
  800410:	83 c4 10             	add    $0x10,%esp
  800413:	85 ff                	test   %edi,%edi
  800415:	7f ec                	jg     800403 <.L36+0x56>
  800417:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80041a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80041d:	85 d2                	test   %edx,%edx
  80041f:	b8 00 00 00 00       	mov    $0x0,%eax
  800424:	0f 49 c2             	cmovns %edx,%eax
  800427:	29 c2                	sub    %eax,%edx
  800429:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80042c:	89 75 0c             	mov    %esi,0xc(%ebp)
  80042f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800432:	eb 17                	jmp    80044b <.L36+0x9e>
				if (altflag && (ch < ' ' || ch > '~'))
  800434:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800438:	75 30                	jne    80046a <.L36+0xbd>
					putch(ch, putdat);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	ff 75 0c             	pushl  0xc(%ebp)
  800440:	50                   	push   %eax
  800441:	ff 55 08             	call   *0x8(%ebp)
  800444:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800447:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
  80044b:	83 c7 01             	add    $0x1,%edi
  80044e:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800452:	0f be c2             	movsbl %dl,%eax
  800455:	85 c0                	test   %eax,%eax
  800457:	74 52                	je     8004ab <.L36+0xfe>
  800459:	85 f6                	test   %esi,%esi
  80045b:	78 d7                	js     800434 <.L36+0x87>
  80045d:	83 ee 01             	sub    $0x1,%esi
  800460:	79 d2                	jns    800434 <.L36+0x87>
  800462:	8b 75 0c             	mov    0xc(%ebp),%esi
  800465:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800468:	eb 32                	jmp    80049c <.L36+0xef>
				if (altflag && (ch < ' ' || ch > '~'))
  80046a:	0f be d2             	movsbl %dl,%edx
  80046d:	83 ea 20             	sub    $0x20,%edx
  800470:	83 fa 5e             	cmp    $0x5e,%edx
  800473:	76 c5                	jbe    80043a <.L36+0x8d>
					putch('?', putdat);
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	ff 75 0c             	pushl  0xc(%ebp)
  80047b:	6a 3f                	push   $0x3f
  80047d:	ff 55 08             	call   *0x8(%ebp)
  800480:	83 c4 10             	add    $0x10,%esp
  800483:	eb c2                	jmp    800447 <.L36+0x9a>
  800485:	89 75 0c             	mov    %esi,0xc(%ebp)
  800488:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048b:	eb be                	jmp    80044b <.L36+0x9e>
				putch(' ', putdat);
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	56                   	push   %esi
  800491:	6a 20                	push   $0x20
  800493:	ff 55 08             	call   *0x8(%ebp)
			for (; width > 0; width--)
  800496:	83 ef 01             	sub    $0x1,%edi
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	85 ff                	test   %edi,%edi
  80049e:	7f ed                	jg     80048d <.L36+0xe0>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a6:	e9 46 01 00 00       	jmp    8005f1 <.L35+0x45>
  8004ab:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004b1:	eb e9                	jmp    80049c <.L36+0xef>

008004b3 <.L31>:
  8004b3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  8004b6:	83 f9 01             	cmp    $0x1,%ecx
  8004b9:	7e 40                	jle    8004fb <.L31+0x48>
		return va_arg(*ap, long long);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8b 50 04             	mov    0x4(%eax),%edx
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cc:	8d 40 08             	lea    0x8(%eax),%eax
  8004cf:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d6:	79 55                	jns    80052d <.L31+0x7a>
				putch('-', putdat);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	56                   	push   %esi
  8004dc:	6a 2d                	push   $0x2d
  8004de:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8004e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e7:	f7 da                	neg    %edx
  8004e9:	83 d1 00             	adc    $0x0,%ecx
  8004ec:	f7 d9                	neg    %ecx
  8004ee:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f6:	e9 db 00 00 00       	jmp    8005d6 <.L35+0x2a>
	else if (lflag)
  8004fb:	85 c9                	test   %ecx,%ecx
  8004fd:	75 17                	jne    800516 <.L31+0x63>
		return va_arg(*ap, int);
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800507:	99                   	cltd   
  800508:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 40 04             	lea    0x4(%eax),%eax
  800511:	89 45 14             	mov    %eax,0x14(%ebp)
  800514:	eb bc                	jmp    8004d2 <.L31+0x1f>
		return va_arg(*ap, long);
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051e:	99                   	cltd   
  80051f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 40 04             	lea    0x4(%eax),%eax
  800528:	89 45 14             	mov    %eax,0x14(%ebp)
  80052b:	eb a5                	jmp    8004d2 <.L31+0x1f>
			num = getint(&ap, lflag);
  80052d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800530:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800533:	b8 0a 00 00 00       	mov    $0xa,%eax
  800538:	e9 99 00 00 00       	jmp    8005d6 <.L35+0x2a>

0080053d <.L37>:
  80053d:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  800540:	83 f9 01             	cmp    $0x1,%ecx
  800543:	7e 15                	jle    80055a <.L37+0x1d>
		return va_arg(*ap, unsigned long long);
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8b 10                	mov    (%eax),%edx
  80054a:	8b 48 04             	mov    0x4(%eax),%ecx
  80054d:	8d 40 08             	lea    0x8(%eax),%eax
  800550:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800553:	b8 0a 00 00 00       	mov    $0xa,%eax
  800558:	eb 7c                	jmp    8005d6 <.L35+0x2a>
	else if (lflag)
  80055a:	85 c9                	test   %ecx,%ecx
  80055c:	75 17                	jne    800575 <.L37+0x38>
		return va_arg(*ap, unsigned int);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8b 10                	mov    (%eax),%edx
  800563:	b9 00 00 00 00       	mov    $0x0,%ecx
  800568:	8d 40 04             	lea    0x4(%eax),%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800573:	eb 61                	jmp    8005d6 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 10                	mov    (%eax),%edx
  80057a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800585:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058a:	eb 4a                	jmp    8005d6 <.L35+0x2a>

0080058c <.L34>:
			putch('X', putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	56                   	push   %esi
  800590:	6a 58                	push   $0x58
  800592:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  800595:	83 c4 08             	add    $0x8,%esp
  800598:	56                   	push   %esi
  800599:	6a 58                	push   $0x58
  80059b:	ff 55 08             	call   *0x8(%ebp)
			putch('X', putdat);
  80059e:	83 c4 08             	add    $0x8,%esp
  8005a1:	56                   	push   %esi
  8005a2:	6a 58                	push   $0x58
  8005a4:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	eb 45                	jmp    8005f1 <.L35+0x45>

008005ac <.L35>:
			putch('0', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	56                   	push   %esi
  8005b0:	6a 30                	push   $0x30
  8005b2:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8005b5:	83 c4 08             	add    $0x8,%esp
  8005b8:	56                   	push   %esi
  8005b9:	6a 78                	push   $0x78
  8005bb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 10                	mov    (%eax),%edx
  8005c3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005c8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005cb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005d1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005d6:	83 ec 0c             	sub    $0xc,%esp
  8005d9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005dd:	57                   	push   %edi
  8005de:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e1:	50                   	push   %eax
  8005e2:	51                   	push   %ecx
  8005e3:	52                   	push   %edx
  8005e4:	89 f2                	mov    %esi,%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	e8 55 fb ff ff       	call   800143 <printnum>
			break;
  8005ee:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8005f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f4:	83 c7 01             	add    $0x1,%edi
  8005f7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fb:	83 f8 25             	cmp    $0x25,%eax
  8005fe:	0f 84 62 fc ff ff    	je     800266 <vprintfmt+0x1f>
			if (ch == '\0')
  800604:	85 c0                	test   %eax,%eax
  800606:	0f 84 91 00 00 00    	je     80069d <.L22+0x21>
			putch(ch, putdat);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	56                   	push   %esi
  800610:	50                   	push   %eax
  800611:	ff 55 08             	call   *0x8(%ebp)
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	eb db                	jmp    8005f4 <.L35+0x48>

00800619 <.L38>:
  800619:	8b 4d cc             	mov    -0x34(%ebp),%ecx
	if (lflag >= 2)
  80061c:	83 f9 01             	cmp    $0x1,%ecx
  80061f:	7e 15                	jle    800636 <.L38+0x1d>
		return va_arg(*ap, unsigned long long);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	8b 48 04             	mov    0x4(%eax),%ecx
  800629:	8d 40 08             	lea    0x8(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062f:	b8 10 00 00 00       	mov    $0x10,%eax
  800634:	eb a0                	jmp    8005d6 <.L35+0x2a>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	75 17                	jne    800651 <.L38+0x38>
		return va_arg(*ap, unsigned int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064a:	b8 10 00 00 00       	mov    $0x10,%eax
  80064f:	eb 85                	jmp    8005d6 <.L35+0x2a>
		return va_arg(*ap, unsigned long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800661:	b8 10 00 00 00       	mov    $0x10,%eax
  800666:	e9 6b ff ff ff       	jmp    8005d6 <.L35+0x2a>

0080066b <.L25>:
			putch(ch, putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	56                   	push   %esi
  80066f:	6a 25                	push   $0x25
  800671:	ff 55 08             	call   *0x8(%ebp)
			break;
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	e9 75 ff ff ff       	jmp    8005f1 <.L35+0x45>

0080067c <.L22>:
			putch('%', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	56                   	push   %esi
  800680:	6a 25                	push   $0x25
  800682:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	89 f8                	mov    %edi,%eax
  80068a:	eb 03                	jmp    80068f <.L22+0x13>
  80068c:	83 e8 01             	sub    $0x1,%eax
  80068f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800693:	75 f7                	jne    80068c <.L22+0x10>
  800695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800698:	e9 54 ff ff ff       	jmp    8005f1 <.L35+0x45>
}
  80069d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a0:	5b                   	pop    %ebx
  8006a1:	5e                   	pop    %esi
  8006a2:	5f                   	pop    %edi
  8006a3:	5d                   	pop    %ebp
  8006a4:	c3                   	ret    

008006a5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	53                   	push   %ebx
  8006a9:	83 ec 14             	sub    $0x14,%esp
  8006ac:	e8 a8 f9 ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  8006b1:	81 c3 4f 19 00 00    	add    $0x194f,%ebx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	74 2b                	je     8006fd <vsnprintf+0x58>
  8006d2:	85 d2                	test   %edx,%edx
  8006d4:	7e 27                	jle    8006fd <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d6:	ff 75 14             	pushl  0x14(%ebp)
  8006d9:	ff 75 10             	pushl  0x10(%ebp)
  8006dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006df:	50                   	push   %eax
  8006e0:	8d 83 0d e2 ff ff    	lea    -0x1df3(%ebx),%eax
  8006e6:	50                   	push   %eax
  8006e7:	e8 5b fb ff ff       	call   800247 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f5:	83 c4 10             	add    $0x10,%esp
}
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    
		return -E_INVAL;
  8006fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800702:	eb f4                	jmp    8006f8 <vsnprintf+0x53>

00800704 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80070a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80070d:	50                   	push   %eax
  80070e:	ff 75 10             	pushl  0x10(%ebp)
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	ff 75 08             	pushl  0x8(%ebp)
  800717:	e8 89 ff ff ff       	call   8006a5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <__x86.get_pc_thunk.cx>:
  80071e:	8b 0c 24             	mov    (%esp),%ecx
  800721:	c3                   	ret    

00800722 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800722:	55                   	push   %ebp
  800723:	89 e5                	mov    %esp,%ebp
  800725:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	eb 03                	jmp    800732 <strlen+0x10>
		n++;
  80072f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800732:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800736:	75 f7                	jne    80072f <strlen+0xd>
	return n;
}
  800738:	5d                   	pop    %ebp
  800739:	c3                   	ret    

0080073a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800740:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800743:	b8 00 00 00 00       	mov    $0x0,%eax
  800748:	eb 03                	jmp    80074d <strnlen+0x13>
		n++;
  80074a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80074d:	39 d0                	cmp    %edx,%eax
  80074f:	74 06                	je     800757 <strnlen+0x1d>
  800751:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800755:	75 f3                	jne    80074a <strnlen+0x10>
	return n;
}
  800757:	5d                   	pop    %ebp
  800758:	c3                   	ret    

00800759 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800763:	89 c2                	mov    %eax,%edx
  800765:	83 c1 01             	add    $0x1,%ecx
  800768:	83 c2 01             	add    $0x1,%edx
  80076b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80076f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800772:	84 db                	test   %bl,%bl
  800774:	75 ef                	jne    800765 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800776:	5b                   	pop    %ebx
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	53                   	push   %ebx
  80077d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800780:	53                   	push   %ebx
  800781:	e8 9c ff ff ff       	call   800722 <strlen>
  800786:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800789:	ff 75 0c             	pushl  0xc(%ebp)
  80078c:	01 d8                	add    %ebx,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 c5 ff ff ff       	call   800759 <strcpy>
	return dst;
}
  800794:	89 d8                	mov    %ebx,%eax
  800796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	56                   	push   %esi
  80079f:	53                   	push   %ebx
  8007a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a6:	89 f3                	mov    %esi,%ebx
  8007a8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007ab:	89 f2                	mov    %esi,%edx
  8007ad:	eb 0f                	jmp    8007be <strncpy+0x23>
		*dst++ = *src;
  8007af:	83 c2 01             	add    $0x1,%edx
  8007b2:	0f b6 01             	movzbl (%ecx),%eax
  8007b5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007b8:	80 39 01             	cmpb   $0x1,(%ecx)
  8007bb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007be:	39 da                	cmp    %ebx,%edx
  8007c0:	75 ed                	jne    8007af <strncpy+0x14>
	}
	return ret;
}
  8007c2:	89 f0                	mov    %esi,%eax
  8007c4:	5b                   	pop    %ebx
  8007c5:	5e                   	pop    %esi
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	56                   	push   %esi
  8007cc:	53                   	push   %ebx
  8007cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007d6:	89 f0                	mov    %esi,%eax
  8007d8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007dc:	85 c9                	test   %ecx,%ecx
  8007de:	75 0b                	jne    8007eb <strlcpy+0x23>
  8007e0:	eb 17                	jmp    8007f9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007e2:	83 c2 01             	add    $0x1,%edx
  8007e5:	83 c0 01             	add    $0x1,%eax
  8007e8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007eb:	39 d8                	cmp    %ebx,%eax
  8007ed:	74 07                	je     8007f6 <strlcpy+0x2e>
  8007ef:	0f b6 0a             	movzbl (%edx),%ecx
  8007f2:	84 c9                	test   %cl,%cl
  8007f4:	75 ec                	jne    8007e2 <strlcpy+0x1a>
		*dst = '\0';
  8007f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007f9:	29 f0                	sub    %esi,%eax
}
  8007fb:	5b                   	pop    %ebx
  8007fc:	5e                   	pop    %esi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800805:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800808:	eb 06                	jmp    800810 <strcmp+0x11>
		p++, q++;
  80080a:	83 c1 01             	add    $0x1,%ecx
  80080d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800810:	0f b6 01             	movzbl (%ecx),%eax
  800813:	84 c0                	test   %al,%al
  800815:	74 04                	je     80081b <strcmp+0x1c>
  800817:	3a 02                	cmp    (%edx),%al
  800819:	74 ef                	je     80080a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80081b:	0f b6 c0             	movzbl %al,%eax
  80081e:	0f b6 12             	movzbl (%edx),%edx
  800821:	29 d0                	sub    %edx,%eax
}
  800823:	5d                   	pop    %ebp
  800824:	c3                   	ret    

00800825 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	53                   	push   %ebx
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082f:	89 c3                	mov    %eax,%ebx
  800831:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800834:	eb 06                	jmp    80083c <strncmp+0x17>
		n--, p++, q++;
  800836:	83 c0 01             	add    $0x1,%eax
  800839:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80083c:	39 d8                	cmp    %ebx,%eax
  80083e:	74 16                	je     800856 <strncmp+0x31>
  800840:	0f b6 08             	movzbl (%eax),%ecx
  800843:	84 c9                	test   %cl,%cl
  800845:	74 04                	je     80084b <strncmp+0x26>
  800847:	3a 0a                	cmp    (%edx),%cl
  800849:	74 eb                	je     800836 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80084b:	0f b6 00             	movzbl (%eax),%eax
  80084e:	0f b6 12             	movzbl (%edx),%edx
  800851:	29 d0                	sub    %edx,%eax
}
  800853:	5b                   	pop    %ebx
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    
		return 0;
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	eb f6                	jmp    800853 <strncmp+0x2e>

0080085d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800867:	0f b6 10             	movzbl (%eax),%edx
  80086a:	84 d2                	test   %dl,%dl
  80086c:	74 09                	je     800877 <strchr+0x1a>
		if (*s == c)
  80086e:	38 ca                	cmp    %cl,%dl
  800870:	74 0a                	je     80087c <strchr+0x1f>
	for (; *s; s++)
  800872:	83 c0 01             	add    $0x1,%eax
  800875:	eb f0                	jmp    800867 <strchr+0xa>
			return (char *) s;
	return 0;
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800888:	eb 03                	jmp    80088d <strfind+0xf>
  80088a:	83 c0 01             	add    $0x1,%eax
  80088d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800890:	38 ca                	cmp    %cl,%dl
  800892:	74 04                	je     800898 <strfind+0x1a>
  800894:	84 d2                	test   %dl,%dl
  800896:	75 f2                	jne    80088a <strfind+0xc>
			break;
	return (char *) s;
}
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	57                   	push   %edi
  80089e:	56                   	push   %esi
  80089f:	53                   	push   %ebx
  8008a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008a6:	85 c9                	test   %ecx,%ecx
  8008a8:	74 13                	je     8008bd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008aa:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008b0:	75 05                	jne    8008b7 <memset+0x1d>
  8008b2:	f6 c1 03             	test   $0x3,%cl
  8008b5:	74 0d                	je     8008c4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ba:	fc                   	cld    
  8008bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008bd:	89 f8                	mov    %edi,%eax
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5f                   	pop    %edi
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    
		c &= 0xFF;
  8008c4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008c8:	89 d3                	mov    %edx,%ebx
  8008ca:	c1 e3 08             	shl    $0x8,%ebx
  8008cd:	89 d0                	mov    %edx,%eax
  8008cf:	c1 e0 18             	shl    $0x18,%eax
  8008d2:	89 d6                	mov    %edx,%esi
  8008d4:	c1 e6 10             	shl    $0x10,%esi
  8008d7:	09 f0                	or     %esi,%eax
  8008d9:	09 c2                	or     %eax,%edx
  8008db:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008dd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008e0:	89 d0                	mov    %edx,%eax
  8008e2:	fc                   	cld    
  8008e3:	f3 ab                	rep stos %eax,%es:(%edi)
  8008e5:	eb d6                	jmp    8008bd <memset+0x23>

008008e7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	57                   	push   %edi
  8008eb:	56                   	push   %esi
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008f5:	39 c6                	cmp    %eax,%esi
  8008f7:	73 35                	jae    80092e <memmove+0x47>
  8008f9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	76 2e                	jbe    80092e <memmove+0x47>
		s += n;
		d += n;
  800900:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800903:	89 d6                	mov    %edx,%esi
  800905:	09 fe                	or     %edi,%esi
  800907:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80090d:	74 0c                	je     80091b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80090f:	83 ef 01             	sub    $0x1,%edi
  800912:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800915:	fd                   	std    
  800916:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800918:	fc                   	cld    
  800919:	eb 21                	jmp    80093c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80091b:	f6 c1 03             	test   $0x3,%cl
  80091e:	75 ef                	jne    80090f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800920:	83 ef 04             	sub    $0x4,%edi
  800923:	8d 72 fc             	lea    -0x4(%edx),%esi
  800926:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800929:	fd                   	std    
  80092a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80092c:	eb ea                	jmp    800918 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80092e:	89 f2                	mov    %esi,%edx
  800930:	09 c2                	or     %eax,%edx
  800932:	f6 c2 03             	test   $0x3,%dl
  800935:	74 09                	je     800940 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800937:	89 c7                	mov    %eax,%edi
  800939:	fc                   	cld    
  80093a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80093c:	5e                   	pop    %esi
  80093d:	5f                   	pop    %edi
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800940:	f6 c1 03             	test   $0x3,%cl
  800943:	75 f2                	jne    800937 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800945:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800948:	89 c7                	mov    %eax,%edi
  80094a:	fc                   	cld    
  80094b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80094d:	eb ed                	jmp    80093c <memmove+0x55>

0080094f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800952:	ff 75 10             	pushl  0x10(%ebp)
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	e8 87 ff ff ff       	call   8008e7 <memmove>
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    

00800962 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	56                   	push   %esi
  800966:	53                   	push   %ebx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096d:	89 c6                	mov    %eax,%esi
  80096f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800972:	39 f0                	cmp    %esi,%eax
  800974:	74 1c                	je     800992 <memcmp+0x30>
		if (*s1 != *s2)
  800976:	0f b6 08             	movzbl (%eax),%ecx
  800979:	0f b6 1a             	movzbl (%edx),%ebx
  80097c:	38 d9                	cmp    %bl,%cl
  80097e:	75 08                	jne    800988 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800980:	83 c0 01             	add    $0x1,%eax
  800983:	83 c2 01             	add    $0x1,%edx
  800986:	eb ea                	jmp    800972 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800988:	0f b6 c1             	movzbl %cl,%eax
  80098b:	0f b6 db             	movzbl %bl,%ebx
  80098e:	29 d8                	sub    %ebx,%eax
  800990:	eb 05                	jmp    800997 <memcmp+0x35>
	}

	return 0;
  800992:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800997:	5b                   	pop    %ebx
  800998:	5e                   	pop    %esi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009a4:	89 c2                	mov    %eax,%edx
  8009a6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009a9:	39 d0                	cmp    %edx,%eax
  8009ab:	73 09                	jae    8009b6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ad:	38 08                	cmp    %cl,(%eax)
  8009af:	74 05                	je     8009b6 <memfind+0x1b>
	for (; s < ends; s++)
  8009b1:	83 c0 01             	add    $0x1,%eax
  8009b4:	eb f3                	jmp    8009a9 <memfind+0xe>
			break;
	return (void *) s;
}
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	57                   	push   %edi
  8009bc:	56                   	push   %esi
  8009bd:	53                   	push   %ebx
  8009be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009c4:	eb 03                	jmp    8009c9 <strtol+0x11>
		s++;
  8009c6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009c9:	0f b6 01             	movzbl (%ecx),%eax
  8009cc:	3c 20                	cmp    $0x20,%al
  8009ce:	74 f6                	je     8009c6 <strtol+0xe>
  8009d0:	3c 09                	cmp    $0x9,%al
  8009d2:	74 f2                	je     8009c6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009d4:	3c 2b                	cmp    $0x2b,%al
  8009d6:	74 2e                	je     800a06 <strtol+0x4e>
	int neg = 0;
  8009d8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009dd:	3c 2d                	cmp    $0x2d,%al
  8009df:	74 2f                	je     800a10 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009e1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009e7:	75 05                	jne    8009ee <strtol+0x36>
  8009e9:	80 39 30             	cmpb   $0x30,(%ecx)
  8009ec:	74 2c                	je     800a1a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009ee:	85 db                	test   %ebx,%ebx
  8009f0:	75 0a                	jne    8009fc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009f2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009f7:	80 39 30             	cmpb   $0x30,(%ecx)
  8009fa:	74 28                	je     800a24 <strtol+0x6c>
		base = 10;
  8009fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800a01:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a04:	eb 50                	jmp    800a56 <strtol+0x9e>
		s++;
  800a06:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a09:	bf 00 00 00 00       	mov    $0x0,%edi
  800a0e:	eb d1                	jmp    8009e1 <strtol+0x29>
		s++, neg = 1;
  800a10:	83 c1 01             	add    $0x1,%ecx
  800a13:	bf 01 00 00 00       	mov    $0x1,%edi
  800a18:	eb c7                	jmp    8009e1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a1a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a1e:	74 0e                	je     800a2e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a20:	85 db                	test   %ebx,%ebx
  800a22:	75 d8                	jne    8009fc <strtol+0x44>
		s++, base = 8;
  800a24:	83 c1 01             	add    $0x1,%ecx
  800a27:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a2c:	eb ce                	jmp    8009fc <strtol+0x44>
		s += 2, base = 16;
  800a2e:	83 c1 02             	add    $0x2,%ecx
  800a31:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a36:	eb c4                	jmp    8009fc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a38:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a3b:	89 f3                	mov    %esi,%ebx
  800a3d:	80 fb 19             	cmp    $0x19,%bl
  800a40:	77 29                	ja     800a6b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a42:	0f be d2             	movsbl %dl,%edx
  800a45:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a48:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a4b:	7d 30                	jge    800a7d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a54:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a56:	0f b6 11             	movzbl (%ecx),%edx
  800a59:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a5c:	89 f3                	mov    %esi,%ebx
  800a5e:	80 fb 09             	cmp    $0x9,%bl
  800a61:	77 d5                	ja     800a38 <strtol+0x80>
			dig = *s - '0';
  800a63:	0f be d2             	movsbl %dl,%edx
  800a66:	83 ea 30             	sub    $0x30,%edx
  800a69:	eb dd                	jmp    800a48 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a6b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a6e:	89 f3                	mov    %esi,%ebx
  800a70:	80 fb 19             	cmp    $0x19,%bl
  800a73:	77 08                	ja     800a7d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a75:	0f be d2             	movsbl %dl,%edx
  800a78:	83 ea 37             	sub    $0x37,%edx
  800a7b:	eb cb                	jmp    800a48 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a81:	74 05                	je     800a88 <strtol+0xd0>
		*endptr = (char *) s;
  800a83:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a86:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	f7 da                	neg    %edx
  800a8c:	85 ff                	test   %edi,%edi
  800a8e:	0f 45 c2             	cmovne %edx,%eax
}
  800a91:	5b                   	pop    %ebx
  800a92:	5e                   	pop    %esi
  800a93:	5f                   	pop    %edi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa7:	89 c3                	mov    %eax,%ebx
  800aa9:	89 c7                	mov    %eax,%edi
  800aab:	89 c6                	mov    %eax,%esi
  800aad:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5f                   	pop    %edi
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	57                   	push   %edi
  800ab8:	56                   	push   %esi
  800ab9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aba:	ba 00 00 00 00       	mov    $0x0,%edx
  800abf:	b8 01 00 00 00       	mov    $0x1,%eax
  800ac4:	89 d1                	mov    %edx,%ecx
  800ac6:	89 d3                	mov    %edx,%ebx
  800ac8:	89 d7                	mov    %edx,%edi
  800aca:	89 d6                	mov    %edx,%esi
  800acc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ace:	5b                   	pop    %ebx
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	57                   	push   %edi
  800ad7:	56                   	push   %esi
  800ad8:	53                   	push   %ebx
  800ad9:	83 ec 1c             	sub    $0x1c,%esp
  800adc:	e8 78 f5 ff ff       	call   800059 <__x86.get_pc_thunk.bx>
  800ae1:	81 c3 1f 15 00 00    	add    $0x151f,%ebx
  800ae7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	asm volatile("int %1\n"
  800aea:	be 00 00 00 00       	mov    $0x0,%esi
  800aef:	8b 55 08             	mov    0x8(%ebp),%edx
  800af2:	b8 03 00 00 00       	mov    $0x3,%eax
  800af7:	89 f1                	mov    %esi,%ecx
  800af9:	89 f3                	mov    %esi,%ebx
  800afb:	89 f7                	mov    %esi,%edi
  800afd:	cd 30                	int    $0x30
  800aff:	89 c6                	mov    %eax,%esi
	if(check && ret > 0) {
  800b01:	85 c0                	test   %eax,%eax
  800b03:	7e 18                	jle    800b1d <sys_env_destroy+0x4a>
		cprintf("syscall %d returned %d (> 0)", num, ret);
  800b05:	83 ec 04             	sub    $0x4,%esp
  800b08:	50                   	push   %eax
  800b09:	6a 03                	push   $0x3
  800b0b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800b0e:	8d 83 c4 ef ff ff    	lea    -0x103c(%ebx),%eax
  800b14:	50                   	push   %eax
  800b15:	e8 15 f6 ff ff       	call   80012f <cprintf>
  800b1a:	83 c4 10             	add    $0x10,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b1d:	89 f0                	mov    %esi,%eax
  800b1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5f                   	pop    %edi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	b8 02 00 00 00       	mov    $0x2,%eax
  800b37:	89 d1                	mov    %edx,%ecx
  800b39:	89 d3                	mov    %edx,%ebx
  800b3b:	89 d7                	mov    %edx,%edi
  800b3d:	89 d6                	mov    %edx,%esi
  800b3f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <sys_test>:

void
sys_test(void)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b51:	b8 04 00 00 00       	mov    $0x4,%eax
  800b56:	89 d1                	mov    %edx,%ecx
  800b58:	89 d3                	mov    %edx,%ebx
  800b5a:	89 d7                	mov    %edx,%edi
  800b5c:	89 d6                	mov    %edx,%esi
  800b5e:	cd 30                	int    $0x30
		syscall(SYS_test, 0, 0, 0, 0, 0, 0);
}
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    
  800b65:	66 90                	xchg   %ax,%ax
  800b67:	66 90                	xchg   %ax,%ax
  800b69:	66 90                	xchg   %ax,%ax
  800b6b:	66 90                	xchg   %ax,%ax
  800b6d:	66 90                	xchg   %ax,%ax
  800b6f:	90                   	nop

00800b70 <__udivdi3>:
  800b70:	55                   	push   %ebp
  800b71:	57                   	push   %edi
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 1c             	sub    $0x1c,%esp
  800b77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800b7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800b7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800b83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800b87:	85 d2                	test   %edx,%edx
  800b89:	75 35                	jne    800bc0 <__udivdi3+0x50>
  800b8b:	39 f3                	cmp    %esi,%ebx
  800b8d:	0f 87 bd 00 00 00    	ja     800c50 <__udivdi3+0xe0>
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	89 d9                	mov    %ebx,%ecx
  800b97:	75 0b                	jne    800ba4 <__udivdi3+0x34>
  800b99:	b8 01 00 00 00       	mov    $0x1,%eax
  800b9e:	31 d2                	xor    %edx,%edx
  800ba0:	f7 f3                	div    %ebx
  800ba2:	89 c1                	mov    %eax,%ecx
  800ba4:	31 d2                	xor    %edx,%edx
  800ba6:	89 f0                	mov    %esi,%eax
  800ba8:	f7 f1                	div    %ecx
  800baa:	89 c6                	mov    %eax,%esi
  800bac:	89 e8                	mov    %ebp,%eax
  800bae:	89 f7                	mov    %esi,%edi
  800bb0:	f7 f1                	div    %ecx
  800bb2:	89 fa                	mov    %edi,%edx
  800bb4:	83 c4 1c             	add    $0x1c,%esp
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    
  800bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800bc0:	39 f2                	cmp    %esi,%edx
  800bc2:	77 7c                	ja     800c40 <__udivdi3+0xd0>
  800bc4:	0f bd fa             	bsr    %edx,%edi
  800bc7:	83 f7 1f             	xor    $0x1f,%edi
  800bca:	0f 84 98 00 00 00    	je     800c68 <__udivdi3+0xf8>
  800bd0:	89 f9                	mov    %edi,%ecx
  800bd2:	b8 20 00 00 00       	mov    $0x20,%eax
  800bd7:	29 f8                	sub    %edi,%eax
  800bd9:	d3 e2                	shl    %cl,%edx
  800bdb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bdf:	89 c1                	mov    %eax,%ecx
  800be1:	89 da                	mov    %ebx,%edx
  800be3:	d3 ea                	shr    %cl,%edx
  800be5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800be9:	09 d1                	or     %edx,%ecx
  800beb:	89 f2                	mov    %esi,%edx
  800bed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bf1:	89 f9                	mov    %edi,%ecx
  800bf3:	d3 e3                	shl    %cl,%ebx
  800bf5:	89 c1                	mov    %eax,%ecx
  800bf7:	d3 ea                	shr    %cl,%edx
  800bf9:	89 f9                	mov    %edi,%ecx
  800bfb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bff:	d3 e6                	shl    %cl,%esi
  800c01:	89 eb                	mov    %ebp,%ebx
  800c03:	89 c1                	mov    %eax,%ecx
  800c05:	d3 eb                	shr    %cl,%ebx
  800c07:	09 de                	or     %ebx,%esi
  800c09:	89 f0                	mov    %esi,%eax
  800c0b:	f7 74 24 08          	divl   0x8(%esp)
  800c0f:	89 d6                	mov    %edx,%esi
  800c11:	89 c3                	mov    %eax,%ebx
  800c13:	f7 64 24 0c          	mull   0xc(%esp)
  800c17:	39 d6                	cmp    %edx,%esi
  800c19:	72 0c                	jb     800c27 <__udivdi3+0xb7>
  800c1b:	89 f9                	mov    %edi,%ecx
  800c1d:	d3 e5                	shl    %cl,%ebp
  800c1f:	39 c5                	cmp    %eax,%ebp
  800c21:	73 5d                	jae    800c80 <__udivdi3+0x110>
  800c23:	39 d6                	cmp    %edx,%esi
  800c25:	75 59                	jne    800c80 <__udivdi3+0x110>
  800c27:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800c2a:	31 ff                	xor    %edi,%edi
  800c2c:	89 fa                	mov    %edi,%edx
  800c2e:	83 c4 1c             	add    $0x1c,%esp
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    
  800c36:	8d 76 00             	lea    0x0(%esi),%esi
  800c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800c40:	31 ff                	xor    %edi,%edi
  800c42:	31 c0                	xor    %eax,%eax
  800c44:	89 fa                	mov    %edi,%edx
  800c46:	83 c4 1c             	add    $0x1c,%esp
  800c49:	5b                   	pop    %ebx
  800c4a:	5e                   	pop    %esi
  800c4b:	5f                   	pop    %edi
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    
  800c4e:	66 90                	xchg   %ax,%ax
  800c50:	31 ff                	xor    %edi,%edi
  800c52:	89 e8                	mov    %ebp,%eax
  800c54:	89 f2                	mov    %esi,%edx
  800c56:	f7 f3                	div    %ebx
  800c58:	89 fa                	mov    %edi,%edx
  800c5a:	83 c4 1c             	add    $0x1c,%esp
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    
  800c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800c68:	39 f2                	cmp    %esi,%edx
  800c6a:	72 06                	jb     800c72 <__udivdi3+0x102>
  800c6c:	31 c0                	xor    %eax,%eax
  800c6e:	39 eb                	cmp    %ebp,%ebx
  800c70:	77 d2                	ja     800c44 <__udivdi3+0xd4>
  800c72:	b8 01 00 00 00       	mov    $0x1,%eax
  800c77:	eb cb                	jmp    800c44 <__udivdi3+0xd4>
  800c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800c80:	89 d8                	mov    %ebx,%eax
  800c82:	31 ff                	xor    %edi,%edi
  800c84:	eb be                	jmp    800c44 <__udivdi3+0xd4>
  800c86:	66 90                	xchg   %ax,%ax
  800c88:	66 90                	xchg   %ax,%ax
  800c8a:	66 90                	xchg   %ax,%ax
  800c8c:	66 90                	xchg   %ax,%ax
  800c8e:	66 90                	xchg   %ax,%ax

00800c90 <__umoddi3>:
  800c90:	55                   	push   %ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	83 ec 1c             	sub    $0x1c,%esp
  800c97:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800c9b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800c9f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ca3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ca7:	85 ed                	test   %ebp,%ebp
  800ca9:	89 f0                	mov    %esi,%eax
  800cab:	89 da                	mov    %ebx,%edx
  800cad:	75 19                	jne    800cc8 <__umoddi3+0x38>
  800caf:	39 df                	cmp    %ebx,%edi
  800cb1:	0f 86 b1 00 00 00    	jbe    800d68 <__umoddi3+0xd8>
  800cb7:	f7 f7                	div    %edi
  800cb9:	89 d0                	mov    %edx,%eax
  800cbb:	31 d2                	xor    %edx,%edx
  800cbd:	83 c4 1c             	add    $0x1c,%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    
  800cc5:	8d 76 00             	lea    0x0(%esi),%esi
  800cc8:	39 dd                	cmp    %ebx,%ebp
  800cca:	77 f1                	ja     800cbd <__umoddi3+0x2d>
  800ccc:	0f bd cd             	bsr    %ebp,%ecx
  800ccf:	83 f1 1f             	xor    $0x1f,%ecx
  800cd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cd6:	0f 84 b4 00 00 00    	je     800d90 <__umoddi3+0x100>
  800cdc:	b8 20 00 00 00       	mov    $0x20,%eax
  800ce1:	89 c2                	mov    %eax,%edx
  800ce3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ce7:	29 c2                	sub    %eax,%edx
  800ce9:	89 c1                	mov    %eax,%ecx
  800ceb:	89 f8                	mov    %edi,%eax
  800ced:	d3 e5                	shl    %cl,%ebp
  800cef:	89 d1                	mov    %edx,%ecx
  800cf1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800cf5:	d3 e8                	shr    %cl,%eax
  800cf7:	09 c5                	or     %eax,%ebp
  800cf9:	8b 44 24 04          	mov    0x4(%esp),%eax
  800cfd:	89 c1                	mov    %eax,%ecx
  800cff:	d3 e7                	shl    %cl,%edi
  800d01:	89 d1                	mov    %edx,%ecx
  800d03:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d07:	89 df                	mov    %ebx,%edi
  800d09:	d3 ef                	shr    %cl,%edi
  800d0b:	89 c1                	mov    %eax,%ecx
  800d0d:	89 f0                	mov    %esi,%eax
  800d0f:	d3 e3                	shl    %cl,%ebx
  800d11:	89 d1                	mov    %edx,%ecx
  800d13:	89 fa                	mov    %edi,%edx
  800d15:	d3 e8                	shr    %cl,%eax
  800d17:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800d1c:	09 d8                	or     %ebx,%eax
  800d1e:	f7 f5                	div    %ebp
  800d20:	d3 e6                	shl    %cl,%esi
  800d22:	89 d1                	mov    %edx,%ecx
  800d24:	f7 64 24 08          	mull   0x8(%esp)
  800d28:	39 d1                	cmp    %edx,%ecx
  800d2a:	89 c3                	mov    %eax,%ebx
  800d2c:	89 d7                	mov    %edx,%edi
  800d2e:	72 06                	jb     800d36 <__umoddi3+0xa6>
  800d30:	75 0e                	jne    800d40 <__umoddi3+0xb0>
  800d32:	39 c6                	cmp    %eax,%esi
  800d34:	73 0a                	jae    800d40 <__umoddi3+0xb0>
  800d36:	2b 44 24 08          	sub    0x8(%esp),%eax
  800d3a:	19 ea                	sbb    %ebp,%edx
  800d3c:	89 d7                	mov    %edx,%edi
  800d3e:	89 c3                	mov    %eax,%ebx
  800d40:	89 ca                	mov    %ecx,%edx
  800d42:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800d47:	29 de                	sub    %ebx,%esi
  800d49:	19 fa                	sbb    %edi,%edx
  800d4b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800d4f:	89 d0                	mov    %edx,%eax
  800d51:	d3 e0                	shl    %cl,%eax
  800d53:	89 d9                	mov    %ebx,%ecx
  800d55:	d3 ee                	shr    %cl,%esi
  800d57:	d3 ea                	shr    %cl,%edx
  800d59:	09 f0                	or     %esi,%eax
  800d5b:	83 c4 1c             	add    $0x1c,%esp
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    
  800d63:	90                   	nop
  800d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d68:	85 ff                	test   %edi,%edi
  800d6a:	89 f9                	mov    %edi,%ecx
  800d6c:	75 0b                	jne    800d79 <__umoddi3+0xe9>
  800d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d73:	31 d2                	xor    %edx,%edx
  800d75:	f7 f7                	div    %edi
  800d77:	89 c1                	mov    %eax,%ecx
  800d79:	89 d8                	mov    %ebx,%eax
  800d7b:	31 d2                	xor    %edx,%edx
  800d7d:	f7 f1                	div    %ecx
  800d7f:	89 f0                	mov    %esi,%eax
  800d81:	f7 f1                	div    %ecx
  800d83:	e9 31 ff ff ff       	jmp    800cb9 <__umoddi3+0x29>
  800d88:	90                   	nop
  800d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800d90:	39 dd                	cmp    %ebx,%ebp
  800d92:	72 08                	jb     800d9c <__umoddi3+0x10c>
  800d94:	39 f7                	cmp    %esi,%edi
  800d96:	0f 87 21 ff ff ff    	ja     800cbd <__umoddi3+0x2d>
  800d9c:	89 da                	mov    %ebx,%edx
  800d9e:	89 f0                	mov    %esi,%eax
  800da0:	29 f8                	sub    %edi,%eax
  800da2:	19 ea                	sbb    %ebp,%edx
  800da4:	e9 14 ff ff ff       	jmp    800cbd <__umoddi3+0x2d>
