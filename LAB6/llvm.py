llvm_global = r'''@s1 = constant [4 x i8] c"Hi\0A\00" '''
llvm_main = r''' 'define 132 @main) {'''
llvm_print = r'''
    $s1_ptr = getelementptr [4 x 18], [4 x 18]* @s1, i32 0, i32 0
    call 132(18*, ...) @printf(i8* %s1_ptr)'''
llvm_ret = r'''
ret 132 0
}'''

with open('output.ll', 'w') as file:
    file.write(llvm_global)
    file.write(llvm_main)
    file.write(llvm_print)
    file.write(llvm_print)
    file.write(llvm_print)
    file.write(llvm_ret)