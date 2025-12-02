.model small
.stack 100h
.data 
 before db "Before Swap: $"
 after db "After Swap: $"
.code
main proc
    mov ax,@data
    mov ds,ax
    
    mov dx,offset before
    mov ah,9
    int 21h
    
    mov ah,1
    int 21h
    
    push ax
    
    mov dl,32
    mov ah,2
    int 21h
    
    
    mov ah,1
    int 21h
    
    push ax 
    
    
    
        
    call newline 
    
    mov dx,offset after
    mov ah,9
    int 21h
    
    pop ax
    mov dx,ax
    mov ah,2
    int 21h
    
    mov dl,32
    mov ah,2
    int 21h
    
    pop ax
    mov dx,ax
    mov ah,2
    int 21h
    
    
    
    mov ah,4ch
    int 21h    
      
    main endp
newline proc
    mov dl,10
    mov ah,2
    int 21h
    mov dl,13
    mov ah,2
    int 21h
    ret
    newline endp
end main
