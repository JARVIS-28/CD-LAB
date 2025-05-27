llvm = r'''@s1 = constant [44 x i8] c"Hi!\0a- Name: Janvii RV\0a- Srn: PES2UG22CS232\0a\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
  %s1_ptr = getelementptr [44 x i8], [44 x i8]* @s1, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %s1_ptr)
  ret i32 0
}
'''

with open('output.ll', 'w') as file:
    file.write(llvm)