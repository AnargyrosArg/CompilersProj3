import syntaxtree.*;

import visitor.GJDepthFirst;



public class IntermediateCodeVisitor extends GJDepthFirst<String,String>{

    public String visit(MainClass n, String argu){
        Global.ST.nextChild(); //ENTER SCOPE
        System.out.println("define i32 @main(){");
        n.f14.accept(this,n.f1.f0.tokenImage);
        n.f15.accept(this,n.f1.f0.tokenImage);
        System.out.println("ret i32 0 \n}");
        Global.ST.exit(); //EXIT SCOPE
        return null;
    }

    public String visit(ClassDeclaration n,String argu){
        //must not accept the field var declaration , these should be part of class object not register variables

        //accept statements
        n.f4.accept(this,n.f1.f0.tokenImage);
        return null;
    }

    public String visit(ClassExtendsDeclaration n,String argu){
        //must not accept the field var declaration , these should be part of class object not register variables

        //accept statements
        n.f6.accept(this,n.f1.f0.tokenImage);

        return null;
    }
    
    public String visit(MethodDeclaration n,String argu){
        Global.resetRegisterCounter();
        String methodname = n.f2.f0.tokenImage;
        String classname = argu;
        Global.ST.nextChild(); //ENTER SCOPE
        //TODO fix return type + params!!!
        System.out.println("define i32 @"+classname+"."+methodname+"(){");
        String type = n.f1.accept(this,argu);
        //var decl
        n.f7.accept(this,argu);
        //statements
        n.f8.accept(this,argu);
        //return expr
        String expr_register = n.f10.accept(this,argu);
        String tempRegister = Global.getTempRegister();
        if(type.equals("int")){
            System.out.println(tempRegister + "= load i32, i32* " +expr_register);
            System.out.println("ret i32 "+tempRegister);
        }else if(type.equals("int[]")){
            System.out.println(tempRegister + "= load i32*, i32** " +expr_register);
            System.out.println("ret i32* "+tempRegister);
        }else if(type.equals("boolean")){
            System.out.println(tempRegister + "= load i1, i1* " +expr_register);
            System.out.println("ret i1 "+tempRegister);
        }else if(type.equals("boolean[]")){
            System.out.println(tempRegister + "= load i1*, i1** " +expr_register);
            System.out.println("ret i1* "+tempRegister);
        }
        System.out.println("}");
        Global.ST.exit(); //EXIT SCOPE
        return null;
    }


    public String visit(AssignmentStatement n ,String argu){
        String identifierRegister = "%"+n.f0.f0.tokenImage;
        String classname = argu;
        String type = Global.ST.lookup(n.f0.f0.tokenImage).get(classname);
        String exprRegister = n.f2.accept(this,argu);
        String tempRegister =  Global.getTempRegister();

        if(type.equals("int")){
            System.out.println(tempRegister + "= load i32, i32* " +exprRegister);
            System.out.println("store i32 "+tempRegister+" , i32* "+identifierRegister);
        }else if(type.equals("boolean")){
            System.out.println(tempRegister + "= load i1, i1* " +exprRegister);
            System.out.println("store i1 "+tempRegister+" , i1* "+identifierRegister);
        }else{
            System.out.println(tempRegister + "= load %class."+type+"*, %class."+type+"** " +exprRegister);
            System.out.println("store %class."+type+"* "+tempRegister+" , %class."+type+"** "+identifierRegister);
        }
        return identifierRegister;
    }

    public String visit(PrintStatement n , String argu){
        String exprRegister= n.f2.accept(this,argu);
        String tempRegister = Global.getTempRegister();
        System.out.println(tempRegister+" = load i32 , i32* "+exprRegister);
        System.out.println("call void @print_int(i32 "+tempRegister +")");
        return null;
    }

    public String visit(PlusExpression n, String argu){
        String expr1_register = n.f0.accept(this,null);
        String expr2_register = n.f2.accept(this,null);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        System.out.println(tempRegister1 + "= load i32, i32* "+expr1_register);
        System.out.println(tempRegister2 + "= load i32, i32* "+expr2_register);
        System.out.println(tempRegister3 + " = add i32 "+tempRegister1+", "+tempRegister2);
        System.out.println(tempRegister4+ " = alloca i32");
        System.out.println("store i32 "+tempRegister3+", i32* "+tempRegister4);
        return tempRegister4;
    }

    public String visit(MinusExpression n, String argu){
        String expr1_register = n.f0.accept(this,null);
        String expr2_register = n.f2.accept(this,null);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        System.out.println(tempRegister1 + "= load i32, i32* "+expr1_register);
        System.out.println(tempRegister2 + "= load i32, i32* "+expr2_register);
        System.out.println(tempRegister3 + " = sub i32 "+tempRegister1+", "+tempRegister2);
        System.out.println(tempRegister4 + " = alloca i32");
        System.out.println("store i32 "+tempRegister3+", i32* "+tempRegister4);
        return tempRegister4;
    }

    public String visit(TimesExpression n, String argu){
        String expr1_register = n.f0.accept(this,null);
        String expr2_register = n.f2.accept(this,null);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        System.out.println(tempRegister1 + " = load i32, i32* "+expr1_register);
        System.out.println(tempRegister2 + " = load i32, i32* "+expr2_register);
        System.out.println(tempRegister3 + " = mul i32 "+tempRegister1+", "+tempRegister2);
        System.out.println(tempRegister4 + " = alloca i32");
        System.out.println("store i32 "+tempRegister3+", i32* "+tempRegister4);
        return tempRegister4;
    }

    public String visit(CompareExpression n ,String argu ){
        String expr1_register = n.f0.accept(this,argu);
        String expr2_register = n.f2.accept(this,argu);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        System.out.println(tempRegister1 + " = load i32, i32* "+expr1_register);
        System.out.println(tempRegister2 + " = load i32, i32* "+expr2_register);
        System.out.println(tempRegister3 + " = icmp slt i32 "+tempRegister1+", "+tempRegister2);
        System.out.println(tempRegister4 + " = alloca i1");
        System.out.println("store i1 "+tempRegister3+", i1* "+tempRegister4);
        return tempRegister4;
    }

    public String visit(VarDeclaration n,String argu){
        String type = n.f0.accept(this,null);
        String tempRegister1 = n.f1.accept(this,null);
        if(type.equals("int")){
            System.out.println(tempRegister1 + " = alloca i32");
        }else if(type.equals("int[]")){
            System.out.println(tempRegister1 + " = alloca i32*");
        }else if(type.equals("boolean")){
            System.out.println(tempRegister1 + " = alloca i1");
        }else if(type.equals("boolean[]")){
            System.out.println(tempRegister1 + " = alloca i1*");
        }else{
            //type is identifier remove % char we get from accepting the identifier
            type = type.substring(1);
            //TODO ACTUALLY ALLOC type NOT type*!!!! refactor accordingly
            //allocate room for a pointer
            //register stores address of pointer that will point to object
            System.out.println(tempRegister1 + " = alloca %class."+type+"*");
        }
        return tempRegister1;

    }
    
    public String visit(IntegerType n, String argu) {
        return "int";
    }
 
    public String visit(IntegerArrayType n, String argu) {
        return "int[]";
    }
    
    public String visit(BooleanType n, String argu) {
        return "boolean";
    }
    
    public String visit(BooleanArrayType n, String argu) {
        return "boolean[]";
    }

    public String visit(Identifier n, String argu){
        return "%"+n.f0.tokenImage;
    }
    

     public String visit(IntegerLiteral n ,String argu){
        String tempRegister = Global.getTempRegister();
        System.out.println(tempRegister+" = alloca i32");
        System.out.println("store i32 "+n.f0.tokenImage +", i32* "+tempRegister);
        return tempRegister;
    }

    public String visit(TrueLiteral n , String argu){
        String tempRegister = Global.getTempRegister();
        System.out.println(tempRegister+" = alloca i1");
        System.out.println("store i1 "+1 +", i1* "+tempRegister);
        return tempRegister;
    }

    public String visit(FalseLiteral n , String argu){
        String tempRegister = Global.getTempRegister();
        System.out.println(tempRegister+" = alloca i1");
        System.out.println("store i1 "+0 +", i1* "+tempRegister);
        return tempRegister;
    }

    public String visit(AllocationExpression n ,String argu){
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String returnRegister = Global.getTempRegister();

        //new expression expects a class name as an identifier that specifies the type
        String type = n.f1.f0.tokenImage;
    
        //allocate space for object in temp register , pointed to by tempregister 1
        System.out.println(tempRegister1+" = alloca %class."+type);
        
        //load first element in tempregister 2, its always pointer to vtable
        System.out.println(tempRegister2+" = getelementptr %class."+type +", %class."+type+"* "+tempRegister1+", i32 0, i32 0");
        System.out.println(tempRegister3+" = bitcast i8** "+ tempRegister2+" to ["+Global.methodoffsets.size() +" x i8*]**");

        //store address of vtable in object 
        System.out.println("store ["+Global.methodoffsets.size() +" x i8*]* @."+type+"_vtable, ["+Global.methodoffsets.size() +" x i8*]** "+tempRegister3);

        //TODO REST OF THE FIELDS


        System.out.println(returnRegister+" = alloca %class."+type+"*");
        System.out.println("store %class."+type+"* "+tempRegister1+", %class."+type+"** "+returnRegister);
        return returnRegister;
    }



     public String visit(MessageSend n, String argu){
        String expr_register = n.f0.accept(this,argu);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        String tempRegister5 = Global.getTempRegister();
        String tempRegister6 = Global.getTempRegister();
        String returnRegister = Global.getTempRegister();


        String type = Global.evaluated_expression.get(n.f0.toString());
        String methodtype = Global.getMethodType(n.f2.f0.tokenImage, type);
        int methodoffset = Global.methodoffsets.get(type).get(type+"."+n.f2.f0.tokenImage);
        
        //expr register is pointer to pointer to object
        //dereference once
        System.out.println(tempRegister1 + " = load %class."+type+"* , %class."+type+"** "+expr_register);
        //get pointer to vtable
        System.out.println(tempRegister2+" = getelementptr %class."+type +", %class."+type+"* "+tempRegister1+", i32 0, i32 0");
        //get pointer to methodoffset/8-th element of the vtable
        System.out.println(tempRegister3+" = getelementptr i8* , i8** "+tempRegister2+", i32 "+(methodoffset/8));
        //load func address
        System.out.println(tempRegister4 +" = load i8* ,i8** "+tempRegister3);
        //hardcoded for now TODO: read methodtype and add args                  vv
        System.out.println(tempRegister5 +" = bitcast i8* "+tempRegister4+" to i32 ()*");
        //TODO read methodtype and add rettype      vv
        System.out.println(tempRegister6 +" = call i32 "+tempRegister5+"()");

        

        System.out.println(returnRegister+" = alloca i32");
        System.out.println("store i32 "+tempRegister6 +", i32* "+returnRegister);

        return returnRegister;
    }
}