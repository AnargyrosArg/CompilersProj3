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
define i32 @main(){
%array = alloca %.IntArrayType
%1 = alloca i32
store i32 110, i32* %1
%2 = alloca %.IntArrayType
%3 = load i32 ,i32* %1
%4 = call i8* @calloc(i32 32 , i32 %3)
%5 = bitcast i8* %4 to i32*
%6 = getelementptr %.IntArrayType,%.IntArrayType* %2,i32 0,i32 1
%7 = getelementptr %.IntArrayType,%.IntArrayType* %2,i32 0,i32 0
store i32 %3,i32* %7
store i32* %5, i32** %6
%8= load %.IntArrayType, %.IntArrayType* %2
store %.IntArrayType %8 , %.IntArrayType* %array
%9 = alloca i32
store i32 11113, i32* %9
%10 = alloca i32
store i32 11, i32* %10
%11 = load i32,i32* %10
%12 = getelementptr %.IntArrayType,%.IntArrayType* %array, i32 0,i32 0
%13 =  load i32 ,i32* %12
%14 = icmp slt i32 %11, %13
br i1 %14,label %continue2, label %oob1
oob1:
call void () @throw_oob()
br label %continue2
continue2:
%15 = getelementptr %.IntArrayType,%.IntArrayType* %array, i32 0,i32 1
%16 =  load i32* , i32** %15
%17 = getelementptr i32 ,i32* %16, i32 %11
%18 = load i32 , i32 *%9
store i32 %18 , i32* %17
%19 = alloca i32
store i32 3, i32* %19
%20 = load i32,i32* %19
%21 = getelementptr %.IntArrayType,%.IntArrayType* %array, i32 0,i32 1
%22 = load i32*,i32**%21
%23 = getelementptr i32 ,i32* %22, i32 %20
%24 = load i32 , i32* %23
call void @print_int(i32 %24)
ret i32 0 
}
