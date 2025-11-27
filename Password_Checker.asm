newline macro:
    mov dl,10
    mov ah,2          ;reusable newline macro
    int 21h
    mov dl,13
    mov ah,2
    int 21h 
    mov dl,0
endm
.stack 100h
.model
.data
input db 'Input the password:- $'  
message1 db 'Correct Password!!$'
message2 db 'Wrong Password!!$'
password db '2412327$'
insertion db 7 dup(?), '$'      ;setting the string empty with 7 byte size
uncomplete db 'Not complete password!! Insert again..$'
.code
    
    ;we are using two loops in the program 
    ;time complexity increases and becomes 2(O(n))
    main proc
        
    mov ax,@data
    mov ds,ax    
    
    program:
        mov dx,offset input
        mov ah,9
        int 21h
        
        mov si,0            ;setting si to 0 starting from index 0
        mov cx,7
        inserting:
           mov ah,8         ;input without echo
           int 21h
          
           mov bl,al
           
           cmp bl,13         ;when user clicks enter it jumps to finish label
           je finish
           
           mov dl,'*'
           mov ah,2          ;printing asterik at every input
           int 21h
           
           
           mov insertion[si],bl     ;moving the input at the index(si) in insertion string
           
           
           
           inc si                 ;incrementing si for index shift
        loop inserting
    
    mov cx,7
    mov si,0                  ;setting si and di 0 to start from 0th index
    mov di,0
    
    checking:
        mov bl,0
        mov al,0
        mov bl,password[si]     ;checking both strings at same index 
        mov al,insertion[di]
        
        cmp bl,al
        jne wrong             ;if the data at same index doesn't match it jumps to wrong label
        
        inc si
        inc di
        
        loop checking
     jmp correct            ;if all numbers are same then it will jmp to correct label
    
    correct:
        newline
        mov dx,offset message1      ;correct label with it's message
        mov ah,9
        int 21h
        
        mov ah,4ch
        int 21h
        
    wrong:     
        newline
        mov dx,offset message2
        mov ah,9                   ;wrong label with it's message
        int 21h
        
        mov dl,7
        mov ah,2                   ;throws beep sound
        int 21h
        
        mov ah,4ch
        int 21h
    
    finish:
       newline

       mov dx,offset uncomplete
       mov ah,9                       ;finish lable with incomplete message
       int 21h 
       
       mov dl,7
       mov ah,2                         ;throws beep sound
       int 21h
       
       newline
       
       jmp program          ;if the user doesn't input 7 numbers it will continiue jumping to program label to take input again and again 
        
  
    
    mov ah,4ch
    int 21h
    
   
           
    main endp
    
end main
