wow     segment     'code'
        assume cs:wow, ds:wow, ss:wow, es:wow
        org 100h
begin: jmp  main
;---------------------------------
date    dw          ?
date2   dw          ?
my_s    db         '+'
T_Th    db          ?
Th      db          ?
Hu      db          ?
Tens    db          ?
Ones    db          ?
;---------------------------------
tmp1 dw ?
tmp2 dw ?
tmp3 dw ?
; ----------------- My variables ------------------------------

MAIN proc near
; ---------------- My Commands ---------------------------------
;Searching X

; ((1980-1955)/5)*2+10+586

        mov ax, 1980
        sub ax, 1955 ;1980-1955
        mov bl, 5
        cbw
        idiv bl
        cbw
;(1980-1955)/5
        mov bl, 2
        imul bl; ((1980-1955)/5)*2
        add ax, 10
        add ax, 586 ; ((1980-1955)/5)*2+10+586
        mov date, ax
        call DISP
;Searching y
        
        mov ax, 2215
        sub ax, 215
        mov tmp1, 21
        add tmp1, 39
        sub tmp1, 10
        cwd
        idiv tmp1
        mov bx, ax
        mov ax, 440
        sub ax, 40
        add ax, 20
        mov tmp2, 200
        add tmp2, 10
        idiv tmp2
        imul bx
        
        mov date, ax
        
        call DISP
        ret
    MAIN endp
; The procedure outputs the result of calculations placed in data
DISP proc near
;----- outputing result ----------------
;--- negative number?----------
        mov     ax,date
        and     ax,1000000000000000b
        mov     cl,15
        shr     ax,cl
        cmp     ax,1
        jne     @m1
        mov     ax,date
        neg     ax
        mov     my_s,'-'
        jmp     @m2
        ;--- getting tens of tousands ---------------
        @m1: mov ax,date
        @m2: cwd
        mov bx,10000
        idiv bx

        mov T_Th,al
        ;------- getting thousands ------------------------------
        mov ax,dx
        cwd
        mov bx,1000
        idiv bx
        mov Th,al
        ;------ getting hundreds ---------------
        mov ax,dx
        mov bl,100
        idiv bl
        mov Hu,al
        ;---- getting tens and units ----------------------
        mov al,ah
        cbw
        mov bl,10
        idiv bl
        mov Tens,al
        mov Ones,ah
        ;--- sign output -----------------------
        cmp my_s,'+'
        je @m500
        mov ah,02h
        mov dl,my_s
        int 21h
        ;---------- digits output -----------------
        @m500: cmp T_TH,0 ; chevk for zero
        je @m200
        mov ah,02h ; output on display if it's not zero
        mov dl,T_Th
        add dl,48
        int 21h
        @m200: cmp T_Th,0
        jne @m300
        cmp Th,0
        je @m400
        @m300: mov ah,02h
        mov dl,Th
        add dl,48
        int 21h
        @m400: cmp T_TH,0
        jne @m600
        cmp Th,0

        jne @m600
        cmp hu,0
        je @m700
        @m600: mov ah,02h
        mov dl,Hu
        add dl,48
        int 21h
        @m700: cmp T_TH,0
        jne @m900
        cmp Th,0
        jne @m900
        cmp Hu,0
        jne @m900
        cmp Tens,0
        je @m950
        @m900: mov ah,02h
        mov dl,Tens
        add dl,48
        int 21h
        @m950: mov ah,02h
        mov dl,Ones
        add dl,48
        int 21h
        mov ah,02h
        mov dl,10
        int 21h
        mov ah,02h
        mov dl,13
        int 21h
;-------------------------------------
        mov     ah,08
        int     21h
        ret
DISP    endp
wow     ends
        end     begin