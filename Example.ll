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
%size = alloca i32
%index = alloca i32
%sum = alloca i32
%int_array = alloca %.IntArrayType
%int_array_ref = alloca %.IntArrayType
%boolean_array = alloca %.BooleanArrayType
%flag = alloca i1
%1 = alloca i32
store i32 1024, i32* %1
%2= load i32, i32* %1
store i32 %2 , i32* %size
%3 = alloca i32
store i32 1, i32* %3
%4= load i32, i32* %size
%5= load i32, i32* %3
%6 = add i32 %4, %5
%7 = alloca i32
store i32 %6, i32* %7
%8 = alloca i32
store i32 1, i32* %8
%9= load i32, i32* %7
%10= load i32, i32* %8
%11 = sub i32 %9, %10
%12 = alloca i32
store i32 %11, i32* %12
%13 = alloca %.IntArrayType
%14 = load i32 ,i32* %12
%15 = call i8* @calloc(i32 32 , i32 %14)
%16 = bitcast i8* %15 to i32*
%17 = getelementptr %.IntArrayType,%.IntArrayType* %13,i32 0,i32 1
%18 = getelementptr %.IntArrayType,%.IntArrayType* %13,i32 0,i32 0
store i32 %14,i32* %18
store i32* %16, i32** %17
%19= load %.IntArrayType, %.IntArrayType* %13
store %.IntArrayType %19 , %.IntArrayType* %int_array
%20 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 0
%21 = load i32, i32* %20
%22 = load i32, i32* %size
%23 = icmp slt i32 %21, %22
%24 = alloca i1
store i1 %23, i1* %24
%25 = load i1,i1* %24
br i1 %25, label %setfalse2, label %settrue1
settrue1:
store i1 1, i1* %24
br label %continue3
setfalse2:
store i1 0, i1* %24
br label %continue3
continue3:
%26 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 0
%27 = load i32, i32* %size
%28 = load i32, i32* %26
%29 = icmp slt i32 %27, %28
%30 = alloca i1
store i1 %29, i1* %30
%31 = load i1,i1* %30
br i1 %31, label %setfalse5, label %settrue4
settrue4:
store i1 1, i1* %30
br label %continue6
setfalse5:
store i1 0, i1* %30
br label %continue6
continue6:
%32 = load i1,i1* %24
%33 = load i1,i1* %30
br i1 %32 , label %expr1_true7,label %expr1_false9
expr1_true7:
br i1 %33 , label %expr2_true8,label %expr2_false10
expr2_true8:
br label %endAnd11
expr1_false9:
br label %endAnd11
expr2_false10:
br label %endAnd11
endAnd11:
%34 = phi i1 [1, %expr2_true8] , [0, %expr1_false9] , [0, %expr2_false10]
%35 = alloca i1
store i1 %34 , i1* %35
%36 = load i1,i1* %35
br i1 %36, label %if12, label %else13
if12:
%37 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 0
%38 = load i32 , i32* %37
call void @print_int(i32 %38)
br label %endif14
else13:
%39 = alloca i32
store i32 2020, i32* %39
%40 = load i32 , i32* %39
call void @print_int(i32 %40)
br label %endif14
endif14:
%41 = alloca i32
store i32 1, i32* %41
%42= load i32, i32* %size
%43= load i32, i32* %41
%44 = add i32 %42, %43
%45 = alloca i32
store i32 %44, i32* %45
%46 = alloca i32
store i32 1, i32* %46
%47= load i32, i32* %45
%48= load i32, i32* %46
%49 = sub i32 %47, %48
%50 = alloca i32
store i32 %49, i32* %50
%51 = alloca %.BooleanArrayType
%52 = load i32 ,i32* %50
%53 = call i8* @calloc(i32 32 , i32 %52)
%54 = bitcast i8* %53 to i1*
%55 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %51,i32 0,i32 1
%56 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %51,i32 0,i32 0
store i32 %52,i32* %56
store i1* %54, i1** %55
%57= load %.BooleanArrayType, %.BooleanArrayType* %51
store %.BooleanArrayType %57 , %.BooleanArrayType* %boolean_array
%58 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%59 = load i32, i32* %58
%60 = load i32, i32* %size
%61 = icmp slt i32 %59, %60
%62 = alloca i1
store i1 %61, i1* %62
%63 = load i1,i1* %62
br i1 %63, label %setfalse16, label %settrue15
settrue15:
store i1 1, i1* %62
br label %continue17
setfalse16:
store i1 0, i1* %62
br label %continue17
continue17:
%64 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%65 = load i32, i32* %size
%66 = load i32, i32* %64
%67 = icmp slt i32 %65, %66
%68 = alloca i1
store i1 %67, i1* %68
%69 = load i1,i1* %68
br i1 %69, label %setfalse19, label %settrue18
settrue18:
store i1 1, i1* %68
br label %continue20
setfalse19:
store i1 0, i1* %68
br label %continue20
continue20:
%70 = load i1,i1* %62
%71 = load i1,i1* %68
br i1 %70 , label %expr1_true21,label %expr1_false23
expr1_true21:
br i1 %71 , label %expr2_true22,label %expr2_false24
expr2_true22:
br label %endAnd25
expr1_false23:
br label %endAnd25
expr2_false24:
br label %endAnd25
endAnd25:
%72 = phi i1 [1, %expr2_true22] , [0, %expr1_false23] , [0, %expr2_false24]
%73 = alloca i1
store i1 %72 , i1* %73
%74 = load i1,i1* %73
br i1 %74, label %if26, label %else27
if26:
%75 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%76 = load i32 , i32* %75
call void @print_int(i32 %76)
br label %endif28
else27:
%77 = alloca i32
store i32 2020, i32* %77
%78 = load i32 , i32* %77
call void @print_int(i32 %78)
br label %endif28
endif28:
%79 = alloca i32
store i32 0, i32* %79
%80= load i32, i32* %79
store i32 %80 , i32* %index
br label %loopstart29
loopstart29:
%81 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 0
%82 = load i32, i32* %index
%83 = load i32, i32* %81
%84 = icmp slt i32 %82, %83
%85 = alloca i1
store i1 %84, i1* %85
%86 = load i1,i1* %85
br i1 %86, label %loop30, label %endloop31
loop30:
%87 = alloca i32
store i32 2, i32* %87
%88 = load i32, i32* %index
%89 = load i32, i32* %87
%90 = mul i32 %88, %89
%91 = alloca i32
store i32 %90, i32* %91
%92 = load i32,i32* %index
%93 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 0
%94 =  load i32 ,i32* %93
%95 = icmp slt i32 %92, %94
br i1 %95,label %continue33, label %oob32
oob32:
call void () @throw_oob()
br label %continue33
continue33:
%96 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 1
%97 =  load i32* , i32** %96
%98 = getelementptr i32 ,i32* %97, i32 %92
%99 = load i32 , i32 *%91
store i32 %99 , i32* %98
%100 = alloca i32
store i32 1, i32* %100
%101= load i32, i32* %index
%102= load i32, i32* %100
%103 = add i32 %101, %102
%104 = alloca i32
store i32 %103, i32* %104
%105= load i32, i32* %104
store i32 %105 , i32* %index
br label %loopstart29
endloop31:
%106 = alloca i32
store i32 0, i32* %106
%107= load i32, i32* %106
store i32 %107 , i32* %index
%108= load %.IntArrayType, %.IntArrayType* %int_array
store %.IntArrayType %108 , %.IntArrayType* %int_array_ref
%109 = alloca i32
store i32 0, i32* %109
%110= load i32, i32* %109
store i32 %110 , i32* %sum
br label %loopstart34
loopstart34:
%111 = getelementptr %.IntArrayType,%.IntArrayType* %int_array_ref, i32 0,i32 0
%112 = load i32, i32* %index
%113 = load i32, i32* %111
%114 = icmp slt i32 %112, %113
%115 = alloca i1
store i1 %114, i1* %115
%116 = load i1,i1* %115
br i1 %116, label %loop35, label %endloop36
loop35:
%117 = load i32,i32* %index
%118 = getelementptr %.IntArrayType,%.IntArrayType* %int_array_ref, i32 0,i32 0
%119 =  load i32 ,i32* %118
%120 = icmp slt i32 %117, %119
br i1 %120,label %continue38, label %oob37
oob37:
call void () @throw_oob()
br label %continue38
continue38:
%121 = getelementptr %.IntArrayType,%.IntArrayType* %int_array_ref, i32 0,i32 1
%122 = load i32*,i32**%121
%123 = getelementptr i32 ,i32* %122, i32 %117
%124= load i32, i32* %123
%125= load i32, i32* %sum
%126 = add i32 %124, %125
%127 = alloca i32
store i32 %126, i32* %127
%128= load i32, i32* %127
store i32 %128 , i32* %sum
%129 = alloca i32
store i32 1, i32* %129
%130= load i32, i32* %index
%131= load i32, i32* %129
%132 = add i32 %130, %131
%133 = alloca i32
store i32 %132, i32* %133
%134= load i32, i32* %133
store i32 %134 , i32* %index
br label %loopstart34
endloop36:
%135 = load i32 , i32* %sum
call void @print_int(i32 %135)
%136 = alloca i32
store i32 0, i32* %136
%137= load i32, i32* %136
store i32 %137 , i32* %index
%138 = alloca i1
store i1 1, i1* %138
%139= load i1, i1* %138
store i1 %139 , i1* %flag
br label %loopstart39
loopstart39:
%140 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%141 = load i32, i32* %index
%142 = load i32, i32* %140
%143 = icmp slt i32 %141, %142
%144 = alloca i1
store i1 %143, i1* %144
%145 = load i1,i1* %144
br i1 %145, label %loop40, label %endloop41
loop40:
%146 = load i32,i32* %index
%147 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%148 =  load i32 ,i32* %147
%149 = icmp slt i32 %146, %148
br i1 %149,label %continue43, label %oob42
oob42:
call void () @throw_oob()
br label %continue43
continue43:
%150 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 1
%151 =  load i1* , i1** %150
%152 = getelementptr i1 ,i1* %151, i32 %146
%153 = load i1 , i1 *%flag
store i1 %153 , i1* %152
%154 = load i1,i1* %flag
br i1 %154, label %setfalse45, label %settrue44
settrue44:
store i1 1, i1* %flag
br label %continue46
setfalse45:
store i1 0, i1* %flag
br label %continue46
continue46:
%155= load i1, i1* %flag
store i1 %155 , i1* %flag
%156 = alloca i32
store i32 1, i32* %156
%157= load i32, i32* %index
%158= load i32, i32* %156
%159 = add i32 %157, %158
%160 = alloca i32
store i32 %159, i32* %160
%161= load i32, i32* %160
store i32 %161 , i32* %index
br label %loopstart39
endloop41:
%162 = alloca i32
store i32 0, i32* %162
%163= load i32, i32* %162
store i32 %163 , i32* %index
%164 = alloca i32
store i32 0, i32* %164
%165= load i32, i32* %164
store i32 %165 , i32* %sum
br label %loopstart47
loopstart47:
%166 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%167 = load i32, i32* %index
%168 = load i32, i32* %166
%169 = icmp slt i32 %167, %168
%170 = alloca i1
store i1 %169, i1* %170
%171 = load i1,i1* %170
br i1 %171, label %loop48, label %endloop49
loop48:
%172 = load i32,i32* %index
%173 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%174 =  load i32 ,i32* %173
%175 = icmp slt i32 %172, %174
br i1 %175,label %continue51, label %oob50
oob50:
call void () @throw_oob()
br label %continue51
continue51:
%176 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 1
%177 = load i1*,i1**%176
%178 = getelementptr i1 ,i1* %177, i32 %172
%179 = load i1,i1* %178
br i1 %179, label %if52, label %else53
if52:
%180 = alloca i32
store i32 1, i32* %180
%181= load i32, i32* %sum
%182= load i32, i32* %180
%183 = add i32 %181, %182
%184 = alloca i32
store i32 %183, i32* %184
%185= load i32, i32* %184
store i32 %185 , i32* %sum
br label %endif54
else53:
%186 = alloca i32
store i32 10, i32* %186
%187= load i32, i32* %sum
%188= load i32, i32* %186
%189 = add i32 %187, %188
%190 = alloca i32
store i32 %189, i32* %190
%191= load i32, i32* %190
store i32 %191 , i32* %sum
br label %endif54
endif54:
%192 = alloca i32
store i32 1, i32* %192
%193= load i32, i32* %index
%194= load i32, i32* %192
%195 = add i32 %193, %194
%196 = alloca i32
store i32 %195, i32* %196
%197= load i32, i32* %196
store i32 %197 , i32* %index
br label %loopstart47
endloop49:
%198 = load i32 , i32* %sum
call void @print_int(i32 %198)
ret i32 0 
}
