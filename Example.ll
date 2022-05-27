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
%class.Receiver = type { i8*}
@.Receiver_vtable = global [8x i8*] [i8* bitcast (i1 (i8*,%class.A )* @Receiver.A to i8*),
i8* bitcast (i1 (i8*,%class.B )* @Receiver.B to i8*),
i8* bitcast (i1 (i8*,%class.C )* @Receiver.C to i8*),
i8* bitcast (i1 (i8*,%class.D )* @Receiver.D to i8*),
i8* bitcast (%class.A(i8*)* @Receiver.alloc_B_for_A to i8*),
i8* bitcast (%class.A(i8*)* @Receiver.alloc_C_for_A to i8*),
i8* bitcast (%class.A(i8*)* @Receiver.alloc_D_for_A to i8*),
i8* bitcast (%class.B(i8*)* @Receiver.alloc_D_for_B to i8*)]

%class.A = type { i8*}
@.A_vtable = global [3x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*),
i8* bitcast (i32 (i8*)* @A.bar to i8*),
i8* bitcast (i32 (i8*)* @A.test to i8*)]

%class.B = type { i8*}
@.B_vtable = global [5x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*),
i8* bitcast (i32 (i8*)* @B.bar to i8*),
i8* bitcast (i32 (i8*)* @A.test to i8*),
i8* bitcast (i32 (i8*)* @B.not_overriden to i8*),
i8* bitcast (i32 (i8*)* @B.another to i8*)]

%class.C = type { i8*}
@.C_vtable = global [3x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*),
i8* bitcast (i32 (i8*)* @C.bar to i8*),
i8* bitcast (i32 (i8*)* @A.test to i8*)]

%class.D = type { i8*}
@.D_vtable = global [6x i8*] [i8* bitcast (i32 (i8*)* @A.foo to i8*),
i8* bitcast (i32 (i8*)* @D.bar to i8*),
i8* bitcast (i32 (i8*)* @A.test to i8*),
i8* bitcast (i32 (i8*)* @B.not_overriden to i8*),
i8* bitcast (i32 (i8*)* @D.another to i8*),
i8* bitcast (i32 (i8*)* @D.stef to i8*)]

define i32 @main(){
%dummy = alloca i1
%a = alloca %class.A
%b = alloca %class.B
%c = alloca %class.C
%d = alloca %class.D
%separator = alloca i32
%cls_separator = alloca i32
%1 = alloca i32
store i32 1111111111, i32* %1
%2= load i32, i32* %1
store i32 %2 , i32* %separator
%3 = alloca i32
store i32 333333333, i32* %3
%4= load i32, i32* %3
store i32 %4 , i32* %cls_separator
%5 = call i8* @calloc(i32 1,i32 8)
%6 = bitcast i8* %5 to %class.A*
%7 = getelementptr inbounds %class.A, %class.A* %6, i32 0, i32 0
%8 = bitcast i8** %7 to [3 x i8*]**
store [3 x i8*]* @.A_vtable, [3 x i8*]** %8
%9 = call i8* @calloc(i32 1,i32 8)
%10 = bitcast i8* %9 to %class.Receiver*
%11 = getelementptr inbounds %class.Receiver, %class.Receiver* %10, i32 0, i32 0
%12 = bitcast i8** %11 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %12
%13 = getelementptr inbounds %class.Receiver, %class.Receiver* %10, i32 0, i32 0
%14 = load i8* , i8** %13
%15 = bitcast i8* %14 to [8 x i8*]*
%16 = getelementptr [8 x i8*], [8 x i8*]* %15, i32 0 , i32 0
%17 = load i8* , i8** %16
%18 = bitcast i8* %17 to i1(i8* ,%class.A)*
%19 = load %class.A,%class.A* %6
%20 = bitcast %class.Receiver* %10 to i8*
%21 = call i1 %18(i8* %20,%class.A %19)
%22 = alloca i1
store i1 %21, i1* %22
%23= load i1, i1* %22
store i1 %23 , i1* %dummy
%24 = load i32 , i32* %separator
call void @print_int(i32 %24)
%25 = call i8* @calloc(i32 1,i32 8)
%26 = bitcast i8* %25 to %class.Receiver*
%27 = getelementptr inbounds %class.Receiver, %class.Receiver* %26, i32 0, i32 0
%28 = bitcast i8** %27 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %28
%29 = getelementptr inbounds %class.Receiver, %class.Receiver* %26, i32 0, i32 0
%30 = load i8* , i8** %29
%31 = bitcast i8* %30 to [8 x i8*]*
%32 = getelementptr [8 x i8*], [8 x i8*]* %31, i32 0 , i32 4
%33 = load i8* , i8** %32
%34 = bitcast i8* %33 to %class.A(i8* )*
%35 = bitcast %class.Receiver* %26 to i8*
%36 = call %class.A %34(i8* %35)
%37 = alloca %class.A
store %class.A %36, %class.A* %37
%38 = call i8* @calloc(i32 1,i32 8)
%39 = bitcast i8* %38 to %class.Receiver*
%40 = getelementptr inbounds %class.Receiver, %class.Receiver* %39, i32 0, i32 0
%41 = bitcast i8** %40 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %41
%42 = getelementptr inbounds %class.Receiver, %class.Receiver* %39, i32 0, i32 0
%43 = load i8* , i8** %42
%44 = bitcast i8* %43 to [8 x i8*]*
%45 = getelementptr [8 x i8*], [8 x i8*]* %44, i32 0 , i32 0
%46 = load i8* , i8** %45
%47 = bitcast i8* %46 to i1(i8* ,%class.A)*
%48 = load %class.A,%class.A* %37
%49 = bitcast %class.Receiver* %39 to i8*
%50 = call i1 %47(i8* %49,%class.A %48)
%51 = alloca i1
store i1 %50, i1* %51
%52= load i1, i1* %51
store i1 %52 , i1* %dummy
%53 = load i32 , i32* %separator
call void @print_int(i32 %53)
%54 = call i8* @calloc(i32 1,i32 8)
%55 = bitcast i8* %54 to %class.Receiver*
%56 = getelementptr inbounds %class.Receiver, %class.Receiver* %55, i32 0, i32 0
%57 = bitcast i8** %56 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %57
%58 = getelementptr inbounds %class.Receiver, %class.Receiver* %55, i32 0, i32 0
%59 = load i8* , i8** %58
%60 = bitcast i8* %59 to [8 x i8*]*
%61 = getelementptr [8 x i8*], [8 x i8*]* %60, i32 0 , i32 5
%62 = load i8* , i8** %61
%63 = bitcast i8* %62 to %class.A(i8* )*
%64 = bitcast %class.Receiver* %55 to i8*
%65 = call %class.A %63(i8* %64)
%66 = alloca %class.A
store %class.A %65, %class.A* %66
%67 = call i8* @calloc(i32 1,i32 8)
%68 = bitcast i8* %67 to %class.Receiver*
%69 = getelementptr inbounds %class.Receiver, %class.Receiver* %68, i32 0, i32 0
%70 = bitcast i8** %69 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %70
%71 = getelementptr inbounds %class.Receiver, %class.Receiver* %68, i32 0, i32 0
%72 = load i8* , i8** %71
%73 = bitcast i8* %72 to [8 x i8*]*
%74 = getelementptr [8 x i8*], [8 x i8*]* %73, i32 0 , i32 0
%75 = load i8* , i8** %74
%76 = bitcast i8* %75 to i1(i8* ,%class.A)*
%77 = load %class.A,%class.A* %66
%78 = bitcast %class.Receiver* %68 to i8*
%79 = call i1 %76(i8* %78,%class.A %77)
%80 = alloca i1
store i1 %79, i1* %80
%81= load i1, i1* %80
store i1 %81 , i1* %dummy
%82 = load i32 , i32* %separator
call void @print_int(i32 %82)
%83 = call i8* @calloc(i32 1,i32 8)
%84 = bitcast i8* %83 to %class.Receiver*
%85 = getelementptr inbounds %class.Receiver, %class.Receiver* %84, i32 0, i32 0
%86 = bitcast i8** %85 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %86
%87 = getelementptr inbounds %class.Receiver, %class.Receiver* %84, i32 0, i32 0
%88 = load i8* , i8** %87
%89 = bitcast i8* %88 to [8 x i8*]*
%90 = getelementptr [8 x i8*], [8 x i8*]* %89, i32 0 , i32 6
%91 = load i8* , i8** %90
%92 = bitcast i8* %91 to %class.A(i8* )*
%93 = bitcast %class.Receiver* %84 to i8*
%94 = call %class.A %92(i8* %93)
%95 = alloca %class.A
store %class.A %94, %class.A* %95
%96 = call i8* @calloc(i32 1,i32 8)
%97 = bitcast i8* %96 to %class.Receiver*
%98 = getelementptr inbounds %class.Receiver, %class.Receiver* %97, i32 0, i32 0
%99 = bitcast i8** %98 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %99
%100 = getelementptr inbounds %class.Receiver, %class.Receiver* %97, i32 0, i32 0
%101 = load i8* , i8** %100
%102 = bitcast i8* %101 to [8 x i8*]*
%103 = getelementptr [8 x i8*], [8 x i8*]* %102, i32 0 , i32 0
%104 = load i8* , i8** %103
%105 = bitcast i8* %104 to i1(i8* ,%class.A)*
%106 = load %class.A,%class.A* %95
%107 = bitcast %class.Receiver* %97 to i8*
%108 = call i1 %105(i8* %107,%class.A %106)
%109 = alloca i1
store i1 %108, i1* %109
%110= load i1, i1* %109
store i1 %110 , i1* %dummy
%111 = load i32 , i32* %cls_separator
call void @print_int(i32 %111)
%112 = call i8* @calloc(i32 1,i32 8)
%113 = bitcast i8* %112 to %class.B*
%114 = getelementptr inbounds %class.B, %class.B* %113, i32 0, i32 0
%115 = bitcast i8** %114 to [5 x i8*]**
store [5 x i8*]* @.B_vtable, [5 x i8*]** %115
%116 = call i8* @calloc(i32 1,i32 8)
%117 = bitcast i8* %116 to %class.Receiver*
%118 = getelementptr inbounds %class.Receiver, %class.Receiver* %117, i32 0, i32 0
%119 = bitcast i8** %118 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %119
%120 = getelementptr inbounds %class.Receiver, %class.Receiver* %117, i32 0, i32 0
%121 = load i8* , i8** %120
%122 = bitcast i8* %121 to [8 x i8*]*
%123 = getelementptr [8 x i8*], [8 x i8*]* %122, i32 0 , i32 1
%124 = load i8* , i8** %123
%125 = bitcast i8* %124 to i1(i8* ,%class.B)*
%126 = load %class.B,%class.B* %113
%127 = bitcast %class.Receiver* %117 to i8*
%128 = call i1 %125(i8* %127,%class.B %126)
%129 = alloca i1
store i1 %128, i1* %129
%130= load i1, i1* %129
store i1 %130 , i1* %dummy
%131 = load i32 , i32* %separator
call void @print_int(i32 %131)
%132 = call i8* @calloc(i32 1,i32 8)
%133 = bitcast i8* %132 to %class.Receiver*
%134 = getelementptr inbounds %class.Receiver, %class.Receiver* %133, i32 0, i32 0
%135 = bitcast i8** %134 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %135
%136 = getelementptr inbounds %class.Receiver, %class.Receiver* %133, i32 0, i32 0
%137 = load i8* , i8** %136
%138 = bitcast i8* %137 to [8 x i8*]*
%139 = getelementptr [8 x i8*], [8 x i8*]* %138, i32 0 , i32 7
%140 = load i8* , i8** %139
%141 = bitcast i8* %140 to %class.B(i8* )*
%142 = bitcast %class.Receiver* %133 to i8*
%143 = call %class.B %141(i8* %142)
%144 = alloca %class.B
store %class.B %143, %class.B* %144
%145 = call i8* @calloc(i32 1,i32 8)
%146 = bitcast i8* %145 to %class.Receiver*
%147 = getelementptr inbounds %class.Receiver, %class.Receiver* %146, i32 0, i32 0
%148 = bitcast i8** %147 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %148
%149 = getelementptr inbounds %class.Receiver, %class.Receiver* %146, i32 0, i32 0
%150 = load i8* , i8** %149
%151 = bitcast i8* %150 to [8 x i8*]*
%152 = getelementptr [8 x i8*], [8 x i8*]* %151, i32 0 , i32 1
%153 = load i8* , i8** %152
%154 = bitcast i8* %153 to i1(i8* ,%class.B)*
%155 = load %class.B,%class.B* %144
%156 = bitcast %class.Receiver* %146 to i8*
%157 = call i1 %154(i8* %156,%class.B %155)
%158 = alloca i1
store i1 %157, i1* %158
%159= load i1, i1* %158
store i1 %159 , i1* %dummy
%160 = load i32 , i32* %cls_separator
call void @print_int(i32 %160)
%161 = call i8* @calloc(i32 1,i32 8)
%162 = bitcast i8* %161 to %class.C*
%163 = getelementptr inbounds %class.C, %class.C* %162, i32 0, i32 0
%164 = bitcast i8** %163 to [3 x i8*]**
store [3 x i8*]* @.C_vtable, [3 x i8*]** %164
%165 = call i8* @calloc(i32 1,i32 8)
%166 = bitcast i8* %165 to %class.Receiver*
%167 = getelementptr inbounds %class.Receiver, %class.Receiver* %166, i32 0, i32 0
%168 = bitcast i8** %167 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %168
%169 = getelementptr inbounds %class.Receiver, %class.Receiver* %166, i32 0, i32 0
%170 = load i8* , i8** %169
%171 = bitcast i8* %170 to [8 x i8*]*
%172 = getelementptr [8 x i8*], [8 x i8*]* %171, i32 0 , i32 2
%173 = load i8* , i8** %172
%174 = bitcast i8* %173 to i1(i8* ,%class.C)*
%175 = load %class.C,%class.C* %162
%176 = bitcast %class.Receiver* %166 to i8*
%177 = call i1 %174(i8* %176,%class.C %175)
%178 = alloca i1
store i1 %177, i1* %178
%179= load i1, i1* %178
store i1 %179 , i1* %dummy
%180 = load i32 , i32* %cls_separator
call void @print_int(i32 %180)
%181 = call i8* @calloc(i32 1,i32 8)
%182 = bitcast i8* %181 to %class.D*
%183 = getelementptr inbounds %class.D, %class.D* %182, i32 0, i32 0
%184 = bitcast i8** %183 to [6 x i8*]**
store [6 x i8*]* @.D_vtable, [6 x i8*]** %184
%185 = call i8* @calloc(i32 1,i32 8)
%186 = bitcast i8* %185 to %class.Receiver*
%187 = getelementptr inbounds %class.Receiver, %class.Receiver* %186, i32 0, i32 0
%188 = bitcast i8** %187 to [8 x i8*]**
store [8 x i8*]* @.Receiver_vtable, [8 x i8*]** %188
%189 = getelementptr inbounds %class.Receiver, %class.Receiver* %186, i32 0, i32 0
%190 = load i8* , i8** %189
%191 = bitcast i8* %190 to [8 x i8*]*
%192 = getelementptr [8 x i8*], [8 x i8*]* %191, i32 0 , i32 3
%193 = load i8* , i8** %192
%194 = bitcast i8* %193 to i1(i8* ,%class.D)*
%195 = load %class.D,%class.D* %182
%196 = bitcast %class.Receiver* %186 to i8*
%197 = call i1 %194(i8* %196,%class.D %195)
%198 = alloca i1
store i1 %197, i1* %198
%199= load i1, i1* %198
store i1 %199 , i1* %dummy
ret i32 0 
}
define i1 @Receiver.A(i8* %this,%class.A %a.arg){
%a = alloca %class.A
store %class.A %a.arg ,%class.A* %a
%1 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%2 = load i8* , i8** %1
%3 = bitcast i8* %2 to [3 x i8*]*
%4 = getelementptr [3 x i8*], [3 x i8*]* %3, i32 0 , i32 0
%5 = load i8* , i8** %4
%6 = bitcast i8* %5 to i32(i8* )*
%7 = bitcast %class.A* %a to i8*
%8 = call i32 %6(i8* %7)
%9 = alloca i32
store i32 %8, i32* %9
%10 = load i32 , i32* %9
call void @print_int(i32 %10)
%11 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%12 = load i8* , i8** %11
%13 = bitcast i8* %12 to [3 x i8*]*
%14 = getelementptr [3 x i8*], [3 x i8*]* %13, i32 0 , i32 1
%15 = load i8* , i8** %14
%16 = bitcast i8* %15 to i32(i8* )*
%17 = bitcast %class.A* %a to i8*
%18 = call i32 %16(i8* %17)
%19 = alloca i32
store i32 %18, i32* %19
%20 = load i32 , i32* %19
call void @print_int(i32 %20)
%21 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%22 = load i8* , i8** %21
%23 = bitcast i8* %22 to [3 x i8*]*
%24 = getelementptr [3 x i8*], [3 x i8*]* %23, i32 0 , i32 2
%25 = load i8* , i8** %24
%26 = bitcast i8* %25 to i32(i8* )*
%27 = bitcast %class.A* %a to i8*
%28 = call i32 %26(i8* %27)
%29 = alloca i32
store i32 %28, i32* %29
%30 = load i32 , i32* %29
call void @print_int(i32 %30)
%31 = alloca i1
store i1 1, i1* %31
%32= load i1, i1* %31
ret i1 %32
}
define i1 @Receiver.B(i8* %this,%class.B %b.arg){
%b = alloca %class.B
store %class.B %b.arg ,%class.B* %b
%1 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%2 = load i8* , i8** %1
%3 = bitcast i8* %2 to [5 x i8*]*
%4 = getelementptr [5 x i8*], [5 x i8*]* %3, i32 0 , i32 0
%5 = load i8* , i8** %4
%6 = bitcast i8* %5 to i32(i8* )*
%7 = bitcast %class.B* %b to i8*
%8 = call i32 %6(i8* %7)
%9 = alloca i32
store i32 %8, i32* %9
%10 = load i32 , i32* %9
call void @print_int(i32 %10)
%11 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%12 = load i8* , i8** %11
%13 = bitcast i8* %12 to [5 x i8*]*
%14 = getelementptr [5 x i8*], [5 x i8*]* %13, i32 0 , i32 1
%15 = load i8* , i8** %14
%16 = bitcast i8* %15 to i32(i8* )*
%17 = bitcast %class.B* %b to i8*
%18 = call i32 %16(i8* %17)
%19 = alloca i32
store i32 %18, i32* %19
%20 = load i32 , i32* %19
call void @print_int(i32 %20)
%21 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%22 = load i8* , i8** %21
%23 = bitcast i8* %22 to [5 x i8*]*
%24 = getelementptr [5 x i8*], [5 x i8*]* %23, i32 0 , i32 2
%25 = load i8* , i8** %24
%26 = bitcast i8* %25 to i32(i8* )*
%27 = bitcast %class.B* %b to i8*
%28 = call i32 %26(i8* %27)
%29 = alloca i32
store i32 %28, i32* %29
%30 = load i32 , i32* %29
call void @print_int(i32 %30)
%31 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%32 = load i8* , i8** %31
%33 = bitcast i8* %32 to [5 x i8*]*
%34 = getelementptr [5 x i8*], [5 x i8*]* %33, i32 0 , i32 3
%35 = load i8* , i8** %34
%36 = bitcast i8* %35 to i32(i8* )*
%37 = bitcast %class.B* %b to i8*
%38 = call i32 %36(i8* %37)
%39 = alloca i32
store i32 %38, i32* %39
%40 = load i32 , i32* %39
call void @print_int(i32 %40)
%41 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%42 = load i8* , i8** %41
%43 = bitcast i8* %42 to [5 x i8*]*
%44 = getelementptr [5 x i8*], [5 x i8*]* %43, i32 0 , i32 4
%45 = load i8* , i8** %44
%46 = bitcast i8* %45 to i32(i8* )*
%47 = bitcast %class.B* %b to i8*
%48 = call i32 %46(i8* %47)
%49 = alloca i32
store i32 %48, i32* %49
%50 = load i32 , i32* %49
call void @print_int(i32 %50)
%51 = alloca i1
store i1 1, i1* %51
%52= load i1, i1* %51
ret i1 %52
}
define i1 @Receiver.C(i8* %this,%class.C %c.arg){
%c = alloca %class.C
store %class.C %c.arg ,%class.C* %c
%1 = getelementptr inbounds %class.C, %class.C* %c, i32 0, i32 0
%2 = load i8* , i8** %1
%3 = bitcast i8* %2 to [3 x i8*]*
%4 = getelementptr [3 x i8*], [3 x i8*]* %3, i32 0 , i32 0
%5 = load i8* , i8** %4
%6 = bitcast i8* %5 to i32(i8* )*
%7 = bitcast %class.C* %c to i8*
%8 = call i32 %6(i8* %7)
%9 = alloca i32
store i32 %8, i32* %9
%10 = load i32 , i32* %9
call void @print_int(i32 %10)
%11 = getelementptr inbounds %class.C, %class.C* %c, i32 0, i32 0
%12 = load i8* , i8** %11
%13 = bitcast i8* %12 to [3 x i8*]*
%14 = getelementptr [3 x i8*], [3 x i8*]* %13, i32 0 , i32 1
%15 = load i8* , i8** %14
%16 = bitcast i8* %15 to i32(i8* )*
%17 = bitcast %class.C* %c to i8*
%18 = call i32 %16(i8* %17)
%19 = alloca i32
store i32 %18, i32* %19
%20 = load i32 , i32* %19
call void @print_int(i32 %20)
%21 = getelementptr inbounds %class.C, %class.C* %c, i32 0, i32 0
%22 = load i8* , i8** %21
%23 = bitcast i8* %22 to [3 x i8*]*
%24 = getelementptr [3 x i8*], [3 x i8*]* %23, i32 0 , i32 2
%25 = load i8* , i8** %24
%26 = bitcast i8* %25 to i32(i8* )*
%27 = bitcast %class.C* %c to i8*
%28 = call i32 %26(i8* %27)
%29 = alloca i32
store i32 %28, i32* %29
%30 = load i32 , i32* %29
call void @print_int(i32 %30)
%31 = alloca i1
store i1 1, i1* %31
%32= load i1, i1* %31
ret i1 %32
}
define i1 @Receiver.D(i8* %this,%class.D %d.arg){
%d = alloca %class.D
store %class.D %d.arg ,%class.D* %d
%1 = getelementptr inbounds %class.D, %class.D* %d, i32 0, i32 0
%2 = load i8* , i8** %1
%3 = bitcast i8* %2 to [6 x i8*]*
%4 = getelementptr [6 x i8*], [6 x i8*]* %3, i32 0 , i32 0
%5 = load i8* , i8** %4
%6 = bitcast i8* %5 to i32(i8* )*
%7 = bitcast %class.D* %d to i8*
%8 = call i32 %6(i8* %7)
%9 = alloca i32
store i32 %8, i32* %9
%10 = load i32 , i32* %9
call void @print_int(i32 %10)
%11 = getelementptr inbounds %class.D, %class.D* %d, i32 0, i32 0
%12 = load i8* , i8** %11
%13 = bitcast i8* %12 to [6 x i8*]*
%14 = getelementptr [6 x i8*], [6 x i8*]* %13, i32 0 , i32 1
%15 = load i8* , i8** %14
%16 = bitcast i8* %15 to i32(i8* )*
%17 = bitcast %class.D* %d to i8*
%18 = call i32 %16(i8* %17)
%19 = alloca i32
store i32 %18, i32* %19
%20 = load i32 , i32* %19
call void @print_int(i32 %20)
%21 = getelementptr inbounds %class.D, %class.D* %d, i32 0, i32 0
%22 = load i8* , i8** %21
%23 = bitcast i8* %22 to [6 x i8*]*
%24 = getelementptr [6 x i8*], [6 x i8*]* %23, i32 0 , i32 2
%25 = load i8* , i8** %24
%26 = bitcast i8* %25 to i32(i8* )*
%27 = bitcast %class.D* %d to i8*
%28 = call i32 %26(i8* %27)
%29 = alloca i32
store i32 %28, i32* %29
%30 = load i32 , i32* %29
call void @print_int(i32 %30)
%31 = getelementptr inbounds %class.D, %class.D* %d, i32 0, i32 0
%32 = load i8* , i8** %31
%33 = bitcast i8* %32 to [6 x i8*]*
%34 = getelementptr [6 x i8*], [6 x i8*]* %33, i32 0 , i32 3
%35 = load i8* , i8** %34
%36 = bitcast i8* %35 to i32(i8* )*
%37 = bitcast %class.D* %d to i8*
%38 = call i32 %36(i8* %37)
%39 = alloca i32
store i32 %38, i32* %39
%40 = load i32 , i32* %39
call void @print_int(i32 %40)
%41 = getelementptr inbounds %class.D, %class.D* %d, i32 0, i32 0
%42 = load i8* , i8** %41
%43 = bitcast i8* %42 to [6 x i8*]*
%44 = getelementptr [6 x i8*], [6 x i8*]* %43, i32 0 , i32 4
%45 = load i8* , i8** %44
%46 = bitcast i8* %45 to i32(i8* )*
%47 = bitcast %class.D* %d to i8*
%48 = call i32 %46(i8* %47)
%49 = alloca i32
store i32 %48, i32* %49
%50 = load i32 , i32* %49
call void @print_int(i32 %50)
%51 = getelementptr inbounds %class.D, %class.D* %d, i32 0, i32 0
%52 = load i8* , i8** %51
%53 = bitcast i8* %52 to [6 x i8*]*
%54 = getelementptr [6 x i8*], [6 x i8*]* %53, i32 0 , i32 5
%55 = load i8* , i8** %54
%56 = bitcast i8* %55 to i32(i8* )*
%57 = bitcast %class.D* %d to i8*
%58 = call i32 %56(i8* %57)
%59 = alloca i32
store i32 %58, i32* %59
%60 = load i32 , i32* %59
call void @print_int(i32 %60)
%61 = alloca i1
store i1 1, i1* %61
%62= load i1, i1* %61
ret i1 %62
}
define %class.A @Receiver.alloc_B_for_A(i8* %this){
%1 = call i8* @calloc(i32 1,i32 8)
%2 = bitcast i8* %1 to %class.B*
%3 = getelementptr inbounds %class.B, %class.B* %2, i32 0, i32 0
%4 = bitcast i8** %3 to [5 x i8*]**
store [5 x i8*]* @.B_vtable, [5 x i8*]** %4
%5 = bitcast %class.B* %2 to %class.A* 
%6= load %class.A, %class.A* %5
ret %class.A %6
}
define %class.A @Receiver.alloc_C_for_A(i8* %this){
%1 = call i8* @calloc(i32 1,i32 8)
%2 = bitcast i8* %1 to %class.C*
%3 = getelementptr inbounds %class.C, %class.C* %2, i32 0, i32 0
%4 = bitcast i8** %3 to [3 x i8*]**
store [3 x i8*]* @.C_vtable, [3 x i8*]** %4
%5 = bitcast %class.C* %2 to %class.A* 
%6= load %class.A, %class.A* %5
ret %class.A %6
}
define %class.A @Receiver.alloc_D_for_A(i8* %this){
%1 = call i8* @calloc(i32 1,i32 8)
%2 = bitcast i8* %1 to %class.D*
%3 = getelementptr inbounds %class.D, %class.D* %2, i32 0, i32 0
%4 = bitcast i8** %3 to [6 x i8*]**
store [6 x i8*]* @.D_vtable, [6 x i8*]** %4
%5 = bitcast %class.D* %2 to %class.A* 
%6= load %class.A, %class.A* %5
ret %class.A %6
}
define %class.B @Receiver.alloc_D_for_B(i8* %this){
%1 = call i8* @calloc(i32 1,i32 8)
%2 = bitcast i8* %1 to %class.D*
%3 = getelementptr inbounds %class.D, %class.D* %2, i32 0, i32 0
%4 = bitcast i8** %3 to [6 x i8*]**
store [6 x i8*]* @.D_vtable, [6 x i8*]** %4
%5 = bitcast %class.D* %2 to %class.B* 
%6= load %class.B, %class.B* %5
ret %class.B %6
}
define i32 @A.foo(i8* %this){
%1 = alloca i32
store i32 1, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @A.bar(i8* %this){
%1 = alloca i32
store i32 2, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @A.test(i8* %this){
%1 = alloca i32
store i32 3, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @B.bar(i8* %this){
%1 = alloca i32
store i32 12, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @B.not_overriden(i8* %this){
%1 = alloca i32
store i32 14, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @B.another(i8* %this){
%1 = alloca i32
store i32 15, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @C.bar(i8* %this){
%1 = alloca i32
store i32 22, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @D.bar(i8* %this){
%1 = alloca i32
store i32 32, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @D.another(i8* %this){
%1 = alloca i32
store i32 35, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
define i32 @D.stef(i8* %this){
%1 = alloca i32
store i32 36, i32* %1
%2= load i32, i32* %1
ret i32 %2
}
