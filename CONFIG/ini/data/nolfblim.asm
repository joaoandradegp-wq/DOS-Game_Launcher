;NOLFBLIM.ASM by Ken Silverman (http://www.advsys.net/ken) 03/22/2005
;
;NOLFBLIM is a TSR that disables the linear framebuffer (LFB) in VESA 2.0
;(and above) BIOS. In addition, it locks the frame rate to the refresh rate
;of your screen. Disabling the frame buffer will make some DOS games
;(including BUILD engine games and other demos on my website) run under
;Windows NT/2K/XP. Programs will run slower without the LFB, but at least
;they work! Locking the frame rate will only work if you have a VGA
;register-compatible card, and the default VESA driver supports the VESA
;protected mode interface.
;
;Compiling info: This MUST be run as a COM file!
;I compiled NOLFBLIM.ASM->NOLFBLIM.COM by using utilities from Watcom C:
;   >wasm nolfblim.asm
;   >wlink f nolfblim.obj system dos com
;
;It should also be possible to compile with old versions of MASM/LINK/EXE2BIN.

.286
code segment
assume cs:code
	org 256

start: jmp tsrinit

veshandler:
		;modify only the VESA set_video_mode calls...
	cmp ax, 4f01h
	je handle4f01

		;replace the default protected mode interface with our own
	cmp ax, 4f0ah
	je handle4f0a

		;pass interrupt to original VESA handler (doesn't return to NOLFBLIM)
	jmp dword ptr cs:oveshandler

handle4f01:
		;call original VESA handler first (returns to NOLFBLIM)
	pushf ;pushf allows you to call an interrupt handler like a 'far' call
	call dword ptr cs:oveshandler

		;do our modifications only if original VESA handler returns 'good'
	cmp ax, 4fh
	jne short oveserror

		;clear flag that says LFB exists (bit 7 of VBE_modeInfo.ModeAttributes)
	and byte ptr es:[di], 7fh
oveserror:
	iret

handle4f0a:
		;call original VESA handler first (returns to NOLFBLIM)
	pushf ;pushf allows you to call an interrupt handler like a 'far' call
	call dword ptr cs:oveshandler

	cmp ax, 4fh
	jne short oveserror

	push ax
	push dx
	push cx
	push bx

		;convert segmented addresses to linear 32-bit address :/
		;dx:ax = es:[di]+[word es:[di]+(0,2,4)]
	mov ax, es
	mov dx, ax
	shl ax, 4
	shr dx, 12
	mov bx, cs
	mov cx, bx
	shl bx, 4
	shr cx, 12
	sub ax, bx
	sbb dx, cx
	add ax, di
	adc dx, 0
	mov bx, ax
	mov cx, dx

	add ax, word ptr es:[di]
	adc dx, 0
	sub ax, offset protjump0
	sbb dx, 0
	mov word ptr cs:[protjump0-4], ax
	mov word ptr cs:[protjump0-2], dx

	mov ax, bx
	mov dx, cx

	add ax, word ptr es:[di+2]
	adc dx, 0
	sub ax, offset protjump1
	sbb dx, 0
	mov word ptr cs:[protjump1-4], ax
	mov word ptr cs:[protjump1-2], dx

	mov ax, bx
	mov dx, cx

	add ax, word ptr es:[di+4]
	adc dx, 0
	sub ax, offset protjump2
	sbb dx, 0
	mov word ptr cs:[protjump2-4], ax
	mov word ptr cs:[protjump2-2], dx

	pop bx
	pop cx
	pop dx
	mov ax, cs
	mov es, ax
	pop ax
	mov di, offset myprotab ;returned es:[di] now points to our table (myprotab)

	mov cx, offset protend - offset myprotab
	iret

;--------------------------------------------------------------
;NOTE: THIS BLOCK OF CODE RUNS IN NATIVE 32-BIT PROTECTED MODE!
myprotab:
	dw offset prot_setwind   - offset myprotab
	dw offset prot_dispstart - offset myprotab
	dw offset prot_setpal    - offset myprotab
	dw 0   ;port & memory location list not simulated... sorry :/
prot_setwind:
	test dx, dx
	jnz short endit

	push ax
	push dx
	mov dl, 0xda ;CAREFUL! This code is run in native 32-bit protected mode, but the assembler
	mov dh, 0x03 ;doesn't know that :P I use the byte instructions here to guarantee compatibility.
wait1:
	in al, dx
	test al, 8
	jnz wait1
wait2:
	in al, dx
	test al, 8
	jz wait2
	pop dx
	pop ax
endit:
		;Jump to original protected mode set window routine
	db 0xe9 ;jmp [rel32]
	dd 0
protjump0:

		;Jump to original protected mode set display start routine
prot_dispstart:
	db 0xe9 ;jmp [rel32]
	dd 0
protjump1:

		;Jump to original protected mode set palette routine
prot_setpal:
	db 0xe9 ;jmp [rel32]
	dd 0
protjump2:

protend:
;--------------------------------------------------------------

oveshandler dd ?
programleng equ $+256-start

mystring db "NOLFBLIM by Ken Silverman (advsys.net/ken) 03/22/2005",'$'

tsrinit:
	pop ax ;throw away the return address with COM files

		;dos_printstring.. please don't remove! :)
	mov dx, offset mystring
	mov ah, 9
	int 21h

		;dos_getvect
	mov ax, 3510h
	int 21h
	mov word ptr cs:[oveshandler+0], bx
	mov word ptr cs:[oveshandler+2], es

		;dos_setvect
	mov dx, offset veshandler
	mov ax, 2510h
	int 21h

		;free environment block
	mov es, ds:[2ch]
	mov ah, 49h
	int 21h

		;terminate and stay resident (TSR)
	mov ax, 3100h
	mov dx, (programleng+15)/16
	int 21h

code ends
end start
