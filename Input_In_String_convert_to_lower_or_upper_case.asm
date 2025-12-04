newline macro
    mov dl,10
    mov ah,2
    int 21h
    mov dl,13
    mov ah,2
    int 21h
    
endm
.model small
.stack 100h
.data
msg db "Enter the string(length 5): $" 
msg1 db "String after conversion: $"
string db 6 dup('0')       ;string of size 6 with each element as zero 000000
.code
main proc
    mov ax,@data
    mov ds,ax
    
    mov dx,offset msg
    mov ah,9
    int 21h
    
    mov cx,5
    mov si,offset string  ;moving string to si
    inputstring: 
        mov ah,1
        int 21h           ;taking input
        
        mov [si],al        ;moving the input in si at index 0 at first then will increase at the input increases
        
        inc si             ;inc si
        loop inputstring
    
    mov [si],'$'           ;important to put dollar sign at end else when we print the string using 9h it will not print it
    
    
    mov si,offset string
    mov cx,5    
    converting:
            cmp [si],65     ;if the value is less than 65 there will be no change
            jl nochange
            
            cmp [si],97     ;if the value is greater than 97 or equal it will convert to lowercase
            jge Capital
              
            jmp lower     ;if none of above then it will convert to capital
       
       
           lower:
                 or [si],00100000b   ;or used to add anything.00100000b binary value of 32.if the letter will be lower it will add 32 to it then it becomes lower
                 jmp increment     
             
           Capital: 
                xor [si],00100000b    ;xor used to sub anything. 00100000b binary value of 32. if the letter will be upper it will subtract 32 then it becomes capital
                jmp increment
           
             
           nochange:
                jmp increment         ;if less than 65 then no change to the value of the si
                
                
           increment:     
                inc si
        
   
        
        loop converting    
    
   
       newline
       
         
       mov dx,offset msg1
       mov ah,9
       int 21h
           
           
       mov dx,offset string  ;printing the converted string now
       mov ah,9
       int 21h
    
        
    mov ah,4ch
    int 21h
        
    main endp
end main