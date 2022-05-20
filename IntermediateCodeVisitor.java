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
    




    public String visit(MethodDeclaration n,String argu){

        Global.ST.nextChild(); //ENTER SCOPE
        super.visit(n, argu);

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
            System.out.println("store i1* "+exprRegister+" , i1* "+identifierRegister);
        }else{
            System.err.println("non int or boolean type in assignment?----------------------------------------------------");
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
        System.out.println(tempRegister4+ " = alloca i32");
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
        System.out.println(tempRegister1 + "= load i32, i32* "+expr1_register);
        System.out.println(tempRegister2 + "= load i32, i32* "+expr2_register);
        System.out.println(tempRegister3 + " = mul i32 "+tempRegister1+", "+tempRegister2);
        System.out.println(tempRegister4+ " = alloca i32");
        System.out.println("store i32 "+tempRegister3+", i32* "+tempRegister4);
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

}