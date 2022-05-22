declare i8* @calloc(i32, i32)
declare i32 @printf(i8*, ...)
declare void @exit(i32)

@_cint = constant [4 x i8] c"%d\0a\00"
@_cOOB = constant [15 x i8] c"Out of bounds\0a\00"
define void @print_int(i32 %i) {
   %_str = bitcast [4 x i8]* @_cint to i8*
   call i32 (i8*, ...) @printf(i8* %_str, i32 %i)
   ret void
   }
define void @throw_oob() {
%_str = bitcast [15 x i8]* @_cOOB to i8*
   call i32 (i8*, ...) @printf(i8* %_str)
   call void @exit(i32 1)   ret void
   }
%class.A = type { i8*}
@.A_vtable = global [1x i8*] [i8* bitcast (i32 ()* @A.bar to i8*)]

define i32 @main(){
%i = alloca i32
%1 = load i32 , i32* %i
call void @print_int(i32 %1)
ret i32 0 
}
define i32 @A.bar(){
%1 = alloca i32
store i32 3, i32* %1
%2 = load i32 , i32* %1
call void @print_int(i32 %2)
%3 = alloca i32
store i32 3, i32* %3
%4= load i32, i32* %3
ret i32 %4
}
