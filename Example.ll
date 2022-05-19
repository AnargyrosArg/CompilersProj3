{A={A.foo=0, B.type=0}, B={A.foo=0, B.type=0}}
[A.foo, B.type]
@.A_vtable = global [2x i8*] [i8* bitcast (i32 (i32*, i32*)* @A.foo to i8*),
i8* bitcast (i32 (i32*, i32*)* @B.type to i8*)]

[A.foo, B.type]
@.B_vtable = global [2x i8*] [i8* bitcast (i32 (i32*, i32*)* @A.foo to i8*),
i8* bitcast (i32 (i32*, i32*)* @B.type to i8*)]

