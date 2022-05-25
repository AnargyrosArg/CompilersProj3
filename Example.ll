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
%class.A = type { i8* ,i32}
@.A_vtable = global [2x i8*] [i8* bitcast (i32 (i8*)* @A.printID to i8*),
i8* bitcast (i32 (i8*,i32 )* @A.setID to i8*)]

%class.B = type { i8* ,i32 ,i32}
@.B_vtable = global [3x i8*] [i8* bitcast (i32 (i8*)* @A.printID to i8*),
i8* bitcast (i32 (i8*,i32 )* @A.setID to i8*),
i8* bitcast (i32 (i8*)* @B.foo to i8*)]

define i32 @main(){
%a = alloca %class.A
%i = alloca i32
%1 = call i8* @calloc(i32 1,i32 12)
%2 = bitcast i8* %1 to %class.A*
%3 = getelementptr inbounds %class.A, %class.A* %2, i32 0, i32 0
%4 = bitcast i8** %3 to [2 x i8*]**
store [2 x i8*]* @.A_vtable, [2 x i8*]** %4
%5= load %class.A, %class.A* %2
store %class.A %5 , %class.A* %a
%6 = alloca i32
store i32 1288, i32* %6
%7= load i32, i32* %6
store i32 %7 , i32* %i
%8 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%9 = load i8* , i8** %8
%10 = bitcast i8* %9 to [2 x i8*]*
%11 = getelementptr [2 x i8*], [2 x i8*]* %10, i32 0 , i32 1
%12 = load i8* , i8** %11
%13 = bitcast i8* %12 to i32(i8* ,i32)*
%14 = load i32,i32* %i
%15 = bitcast %class.A* %a to i8*
%16 = call i32 %13(i8* %15,i32 %14)
%17 = alloca i32
store i32 %16, i32* %17
%18= load i32, i32* %17
store i32 %18 , i32* %i
%19 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%20 = load i8* , i8** %19
%21 = bitcast i8* %20 to [2 x i8*]*
%22 = getelementptr [2 x i8*], [2 x i8*]* %21, i32 0 , i32 0
%23 = load i8* , i8** %22
%24 = bitcast i8* %23 to i32(i8* )*
%25 = bitcast %class.A* %a to i8*
%26 = call i32 %24(i8* %25)
%27 = alloca i32
store i32 %26, i32* %27
%28= load i32, i32* %27
store i32 %28 , i32* %i
ret i32 0 
}
define i32 @A.printID(i8* %this){
%1 = getelementptr i8,i8* %this, i32 8
%2 = bitcast i8* %1 to i32*
%3 = load i32 , i32* %2
call void @print_int(i32 %3)
%4 = getelementptr i8,i8* %this, i32 8
%5 = bitcast i8* %4 to i32*
%6= load i32, i32* %5
ret i32 %6
}
define i32 @A.setID(i8* %this,i32 %i.arg){
%i = alloca i32
store i32 %i.arg ,i32* %i
%1 = getelementptr i8,i8* %this, i32 8
%2 = bitcast i8* %1 to i32*
%3= load i32, i32* %i
store i32 %3 , i32* %2
%4 = getelementptr i8,i8* %this, i32 8
%5 = bitcast i8* %4 to i32*
%6 = alloca i32
store i32 23, i32* %6
%7= load i32, i32* %6
store i32 %7 , i32* %5
%8 = getelementptr i8,i8* %this, i32 8
%9 = bitcast i8* %8 to i32*
%10= load i32, i32* %9
ret i32 %10
}
define i32 @B.foo(i8* %this){
%id = alloca i32
%1 = getelementptr i8,i8* %this, i32 12
%2 = bitcast i8* %1 to i32*
%3= load i32, i32* %2
store i32 %3 , i32* %id
%4= load i32, i32* %id
ret i32 %4
}
