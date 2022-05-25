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
%class.A = type { i8* ,i1}
@.A_vtable = global [1x i8*] [i8* bitcast (i32 (i8*,i32 ,%class.A )* @A.foo to i8*)]

%class.B = type { i8* ,i1 ,i32}
@.B_vtable = global [1x i8*] [i8* bitcast (i32 (i8*,i32 ,%class.A )* @A.foo to i8*)]

define i32 @main(){
%a = alloca %class.A
%b = alloca %class.B
%i = alloca i32
%1 = alloca i32
store i32 32, i32* %1
%2= load i32, i32* %1
store i32 %2 , i32* %i
%3 = alloca %class.A
%4 = getelementptr inbounds %class.A, %class.A* %3, i32 0, i32 0
%5 = bitcast i8** %4 to [1 x i8*]**
store [1 x i8*]* @.A_vtable, [1 x i8*]** %5
%6= load %class.A, %class.A* %3
store %class.A %6 , %class.A* %a
%7 = alloca %class.B
%8 = getelementptr inbounds %class.B, %class.B* %7, i32 0, i32 0
%9 = bitcast i8** %8 to [1 x i8*]**
store [1 x i8*]* @.B_vtable, [1 x i8*]** %9
%10= load %class.B, %class.B* %7
store %class.B %10 , %class.B* %b
%11 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%12 = load i8* , i8** %11
%13 = bitcast i8* %12 to [1 x i8*]*
%14 = getelementptr [1 x i8*], [1 x i8*]* %13, i32 0 , i32 0
%15 = load i8* , i8** %14
%16 = bitcast i8* %15 to i32(i8* ,i32,%class.B)*
%17 = load i32,i32* %i
%18 = load %class.B,%class.B* %b
%19 = bitcast %class.A* %a to i8*
%20 = call i32 %16(i8* %19,i32 %17,%class.B %18)
%21 = alloca i32
store i32 %20, i32* %21
%22= load i32, i32* %21
store i32 %22 , i32* %i
ret i32 0 
}
define i32 @A.foo(i8* %this,i32 %i.arg,%class.A %a.arg){
%i = alloca i32
store i32 %i.arg ,i32* %i
%a = alloca %class.A
store %class.A %a.arg ,%class.A* %a
%1 = load i32 , i32* %i
call void @print_int(i32 %1)
%2= load i32, i32* %i
ret i32 %2
}
