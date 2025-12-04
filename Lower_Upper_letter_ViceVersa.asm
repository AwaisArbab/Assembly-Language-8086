newline macro
    mov dl,13
    mov ah,2
    int 21h                ;newline macro
    mov dl,10
    mov ah,2
    int 21h
    
endm
toCapital macro p1,p2
    mov dx,offset p1
    mov ah,9
    int 21h
    
    mov ah,1
    int 21h
    
    or al,00100000b        ;or will add the binary value of 32 in the input
    mov bl,al
    
    newline                
    
    mov dx,offset p2
    mov ah,9
    int 21h
    
    mov dl,bl
    mov ah,2
    int 21h
endm
toLower macro p1,p2
    mov dx,offset p1
    mov ah,9
    int 21h
    
    mov ah,1
    int 21h
    
    xor al,00100000b         ;xor will subtract the binary value of 32 from al
    mov bl,al
    
    newline
    
    
    mov dx,offset p2
    mov ah,9
    int 21h
    
    mov dl,bl
    mov ah,2
    int 21h
    
endm 
    
.model small
.stack 100h
.data 
msg1 db "Enter zero(0) to convert from capital to lower or else other: $"
input db "Enter the Capital Letter: $"
output db "The Lower letter is: $" 
input2 db "Enter the Lower Letter: $"
output2 db "The Capital letter is: $"
.code
main proc 
    mov ax,@data         
    mov ds,ax
    
    
    mov dx,offset msg1
    mov ah,9
    int 21h
    
    
    mov ah,1
    int 21h
    
    cmp al,48
    je Capital 
    
    jne Lower 
 
    
    Capital:
        newline
        toCapital input,output
        
        mov ah,4ch
        int 21h
        
    Lower:
        newline
        toLower input2,output2
        
        mov ah,4ch
        int 21h
    
    
    mov ah,4ch
    int 21h
    
    
    main endp

end main