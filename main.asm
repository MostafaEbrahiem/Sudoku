INCLUDE Irvine32.inc
INCLUDE macros.inc
.DATA
;/////////////////////////////////
b=blue+(lightgray*16)
BUFFER_SIZE = 5000
buffer BYTE BUFFER_SIZE DUP(?),0
buffer2 BYTE BUFFER_SIZE DUP(?),0
num byte 30 dup(?),0
file1 BYTE "diff_1_1.txt",0
file2 BYTE "diff_2_1.txt",0
file3 BYTE "diff_3_1.txt",0
file1_solv BYTE "diff_1_1_solved.txt",0
file2_solv BYTE "diff_2_1_solved.txt",0
file3_solv BYTE "diff_3_1_solved.txt",0
cont_solv_file byte "cont_solv.txt",0 
cont_file BYTE "continue.txt",0
cl_file BYTE "clear.txt",0
fileHandle HANDLE ?
startTime DWORD ?
count_corr dword ?
count_incorr dword ?
;/////////////////////////////////
.code
main PROC

   mWrite <"1>start game",0dh,0ah>
   mWrite <"2>continue",0dh,0ah>

   call readdec

   cmp eax,2
   je continue

   jmp start
  
	exit
main ENDP
;////////////////////////////
start PROC
push ebp
   INVOKE GetTickCount
   mov startTime,eax

   mWrite <"please choose diffculty level(1,2or3)",0dh,0ah>
   call readdec
   call read_file
   call show_suduko
   
   s:
   call crlf
   mWrite <"1. print my board",0dh,0ah>
   mWrite <"2. clear board",0dh,0ah>
   mWrite <"3. edit",0dh,0ah>
   mWrite <"4. save and exit",0dh,0ah>

   mWrite <"make your choise(1,2,3or4)",0dh,0ah>

   call readdec
   cmp eax,1
   je f1
   cmp eax,2
   je f2
   cmp eax,3
   je f3
   cmp eax,4
   je f4

   f1:
   call print
   exit  
   
   f2:
   call clear
   jmp s


   f3: 
   call edit
   jmp s

   f4:
   call save
   exit

pop ebp
ret
start ENDP
;//////////////////////////////////////

;///////////////////////////////////////
print PROC
push ebp
   call show_suduko
   mWrite <"number of incorrect solutions",0dh,0ah>
   mov eax,count_incorr
   call writedec
   call crlf

   mWrite <"number of correct solutions",0dh,0ah>
   mov eax,count_corr
   call writedec
   call crlf

   mWrite <"time",0dh,0ah>
   INVOKE GetTickCount
   sub eax,startTime 
   mov ebx,1000
   div ebx
   call writedec
   mWrite <" sec",0dh,0ah>

pop ebp
ret
print ENDP
;///////////////////////////////////////
continue PROC
push ebp
 INVOKE GetTickCount
 mov startTime,eax

 mov edx,OFFSET cont_file 
 call OpenInputFile
 mov fileHandle,eax
 mov edx,OFFSET buffer
 mov ecx,BUFFER_SIZE
 call ReadFromFile
 mov eax,filehandle
 call closefile


  mov edx,offset cont_solv_file
  call OpenInputFile
  mov fileHandle,eax
  
  mov edx,OFFSET buffer2
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile


 call show_suduko
 s:
   call crlf
   mWrite <"1. print my board",0dh,0ah>
   mWrite <"2. clear board",0dh,0ah>
   mWrite <"3. edit",0dh,0ah>
   mWrite <"4. save and exit",0dh,0ah>

   mWrite <"make your choise(1,2,3or4)",0dh,0ah>

   call readdec
   cmp eax,1
   je f1
   cmp eax,2
   je f2
   cmp eax,3
   je f3
   cmp eax,4
   je f4

   f1:
   call print
   exit
   
   f2:
   call con_clear
   jmp s


   f3: 
   call edit
   jmp s

   f4:
   call cont_save
   exit


pop ebp
ret
continue ENDP

;////////////////////////////////////////

;////////////////////////////////////////
read_file PROC
push ebp
  cmp eax,1
  je f1
  cmp eax,2
  je f2
  cmp eax,3
  je f3

  f1:
  mov edx,OFFSET file1 
  mov edi,1
  jmp do
  f2:
  mov edx,OFFSET file2
  mov edi,2
  jmp do
  f3:
  mov edx,OFFSET file3
  mov edi,3
  jmp do
  do:

  call OpenInputFile
  mov fileHandle,eax
  
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  cmp edi,1
  je sol_f1

  cmp edi,2
  je sol_f2

  jmp sol_f3


  sol_f1:
  mov edx,offset file1_solv
  call OpenInputFile
  mov fileHandle,eax
  
  mov edx,OFFSET buffer2
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile


  jmp e

  sol_f2:
  mov edx,offset file2_solv
  call OpenInputFile
  mov fileHandle,eax
  
  mov edx,OFFSET buffer2
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  jmp e

  sol_f3:
  mov edx,offset file3_solv
  call OpenInputFile
  mov fileHandle,eax
  
  mov edx,OFFSET buffer2
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  e:

 pop ebp
ret
read_file ENDP
;//////////////////////////////////////
show_suduko proc
 push ebp

  ;mov buffer[eax],0 
  mWrite <"suduko:",0dh,0ah,0dh,0ah>
  mov edx,OFFSET buffer 
  call WriteString
  call Crlf
 
 pop ebp
ret
show_suduko endp
;////////////////////////////////////
 clear proc
  push ebp
  
  cmp edi,1
  je F1

  cmp edi,2
  je F2

  jmp F3

  F1:
  mov edx,OFFSET file1 
  call OpenInputFile
  mov fileHandle,eax
  mov buffer,0
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile
  jmp ex
  F2:
  mov edx,OFFSET file2 
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile
  jmp ex

  F3:
  mov edx,OFFSET file3
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile
  ex:
  call show_suduko

  pop ebp
 ret
 clear endp
 ;/////////////////////
 con_clear proc
  push ebp

  mov edx,OFFSET cl_file
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile
  call show_suduko

  pop ebp
 ret
 con_clear endp

 ;////////////////////////////////////////
 edit proc
  push ebp
   mWrite <"please enter row and colum number",0dh,0ah>
   mov ebp,offset buffer2
   mov ecx,0

   r1:
   cmp ecx,0
   je r2

   mov eax,0
   mov eax,count_incorr
   add eax,1
   xchg eax,count_incorr

   mWrite <"Wrong",0dh,0ah>
   mWrite <"Row: ">
   call readdec
   cmp eax,9
   ja r2
   mov ebx,eax

   mWrite <"colum: ">
   call readdec 
   cmp eax,9
   ja r2
   mov esi,eax

   mWrite <"your number: ">
   call readchar
   cmp ebx,1  
   jne e

   jmp t

   r2:
   mWrite <"Row: ">
   call readdec
   cmp eax,9
   ja r2
   mov ebx,eax

   mWrite <"colum: ">
   call readdec 
   cmp eax,9
   ja r2
   mov esi,eax

   mWrite <"your number: ">
   call readchar
   cmp ebx,1  
   jne e
   
   t:
   mov ecx,1
   sub esi,1 
   mov cl,[edx+esi]
   cmp cl,'0'
   jne r2

   mov ecx,1
   cmp [ebp+esi],al
   jne r1

   mov [edx+esi],al

   mov eax,0
   mov eax,count_corr
   add eax,1
   xchg eax,count_corr

   ;mov eax,b
   ;call SetTextColor

   jmp en

   e:
   
   sub ebx,1
   mov ecx,ebx
   mult:
   add esi,10
   loop mult

   mov cl,[edx+esi]
   cmp cl,'0'
   jne r2

   mov ecx,1
   cmp [ebp+esi],al
   jne r1

   mov [edx+esi],al
   mov eax,0
   mov eax,count_corr
   add eax,1
   xchg eax,count_corr

   en:

   call show_suduko

  pop ebp
 ret
 edit endp
 ;//////////////////////////////////////
 save proc
  push ebp

  mov edx,OFFSET cont_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile

  cmp edi,1
  je F1

  cmp edi,2
  je F2

  jmp F3

  F1:
  mov edx,OFFSET file1
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  mov edx,OFFSET cl_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile

  mov edx,OFFSET file1_solv
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  mov edx,OFFSET cont_solv_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile






  jmp ex
  F2:
  mov edx,OFFSET file2
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  mov edx,OFFSET cl_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile
 
  mov edx,OFFSET file2_solv
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  mov edx,OFFSET cont_solv_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile


  jmp ex

  F3:
  mov edx,OFFSET file3
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  mov edx,OFFSET cl_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile
 
  mov edx,OFFSET file3_solv
  call OpenInputFile
  mov fileHandle,eax
  mov edx,OFFSET buffer
  mov ecx,BUFFER_SIZE
  call ReadFromFile
  mov eax,filehandle
  call closefile

  mov edx,OFFSET cont_solv_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile


  ex:

  pop ebp
 ret
 save endp
 ;//////////////////////////////
 cont_save proc
  push ebp

  mov edx,OFFSET cont_file
  call CreateOutputFile
  mov fileHandle,eax

  mov edx,offset buffer
  mov ecx,LENGTHOF buffer
  call writetofile
  mov eax,filehandle
  call closefile  

  pop ebp
 ret
 cont_save endp
 ;/////////////////////
END main