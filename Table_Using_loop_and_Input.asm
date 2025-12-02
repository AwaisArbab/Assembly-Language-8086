.model small
.stack 100h
.data 
input2 db "***Table*** $"
input db "Input number: $"
num db ?
times db 1
.code
main proc
    mov ax,@data
    mov ds,ax
    
    
    mov dx,offset input2
    mov ah,9               ;printing table message
    int 21h
    
    
    call newline
    
    mov dx,offset input      ;printing input number message
    mov ah,9
    int 21h
    
   
    
    mov ah,1                 ;taking input
    int 21h                  
    sub al,48                ;converting from asc code
    
    mov num,al
    
    call newline             ;calling newline procedure
    
    mov cx,10                ;setting the size of loop for 10. as we print the table from 1 to 10
    
    multiply:
        mov dl,num 
        add dl,48           ;printing the number of the required table
        mov ah,2            
        int 21h
        
        mov dl,"*"           ;printing asterik
        mov ah,2
        int 21h
        
        mov al,times          ;we want to print 01 02 till 10
        
        AAM                   ;so we will apply aam on that
        
        mov bl,al             ;after aam we get result in al, ah
        mov bh,ah             ;we move them in bl and bh respectively
        
        mov dl,bh 
        add dl,48              ;printing the higher byte
        mov ah,2
        int 21h
        
        mov dl,bl
        add dl,48              ;printing the lower byte
        mov ah,2
        int 21h
        
        
        
     
        
        mov al,times
        mul num                ;now we will multiply the num with the times
                               ;applying aam as we can have result if greater than 9
        AAM                    ;result will come in 2 bits
        
        mov bl,al
        mov bh,ah
        
        mov dl,"="
        mov ah,2
        int 21h
        
        mov dl,bh
        add dl,48             ;printing higher byte of the result
        mov ah,2
        int 21h
        
        mov dl,bl 
        add dl,48            ;printing lower byte of the result
        mov ah,2
        int 21h
        
        
        call newline         ;calling newline as after every iteration the the result goes in newline . not in forward position
        
        inc times            ;increasing times as it goes from 1 2 3 4 ... 10
        
        loop multiply
        
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