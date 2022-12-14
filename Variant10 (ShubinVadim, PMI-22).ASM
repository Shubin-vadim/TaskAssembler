 format PE console
include 'win32ax.inc'

.data
    inputstr  db   256 dup(' '),10,13,0             ;максимальная длина строки
    cntChars dd  0                                  ;кол-во считанных символов
    stdout dd 0
    stdin dd 0
    titlestr db 'Shubin VadimLaba Assembler Variant10',0
    inpmessage db 'Enter string: ',10,13,0
    messageyes db 'There are duplicate characters in the string',0
    messageno db 'There are no duplicate characters in the string',0
    exittext db 10,13,'Press any key to exit...',0

macro readtext text, num, cntsymbols {
   push STD_INPUT_HANDLE
   call [GetStdHandle]
   push 0
   push num
   push cntsymbols
   push text
   push eax
   call [ReadConsole]
}

macro writetext text, num, cntsymbols{
  push STD_OUTPUT_HANDLE
  call [GetStdHandle]
  push 0
  push num
  push cntsymbols
  push text
  push eax
  call [WriteConsole]
}

macro exitprogram{
    push STD_OUTPUT_HANDLE
    call [GetStdHandle]
    push 0
    push stdout
    push 25
    push exittext
    push eax
    call [WriteConsole]
    push STD_INPUT_HANDLE
    call [GetStdHandle]
    push NULL
    push eax
    call [SetConsoleMode]
    push STD_INPUT_HANDLE
    call [GetStdHandle]
    push 0
    push stdout
    push 1
    push exittext
    push eax
    call [ReadConsole]
    push 0
    call [ExitProcess]
}

.code
start:
  push titlestr
  call [SetConsoleTitle]

  writetext  inpmessage,stdout,14
  readtext inputstr, cntChars,256

   mov  esi, inputstr                                                                                       ;адрес строки
   xor ecx,ecx                                                                                        ; обнуляем ecx
   mov  ecx, [cntChars]                                                                                                                                                                  ;вычитаем, так как считалось \r\n(перевод и возврат каретки)

loop1:
     cmp  ecx, 0                        ;  если достигли конца строки (ecx=0), то дубликатов нет
     jz   outputno
     mov  al, [esi]         ; заносим символ в регистр al
     push  ecx
     push  esi
                                                                                                                
loop2:
   dec  ecx
   inc  esi
   cmp ecx, 0
   jz   Eloop
   cmp al, byte[esi]        ;сравнение i и j символов
   jz  outputyes
   jmp loop2

Eloop:
  pop  esi
  pop  ecx
  inc  esi
  dec ecx
  jmp loop1
  jmp outputno

        
outputno:
   writetext  messageno,stdout,47
   jmp exit
        
outputyes:
  writetext  messageyes,stdout,44
  jmp exit

exit:
    exitprogram
.end start