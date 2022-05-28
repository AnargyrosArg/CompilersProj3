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
%class.A = type { i8*}
@.A_vtable = global [1x i8*] [i8* bitcast (i32 (i8*)* @A.getData to i8*)]

define i32 @main(){
%i = alloca i32
%j = alloca i32
%1 = alloca i32
store i32 10, i32* %1
%2= load i32, i32* %1
store i32 %2 , i32* %i
%3 = alloca i32
store i32 20, i32* %3
%4= load i32, i32* %3
store i32 %4 , i32* %j
%5 = alloca i32
store i32 1, i32* %5
%6 = alloca i32
store i32 2, i32* %6
%7= load i32, i32* %5
%8= load i32, i32* %6
%9 = add i32 %7, %8
%10 = alloca i32
store i32 %9, i32* %10
%11 = alloca i32
store i32 3, i32* %11
%12= load i32, i32* %10
%13= load i32, i32* %11
%14 = add i32 %12, %13
%15 = alloca i32
store i32 %14, i32* %15
%16= load i32, i32* %15
%17= load i32, i32* %i
%18 = add i32 %16, %17
%19 = alloca i32
store i32 %18, i32* %19
%20= load i32, i32* %19
%21= load i32, i32* %j
%22 = add i32 %20, %21
%23 = alloca i32
store i32 %22, i32* %23
%24 = load i32 , i32* %23
call void @print_int(i32 %24)
%25 = alloca i32
store i32 1, i32* %25
%26 = alloca i32
store i32 2, i32* %26
%27 = load i32, i32* %25
%28 = load i32, i32* %26
%29 = mul i32 %27, %28
%30 = alloca i32
store i32 %29, i32* %30
%31 = alloca i32
store i32 3, i32* %31
%32 = load i32, i32* %30
%33 = load i32, i32* %31
%34 = mul i32 %32, %33
%35 = alloca i32
store i32 %34, i32* %35
%36 = load i32, i32* %35
%37 = load i32, i32* %i
%38 = mul i32 %36, %37
%39 = alloca i32
store i32 %38, i32* %39
%40 = load i32, i32* %39
%41 = load i32, i32* %j
%42 = mul i32 %40, %41
%43 = alloca i32
store i32 %42, i32* %43
%44 = load i32 , i32* %43
call void @print_int(i32 %44)
%45 = alloca i32
store i32 1, i32* %45
%46 = alloca i32
store i32 2, i32* %46
%47 = load i32, i32* %45
%48 = load i32, i32* %46
%49 = mul i32 %47, %48
%50 = alloca i32
store i32 %49, i32* %50
%51 = alloca i32
store i32 3, i32* %51
%52 = load i32, i32* %50
%53 = load i32, i32* %51
%54 = mul i32 %52, %53
%55 = alloca i32
store i32 %54, i32* %55
%56= load i32, i32* %55
%57= load i32, i32* %i
%58 = sub i32 %56, %57
%59 = alloca i32
store i32 %58, i32* %59
%60= load i32, i32* %59
%61= load i32, i32* %j
%62 = add i32 %60, %61
%63 = alloca i32
store i32 %62, i32* %63
%64 = load i32 , i32* %63
call void @print_int(i32 %64)
%65 = alloca i32
store i32 1, i32* %65
%66 = call i8* @calloc(i32 1,i32 8)
%67 = bitcast i8* %66 to %class.A*
%68 = getelementptr inbounds %class.A, %class.A* %67, i32 0, i32 0
%69 = bitcast i8** %68 to [1 x i8*]**
store [1 x i8*]* @.A_vtable, [1 x i8*]** %69
%70 = getelementptr inbounds %class.A, %class.A* %67, i32 0, i32 0
%71 = load i8* , i8** %70
%72 = bitcast i8* %71 to [1 x i8*]*
%73 = getelementptr [1 x i8*], [1 x i8*]* %72, i32 0 , i32 0
%74 = load i8* , i8** %73
%75 = bitcast i8* %74 to i32(i8* )*
%76 = bitcast %class.A* %67 to i8*
%77 = call i32 %75(i8* %76)
%78 = alloca i32
store i32 %77, i32* %78
%79 = load i32, i32* %65
%80 = load i32, i32* %78
%81 = mul i32 %79, %80
%82 = alloca i32
store i32 %81, i32* %82
%83 = alloca i32
store i32 3, i32* %83
%84 = load i32, i32* %82
%85 = load i32, i32* %83
%86 = mul i32 %84, %85
%87 = alloca i32
store i32 %86, i32* %87
%88= load i32, i32* %87
%89= load i32, i32* %i
%90 = sub i32 %88, %89
%91 = alloca i32
store i32 %90, i32* %91
%92 = alloca i32
store i32 20, i32* %92
%93= load i32, i32* %91
%94= load i32, i32* %92
%95 = add i32 %93, %94
%96 = alloca i32
store i32 %95, i32* %96
%97 = load i32 , i32* %96
call void @print_int(i32 %97)
ret i32 0 
}
define i32 @A.getData(i8* %this){
%1 = alloca i32
store i32 100, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
