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
%82= load i1, i1* null
store i1 %82 , i1* %flag
%83 = alloca i32
store i32 1, i32* %83
%84= load i32, i32* %i
%85= load i32, i32* %83
%86 = add i32 %84, %85
%87 = alloca i32
store i32 %86, i32* %87
%88= load i32, i32* %87
store i32 %88 , i32* %i
br label %loopstart6
endloop8:
%89 = alloca i32
store i32 1024, i32* %89
%90 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%91 = load i8* , i8** %90
%92 = bitcast i8* %91 to [6 x i8*]*
%93 = getelementptr [6 x i8*], [6 x i8*]* %92, i32 0 , i32 0
%94 = load i8* , i8** %93
%95 = bitcast i8* %94 to i32(i8* ,i32)*
%96 = load i32,i32* %89
%97 = bitcast %class.A* %a to i8*
%98 = call i32 %95(i8* %97,i32 %96)
%99 = alloca i32
store i32 %98, i32* %99
%100 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%101 = load i8* , i8** %100
%102 = bitcast i8* %101 to [6 x i8*]*
%103 = getelementptr [6 x i8*], [6 x i8*]* %102, i32 0 , i32 0
%104 = load i8* , i8** %103
%105 = bitcast i8* %104 to i32(i8* ,i32)*
%106 = load i32,i32* %99
%107 = bitcast %class.A* %a to i8*
%108 = call i32 %105(i8* %107,i32 %106)
%109 = alloca i32
store i32 %108, i32* %109
%110 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%111 = load i8* , i8** %110
%112 = bitcast i8* %111 to [6 x i8*]*
%113 = getelementptr [6 x i8*], [6 x i8*]* %112, i32 0 , i32 0
%114 = load i8* , i8** %113
%115 = bitcast i8* %114 to i32(i8* ,i32)*
%116 = load i32,i32* %109
%117 = bitcast %class.A* %a to i8*
%118 = call i32 %115(i8* %117,i32 %116)
%119 = alloca i32
store i32 %118, i32* %119
%120 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%121 = load i8* , i8** %120
%122 = bitcast i8* %121 to [6 x i8*]*
%123 = getelementptr [6 x i8*], [6 x i8*]* %122, i32 0 , i32 0
%124 = load i8* , i8** %123
%125 = bitcast i8* %124 to i32(i8* ,i32)*
%126 = load i32,i32* %119
%127 = bitcast %class.A* %a to i8*
%128 = call i32 %125(i8* %127,i32 %126)
%129 = alloca i32
store i32 %128, i32* %129
%130 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%131 = load i8* , i8** %130
%132 = bitcast i8* %131 to [6 x i8*]*
%133 = getelementptr [6 x i8*], [6 x i8*]* %132, i32 0 , i32 0
%134 = load i8* , i8** %133
%135 = bitcast i8* %134 to i32(i8* ,i32)*
%136 = load i32,i32* %129
%137 = bitcast %class.A* %a to i8*
%138 = call i32 %135(i8* %137,i32 %136)
%139 = alloca i32
store i32 %138, i32* %139
%140 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%141 = load i8* , i8** %140
%142 = bitcast i8* %141 to [6 x i8*]*
%143 = getelementptr [6 x i8*], [6 x i8*]* %142, i32 0 , i32 0
%144 = load i8* , i8** %143
%145 = bitcast i8* %144 to i32(i8* ,i32)*
%146 = load i32,i32* %139
%147 = bitcast %class.A* %a to i8*
%148 = call i32 %145(i8* %147,i32 %146)
%149 = alloca i32
store i32 %148, i32* %149
%150 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%151 = load i8* , i8** %150
%152 = bitcast i8* %151 to [6 x i8*]*
%153 = getelementptr [6 x i8*], [6 x i8*]* %152, i32 0 , i32 0
%154 = load i8* , i8** %153
%155 = bitcast i8* %154 to i32(i8* ,i32)*
%156 = load i32,i32* %149
%157 = bitcast %class.A* %a to i8*
%158 = call i32 %155(i8* %157,i32 %156)
%159 = alloca i32
store i32 %158, i32* %159
%160 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%161 = load i8* , i8** %160
%162 = bitcast i8* %161 to [6 x i8*]*
%163 = getelementptr [6 x i8*], [6 x i8*]* %162, i32 0 , i32 1
%164 = load i8* , i8** %163
%165 = bitcast i8* %164 to %.IntArrayType(i8* ,%.IntArrayType)*
%166 = load %.IntArrayType,%.IntArrayType* %int_array
%167 = bitcast %class.A* %a to i8*
%168 = call %.IntArrayType %165(i8* %167,%.IntArrayType %166)
%169 = alloca %.IntArrayType
store %.IntArrayType %168, %.IntArrayType* %169
%170 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%171 = load i8* , i8** %170
%172 = bitcast i8* %171 to [6 x i8*]*
%173 = getelementptr [6 x i8*], [6 x i8*]* %172, i32 0 , i32 1
%174 = load i8* , i8** %173
%175 = bitcast i8* %174 to %.IntArrayType(i8* ,%.IntArrayType)*
%176 = load %.IntArrayType,%.IntArrayType* %169
%177 = bitcast %class.A* %a to i8*
%178 = call %.IntArrayType %175(i8* %177,%.IntArrayType %176)
%179 = alloca %.IntArrayType
store %.IntArrayType %178, %.IntArrayType* %179
%180 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%181 = load i8* , i8** %180
%182 = bitcast i8* %181 to [6 x i8*]*
%183 = getelementptr [6 x i8*], [6 x i8*]* %182, i32 0 , i32 1
%184 = load i8* , i8** %183
%185 = bitcast i8* %184 to %.IntArrayType(i8* ,%.IntArrayType)*
%186 = load %.IntArrayType,%.IntArrayType* %179
%187 = bitcast %class.A* %a to i8*
%188 = call %.IntArrayType %185(i8* %187,%.IntArrayType %186)
%189 = alloca %.IntArrayType
store %.IntArrayType %188, %.IntArrayType* %189
%190 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%191 = load i8* , i8** %190
%192 = bitcast i8* %191 to [6 x i8*]*
%193 = getelementptr [6 x i8*], [6 x i8*]* %192, i32 0 , i32 1
%194 = load i8* , i8** %193
%195 = bitcast i8* %194 to %.IntArrayType(i8* ,%.IntArrayType)*
%196 = load %.IntArrayType,%.IntArrayType* %189
%197 = bitcast %class.A* %a to i8*
%198 = call %.IntArrayType %195(i8* %197,%.IntArrayType %196)
%199 = alloca %.IntArrayType
store %.IntArrayType %198, %.IntArrayType* %199
%200 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%201 = load i8* , i8** %200
%202 = bitcast i8* %201 to [6 x i8*]*
%203 = getelementptr [6 x i8*], [6 x i8*]* %202, i32 0 , i32 1
%204 = load i8* , i8** %203
%205 = bitcast i8* %204 to %.IntArrayType(i8* ,%.IntArrayType)*
%206 = load %.IntArrayType,%.IntArrayType* %199
%207 = bitcast %class.A* %a to i8*
%208 = call %.IntArrayType %205(i8* %207,%.IntArrayType %206)
%209 = alloca %.IntArrayType
store %.IntArrayType %208, %.IntArrayType* %209
%210 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%211 = load i8* , i8** %210
%212 = bitcast i8* %211 to [6 x i8*]*
%213 = getelementptr [6 x i8*], [6 x i8*]* %212, i32 0 , i32 1
%214 = load i8* , i8** %213
%215 = bitcast i8* %214 to %.IntArrayType(i8* ,%.IntArrayType)*
%216 = load %.IntArrayType,%.IntArrayType* %209
%217 = bitcast %class.A* %a to i8*
%218 = call %.IntArrayType %215(i8* %217,%.IntArrayType %216)
%219 = alloca %.IntArrayType
store %.IntArrayType %218, %.IntArrayType* %219
%220 = alloca i1
store i1 1, i1* %220
%221 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%222 = load i8* , i8** %221
%223 = bitcast i8* %222 to [6 x i8*]*
%224 = getelementptr [6 x i8*], [6 x i8*]* %223, i32 0 , i32 2
%225 = load i8* , i8** %224
%226 = bitcast i8* %225 to i1(i8* ,i1)*
%227 = load i1,i1* %220
%228 = bitcast %class.A* %a to i8*
%229 = call i1 %226(i8* %228,i1 %227)
%230 = alloca i1
store i1 %229, i1* %230
%231 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%232 = load i8* , i8** %231
%233 = bitcast i8* %232 to [6 x i8*]*
%234 = getelementptr [6 x i8*], [6 x i8*]* %233, i32 0 , i32 2
%235 = load i8* , i8** %234
%236 = bitcast i8* %235 to i1(i8* ,i1)*
%237 = load i1,i1* %230
%238 = bitcast %class.A* %a to i8*
%239 = call i1 %236(i8* %238,i1 %237)
%240 = alloca i1
store i1 %239, i1* %240
%241 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%242 = load i8* , i8** %241
%243 = bitcast i8* %242 to [6 x i8*]*
%244 = getelementptr [6 x i8*], [6 x i8*]* %243, i32 0 , i32 2
%245 = load i8* , i8** %244
%246 = bitcast i8* %245 to i1(i8* ,i1)*
%247 = load i1,i1* %240
%248 = bitcast %class.A* %a to i8*
%249 = call i1 %246(i8* %248,i1 %247)
%250 = alloca i1
store i1 %249, i1* %250
%251 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%252 = load i8* , i8** %251
%253 = bitcast i8* %252 to [6 x i8*]*
%254 = getelementptr [6 x i8*], [6 x i8*]* %253, i32 0 , i32 2
%255 = load i8* , i8** %254
%256 = bitcast i8* %255 to i1(i8* ,i1)*
%257 = load i1,i1* %250
%258 = bitcast %class.A* %a to i8*
%259 = call i1 %256(i8* %258,i1 %257)
%260 = alloca i1
store i1 %259, i1* %260
%261 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%262 = load i8* , i8** %261
%263 = bitcast i8* %262 to [6 x i8*]*
%264 = getelementptr [6 x i8*], [6 x i8*]* %263, i32 0 , i32 2
%265 = load i8* , i8** %264
%266 = bitcast i8* %265 to i1(i8* ,i1)*
%267 = load i1,i1* %260
%268 = bitcast %class.A* %a to i8*
%269 = call i1 %266(i8* %268,i1 %267)
%270 = alloca i1
store i1 %269, i1* %270
%271 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%272 = load i8* , i8** %271
%273 = bitcast i8* %272 to [6 x i8*]*
%274 = getelementptr [6 x i8*], [6 x i8*]* %273, i32 0 , i32 2
%275 = load i8* , i8** %274
%276 = bitcast i8* %275 to i1(i8* ,i1)*
%277 = load i1,i1* %270
%278 = bitcast %class.A* %a to i8*
%279 = call i1 %276(i8* %278,i1 %277)
%280 = alloca i1
store i1 %279, i1* %280
%281 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%282 = load i8* , i8** %281
%283 = bitcast i8* %282 to [6 x i8*]*
%284 = getelementptr [6 x i8*], [6 x i8*]* %283, i32 0 , i32 2
%285 = load i8* , i8** %284
%286 = bitcast i8* %285 to i1(i8* ,i1)*
%287 = load i1,i1* %280
%288 = bitcast %class.A* %a to i8*
%289 = call i1 %286(i8* %288,i1 %287)
%290 = alloca i1
store i1 %289, i1* %290
%291 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%292 = load i8* , i8** %291
%293 = bitcast i8* %292 to [6 x i8*]*
%294 = getelementptr [6 x i8*], [6 x i8*]* %293, i32 0 , i32 3
%295 = load i8* , i8** %294
%296 = bitcast i8* %295 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%297 = load %.BooleanArrayType,%.BooleanArrayType* %boolean_array
%298 = bitcast %class.A* %a to i8*
%299 = call %.BooleanArrayType %296(i8* %298,%.BooleanArrayType %297)
%300 = alloca %.BooleanArrayType
store %.BooleanArrayType %299, %.BooleanArrayType* %300
%301 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%302 = load i8* , i8** %301
%303 = bitcast i8* %302 to [6 x i8*]*
%304 = getelementptr [6 x i8*], [6 x i8*]* %303, i32 0 , i32 3
%305 = load i8* , i8** %304
%306 = bitcast i8* %305 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%307 = load %.BooleanArrayType,%.BooleanArrayType* %300
%308 = bitcast %class.A* %a to i8*
%309 = call %.BooleanArrayType %306(i8* %308,%.BooleanArrayType %307)
%310 = alloca %.BooleanArrayType
store %.BooleanArrayType %309, %.BooleanArrayType* %310
%311 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%312 = load i8* , i8** %311
%313 = bitcast i8* %312 to [6 x i8*]*
%314 = getelementptr [6 x i8*], [6 x i8*]* %313, i32 0 , i32 3
%315 = load i8* , i8** %314
%316 = bitcast i8* %315 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%317 = load %.BooleanArrayType,%.BooleanArrayType* %310
%318 = bitcast %class.A* %a to i8*
%319 = call %.BooleanArrayType %316(i8* %318,%.BooleanArrayType %317)
%320 = alloca %.BooleanArrayType
store %.BooleanArrayType %319, %.BooleanArrayType* %320
%321 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%322 = load i8* , i8** %321
%323 = bitcast i8* %322 to [6 x i8*]*
%324 = getelementptr [6 x i8*], [6 x i8*]* %323, i32 0 , i32 3
%325 = load i8* , i8** %324
%326 = bitcast i8* %325 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%327 = load %.BooleanArrayType,%.BooleanArrayType* %320
%328 = bitcast %class.A* %a to i8*
%329 = call %.BooleanArrayType %326(i8* %328,%.BooleanArrayType %327)
%330 = alloca %.BooleanArrayType
store %.BooleanArrayType %329, %.BooleanArrayType* %330
%331 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%332 = load i8* , i8** %331
%333 = bitcast i8* %332 to [6 x i8*]*
%334 = getelementptr [6 x i8*], [6 x i8*]* %333, i32 0 , i32 3
%335 = load i8* , i8** %334
%336 = bitcast i8* %335 to %.BooleanArrayType(i8* ,%.BooleanArrayType)*
%337 = load %.BooleanArrayType,%.BooleanArrayType* %330
%338 = bitcast %class.A* %a to i8*
%339 = call %.BooleanArrayType %336(i8* %338,%.BooleanArrayType %337)
%340 = alloca %.BooleanArrayType
store %.BooleanArrayType %339, %.BooleanArrayType* %340
%341 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%342 = load i8* , i8** %341
%343 = bitcast i8* %342 to [3 x i8*]*
%344 = getelementptr [3 x i8*], [3 x i8*]* %343, i32 0 , i32 2
%345 = load i8* , i8** %344
%346 = bitcast i8* %345 to %class.B(i8* ,%class.B)*
%347 = load %class.B,%class.B* %b
%348 = bitcast %class.B* %b to i8*
%349 = call %class.B %346(i8* %348,%class.B %347)
%350 = alloca %class.B
store %class.B %349, %class.B* %350
%351 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%352 = load i8* , i8** %351
%353 = bitcast i8* %352 to [3 x i8*]*
%354 = getelementptr [3 x i8*], [3 x i8*]* %353, i32 0 , i32 2
%355 = load i8* , i8** %354
%356 = bitcast i8* %355 to %class.B(i8* ,%class.B)*
%357 = load %class.B,%class.B* %350
%358 = bitcast %class.B* %b to i8*
%359 = call %class.B %356(i8* %358,%class.B %357)
%360 = alloca %class.B
store %class.B %359, %class.B* %360
%361 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%362 = load i8* , i8** %361
%363 = bitcast i8* %362 to [3 x i8*]*
%364 = getelementptr [3 x i8*], [3 x i8*]* %363, i32 0 , i32 2
%365 = load i8* , i8** %364
%366 = bitcast i8* %365 to %class.B(i8* ,%class.B)*
%367 = load %class.B,%class.B* %360
%368 = bitcast %class.B* %b to i8*
%369 = call %class.B %366(i8* %368,%class.B %367)
%370 = alloca %class.B
store %class.B %369, %class.B* %370
%371 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%372 = load i8* , i8** %371
%373 = bitcast i8* %372 to [3 x i8*]*
%374 = getelementptr [3 x i8*], [3 x i8*]* %373, i32 0 , i32 2
%375 = load i8* , i8** %374
%376 = bitcast i8* %375 to %class.B(i8* ,%class.B)*
%377 = load %class.B,%class.B* %370
%378 = bitcast %class.B* %b to i8*
%379 = call %class.B %376(i8* %378,%class.B %377)
%380 = alloca %class.B
store %class.B %379, %class.B* %380
%381 = getelementptr inbounds %class.B, %class.B* %b, i32 0, i32 0
%382 = load i8* , i8** %381
%383 = bitcast i8* %382 to [3 x i8*]*
%384 = getelementptr [3 x i8*], [3 x i8*]* %383, i32 0 , i32 2
%385 = load i8* , i8** %384
%386 = bitcast i8* %385 to %class.B(i8* ,%class.B)*
%387 = load %class.B,%class.B* %380
%388 = bitcast %class.B* %b to i8*
%389 = call %class.B %386(i8* %388,%class.B %387)
%390 = alloca %class.B
store %class.B %389, %class.B* %390
%391 = getelementptr inbounds %class.A, %class.A* %a, i32 0, i32 0
%392 = load i8* , i8** %391
%393 = bitcast i8* %392 to [6 x i8*]*
%394 = getelementptr [6 x i8*], [6 x i8*]* %393, i32 0 , i32 5
%395 = load i8* , i8** %394
%396 = bitcast i8* %395 to i32(i8* ,i32,%.IntArrayType,i1,%.BooleanArrayType,%class.B)*
%397 = load i32,i32* %159
%398 = load %.IntArrayType,%.IntArrayType* %219
%399 = load i1,i1* %290
%400 = load %.BooleanArrayType,%.BooleanArrayType* %340
%401 = load %class.B,%class.B* %390
%402 = bitcast %class.A* %a to i8*
%403 = call i32 %396(i8* %402,i32 %397,%.IntArrayType %398,i1 %399,%.BooleanArrayType %400,%class.B %401)
%404 = alloca i32
store i32 %403, i32* %404
%405= load i32, i32* %404
store i32 %405 , i32* %i
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
br label %loopstart11
loopstart11:
%11 = getelementptr %.IntArrayType,%.IntArrayType* %int_arr, i32 0,i32 0
%12 = load i32, i32* %j
%13 = load i32, i32* %11
%14 = icmp slt i32 %12, %13
%15 = alloca i1
store i1 %14, i1* %15
%16 = load i1,i1* %15
br i1 %16, label %loop12, label %endloop13
loop12:
%17 = load i32,i32* %j
%18 = getelementptr %.IntArrayType,%.IntArrayType* %int_arr, i32 0,i32 0
%19 =  load i32 ,i32* %18
%20 = icmp slt i32 %17, %19
br i1 %20,label %continue15, label %oob14
oob14:
call void () @throw_oob()
br label %continue15
continue15:
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
br label %loopstart11
endloop13:
%35 = load i32 , i32* %sum
call void @print_int(i32 %35)
%36 = load i1,i1* %b
br i1 %36, label %if16, label %else17
if16:
%37 = alloca i32
store i32 1, i32* %37
%38 = load i32 , i32* %37
call void @print_int(i32 %38)
br label %endif18
else17:
%39 = alloca i32
store i32 0, i32* %39
%40 = load i32 , i32* %39
call void @print_int(i32 %40)
br label %endif18
endif18:
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
br i1 %50,label %continue20, label %oob19
oob19:
call void () @throw_oob()
br label %continue20
continue20:
%51 = getelementptr %.BooleanArrayType,%.BooleanArrayType* %b_arr, i32 0,i32 1
%52 = load i1*,i1**%51
%53 = getelementptr i1 ,i1* %52, i32 %47
%54 = load i1,i1* %53
br i1 %54, label %if21, label %else22
if21:
%55 = alloca i32
store i32 1, i32* %55
%56= load i32, i32* %sum
%57= load i32, i32* %55
%58 = add i32 %56, %57
%59 = alloca i32
store i32 %58, i32* %59
%60= load i32, i32* %59
store i32 %60 , i32* %sum
br label %endif23
else22:
%61 = alloca i32
store i32 10, i32* %61
%62= load i32, i32* %sum
%63= load i32, i32* %61
%64 = add i32 %62, %63
%65 = alloca i32
store i32 %64, i32* %65
%66= load i32, i32* %65
store i32 %66 , i32* %sum
br label %endif23
endif23:
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
