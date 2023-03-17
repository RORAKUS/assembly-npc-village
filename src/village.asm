;;; CONSTANT SECTION
%assign ACTIONS_LENGTH 10 ; length of the actions array
%assign NAMES_LENGTH 5 ; length of the names array
%assign MAX_RESULT_LENGTH 20 ; maximum length for the string containing the result to print

%assign STDOUT_FILENO 1 ; file descriptor for STDOUT
%assign GRND_NONBLOCK 0x01 ; option for getrandom()
%assign GRND_RANDOM 0x02 ; option for getrandom()

%assign EXIT_CODE 0 ; exit code of the program
%assign NEGATIVE_ONE 0xFFFFFFFF ; self explanatory

%assign SYS_WRITE 4 ; code for write() syscall
%assign SYS_EXIT 1 ; code for _exit() syscall
%assign SYS_GETRANDOM 355 ; code for getrandom() syscall

global _start ; for linker

section .data ; section containing all the static data
; names for NPCS
alice db 'Alice', 0x0
bob db 'Bob', 0x0
charlie db 'Charlie', 0x0
david db 'David', 0x0
eve db 'Eve', 0x0
; actions for NPSC
runs db 'runs', 0x0
jumps db 'jumps', 0x0
sleeps db 'sleeps', 0x0
eats db 'eats', 0x0
laughs db 'laughs', 0x0
works db 'works', 0x0
reads db 'reads', 0x0
sings db 'sings', 0x0
dances db 'dances', 0x0
talks db 'talks', 0x0

names dd alice, bob, charlie, david, eve ; array of strings with npc names
actions dd runs, jumps, sleeps, eats, laughs, works, reads, sings, dances, talks ; array of strings for npc actions

section .bss ; section containing non-initialized data (dynamic data)
rnm resd 1 ; the result of random() function, 4 bytes (int)
result resb MAX_RESULT_LENGTH ; the result string, used for printing

section .text ; the main section with all the code
random: ; int random(int max) // generates a random number from 0 to max
    push ebp ; function enter logic - pushes return address onto stack
    mov ebp, esp ; sets ebp to the stack top

    push ebx ; save registers
    push ecx
    push edx

    ; prepare flags GRND_RANDOM | GRND_NONBLOCK
    mov edx, GRND_RANDOM
    or edx, GRND_NONBLOCK
    ; call getrandom
    mov ecx, 4 ; four bytes for an integer
    mov ebx, rnm ; copies the address of rnm into ebx
    mov eax, SYS_GETRANDOM ; code for getrandom() syscall
    int 0x80 ; perform syscall

    ; if rnm >= 0 jump to skipabs
    cmp [rnm], DWORD 0
    jge skipabs
    ; perform abs()
    mov eax, [rnm]
    mov ebx, NEGATIVE_ONE
    imul ebx ; eax - result lower, edx - result higher - can be disposed
    mov [rnm], eax ; back to rnm

    skipabs:
    ; return rnm % max
    xor edx, edx ; prepare for division
    mov eax, [rnm]
    idiv DWORD [ebp+8] ; divides by max (ebp+4 -> old ebp)
    mov eax, edx ; moves the reminder into the return register

    pop edx ; retrieves registers
    pop ecx
    pop ebx

    mov esp, ebp ; clears stack back to it's original state
    pop ebp ; pops the return address back to ebp
    ret
strlen: ; int strlen(char* string)
    push ebp ; function enter logic - pushes return address onto stack
    mov ebp, esp ; sets ebp to the stack top

    push ebx ; saves registers
    push ecx
    push edx

    mov ecx, NEGATIVE_ONE ; sets the counter to -1
    mov ebx, [ebp+8] ; address to the string we want to measure (char* string)
    loop1: ; while (string[ecx] != '\0')
        inc ecx ; increase ecx
        cmp [ebx+ecx], BYTE 0x0 ; compare the byte on ecx offset from string with null byte (termination byte)
        jne loop1 ; if it doesn't equal, do it again
    mov eax, ecx ; eax = return register -- move the length to the return register

    pop edx ; retrieves registers
    pop ecx
    pop ebx

    mov esp, ebp ; clears stack back to it's original state
    pop ebp ; pops the return address back to ebp
    ret
merge_strings: ; void merge_strings(char* res, char* first, char* second)
    push ebp ; function enter logic - pushes return address onto stack
    mov ebp, esp ; sets ebp to the stack top

    push eax ; saves registers
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov edi, [ebp+8] ; char* second
    mov esi, [ebp+12] ; char* first
    mov eax, [ebp+16] ; char* res

    xor edx, edx ; setting the counters to 0
    xor ecx, ecx ; edx - counter for res, ecx - counter for first and second

    loop2: ; while (first[ecx] != '\0')
        cmp [esi+ecx], BYTE 0x0 ; compare offset ecx of esi with the null byte
        je out2 ; if equals break
        mov bl, BYTE [esi+ecx] ; helping operation, because you cannot move memory to memory :/
        mov [eax+edx], BYTE bl ; moving the ecx byte from first to the edx byte of res (copying...)
        inc ecx ; ecx++
        inc edx ; edx++
        jmp loop2 ; continue
    out2:
    mov [eax+edx], BYTE ' ' ; add space to the result string
    inc edx ; edx++
    xor ecx, ecx ; ecx = 0 (start over, but with the second string)
    loop3: ; the same, but with second instead of first
        cmp [edi+ecx], BYTE 0x00
        je out3
        mov bl, BYTE [edi+ecx]
        mov [eax+edx], BYTE bl
        inc ecx
        inc edx
        jmp loop3
    out3:
    mov [eax+edx], BYTE 0x0a ; adds a new line to the result
    inc edx ; edx++
    mov [eax+edx], BYTE 0x00 ; adds a termination byte to the result

    pop edi ; retrieves registers
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp ; clears stack back to it's original state
    pop ebp ; pops the return address back to ebp
    ret
_start: ; main function
    xor ecx, ecx ; prepare the counter register (ecx = 0)
    loop4: ; for (name_index ecx in names)
        push DWORD ACTIONS_LENGTH
        call random ; call random(ACTIONS_LENGTH)
        add esp, 4 ; clears the stack

        mov ebx, [actions+eax+eax+eax+eax] ; select a random action - 4x because address is four bytes (it's ugly, but the easiest :D)

        push result
        push DWORD [names+ecx+ecx+ecx+ecx] ; bleuch too
        push ebx
        call merge_strings ; calls merge_strings(result, names[ecx], ebx /* random action */) - merges it to writable string
        add esp, 12 ; clears stack

        push result
        call strlen ; calls strlen(result) and saves into eax (return register)
        add esp, 4 ; clears stack

        push ecx ; saves the counter register

        ; preparing parameters for the write(fd, what, how_much) syscall
        mov edx, eax ; how much = length of the string
        mov ecx, result ; what = result
        mov ebx, STDOUT_FILENO ; fd = file descriptor = stdout
        mov eax, SYS_WRITE ; what method = 4 = SYS_WRITE
        int 0x80 ; performs syscall

        pop ecx ; retrieves the counter register

        inc ecx ; ecx++
        cmp ecx, DWORD NAMES_LENGTH ; compare the counter with the length of the name array
        jne loop4 ; if it doesn't equal, do it again

    ; preparing parameters for the _exit(code) syscall
    mov ebx, EXIT_CODE ; exit with code 0
    mov eax, SYS_EXIT ; 1 = SYS_EXIT
    int 0x80 ; performs syscall and successfully exits the program
; THE END :D