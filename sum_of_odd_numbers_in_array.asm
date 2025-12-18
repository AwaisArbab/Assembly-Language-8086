.model small
.stack 100h
.data
array db 1,2,3,4,5,6,7,8,9,0
msg db "Sum of odd numbers: $"
total db 0

.code
main proc
    mov ax, @data
    mov ds, ax

    mov si, offset array
    mov cx, 10

loopx:
    mov al, [si] 
    mov ah, 0
    mov bl, 2
    div bl
    cmp ah, 1
    jne next

    mov al, [si]
    add total, al

next:
    inc si 
    
    loop loopx

    mov dx, offset msg
    mov ah, 9
    int 21h

    mov al, total
    AAM
    mov bh,ah
    mov bl,al
    
    mov dl, bh
    add dl,48
    mov ah, 2
    int 21h
    
    mov dl,bl 
    add dl,48
    mov ah,2
    int 21h
    

    mov ah, 4Ch
    int 21h
main endp
end main
