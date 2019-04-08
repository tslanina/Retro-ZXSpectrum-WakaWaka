; WakaWaka
;
; 256 bytes intro for ZX Spectrum by Tomasz Slanina ( dox/joker )
; 3rd place in 256b compo @ Speccy.pl Party 2019.1
; 
; Finite chessboard (5 levels)
; starring: Pac Man and Inky
;
; The code is self modding here and there ,so it is quite hard to follow.
;


;4000 xstep-2
;4002 xstep
;4004 xstep1
    

    org $e000

.gfx: 
    db %00111100
    db %01111110
    db %11111000
    db %11100000
    db %11100000
    db %11111000
    db %01111110

.gfx1: 
    db %00111100
    db %01111110
    db %11111111
    db %11111111
    db %11111111
    db %11111111
    db %01111110
    db %00111100

.gfx2:
    db %01010101
    db %01111111
    db %01111111
.eyes:
    db %01011011
    db %01001001
    db %01111111
    db %00111110
    db %00011100


start:


.main:
    ld hl,$5800 ; attributes
    exx ; only once!

    ld c,24

.yloop:
    ld b,c
    ld a,248

.snd:
    out [254],a
    djnz .snd
   
    xor a
    out [254],a

    ld b,32

.xloop:
    ld d,$10
    ld hl,$4002

 .lup:
    push bc

.m1:
    ld a,[hl] ; dx

    add a,c

    ld [.wpc+1],a

    ld c,a
    inc hl
   
    ld a,[hl] ; dy
   
    inc hl
    add a,b

    ld [.wpb+1],a

.tuxor:
    xor c

    and d  ; check with mask
    pop bc
    jr nz,.sk000

.inner:
    srl d   ; shift mask right

    jr nz,.lup

 .sk000:   
    cp $8
    jr nz,.o10

    push bc

.wpb:
    ld a,0 ;b x  - data written directly here
    and 7
    inc a
    ld b,a

.wpgfx
    ld hl,$e000  ; anim data offst,  modified on the fly
    ld c,$36

.wpskip:
    db $18,00  ; jr  $+0 - jr offset modfied on the fly, depends on frame

    ld l, LOW .gfx2
    ld c,%101101

.wpc:
    ld a,0 ; c  ;code changes the value here

    and 7
    add a,l
    ld l,a
    ld a,[hl]

.shft:
    srl a
    djnz .shft

    ld a,c
    jr nc,.noooo

    set 6,a
.noooo:
    pop bc
    jr .setme


.o10:
    and 7
    ld e,a
    add a,a
    add a,a
    add a,a
    or e
    
.setme:
    exx
    ld [hl],a

    inc hl
    exx

    djnz .xloop

    dec c
    jr nz,.yloop

.end:
    ld hl,$4004
    ld [.modme+1],hl ; reset to xstep1
    dec l

    ld bc,.ofs
    call .incrs

    dec hl
    inc bc
    call .incrs

    inc hl
    ld l,[hl]
    ld h,a

    ld d,1

.scroll:
    inc d

    push hl
    call .divide
    ld e,l

    ld l,h
    call .divide
    ld h,l
    ld l,e

.modme:
    ld [$4004], hl
    ld hl, .modme+1
    inc [hl]
    inc [hl]
    pop hl

    ld a,d
    cp 5
    jr nz,.scroll

    ld hl,$e0fd

    ld a,[hl]
    add a,l
    ld [hl],a

    ld l,LOW .tuxor

    jr nz,.nope

    ld a,[hl] ;type
    xor 8
    ld [hl],a

    ld l, 1 + LOW .wpskip
    ld a,[hl]
    xor 4
    ld [hl],a
   
.nope:
    and 3
    jr nz,.kk

    ld l, LOW .wpgfx+1
   
    ld a,[hl] ;pac anim
    xor 7
    ld [hl],a


    ld l, LOW .eyes
    ld a,[hl]
    xor %00110110
    ld [hl],a

.kk:
    jp .main

.divide:
    ld b,8
    xor a

.divloop:
    sla l
    rla
    cp d
    jr c,.doloop
    inc l
    sub d

.doloop:
    djnz .divloop
    ret

.incrs:  ; h  = $40
    ld a,[bc]
    inc a

.endTable:
    ld [bc],a
    cp h
    jr c,.no32
    xor a
    jr .endTable

 .no32:
    cp 32
    jr c,.no16
    sub h
    cpl

.no16:
    srl a
    srl a
    srl a

    dec a
    add a,[hl]
    ld [hl],a
    ret

    db 255

.ofs:
    db 0,14 ; chessboard offsets ( x and y )

end start



