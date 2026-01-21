X64Args struct
	Arg1 dq	0
	Arg2 dq 0
	Arg3 dq 0
	Arg4 dq 0
	Arg5 dq 0
	Arg6 dq 0
	Arg7 dq 0
	Arg8 dq 0
	Arg9 dq 0
	Arg10 dq 0
	Arg11 dq 0
	Arg12 dq 0
	Arg13 dq 0
	Arg14 dq 0
	Arg15 dq 0
	Arg16 dq 0
	
	union
		SsdtIndex dq 0
		FunAddr   dq 0
	ends

	ReturnValue dq 0
X64Args ends

X64Args_Native struct
	Arg1 dq	0
	Arg2 dq 0
	Arg3 dq 0
	Arg4 dq 0
	Arg5 dq 0
	Arg6 dq 0
	Arg7 dq 0
	Arg8 dq 0
	Arg9 dq 0
	Arg10 dq 0
	Arg11 dq 0
	Arg12 dq 0
	Arg13 dq 0
	Arg14 dq 0
	Arg15 dq 0
	Arg16 dq 0
	
	FunAddr dq 0	;ntdll64 函数地址
	ReturnValue  dq 0
X64Args_Native ends

.code
;--------------------------------------------------------------------------------
;直接调用ntdll64 API，不支持win32 API
;
;因为Wow64进程没有win32u.dll
;
;--------------------------------------------------------------------------------

;
;
CallX64_Native proc par:qword
    
    ;------------------------------------------------------------------------
    ;堆栈参数
    ;------------------------------------------------------------------------
	push rbp
    mov rbp, rsp
    
    ;---------------------------------------------------------------------------------
    ;进入X64模式
    ;--------------------------------------------------------------------------------- 
    push 033h
    call $+5
    add dword ptr [esp], 5
    retf
    
    ;-------------------------------------------------------------------------------------
    ;X64模式
    ;-------------------------------------------------------------------------------------
    ;保存非易变寄存器
    ;-------------------------------------------------------------------------------------
    push rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    
    ;------------------------------------------------------------------------------------------
    ;调用X64函数
    ;------------------------------------------------------------------------------------------
    
    ;开辟堆栈
    sub rsp, 256   
    
    ;传参
	mov ebx, dword ptr [rbp+12]
	
	mov rcx, (X64Args ptr [rbx]).Arg1		;arg1
	mov rdx, (X64Args ptr [rbx]).Arg2		;arg2
	mov r8,  (X64Args ptr [rbx]).Arg3		;arg3
	mov r9,	 (X64Args ptr [rbx]).Arg4		;arg4
	
	xor rax, rax
	mov [rsp], rax						;arg_1 = 0
	mov [rsp+8], rax						;arg_2 = 0
	mov [rsp+16], rax						;arg_3 = 0
	mov [rsp+24], rax						;arg_4 = 0
	
	mov rax, (X64Args ptr [rbx]).Arg5		;arg5
	mov [rsp+32], rax
	
	mov rax, (X64Args ptr [rbx]).Arg6		;arg6
	mov [rsp+40], rax
	
	mov rax, (X64Args ptr [rbx]).Arg7		;arg7
	mov [rsp+48], rax
	
	mov rax, (X64Args ptr [rbx]).Arg8		;arg8
	mov [rsp+56], rax
	
	mov rax, (X64Args ptr [rbx]).Arg9		;arg9
	mov [rsp+64], rax
	
	mov rax, (X64Args ptr [rbx]).Arg10		;arg10
	mov [rsp+72], rax
	
	mov rax, (X64Args ptr [rbx]).Arg11		;arg11
	mov [rsp+80], rax
	
	mov rax, (X64Args ptr [rbx]).Arg12		;arg12
	mov [rsp+88], rax
	
	mov rax, (X64Args ptr [rbx]).Arg13		;arg13
	mov [rsp+96], rax
	
	mov rax, (X64Args ptr [rbx]).Arg14		;arg14
	mov [rsp+104], rax
	
	mov rax, (X64Args ptr [rbx]).Arg15		;arg15
	mov [rsp+112], rax
	
	mov rax, (X64Args ptr [rbx]).Arg16		;arg16
	mov [rsp+120], rax
    
    
    ;调用系统函数
    mov rax, (X64Args ptr [rbx]).FunAddr	;ssdtIndex
	call rax
    
  	mov ebx, dword ptr [rbp+12]				;读参数指针
  	
  	mov qword ptr (X64Args ptr [rbx]).ReturnValue, rax
    
    ;清空堆栈
    add rsp, 256
    
    ;-------------------------------------------------------
    ;恢复非易变寄存器
    ;-----------------------------------------------------------
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rsp
        
    ;--------------------------------------------------------------------
    ;进入X86模式
    ;--------------------------------------------------------------------
    call $+5
    mov dword ptr [rsp+04h], 023h
    add dword ptr [rsp], 0Dh
    retf
    
    ;------------------------------------------------------------------------
    ;返回到调用者 - 仅演示，实际代码不要包含如下代码
    ;-------------------------------------------------------------------------
    mov rsp, rbp
    pop rbp
    ret

CallX64_Native endp

;----------------------------------------------------------------------------
;通过Syscall调用系统API，支持win32 API
;------------------------------------------------------------------------------
CallX64_SysCall proc par:qword
    
    ;------------------------------------------------------------------------
    ;堆栈参数
    ;------------------------------------------------------------------------
	push rbp
    mov rbp, rsp
    
    ;---------------------------------------------------------------------------------
    ;进入X64模式
    ;--------------------------------------------------------------------------------- 
    push 033h
    call $+5
    add dword ptr [esp], 5
    retf
    
    ;-------------------------------------------------------------------------------------
    ;X64模式
    ;-------------------------------------------------------------------------------------
    ;保存非易变寄存器
    ;-------------------------------------------------------------------------------------
    push rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    
    ;------------------------------------------------------------------------------------------
    ;调用X64函数
    ;------------------------------------------------------------------------------------------
    
    ;开辟堆栈
    sub rsp, 256   
    
    ;传参
	mov ebx, dword ptr [rbp+12]
	
	mov rcx, (X64Args ptr [rbx]).Arg1		;arg1
	mov rdx, (X64Args ptr [rbx]).Arg2		;arg2
	mov r8,  (X64Args ptr [rbx]).Arg3		;arg3
	mov r9,	 (X64Args ptr [rbx]).Arg4		;arg4
	
	xor rax, rax
	mov [rsp+8], rax						;arg_1 = 0
	mov [rsp+16], rax						;arg_2 = 0
	mov [rsp+24], rax						;arg_3 = 0
	mov [rsp+32], rax						;arg_4 = 0
	
	mov rax, (X64Args ptr [rbx]).Arg5		;arg5
	mov [rsp+40], rax
	
	mov rax, (X64Args ptr [rbx]).Arg6		;arg6
	mov [rsp+48], rax
	
	mov rax, (X64Args ptr [rbx]).Arg7		;arg7
	mov [rsp+56], rax
	
	mov rax, (X64Args ptr [rbx]).Arg8		;arg8
	mov [rsp+64], rax
	
	mov rax, (X64Args ptr [rbx]).Arg9		;arg9
	mov [rsp+72], rax
	
	mov rax, (X64Args ptr [rbx]).Arg10		;arg10
	mov [rsp+80], rax
	
	mov rax, (X64Args ptr [rbx]).Arg11		;arg11
	mov [rsp+88], rax
	
	mov rax, (X64Args ptr [rbx]).Arg12		;arg12
	mov [rsp+96], rax
	
	mov rax, (X64Args ptr [rbx]).Arg13		;arg13
	mov [rsp+104], rax
	
	mov rax, (X64Args ptr [rbx]).Arg14		;arg14
	mov [rsp+112], rax
	
	mov rax, (X64Args ptr [rbx]).Arg15		;arg15
	mov [rsp+120], rax
	
	mov rax, (X64Args ptr [rbx]).Arg16		;arg16
	mov [rsp+128], rax
    
    
    ;调用系统函数
    mov rax, (X64Args ptr [rbx]).SsdtIndex	;ssdtIndex
    mov r10, rcx
    syscall
    
  	mov ebx, dword ptr [rbp+12]				;读参数指针
  	
  	mov qword ptr (X64Args ptr [rbx]).ReturnValue, rax
    
    ;清空堆栈
    add rsp, 256
    
    ;-------------------------------------------------------
    ;恢复非易变寄存器
    ;-----------------------------------------------------------
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rsp
        
    ;--------------------------------------------------------------------
    ;进入X86模式
    ;--------------------------------------------------------------------
    call $+5
    mov dword ptr [rsp+04h], 023h
    add dword ptr [rsp], 0Dh
    retf
    
    ;------------------------------------------------------------------------
    ;返回到调用者
    ;-------------------------------------------------------------------------
    mov rsp, rbp
    pop rbp
    ret

CallX64_Syscall endp

main proc
	ret
main endp
end