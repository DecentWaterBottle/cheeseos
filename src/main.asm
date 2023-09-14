org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
	jmp main


;
; Prints a string to the screen.
; Params:
;   - ds:si points to string
;
puts: 
	; save registers we wil modify
	push si
	push ax

.loop:
	lodsb				; loads next character in al
	or al, al			; verify if next character is null
	jz .done			; if so, jump to done
	
	mov ah, 0x0e		; otherwise, move 0x0e into the ah register
						; in order to tell the BIOS that we want 
						; to make a teletype output
						
	int 0x10			; Invoke the BIOS interrupt

	jmp .loop

.done:
	pop ax
	pop si
	ret

main:

	; setup data segments
	mov ax, 0
	mov ds, ax
	mov es, ax

	; setup stack
	mov ss, ax
	mov sp, 0x7C00 ; stack grows downwards from where we are loaded in memory

	mov si, msg_hello
	call puts

	hlt

.halt:
	jmp .halt


msg_hello: db 'Hello World', ENDL, 0


times 510-($-$$) db 0
dw 0AA55h
