macro applyingAAM p1
    mov al, p1      
    AAM             
    
    mov cl,al
    mov ch,ah
    
    ; print tens digit (CH)
    mov dl, ch
    add dl, 30h   ;converting from asc code
    mov ah,2
    int 21h

    ; print ones digit (CL)
    mov dl, cl
    add dl, 30h   ;convertig from asc code
    mov ah,2
    int 21h
endm

.model small
.stack 100h
.data
vowels db 0            ;setting vowels and consonants variable to null
consonants db 0
str1 db 'Enter the word:  $'
str2 db 'Vowel: $'
str3 db 'Consonant: $' 
.code
main proc
    mov ax,@data
    mov ds,ax
    
    
    mov dx,offset str1
    mov ah,9
    int 21h
    
    
    starting:
        mov ah,1          ;input with echo
        int 21h 
 
        
        cmp al,13         ;if user clicks enter it jumps to print label
        je print
                               
        cmp al,'a'        ;comparing with each vowels separately
        je vowel
        
        cmp al,'e'
        je vowel
        
        cmp al,'i'
        je vowel
        
        cmp al,'o'
        je vowel 
        
        cmp al,'u'
        je vowel
        
         cmp al,32         ;if user clicks space it continues taking input
        je starting
        
        jmp consonant     ;if not matched to vowels jumps to consonant label
        
              
        
      
vowel:
        inc vowels         ;vowel label when it jumps to this label vowels gets incremented by 1
        jmp starting       ;after incrementing. it again jumps back to starting label to take further inputs
        
consonant:
        inc consonants       ;consonant label when it jumps to this label consonants gets incremented by 1
        jmp starting           ;after incrementing. it again jumps back to starting label to take further inputs
        
  
  
  mov ah,4ch                 ;returns the control to OS
  int 21h
        
        main endp
        

 print proc 
        call newline 
        
        mov dx,offset str2
        mov ah,9
        int 21h
        
        mov bl,vowels       ;moving vowels to bl because if we directly use vowels as argument it will store the address not the data inside it
        applyingAAM bl      ;macro with arguemnt bl
        
        mov bl,0            ;sets bl to zero
        
        call newline
        
        
        mov dx,offset str3
        mov ah,9
        int 21h
        
        mov bl,consonants     ;moving consonants to bl because if we directly use vowels as argument it will store the address not the data inside it
        applyingAAM bl        ;macro with argument bl
        
        mov ah,4ch
        int 21h
         
        print endp
 
newline proc
    mov dl,10
    mov ah,2
    int 21h                ;newline procedure
    mov dl,13
    mov ah,2
    int 21h
    
    ret 
    newline endp

end main