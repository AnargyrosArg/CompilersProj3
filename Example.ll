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
@.A_vtable = global [1x i8*] [i8* bitcast (i32 (i8*,i32 )* @A.foo to i8*)]

define i32 @main(){
%a = alloca %class.A
%i = alloca i32
%1 = alloca %class.A
%2 = getelementptr inbounds %class.A, %class.A* %1, i32 0, i32 0
%3 = bitcast i8** %2 to [1 x i8*]**
store [1 x i8*]* @.A_vtable, [1 x i8*]** %3
%4= load %class.A, %class.A* %1
store %class.A %4 , %class.A* %a
%5 = alloca i32
store i32 32, i32* %5
%6 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%7 = load i8* , i8** %6
%8 = bitcast i8* %7 to [1 x i8*]*
%9 = getelementptr [1 x i8*], [1 x i8*]* %8, i32 0 , i32 0
%10 = load i8* , i8** %9
%11 = bitcast i8* %10 to i32(i8* ,i32)*
%12 = load i32,i32* %5
%13 = bitcast %class.A* %a to i8*
%14 = call i32 %11(i8* %13,i32 %12)
%15 = alloca i32
store i32 %14, i32* %15
%16= load i32, i32* %15
store i32 %16 , i32* %i
ret i32 0 
}
define i32 @A.foo(i8* %this,i32 %i.arg){
%i = alloca i32
store i32 %i.arg ,i32* %i
%1 = load i32 , i32* %i
call void @print_int(i32 %1)
%2= load i32, i32* %i
ret i32 %2
}
