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
define i32 @main(){
%a = alloca i32
%b = alloca i32
%1 = alloca i32
store i32 32, i32* %1
%2= load i32, i32* %1
store i32 %2 , i32* %a
%3 = alloca i32
store i32 21, i32* %3
%4= load i32, i32* %a
%5= load i32, i32* %3
%6 = sub i32 %4, %5
%7 = alloca i32
store i32 %6, i32* %7
%8= load i32, i32* %7
store i32 %8 , i32* %b
%9= load i32, i32* %a
%10= load i32, i32* %b
%11 = mul i32 %9, %10
%12 = alloca i32
store i32 %11, i32* %12
%13= load i32, i32* %12
store i32 %13 , i32* %a
%14 = load i32 , i32* %a
call void @print_int(i32 %14)
%15 = load i32 , i32* %b
call void @print_int(i32 %15)
ret i32 0 
}
