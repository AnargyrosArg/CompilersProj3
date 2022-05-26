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
%array = alloca %.BooleanArrayType
%i = alloca i32
%1 = alloca i32
store i32 0, i32* %1
%2= load i32, i32* %1
store i32 %2 , i32* %i
%3 = alloca i32
store i32 11230, i32* %3
%4 = alloca %.BooleanArrayType
%5 = load i32 ,i32* %3
%6 = call i8* @calloc(i32 32 , i32 %5)
%7 = bitcast i8* %6 to i1*
%8 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %4,i32 0,i32 1
%9 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %4,i32 0,i32 0
store i32 %5,i32* %9
store i1* %7, i1** %8
%10= load %.BooleanArrayType, %.BooleanArrayType* %4
store %.BooleanArrayType %10 , %.BooleanArrayType* %array
%11 = alloca i1
store i1 1, i1* %11
%12 = alloca i32
store i32 0, i32* %12
%13 = load i32,i32* %12
%14 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%15 =  load i32 ,i32* %14
%16 = icmp slt i32 %13, %15
br i1 %16,label %continue2, label %oob1
oob1:
call void () @throw_oob()
br label %continue2
continue2:
%17 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%18 =  load i1* , i1** %17
%19 = getelementptr i1 ,i1* %18, i32 %13
%20 = load i1 , i1 *%11
store i1 %20 , i1* %19
%21 = alloca i1
store i1 1, i1* %21
%22 = alloca i32
store i32 1, i32* %22
%23 = load i32,i32* %22
%24 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%25 =  load i32 ,i32* %24
%26 = icmp slt i32 %23, %25
br i1 %26,label %continue4, label %oob3
oob3:
call void () @throw_oob()
br label %continue4
continue4:
%27 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%28 =  load i1* , i1** %27
%29 = getelementptr i1 ,i1* %28, i32 %23
%30 = load i1 , i1 *%21
store i1 %30 , i1* %29
%31 = alloca i1
store i1 1, i1* %31
%32 = alloca i32
store i32 2, i32* %32
%33 = load i32,i32* %32
%34 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%35 =  load i32 ,i32* %34
%36 = icmp slt i32 %33, %35
br i1 %36,label %continue6, label %oob5
oob5:
call void () @throw_oob()
br label %continue6
continue6:
%37 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%38 =  load i1* , i1** %37
%39 = getelementptr i1 ,i1* %38, i32 %33
%40 = load i1 , i1 *%31
store i1 %40 , i1* %39
%41 = alloca i1
store i1 1, i1* %41
%42 = alloca i32
store i32 3, i32* %42
%43 = load i32,i32* %42
%44 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%45 =  load i32 ,i32* %44
%46 = icmp slt i32 %43, %45
br i1 %46,label %continue8, label %oob7
oob7:
call void () @throw_oob()
br label %continue8
continue8:
%47 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%48 =  load i1* , i1** %47
%49 = getelementptr i1 ,i1* %48, i32 %43
%50 = load i1 , i1 *%41
store i1 %50 , i1* %49
%51 = alloca i1
store i1 1, i1* %51
%52 = alloca i32
store i32 4, i32* %52
%53 = load i32,i32* %52
%54 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%55 =  load i32 ,i32* %54
%56 = icmp slt i32 %53, %55
br i1 %56,label %continue10, label %oob9
oob9:
call void () @throw_oob()
br label %continue10
continue10:
%57 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%58 =  load i1* , i1** %57
%59 = getelementptr i1 ,i1* %58, i32 %53
%60 = load i1 , i1 *%51
store i1 %60 , i1* %59
%61 = alloca i1
store i1 1, i1* %61
%62 = alloca i32
store i32 5, i32* %62
%63 = load i32,i32* %62
%64 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%65 =  load i32 ,i32* %64
%66 = icmp slt i32 %63, %65
br i1 %66,label %continue12, label %oob11
oob11:
call void () @throw_oob()
br label %continue12
continue12:
%67 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%68 =  load i1* , i1** %67
%69 = getelementptr i1 ,i1* %68, i32 %63
%70 = load i1 , i1 *%61
store i1 %70 , i1* %69
%71 = alloca i1
store i1 1, i1* %71
%72 = alloca i32
store i32 6, i32* %72
%73 = load i32,i32* %72
%74 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%75 =  load i32 ,i32* %74
%76 = icmp slt i32 %73, %75
br i1 %76,label %continue14, label %oob13
oob13:
call void () @throw_oob()
br label %continue14
continue14:
%77 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%78 =  load i1* , i1** %77
%79 = getelementptr i1 ,i1* %78, i32 %73
%80 = load i1 , i1 *%71
store i1 %80 , i1* %79
%81 = alloca i1
store i1 1, i1* %81
%82 = alloca i32
store i32 7, i32* %82
%83 = load i32,i32* %82
%84 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%85 =  load i32 ,i32* %84
%86 = icmp slt i32 %83, %85
br i1 %86,label %continue16, label %oob15
oob15:
call void () @throw_oob()
br label %continue16
continue16:
%87 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%88 =  load i1* , i1** %87
%89 = getelementptr i1 ,i1* %88, i32 %83
%90 = load i1 , i1 *%81
store i1 %90 , i1* %89
%91 = alloca i1
store i1 0, i1* %91
%92 = alloca i32
store i32 8, i32* %92
%93 = load i32,i32* %92
%94 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%95 =  load i32 ,i32* %94
%96 = icmp slt i32 %93, %95
br i1 %96,label %continue18, label %oob17
oob17:
call void () @throw_oob()
br label %continue18
continue18:
%97 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%98 =  load i1* , i1** %97
%99 = getelementptr i1 ,i1* %98, i32 %93
%100 = load i1 , i1 *%91
store i1 %100 , i1* %99
br label %loopstart19
loopstart19:
%101 = load i32,i32* %i
%102 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%103 =  load i32 ,i32* %102
%104 = icmp slt i32 %101, %103
br i1 %104,label %continue23, label %oob22
oob22:
call void () @throw_oob()
br label %continue23
continue23:
%105 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 1
%106 = load i1*,i1**%105
%107 = getelementptr i1 ,i1* %106, i32 %101
%108 = load i1,i1* %107
br i1 %108, label %loop20, label %endloop21
loop20:
%109 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %array, i32 0,i32 0
%110 = load i32 , i32* %109
call void @print_int(i32 %110)
%111 = alloca i32
store i32 1, i32* %111
%112= load i32, i32* %i
%113= load i32, i32* %111
%114 = add i32 %112, %113
%115 = alloca i32
store i32 %114, i32* %115
%116= load i32, i32* %115
store i32 %116 , i32* %i
br label %loopstart19
endloop21:
ret i32 0 
}
