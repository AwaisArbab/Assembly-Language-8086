.model small
.stack 100h 
.data
input db "Enter the operation: $"                 ;using dollar sign at the end to print the complete string
first db "Enter the first value: $"
second db "Enter the second value: $"
answer db "The output is: $"  
newline db 0dh,0ah,"$"                  ;alternate: newline db 13,10,"$"
.code
main proc  
    mov ax,@data                        ;to take the complete data from the .data and mov -> ax
    mov ds,ax                           ;mov ax -> ds
    
    
    mov ah,9h                            ;Function ah = 09h tells DOS: “Print a string to the screen”.
    mov dx,offset input                  ; DX must point to the memory location of the string you want to print.
                                         ; offset input gives the address of the string input in the data segment
    int 21h                              ;calls DOS interrupt
    
     
    mov ah,1                             ; takes input with echo
    int 21h   
   
    
    cmp al,'+'                           ;cmp is compare instruction in assembly language
                                         ;cmp operand1,operand2
                                         ;subtracts operand2 from operand1 internally but does not store the result.
                                         ;Instead, it sets flags (Zero Flag, Sign Flag, etc.) that the CPU uses for conditional jumps.
                                         ; cmp al,'+' Is the user input +?
                                         ;je -> jump if equal
                                         ;If the comparison sets the Zero Flag (ZF = 1) (i.e., AL equals +), the CPU jumps to the label addition.
                                         ;Otherwise, it continues to the next instruction.
    je addition
    
    
    cmp al,'-'
    je subtraction
                               
    
    mov ah,4ch
    int 21h
     
main endp

addition proc                               ;creating procedure -> name  proc
    mov ah,9h
    mov dx,offset newline
    int 21h
       
    mov ah,9h
    mov dx,offset first
    int 21h
    mov ah,1
    int 21h
    mov bl,al                                 ;body
    
    mov ah,9h
    mov dx,offset newline
    int 21h 
    
    mov ah,9h
    mov dx,offset second
    int 21h
    mov ah,1
    int 21h
    mov bh,al 
    
    mov ah,9h
    mov dx,offset newline
    int 21h 
    
    add bl,bh 
    
    sub bl,30h 
    
    mov ah,9h
    mov dx,offset answer
    int 21h
    
    mov dl,bl
    mov ah,2
    int 21h
    
    mov ah,4ch
    int 21h 
    
    addition endp                               ;ending proedure -> name endp

subtraction proc   
    mov ah,9h
    mov dx,offset newline
    int 21h
    
    mov ah,9h
    mov dx,offset first
    int 21h
    mov ah,1
    int 21h
    mov bl,al
    
    mov ah,9h
    mov dx,offset newline
    int 21h 
    
    mov ah,9h
    mov dx,offset second
    int 21h
    mov ah,1
    int 21h
    mov bh,al 
    
    mov ah,9h
    mov dx,offset newline
    int 21h 
    
    sub bl,bh 
    
    add bl,48 
    
    mov ah,9h
    mov dx,offset answer
    int 21h
    
    mov dl,bl
    mov ah,2
    int 21h
    
    mov ah,4ch
    int 21h   
    subtraction endp

end main