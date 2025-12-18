.model small
.stack 100h
.data 
msg1 db "Greater number is: $" 
msg2 db "Input num1: $"
msg3 db "Input num2: $"
.code
main proc      
    mov ax,@data
    mov ds, ax
    
    mov dx,offset msg2
    mov ah,9
    int 21h  
    
    mov ah,1   
    int 21h
    mov bl,al    
   
    call newline
    
    mov dx,offset msg3
    mov ah,9 
    int 21h 
    
    mov ah,1
    int 21h
    
    call newline
    
    cmp bl,al        
    jg greaterNum
    
    cmp al,bl            
    jg greaterNum_two
    
    
    mov ah,4ch
    int 21h
    
    main endp  
greaterNum proc
    mov dx,offset msg1
    mov ah,9
    int 21h
    
    mov dl,bl
    mov ah,2
    int 21h 
    
    mov ah,4ch
    int 21h
    
    
    greaterNum endp

greaterNum_two proc
    mov dx,offset msg4
    mov ah,9
    int 21h
    
    mov dl,al
    mov ah,2
    int 21h
    
    mov ah,4ch
    int 21h
    
    greaterNum_two endp
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