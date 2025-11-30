.model small
.stack 100h
.data   
asterik dw 1
asterik2 dw 4 
newline db 13,10,'$'
.code
main proc  
    
    mov ax, @data
    mov ds, ax

    mov cx, 4
outer:
    mov bx, cx
    mov cx, asterik
inner:
    mov dl, 42
    mov ah, 2
    int 21h
    loop inner


    mov dx, offset newline
    mov ah, 9
    int 21h

   inc asterik

    mov cx, bx
    loop outer
    
    
mov cx,4
outer2:
mov bx,cx
mov cx,asterik2
inner2:
mov dl,42
mov ah,2
int 21h
loop inner2

mov ah,9
mov dx , offset newline
int 21h

dec asterik2

mov cx,bx
loop outer2    

    mov ah, 4Ch
    int 21h
main endp
end main
