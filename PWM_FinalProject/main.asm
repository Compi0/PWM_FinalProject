;
; PruebaProyecto.asm
;
; Created: 4/5/2024 13:07:33
; Author : diego
;

LDI r16, 0xFF 
OUT DDRD, r16 

LDI R17, 0
OUT DDRB, R17 

LDI R18, 63 ; Incremento de PWM (en 25%)
LDI R24, 0 ; Contador 
LDI R25, 1

; Configurar timer para PWM
LDI R16, (1 << COM0A1) | (1 << WGM01) | (1 << WGM00) ; Modo PWM rápido no invertido en pin 6
OUT TCCR0A, R16 ; Configurar Timer0 para PWM
LDI R16, (1 << CS01) ; Preescalador de 8 para Timer0
OUT TCCR0B, R16 ; Iniciar Timer0 con preescalador de 8

OUT OCR0A, R24 ;Inicializa pwm en 0

loop:
  IN R16, PINB 
  nop
  nop
  CPI R16, 1 
  BREQ presionado 

  LDI R23, 0 ;Para el actual
  LDI R22, 0 ; Para el previo

  RJMP loop 

presionado:
	LDI R23, 1 ; Para el debounce actual
	nop
	nop
	CPI R22, 0
	LDI R22, 1
	BRNE loop    ; Si no es igual a cero significa que hay q hace debounce

  ADD R24, R25
  ADD r20, r18 ; Incrementar el PWM
  nop
  nop
  CPI R24, 5
  BRCC tope

  OUT OCR0A, r20 ; Actualizar el valor de PWM
  RJMP loop

tope:
  ; cuando llega al 100%
  LDI R24, 0
  LDI R20, 0
  OUT OCR0A, r24 ; Actualizar el valor de PWM
  RJMP loop