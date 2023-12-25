[org 0x0100]
jmp start

score: dw 0
pos: dw 3920
rand: dw 0
randnum: dw 0
generatedcharacter: db "[", "[", "[", "[", "["
temp: dw 0
seconds: dw 0
counter: dw 0
posarr: dw 0, 0, 0, 0, 0
currentcharacters: dw 0
lives: dw 0

oldkbisr dd 0
oldtimer dd 0 

randG:
push bp
mov bp, sp
pusha
cmp word [rand], 0
jne next
mov AH, 00h  
int 1AH
inc word [rand]
mov [randnum], dx
jmp next1
next:
mov ax, 25173          
mul word  [randnum]    
add ax, 13849          
mov [randnum], ax     
next1:
xor dx, dx
mov ax, [randnum]
mov cx, [bp+4]
inc cx
div cx
mov [bp+6], dx
popa
pop bp
ret 2

clrscr: 
push es
push ax
push cx
push di
mov ax, 0xb800
mov es, ax 
xor di, di 
mov ax, 0x0720 
mov cx, 2000
cld 
rep stosw
pop di
pop cx
pop ax
pop es
ret

printbox:
push bp
mov bp, sp
pusha
mov ax, 0xb800
mov es, ax
mov di, [pos]
mov word [es:di], 0x07DC
popa
pop bp
ret

left:
cmp di, 3840
je s2
mov word [es:di], 0x0720
sub di, 2
sub word [pos], 2
s2:
mov word [es:di], 0x07DC
ret

right:
cmp di, 3998
je s1
mov word [es:di], 0x0720
add di, 2
add word [pos], 2
s1:
mov word [es:di], 0x07DC
ret

printgeneratedcharacter:
push bp
mov bp, sp
pusha 

mov ax, 0xb800
mov es, ax

mov si, 0
rr:
mov bl, [generatedcharacter+si]
cmp byte bl, '['
je tt
inc si
jmp rr

tt:
mov [temp], si
sub sp, 2
push 159
call randG
pop dx

add dx, 160
test dx, 1
jz even
add dx, 1
even:
mov bx, [temp]
shl bx, 1
mov word [posarr+bx], dx

sub sp, 2
push 25
call randG
pop dx
mov dh, 0
add word dx, 65

mov si, [temp]
mov byte [generatedcharacter+si], dl
mov byte al, [generatedcharacter+si]
mov ah, 0x07

mov word di, [posarr+bx]
mov [es:di], ax

inc word [currentcharacters]

popa
pop bp
ret

delay:
push cx
mov cx, 0xFFFF
a:
loop a
mov cx, 0xFFFF
b:
loop b
pop cx
ret 

kbisr:
push ax
push es

mov ax, 0xb800
mov es, ax 

mov di, [pos]

in al, 0x60 
cmp al, 0x4B ; is the key left arrow key
jne nextcmp 
call left
jmp nomatch 
nextcmp: 
cmp al, 0x4D ; is the key right arrow key
jne nomatch 
call right
nomatch: 
mov al, 0x20
out 0x20, al

pop ax
pop es
iret

movedown1:
push bp
mov bp, sp
pusha

mov ax, 0xb800
mov es, ax
mov bx, 0
mov di, [posarr+bx]

mov word [es:di], 0x0720

add di, 160
mov word [posarr+bx], di

mov si, 0
mov byte al, [generatedcharacter+si]
mov ah, 0x07
mov word [es:di], ax

cmp di, [pos] 
jne vw
mov word [es:di], 0x07DC
inc word [score]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
jmp qr

vw:
mov cx, 80
mov ax, 3998
jk:
add ax, 2
cmp word di, ax
jne bc
inc word [lives]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
bc:
loop jk

qr:
popa
pop bp
ret

movedown2:
push bp
mov bp, sp
pusha

mov ax, 0xb800
mov es, ax
mov bx, 2
mov di, [posarr+bx]

mov word [es:di], 0x0720

add di, 160
mov word [posarr+bx], di

mov si, 1
mov byte al, [generatedcharacter+si]
mov ah, 0x07
mov word [es:di], ax

cmp di, [pos] 
jne vx
mov word [es:di], 0x07DC
inc word [score]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
jmp qs

vx:
mov cx, 80
mov ax, 3998
jm:
add ax, 2
cmp word di, ax
jne bd
inc word [lives]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
bd:
loop jm

qs:
popa
pop bp
ret

movedown3:
push bp
mov bp, sp
pusha

mov ax, 0xb800
mov es, ax
mov bx, 4
mov di, [posarr+bx]

mov word [es:di], 0x0720

add di, 160
mov word [posarr+bx], di

mov si, 2
mov byte al, [generatedcharacter+si]
mov ah, 0x07
mov word [es:di], ax

cmp di, [pos] 
jne vy
mov word [es:di], 0x07DC
inc word [score]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
jmp qt

vy:
mov cx, 80
mov ax, 3998
jn:
add ax, 2
cmp word di, ax
jne be
inc word [lives]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
be:
loop jn

qt:
popa
pop bp
ret

movedown4:
push bp
mov bp, sp
pusha

mov ax, 0xb800
mov es, ax
mov bx, 6
mov di, [posarr+bx]

mov word [es:di], 0x0720

add di, 160
mov word [posarr+bx], di

mov si, 3
mov byte al, [generatedcharacter+si]
mov ah, 0x07
mov word [es:di], ax

cmp di, [pos] 
jne vz
mov word [es:di], 0x07DC
inc word [score]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
jmp qu

vz:
mov cx, 80
mov ax, 3998
jq:
add ax, 2
cmp word di, ax
jne bf
inc word [lives]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
bf:
loop jq

qu:
popa
pop bp
ret

movedown5:
push bp
mov bp, sp
pusha

mov ax, 0xb800
mov es, ax
mov bx, 8
mov di, [posarr+bx]

mov word [es:di], 0x0720

add di, 160
mov word [posarr+bx], di

mov si, 4
mov byte al, [generatedcharacter+si]
mov ah, 0x07
mov word [es:di], ax

cmp di, [pos] 
jne vv
mov word [es:di], 0x07DC
inc word [score]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
jmp qq

vv:
mov cx, 80
mov ax, 3998
jj:
add ax, 2
cmp word di, ax
jne bb
inc word [lives]
dec word [currentcharacters]
mov byte [generatedcharacter+si], '['
mov word [posarr+bx], 0
bb:
loop jj

qq:
popa
pop bp
ret

displayscore: 
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax
mov ax, [bp+4] 
mov bx, 10 
mov cx, 0
nextdigit: mov dx, 0 
div bx 
add dl, 0x30 
push dx 
inc cx 
cmp ax, 0 
jnz nextdigit 
mov di, 156 
nextpos: pop dx 
mov dh, 0x07 
mov [es:di], dx
add di, 2 
loop nextpos 
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 2 

displaylife: 
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax
mov ax, [bp+4] 
mov bx, 10 
mov cx, 0
nextdigit1:
mov dx, 0 
div bx 
add dl, 0x30 
push dx 
inc cx 
cmp ax, 0 
jnz nextdigit1
mov di, 2 
nextpos1: pop dx 
mov dh, 0x07 
mov [es:di], dx
add di, 2 
loop nextpos1 
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 2 

; timer interrupt service routine
timer: 
push ax

push word [lives]
call displaylife

push word [score]
call displayscore

inc word [cs:counter] ; increment tick count

cmp word [cs:currentcharacters], 0
jle v
cmp word [cs:counter], 3
jne p
call movedown1

p:
cmp word [cs:currentcharacters], 1
jle v
cmp word [cs:counter], 10
jne q
call movedown2

q:
cmp word [cs:currentcharacters], 2
jle v
cmp word [cs:counter], 6
jne r
call movedown3

r:
cmp word [cs:currentcharacters], 3
jle v
cmp word [cs:counter], 15
jne s
call movedown4

s:
cmp word [cs:currentcharacters], 4
jle v
cmp word [cs:counter], 17
jne v
call movedown5

v:
cmp word [cs:counter], 18
jne skipall
inc word [cs:seconds]
mov word [cs:counter], 0
cmp word [cs:currentcharacters], 5
je skipall
call printgeneratedcharacter
skipall:
mov al, 0x20
out 0x20, al 
pop ax
iret 

start: 
call clrscr
call printbox
xor ax, ax
mov es, ax 

mov ax, [es:9*4]
mov [oldkbisr], ax 
mov ax, [es:9*4+2]
mov [oldkbisr+2], ax 

mov ax, [es:8*4]
mov [oldtimer], ax 
mov ax, [es:8*4+2]
mov [oldtimer+2], ax 

cli 
mov word [es:9*4], kbisr 
mov [es:9*4+2], cs 
mov word [es:8*4], timer 
mov [es:8*4+2], cs 
sti 

l1:
cmp word [lives], 10
je w
jmp l1

w:
xor ax, ax
mov es, ax
mov ax, [oldkbisr] 
mov bx, [oldkbisr+2] 
mov cx, [oldtimer] 
mov dx, [oldtimer+2] 
cli 
mov [es:9*4], ax
mov [es:9*4+2], bx 
mov [es:8*4], cx 
mov [es:8*4+2], dx 
sti 
call clrscr

mov ax, 0x4c00 
int 0x21 
