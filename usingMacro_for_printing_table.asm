multiply macro p1,p2
    mov dl,p1
    add dl,48       ;printing the num like 2
    mov ah,2
    int 21h
    
    mov dl,'*'      ;printng *
    mov ah,2
    int 21h
    
    
    mov al,p2       ;dividing into ah,al to counter 10
    AAM
    mov bl,al
    mov bh,ah
    mov dl,bh       ;and then printing in 02,03 order till 10
    add dl,48
    mov ah,2
    int 21h
    mov dl,bl
    add dl,48
    mov ah,2
    int 21h
                       
    
    
    mov al,p1        ;mov p1 value al
    mul p2           ;mul al by p2 and storing value in al
    
    AAM              
    
    mov bl,al        ;storing values in bx for high and low bytes
    mov bh,ah
  
    mov dl,'='       ;printing = sign
    mov ah,2
    int 21h
    
    mov dl,bh        ;printing higher byte
    add dl,48
    mov ah,2
    int 21h 
    
    mov dl,bl
    add dl,48        ;printing lower byte
    mov ah,2
    int 21h
    
    endm
         
.model small
.stack 100h
.data 
 message db 'Input the number to print table: $'
 num db ?
 times db 1
 str1 db '***Multiplication$***'
.code
main proc
    mov ax,@data
    mov ds,ax
    
    
    mov dx,offset str1
    mov ah,9
    int 21h
    
    call newline
    
    mov dx,offset message
    mov ah,9
    int 21h
    
    mov ah,1              ;taking table input
    int 21h
    sub al,48
    mov num,al
    
    call newline
    
    
   mov cx,10
    
    multiplication:
    
        multiply num,times                   ;macro for two arguments
        
        call newline
        
        inc times                            ;incrementing value of times 
        
        loop multiplication
    
       
    mov ah,4ch
    int 21h
        
    main endp
    
newline proc
    mov dl,10
    mov ah,2                       ;newline code
    int 21h
    mov dl,13
    mov ah,2
    int 21h
     
    ret
    newline endp

end main