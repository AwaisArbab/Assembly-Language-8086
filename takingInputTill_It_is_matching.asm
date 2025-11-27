.model small
.stack 100h
.data
str1 db 'Does the number matches? $'
str2 db '***Comparing the number till matches*** $' 
str3 db 'Input number: $'
str4 db '   Yes Equal!! $'
str5 db '   Not Equal !!$' 
.code
main proc  
    mov ax,@data
    mov ds,ax
    
    mov dx,offset str2
    mov ah,9
    int 21h
    
    call newline
    comparing: 
          mov dx,offset str1
          mov ah,9
          int 21h
          
          call newline
          
          
          mov dx,offset str3
          mov ah,9
          int 21h
            
          
          mov ah,1
          int 21h 
          
          sub al,48
          
          mov dl,5
          
          cmp al,dl 
          
          je isequal
          jne notequal
          
          
    isequal:
          mov dx,offset str4
          mov ah,9
          int 21h
          
          call newline
          
          jmp comparing
    
    notequal:
          mov dx,offset str5
          mov ah,9
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
      
   