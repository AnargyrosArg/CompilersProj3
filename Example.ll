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
%.BooleanArrayType = type { i32 , i1*}
%.IntArrayType = type { i32 , i32*}
%class.A = type { i8* ,i1 ,i32 ,i1}
@.A_vtable = global [1x i8*] [i8* bitcast (i32 (i8*,i32 ,%class.A ,%.IntArrayType )* @A.foo to i8*)]

%class.B = type { i8* ,i1 ,i32 ,i1 ,i32}
@.B_vtable = global [1x i8*] [i8* bitcast (i32 (i8*,i32 ,%class.A ,%.IntArrayType )* @A.foo to i8*)]

define i32 @main(){
%a = alloca %class.A
%b = alloca %class.B
%i = alloca i32
%table = alloca %.IntArrayType
%1 = alloca i32
store i32 32, i32* %1
%2= load i32, i32* %1
store i32 %2 , i32* %i
%3 = call i8* @calloc(i32 1,i32 14)
%4 = bitcast i8* %3 to %class.A*
%5 = getelementptr inbounds %class.A, %class.A* %4, i32 0, i32 0
%6 = bitcast i8** %5 to [1 x i8*]**
store [1 x i8*]* @.A_vtable, [1 x i8*]** %6
%7= load %class.A, %class.A* %4
store %class.A %7 , %class.A* %a
%8 = call i8* @calloc(i32 1,i32 18)
%9 = bitcast i8* %8 to %class.B*
%10 = getelementptr inbounds %class.B, %class.B* %9, i32 0, i32 0
%11 = bitcast i8** %10 to [1 x i8*]**
store [1 x i8*]* @.B_vtable, [1 x i8*]** %11
%12= load %class.B, %class.B* %9
store %class.B %12 , %class.B* %b
%13 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%14 = load i8* , i8** %13
%15 = bitcast i8* %14 to [1 x i8*]*
%16 = getelementptr [1 x i8*], [1 x i8*]* %15, i32 0 , i32 0
%17 = load i8* , i8** %16
%18 = bitcast i8* %17 to i32(i8* ,i32,%class.B,%.IntArrayType)*
%19 = load i32,i32* %i
%20 = load %class.B,%class.B* %b
%21 = load %.IntArrayType,%.IntArrayType* %table
%22 = bitcast %class.A* %a to i8*
%23 = call i32 %18(i8* %22,i32 %19,%class.B %20,%.IntArrayType %21)
%24 = alloca i32
store i32 %23, i32* %24
%25= load i32, i32* %24
store i32 %25 , i32* %i
ret i32 0 
}
define i32 @A.foo(i8* %this,i32 %i.arg,%class.A %a.arg,%.IntArrayType %table.arg){
%i = alloca i32
store i32 %i.arg ,i32* %i
%a = alloca %class.A
store %class.A %a.arg ,%class.A* %a
%table = alloca %.IntArrayType
store %.IntArrayType %table.arg ,%.IntArrayType* %table
%1 = load i32 , i32* %i
call void @print_int(i32 %1)
%2= load i32, i32* %i
ret i32 %2
}
