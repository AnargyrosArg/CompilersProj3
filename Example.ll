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
@.A_vtable = global [6x i8*] [i8* bitcast (i32 (i8*,i32 )* @A.func_int to i8*),
i8* bitcast (%.IntArrayType (i8*,%.IntArrayType )* @A.func_int_array to i8*),
i8* bitcast (i1 (i8*,i1 )* @A.func_boolean to i8*),
i8* bitcast (%.BooleanArrayType (i8*,%.BooleanArrayType )* @A.func_boolean_array to i8*),
i8* bitcast (i32 (i8*,i32 )* @A.decrease to i8*),
i8* bitcast (i32 (i8*,i32 ,%.IntArrayType ,i1 ,%.BooleanArrayType ,%class.B )* @A.func to i8*)]

%class.B = type { i8* ,i32}
@.B_vtable = global [3x i8*] [i8* bitcast (i32 (i8*)* @B.Init to i8*),
i8* bitcast (i32 (i8*)* @B.Print to i8*),
i8* bitcast (%class.B(i8*,%class.B )* @B.getB to i8*)]

define i32 @main(){
%a = alloca %class.A
%b = alloca %class.B
%int_array = alloca %.IntArrayType
%boolean_array = alloca %.BooleanArrayType
%i = alloca i32
%flag = alloca i1
%1 = call i8* @calloc(i32 1,i32 12)
%2 = bitcast i8* %1 to %class.A*
%3 = getelementptr inbounds %class.A, %class.A* %2, i32 0, i32 0
%4 = bitcast i8** %3 to [6 x i8*]**
store [6 x i8*]* @.A_vtable, [6 x i8*]** %4
%5= load %class.A, %class.A* %2
store %class.A %5 , %class.A* %a
%6 = call i8* @calloc(i32 1,i32 12)
%7 = bitcast i8* %6 to %class.B*
%8 = getelementptr inbounds %class.B, %class.B* %7, i32 0, i32 0
%9 = bitcast i8** %8 to [3 x i8*]**
store [3 x i8*]* @.B_vtable, [3 x i8*]** %9
%10= load %class.B, %class.B* %7
store %class.B %10 , %class.B* %b
%11 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%12 = load i8* , i8** %11
%13 = bitcast i8* %12 to [3 x i8*]*
%14 = getelementptr [3 x i8*], [3 x i8*]* %13, i32 0 , i32 0
%15 = load i8* , i8** %14
%16 = bitcast i8* %15 to i32(i8* )*
%17 = bitcast %class.B* %b to i8*
%18 = call i32 %16(i8* %17)
%19 = alloca i32
store i32 %18, i32* %19
%20= load i32, i32* %19
store i32 %20 , i32* %i
%21 = alloca i32
store i32 1000, i32* %21
%22 = alloca %.IntArrayType
%23 = load i32 ,i32* %21
%24 = call i8* @calloc(i32 32 , i32 %23)
%25 = bitcast i8* %24 to i32*
%26 = getelementptr %.IntArrayType,%.IntArrayType* %22,i32 0,i32 1
%27 = getelementptr %.IntArrayType,%.IntArrayType* %22,i32 0,i32 0
store i32 %23,i32* %27
store i32* %25, i32** %26
%28= load %.IntArrayType, %.IntArrayType* %22
store %.IntArrayType %28 , %.IntArrayType* %int_array
%29 = alloca i32
store i32 1000, i32* %29
%30 = alloca %.BooleanArrayType
%31 = load i32 ,i32* %29
%32 = call i8* @calloc(i32 32 , i32 %31)
%33 = bitcast i8* %32 to i1*
%34 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %30,i32 0,i32 1
%35 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %30,i32 0,i32 0
store i32 %31,i32* %35
store i1* %33, i1** %34
%36= load %.BooleanArrayType, %.BooleanArrayType* %30
store %.BooleanArrayType %36 , %.BooleanArrayType* %boolean_array
%37 = alloca i32
store i32 0, i32* %37
%38= load i32, i32* %37
store i32 %38 , i32* %i
br label %loopstart1
loopstart1:
%39 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 0
%40 = load i32, i32* %i
%41 = load i32, i32* %39
%42 = icmp slt i32 %40, %41
%43 = alloca i1
store i1 %42, i1* %43
%44 = load i1,i1* %43
br i1 %44, label %loop2, label %endloop3
loop2:
%45 = alloca i32
store i32 2, i32* %45
%46 = load i32, i32* %i
%47 = load i32, i32* %45
%48 = mul i32 %46, %47
%49 = alloca i32
store i32 %48, i32* %49
%50 = load i32,i32* %i
%51 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 0
%52 =  load i32 ,i32* %51
%53 = icmp slt i32 %50, %52
br i1 %53,label %continue5, label %oob4
oob4:
call void () @throw_oob()
br label %continue5
continue5:
%54 = getelementptr %.IntArrayType,%.IntArrayType* %int_array, i32 0,i32 1
%55 =  load i32* , i32** %54
%56 = getelementptr i32 ,i32* %55, i32 %50
%57 = load i32 , i32 *%49
store i32 %57 , i32* %56
%58 = alloca i32
store i32 1, i32* %58
%59= load i32, i32* %i
%60= load i32, i32* %58
%61 = add i32 %59, %60
%62 = alloca i32
store i32 %61, i32* %62
%63= load i32, i32* %62
store i32 %63 , i32* %i
br label %loopstart1
endloop3:
%64 = alloca i32
store i32 0, i32* %64
%65= load i32, i32* %64
store i32 %65 , i32* %i
%66 = alloca i1
store i1 1, i1* %66
%67= load i1, i1* %66
store i1 %67 , i1* %flag
br label %loopstart6
loopstart6:
%68 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%69 = load i32, i32* %i
%70 = load i32, i32* %68
%71 = icmp slt i32 %69, %70
%72 = alloca i1
store i1 %71, i1* %72
%73 = load i1,i1* %72
br i1 %73, label %loop7, label %endloop8
loop7:
%74 = load i32,i32* %i
%75 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 0
%76 =  load i32 ,i32* %75
%77 = icmp slt i32 %74, %76
br i1 %77,label %continue10, label %oob9
oob9:
call void () @throw_oob()
br label %continue10
continue10:
%78 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %boolean_array, i32 0,i32 1
%79 =  load i1* , i1** %78
%80 = getelementptr i1 ,i1* %79, i32 %74
%81 = load i1 , i1 *%flag
store i1 %81 , i1* %80
%82 = load i1,i1* %flag
br i1 %82, label %setfalse12, label %settrue11
settrue11:
store i1 1, i1* %flag
br label %continue13
setfalse12:
store i1 0, i1* %flag
br label %continue13
continue13:
%83= load i1, i1* %flag
store i1 %83 , i1* %flag
%84 = alloca i32
store i32 1, i32* %84
%85= load i32, i32* %i
%86= load i32, i32* %84
%87 = add i32 %85, %86
%88 = alloca i32
store i32 %87, i32* %88
%89= load i32, i32* %88
store i32 %89 , i32* %i
br label %loopstart6
endloop8:
%90 = alloca i32
store i32 1024, i32* %90
%91 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%92 = load i8* , i8** %91
%93 = bitcast i8* %92 to [6 x i8*]*
%94 = getelementptr [6 x i8*], [6 x i8*]* %93, i32 0 , i32 0
%95 = load i8* , i8** %94
%96 = bitcast i8* %95 to i32(i8* ,i32)*
%97 = load i32,i32* %90
%98 = bitcast %class.A* %a to i8*
%99 = call i32 %96(i8* %98,i32 %97)
%100 = alloca i32
store i32 %99, i32* %100
%101 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%102 = load i8* , i8** %101
%103 = bitcast i8* %102 to [6 x i8*]*
%104 = getelementptr [6 x i8*], [6 x i8*]* %103, i32 0 , i32 0
%105 = load i8* , i8** %104
%106 = bitcast i8* %105 to i32(i8* ,i32)*
%107 = load i32,i32* %100
%108 = bitcast %class.A* %a to i8*
%109 = call i32 %106(i8* %108,i32 %107)
%110 = alloca i32
store i32 %109, i32* %110
%111 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%112 = load i8* , i8** %111
%113 = bitcast i8* %112 to [6 x i8*]*
%114 = getelementptr [6 x i8*], [6 x i8*]* %113, i32 0 , i32 0
%115 = load i8* , i8** %114
%116 = bitcast i8* %115 to i32(i8* ,i32)*
%117 = load i32,i32* %110
%118 = bitcast %class.A* %a to i8*
%119 = call i32 %116(i8* %118,i32 %117)
%120 = alloca i32
store i32 %119, i32* %120
%121 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%122 = load i8* , i8** %121
%123 = bitcast i8* %122 to [6 x i8*]*
%124 = getelementptr [6 x i8*], [6 x i8*]* %123, i32 0 , i32 0
%125 = load i8* , i8** %124
%126 = bitcast i8* %125 to i32(i8* ,i32)*
%127 = load i32,i32* %120
%128 = bitcast %class.A* %a to i8*
%129 = call i32 %126(i8* %128,i32 %127)
%130 = alloca i32
store i32 %129, i32* %130
%131 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%132 = load i8* , i8** %131
%133 = bitcast i8* %132 to [6 x i8*]*
%134 = getelementptr [6 x i8*], [6 x i8*]* %133, i32 0 , i32 0
%135 = load i8* , i8** %134
%136 = bitcast i8* %135 to i32(i8* ,i32)*
%137 = load i32,i32* %130
%138 = bitcast %class.A* %a to i8*
%139 = call i32 %136(i8* %138,i32 %137)
%140 = alloca i32
store i32 %139, i32* %140
%141 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%142 = load i8* , i8** %141
%143 = bitcast i8* %142 to [6 x i8*]*
%144 = getelementptr [6 x i8*], [6 x i8*]* %143, i32 0 , i32 0
%145 = load i8* , i8** %144
%146 = bitcast i8* %145 to i32(i8* ,i32)*
%147 = load i32,i32* %140
%148 = bitcast %class.A* %a to i8*
%149 = call i32 %146(i8* %148,i32 %147)
%150 = alloca i32
store i32 %149, i32* %150
%151 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%152 = load i8* , i8** %151
%153 = bitcast i8* %152 to [6 x i8*]*
%154 = getelementptr [6 x i8*], [6 x i8*]* %153, i32 0 , i32 0
%155 = load i8* , i8** %154
%156 = bitcast i8* %155 to i32(i8* ,i32)*
%157 = load i32,i32* %150
%158 = bitcast %class.A* %a to i8*
%159 = call i32 %156(i8* %158,i32 %157)
%160 = alloca i32
store i32 %159, i32* %160
%161 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%162 = load i8* , i8** %161
%163 = bitcast i8* %162 to [6 x i8*]*
%164 = getelementptr [6 x i8*], [6 x i8*]* %163, i32 0 , i32 1
%165 = load i8* , i8** %164
%166 = bitcast i8* %165 to %.IntArrayType(i8* ,%.IntArrayType)*
%167 = load %.IntArrayType,%.IntArrayType* %int_array
%168 = bitcast %class.A* %a to i8*
%169 = call %.IntArrayType %166(i8* %168,%.IntArrayType %167)
%170 = alloca %.IntArrayType
store %.IntArrayType %169, %.IntArrayType* %170
%171 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%172 = load i8* , i8** %171
%173 = bitcast i8* %172 to [6 x i8*]*
%174 = getelementptr [6 x i8*], [6 x i8*]* %173, i32 0 , i32 1
%175 = load i8* , i8** %174
%176 = bitcast i8* %175 to %.IntArrayType(i8* ,%.IntArrayType)*
%177 = load %.IntArrayType,%.IntArrayType* %170
%178 = bitcast %class.A* %a to i8*
%179 = call %.IntArrayType %176(i8* %178,%.IntArrayType %177)
%180 = alloca %.IntArrayType
store %.IntArrayType %179, %.IntArrayType* %180
%181 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%182 = load i8* , i8** %181
%183 = bitcast i8* %182 to [6 x i8*]*
%184 = getelementptr [6 x i8*], [6 x i8*]* %183, i32 0 , i32 1
%185 = load i8* , i8** %184
%186 = bitcast i8* %185 to %.IntArrayType(i8* ,%.IntArrayType)*
%187 = load %.IntArrayType,%.IntArrayType* %180
%188 = bitcast %class.A* %a to i8*
%189 = call %.IntArrayType %186(i8* %188,%.IntArrayType %187)
%190 = alloca %.IntArrayType
store %.IntArrayType %189, %.IntArrayType* %190
%191 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%192 = load i8* , i8** %191
%193 = bitcast i8* %192 to [6 x i8*]*
%194 = getelementptr [6 x i8*], [6 x i8*]* %193, i32 0 , i32 1
%195 = load i8* , i8** %194
%196 = bitcast i8* %195 to %.IntArrayType(i8* ,%.IntArrayType)*
%197 = load %.IntArrayType,%.IntArrayType* %190
%198 = bitcast %class.A* %a to i8*
%199 = call %.IntArrayType %196(i8* %198,%.IntArrayType %197)
%200 = alloca %.IntArrayType
store %.IntArrayType %199, %.IntArrayType* %200
%201 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%202 = load i8* , i8** %201
%203 = bitcast i8* %202 to [6 x i8*]*
%204 = getelementptr [6 x i8*], [6 x i8*]* %203, i32 0 , i32 1
%205 = load i8* , i8** %204
%206 = bitcast i8* %205 to %.IntArrayType(i8* ,%.IntArrayType)*
%207 = load %.IntArrayType,%.IntArrayType* %200
%208 = bitcast %class.A* %a to i8*
%209 = call %.IntArrayType %206(i8* %208,%.IntArrayType %207)
%210 = alloca %.IntArrayType
store %.IntArrayType %209, %.IntArrayType* %210
%211 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%212 = load i8* , i8** %211
%213 = bitcast i8* %212 to [6 x i8*]*
%214 = getelementptr [6 x i8*], [6 x i8*]* %213, i32 0 , i32 1
%215 = load i8* , i8** %214
%216 = bitcast i8* %215 to %.IntArrayType(i8* ,%.IntArrayType)*
%217 = load %.IntArrayType,%.IntArrayType* %210
%218 = bitcast %class.A* %a to i8*
%219 = call %.IntArrayType %216(i8* %218,%.IntArrayType %217)
%220 = alloca %.IntArrayType
store %.IntArrayType %219, %.IntArrayType* %220
%221 = alloca i1
store i1 1, i1* %221
%222 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%223 = load i8* , i8** %222
%224 = bitcast i8* %223 to [6 x i8*]*
%225 = getelementptr [6 x i8*], [6 x i8*]* %224, i32 0 , i32 2
%226 = load i8* , i8** %225
%227 = bitcast i8* %226 to i1(i8* ,i1)*
%228 = load i1,i1* %221
%229 = bitcast %class.A* %a to i8*
%230 = call i1 %227(i8* %229,i1 %228)
%231 = alloca i1
store i1 %230, i1* %231
%232 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%233 = load i8* , i8** %232
%234 = bitcast i8* %233 to [6 x i8*]*
%235 = getelementptr [6 x i8*], [6 x i8*]* %234, i32 0 , i32 2
%236 = load i8* , i8** %235
%237 = bitcast i8* %236 to i1(i8* ,i1)*
%238 = load i1,i1* %231
%239 = bitcast %class.A* %a to i8*
%240 = call i1 %237(i8* %239,i1 %238)
%241 = alloca i1
store i1 %240, i1* %241
%242 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%243 = load i8* , i8** %242
%244 = bitcast i8* %243 to [6 x i8*]*
%245 = getelementptr [6 x i8*], [6 x i8*]* %244, i32 0 , i32 2
%246 = load i8* , i8** %245
%247 = bitcast i8* %246 to i1(i8* ,i1)*
%248 = load i1,i1* %241
%249 = bitcast %class.A* %a to i8*
%250 = call i1 %247(i8* %249,i1 %248)
%251 = alloca i1
store i1 %250, i1* %251
%252 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%253 = load i8* , i8** %252
%254 = bitcast i8* %253 to [6 x i8*]*
%255 = getelementptr [6 x i8*], [6 x i8*]* %254, i32 0 , i32 2
%256 = load i8* , i8** %255
%257 = bitcast i8* %256 to i1(i8* ,i1)*
%258 = load i1,i1* %251
%259 = bitcast %class.A* %a to i8*
%260 = call i1 %257(i8* %259,i1 %258)
%261 = alloca i1
store i1 %260, i1* %261
%262 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%263 = load i8* , i8** %262
%264 = bitcast i8* %263 to [6 x i8*]*
%265 = getelementptr [6 x i8*], [6 x i8*]* %264, i32 0 , i32 2
%266 = load i8* , i8** %265
%267 = bitcast i8* %266 to i1(i8* ,i1)*
%268 = load i1,i1* %261
%269 = bitcast %class.A* %a to i8*
%270 = call i1 %267(i8* %269,i1 %268)
%271 = alloca i1
store i1 %270, i1* %271
%272 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%273 = load i8* , i8** %272
%274 = bitcast i8* %273 to [6 x i8*]*
%275 = getelementptr [6 x i8*], [6 x i8*]* %274, i32 0 , i32 2
%276 = load i8* , i8** %275
%277 = bitcast i8* %276 to i1(i8* ,i1)*
%278 = load i1,i1* %271
%279 = bitcast %class.A* %a to i8*
%280 = call i1 %277(i8* %279,i1 %278)
%281 = alloca i1
store i1 %280, i1* %281
%282 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%283 = load i8* , i8** %282
%284 = bitcast i8* %283 to [6 x i8*]*
%285 = getelementptr [6 x i8*], [6 x i8*]* %284, i32 0 , i32 2
%286 = load i8* , i8** %285
%287 = bitcast i8* %286 to i1(i8* ,i1)*
%288 = load i1,i1* %281
%289 = bitcast %class.A* %a to i8*
%290 = call i1 %287(i8* %289,i1 %288)
%291 = alloca i1
store i1 %290, i1* %291
%292 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%293 = load i8* , i8** %292
%294 = bitcast i8* %293 to [6 x i8*]*
%295 = getelementptr [6 x i8*], [6 x i8*]* %294, i32 0 , i32 3
%296 = load i8* , i8** %295
%297 = bitcast i8* %296 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%298 = load %.BooleanArrayType,%.BooleanArrayType* %boolean_array
%299 = bitcast %class.A* %a to i8*
%300 = call %.BooleanArrayType %297(i8* %299,%.BooleanArrayType %298)
%301 = alloca %.BooleanArrayType
store %.BooleanArrayType %300, %.BooleanArrayType* %301
%302 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%303 = load i8* , i8** %302
%304 = bitcast i8* %303 to [6 x i8*]*
%305 = getelementptr [6 x i8*], [6 x i8*]* %304, i32 0 , i32 3
%306 = load i8* , i8** %305
%307 = bitcast i8* %306 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%308 = load %.BooleanArrayType,%.BooleanArrayType* %301
%309 = bitcast %class.A* %a to i8*
%310 = call %.BooleanArrayType %307(i8* %309,%.BooleanArrayType %308)
%311 = alloca %.BooleanArrayType
store %.BooleanArrayType %310, %.BooleanArrayType* %311
%312 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%313 = load i8* , i8** %312
%314 = bitcast i8* %313 to [6 x i8*]*
%315 = getelementptr [6 x i8*], [6 x i8*]* %314, i32 0 , i32 3
%316 = load i8* , i8** %315
%317 = bitcast i8* %316 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%318 = load %.BooleanArrayType,%.BooleanArrayType* %311
%319 = bitcast %class.A* %a to i8*
%320 = call %.BooleanArrayType %317(i8* %319,%.BooleanArrayType %318)
%321 = alloca %.BooleanArrayType
store %.BooleanArrayType %320, %.BooleanArrayType* %321
%322 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%323 = load i8* , i8** %322
%324 = bitcast i8* %323 to [6 x i8*]*
%325 = getelementptr [6 x i8*], [6 x i8*]* %324, i32 0 , i32 3
%326 = load i8* , i8** %325
%327 = bitcast i8* %326 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%328 = load %.BooleanArrayType,%.BooleanArrayType* %321
%329 = bitcast %class.A* %a to i8*
%330 = call %.BooleanArrayType %327(i8* %329,%.BooleanArrayType %328)
%331 = alloca %.BooleanArrayType
store %.BooleanArrayType %330, %.BooleanArrayType* %331
%332 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%333 = load i8* , i8** %332
%334 = bitcast i8* %333 to [6 x i8*]*
%335 = getelementptr [6 x i8*], [6 x i8*]* %334, i32 0 , i32 3
%336 = load i8* , i8** %335
%337 = bitcast i8* %336 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%338 = load %.BooleanArrayType,%.BooleanArrayType* %331
%339 = bitcast %class.A* %a to i8*
%340 = call %.BooleanArrayType %337(i8* %339,%.BooleanArrayType %338)
%341 = alloca %.BooleanArrayType
store %.BooleanArrayType %340, %.BooleanArrayType* %341
%342 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%343 = load i8* , i8** %342
%344 = bitcast i8* %343 to [3 x i8*]*
%345 = getelementptr [3 x i8*], [3 x i8*]* %344, i32 0 , i32 2
%346 = load i8* , i8** %345
%347 = bitcast i8* %346 to %class.B(i8* ,%class.B)*
%348 = load %class.B,%class.B* %b
%349 = bitcast %class.B* %b to i8*
%350 = call %class.B %347(i8* %349,%class.B %348)
%351 = alloca %class.B
store %class.B %350, %class.B* %351
%352 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%353 = load i8* , i8** %352
%354 = bitcast i8* %353 to [3 x i8*]*
%355 = getelementptr [3 x i8*], [3 x i8*]* %354, i32 0 , i32 2
%356 = load i8* , i8** %355
%357 = bitcast i8* %356 to %class.B(i8* ,%class.B)*
%358 = load %class.B,%class.B* %351
%359 = bitcast %class.B* %b to i8*
%360 = call %class.B %357(i8* %359,%class.B %358)
%361 = alloca %class.B
store %class.B %360, %class.B* %361
%362 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%363 = load i8* , i8** %362
%364 = bitcast i8* %363 to [3 x i8*]*
%365 = getelementptr [3 x i8*], [3 x i8*]* %364, i32 0 , i32 2
%366 = load i8* , i8** %365
%367 = bitcast i8* %366 to %class.B(i8* ,%class.B)*
%368 = load %class.B,%class.B* %361
%369 = bitcast %class.B* %b to i8*
%370 = call %class.B %367(i8* %369,%class.B %368)
%371 = alloca %class.B
store %class.B %370, %class.B* %371
%372 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%373 = load i8* , i8** %372
%374 = bitcast i8* %373 to [3 x i8*]*
%375 = getelementptr [3 x i8*], [3 x i8*]* %374, i32 0 , i32 2
%376 = load i8* , i8** %375
%377 = bitcast i8* %376 to %class.B(i8* ,%class.B)*
%378 = load %class.B,%class.B* %371
%379 = bitcast %class.B* %b to i8*
%380 = call %class.B %377(i8* %379,%class.B %378)
%381 = alloca %class.B
store %class.B %380, %class.B* %381
%382 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%383 = load i8* , i8** %382
%384 = bitcast i8* %383 to [3 x i8*]*
%385 = getelementptr [3 x i8*], [3 x i8*]* %384, i32 0 , i32 2
%386 = load i8* , i8** %385
%387 = bitcast i8* %386 to %class.B(i8* ,%class.B)*
%388 = load %class.B,%class.B* %381
%389 = bitcast %class.B* %b to i8*
%390 = call %class.B %387(i8* %389,%class.B %388)
%391 = alloca %class.B
store %class.B %390, %class.B* %391
%392 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%393 = load i8* , i8** %392
%394 = bitcast i8* %393 to [6 x i8*]*
%395 = getelementptr [6 x i8*], [6 x i8*]* %394, i32 0 , i32 5
%396 = load i8* , i8** %395
%397 = bitcast i8* %396 to i32(i8* ,i32,%.IntArrayType,i1,%.BooleanArrayType,%class.B)*
%398 = load i32,i32* %160
%399 = load %.IntArrayType,%.IntArrayType* %220
%400 = load i1,i1* %291
%401 = load %.BooleanArrayType,%.BooleanArrayType* %341
%402 = load %class.B,%class.B* %391
%403 = bitcast %class.A* %a to i8*
%404 = call i32 %397(i8* %403,i32 %398,%.IntArrayType %399,i1 %400,%.BooleanArrayType %401,%class.B %402)
%405 = alloca i32
store i32 %404, i32* %405
%406= load i32, i32* %405
store i32 %406 , i32* %i
ret i32 0 
}
define i32 @A.func_int(i8* %this,i32 %i.arg){
%i = alloca i32
store i32 %i.arg ,i32* %i
%1 = getelementptr i8,i8* %this, i32 8
%2 = bitcast i8* %1 to i32*
%3= load i32, i32* %i
store i32 %3 , i32* %2
%4= load i32, i32* %i
ret i32 %4
}
define %.IntArrayType @A.func_int_array(i8* %this,%.IntArrayType %arr.arg){
%arr = alloca %.IntArrayType
store %.IntArrayType %arr.arg ,%.IntArrayType* %arr
%1= load %.IntArrayType, %.IntArrayType* %arr
ret %.IntArrayType %1
}
define i1 @A.func_boolean(i8* %this,i1 %b.arg){
%b = alloca i1
store i1 %b.arg ,i1* %b
%1= load i1, i1* %b
ret i1 %1
}
define %.BooleanArrayType @A.func_boolean_array(i8* %this,%.BooleanArrayType %arr.arg){
%arr = alloca %.BooleanArrayType
store %.BooleanArrayType %arr.arg ,%.BooleanArrayType* %arr
%1= load %.BooleanArrayType, %.BooleanArrayType* %arr
ret %.BooleanArrayType %1
}
define i32 @A.decrease(i8* %this,i32 %i.arg){
%i = alloca i32
store i32 %i.arg ,i32* %i
%1 = alloca i32
store i32 1, i32* %1
%2= load i32, i32* %i
%3= load i32, i32* %1
%4 = sub i32 %2, %3
%5 = alloca i32
store i32 %4, i32* %5
%6= load i32, i32* %5
store i32 %6 , i32* %i
%7= load i32, i32* %i
ret i32 %7
}
define i32 @A.func(i8* %this,i32 %i.arg,%.IntArrayType %int_arr.arg,i1 %b.arg,%.BooleanArrayType %b_arr.arg,%class.B %c_b.arg){
%i = alloca i32
store i32 %i.arg ,i32* %i
%int_arr = alloca %.IntArrayType
store %.IntArrayType %int_arr.arg ,%.IntArrayType* %int_arr
%b = alloca i1
store i1 %b.arg ,i1* %b
%b_arr = alloca %.BooleanArrayType
store %.BooleanArrayType %b_arr.arg ,%.BooleanArrayType* %b_arr
%c_b = alloca %class.B
store %class.B %c_b.arg ,%class.B* %c_b
%j = alloca i32
%sum = alloca i32
%1 = getelementptr i8,i8* %this, i32 8
%2 = bitcast i8* %1 to i32*
%3 = load i32 , i32* %2
call void @print_int(i32 %3)
%4 = load i32 , i32* %i
call void @print_int(i32 %4)
%5 = getelementptr %.IntArrayType,%.IntArrayType* %int_arr, i32 0,i32 0
%6 = load i32 , i32* %5
call void @print_int(i32 %6)
%7 = alloca i32
store i32 0, i32* %7
%8= load i32, i32* %7
store i32 %8 , i32* %j
%9 = alloca i32
store i32 0, i32* %9
%10= load i32, i32* %9
store i32 %10 , i32* %sum
br label %loopstart14
loopstart14:
%11 = getelementptr %.IntArrayType,%.IntArrayType* %int_arr, i32 0,i32 0
%12 = load i32, i32* %j
%13 = load i32, i32* %11
%14 = icmp slt i32 %12, %13
%15 = alloca i1
store i1 %14, i1* %15
%16 = load i1,i1* %15
br i1 %16, label %loop15, label %endloop16
loop15:
%17 = load i32,i32* %j
%18 = getelementptr %.IntArrayType,%.IntArrayType* %int_arr, i32 0,i32 0
%19 =  load i32 ,i32* %18
%20 = icmp slt i32 %17, %19
br i1 %20,label %continue18, label %oob17
oob17:
call void () @throw_oob()
br label %continue18
continue18:
%21 = getelementptr %.IntArrayType,%.IntArrayType* %int_arr, i32 0,i32 1
%22 = load i32*,i32**%21
%23 = getelementptr i32 ,i32* %22, i32 %17
%24= load i32, i32* %23
%25= load i32, i32* %sum
%26 = add i32 %24, %25
%27 = alloca i32
store i32 %26, i32* %27
%28= load i32, i32* %27
store i32 %28 , i32* %sum
%29 = alloca i32
store i32 1, i32* %29
%30= load i32, i32* %j
%31= load i32, i32* %29
%32 = add i32 %30, %31
%33 = alloca i32
store i32 %32, i32* %33
%34= load i32, i32* %33
store i32 %34 , i32* %j
br label %loopstart14
endloop16:
%35 = load i32 , i32* %sum
call void @print_int(i32 %35)
%36 = load i1,i1* %b
br i1 %36, label %if19, label %else20
if19:
%37 = alloca i32
store i32 1, i32* %37
%38 = load i32 , i32* %37
call void @print_int(i32 %38)
br label %endif21
else20:
%39 = alloca i32
store i32 0, i32* %39
%40 = load i32 , i32* %39
call void @print_int(i32 %40)
br label %endif21
endif21:
%41 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %b_arr, i32 0,i32 0
%42 = load i32 , i32* %41
call void @print_int(i32 %42)
%43 = alloca i32
store i32 0, i32* %43
%44= load i32, i32* %43
store i32 %44 , i32* %j
%45 = alloca i32
store i32 0, i32* %45
%46= load i32, i32* %45
store i32 %46 , i32* %sum
%47 = load i32,i32* %j
%48 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %b_arr, i32 0,i32 0
%49 =  load i32 ,i32* %48
%50 = icmp slt i32 %47, %49
br i1 %50,label %continue23, label %oob22
oob22:
call void () @throw_oob()
br label %continue23
continue23:
%51 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %b_arr, i32 0,i32 1
%52 = load i1*,i1**%51
%53 = getelementptr i1 ,i1* %52, i32 %47
%54 = load i1,i1* %53
br i1 %54, label %if24, label %else25
if24:
%55 = alloca i32
store i32 1, i32* %55
%56= load i32, i32* %sum
%57= load i32, i32* %55
%58 = add i32 %56, %57
%59 = alloca i32
store i32 %58, i32* %59
%60= load i32, i32* %59
store i32 %60 , i32* %sum
br label %endif26
else25:
%61 = alloca i32
store i32 10, i32* %61
%62= load i32, i32* %sum
%63= load i32, i32* %61
%64 = add i32 %62, %63
%65 = alloca i32
store i32 %64, i32* %65
%66= load i32, i32* %65
store i32 %66 , i32* %sum
br label %endif26
endif26:
%67 = load i32 , i32* %sum
call void @print_int(i32 %67)
%68 = getelementptr inbounds %class.B, %class.B* %c_b, i32 0, i32 0
%69 = load i8* , i8** %68
%70 = bitcast i8* %69 to [3 x i8*]*
%71 = getelementptr [3 x i8*], [3 x i8*]* %70, i32 0 , i32 1
%72 = load i8* , i8** %71
%73 = bitcast i8* %72 to i32(i8* )*
%74 = bitcast %class.B* %c_b to i8*
%75 = call i32 %73(i8* %74)
%76 = alloca i32
store i32 %75, i32* %76
%77= load i32, i32* %76
store i32 %77 , i32* %j
%78= load i32, i32* %j
ret i32 %78
}
define i32 @B.Init(i8* %this){
%1 = getelementptr i8,i8* %this, i32 8
%2 = bitcast i8* %1 to i32*
%3 = alloca i32
store i32 1048576, i32* %3
%4= load i32, i32* %3
store i32 %4 , i32* %2
%5 = alloca i32
store i32 1, i32* %5
%6= load i32, i32* %5
ret i32 %6
}
define i32 @B.Print(i8* %this){
%1 = getelementptr i8,i8* %this, i32 8
%2 = bitcast i8* %1 to i32*
%3 = load i32 , i32* %2
call void @print_int(i32 %3)
%4 = alloca i32
store i32 1, i32* %4
%5= load i32, i32* %4
ret i32 %5
}
define %class.B @B.getB(i8* %this,%class.B %b.arg){
%b = alloca %class.B
store %class.B %b.arg ,%class.B* %b
%1= load %class.B, %class.B* %b
ret %class.B %1
}
