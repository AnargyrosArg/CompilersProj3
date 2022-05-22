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
@.A_vtable = global [2x i8*] [i8* bitcast (i32 (i8*,i32 ,i1 )* @A.foo to i8*),
i8* bitcast (i32 (i8*)* @A.bar to i8*)]

define i32 @main(){
%1 = alloca i32
store i32 32, i32* %1
%2 = alloca i1
store i1 1, i1* %2
%3 = alloca %class.A
%4 = getelementptr inbounds %class.A, %class.A* %3, i32 0, i32 0
%5 = bitcast i8** %4 to [2 x i8*]**
store [2 x i8*]* @.A_vtable, [2 x i8*]** %5
%6 = getelementptr inbounds %class.A, %class.A* %3, i32 0, i32 0
%7 = load i8* , i8** %6
%8 = bitcast i8* %7 to [2 x i8*]*
%9 = getelementptr [2 x i8*], [2 x i8*]* %8, i32 0 , i32 0
%10 = load i8* , i8** %9
%11 = bitcast i8* %10 to i32(i32,i1)*
%12 = load i32,i32* %1
%13 = load i1,i1* %2
%14 = call i32 %11(i32 %12,i1 %13)
%15 = alloca i32
store i32 %14, i32* %15
%16 = load i32 , i32* %15
call void @print_int(i32 %16)
ret i32 0 
}
define i32 @A.foo(i8* %this,i32 %i, i1 %b){%1= load i32, i32* %i
ret i32 %1
}
define i32 @A.bar(i8* %this){%1 = alloca i32
store i32 1, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
