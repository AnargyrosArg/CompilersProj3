import syntaxtree.*;

import visitor.GJDepthFirst;
//TODO calloc heap allocation on new , class objects as arguements , fields


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
        if(n.f6.present()){
            n.f6.accept(this,n.f1.f0.tokenImage);
        }

        return null;
    }
    
    public String visit(MethodDeclaration n,String argu){
        Global.resetRegisterCounter();
        String methodname = n.f2.f0.tokenImage;
        String methodtype = Global.getMethodType(methodname, argu);
        String classname = argu;
        Global.ST.nextChild(); //ENTER SCOPE
        String type = n.f1.accept(this,argu);
        System.out.print("define "+Global.javaType2LLVM(type)+  " @"+classname+"."+methodname+"(i8* %this");
        //print args
        //-------
        if(n.f4.present()){
            String args[] = n.f4.accept(this,argu).split(" ");
            
        for(int i=0;i<args.length;i=i+2){
            System.out.print(","+args[i]+" ");
            System.out.print(args[i+1]+".arg");
        }
        //-------
        System.out.print("){\n");
        //load from temp arg vars into identifiers
        for(int i=0;i<args.length;i=i+2){
            System.out.println(args[i+1]+" = alloca "+args[i]);
            System.out.println("store "+args[i]+" "+args[i+1]+".arg ,"+args[i]+"* "+args[i+1]);
        }
        }else{
            System.out.print("){\n");
        }
        //var decl
        if(n.f7.present()){
            n.f7.accept(this,argu);
        }
        //statements
        if(n.f8.present()){
            n.f8.accept(this,argu);
        }
        //return expr
        String expr_register = n.f10.accept(this,argu);
        String expr_type = Global.evaluated_expression.get(n.f10.toString());
        if(type.equals("int")){
            String tempRegister = Global.getTempRegister();

            System.out.println(tempRegister + "= load i32, i32* " +expr_register);
            System.out.println("ret i32 "+tempRegister);
        }else if(type.equals("int[]")){
            String tempRegister = Global.getTempRegister();

            System.out.println(tempRegister + "= load %.IntArrayType, %.IntArrayType* " +expr_register);
            System.out.println("ret %.IntArrayType "+tempRegister);
        }else if(type.equals("boolean")){
            String tempRegister = Global.getTempRegister();

            System.out.println(tempRegister + "= load i1, i1* " +expr_register);
            System.out.println("ret i1 "+tempRegister);
        }else if(type.equals("boolean[]")){
            String tempRegister = Global.getTempRegister();

            System.out.println(tempRegister + "= load %.BooleanArrayType, %.BooleanArrayType* " +expr_register);
            System.out.println("ret %.BooleanArrayType "+tempRegister);
        }else{
            String convertRegister = Global.getTempRegister();
            String tempRegister = Global.getTempRegister();
            System.out.println(convertRegister+" = bitcast %class."+expr_type+"* " + expr_register+" to %class."+methodtype.split(" ")[0]+"* ");
            System.out.println(tempRegister + "= load %class."+methodtype.split(" ")[0]+", %class."+methodtype.split(" ")[0]+"* " +convertRegister);
            System.out.println("ret %class."+methodtype.split(" ")[0]+" "+tempRegister);
        }
        System.out.println("}");
        Global.ST.exit(); //EXIT SCOPE
        return null;
    }


    public String visit(AssignmentStatement n ,String argu){
        String identifierRegister = n.f0.accept(this,argu);
        String type = Global.getFieldType(n.f0.f0.tokenImage, argu);
        String expr_type = Global.evaluated_expression.get(n.f2.toString());
        String exprRegister = n.f2.accept(this,argu);
        

        if(type.equals("int")){
            String tempRegister =  Global.getTempRegister();

            System.out.println(tempRegister + "= load i32, i32* " +exprRegister);
            System.out.println("store i32 "+tempRegister+" , i32* "+identifierRegister);
        }else if(type.equals("boolean")){
            String tempRegister =  Global.getTempRegister();

            System.out.println(tempRegister + "= load i1, i1* " +exprRegister);
            System.out.println("store i1 "+tempRegister+" , i1* "+identifierRegister);
        }
        else if(type.equals("boolean[]")){
            String tempRegister =  Global.getTempRegister();

            System.out.println(tempRegister + "= load %.BooleanArrayType, %.BooleanArrayType* " +exprRegister);
            System.out.println("store %.BooleanArrayType "+tempRegister+" , %.BooleanArrayType* "+identifierRegister);
        }
        else if(type.equals("int[]")){
            String tempRegister =  Global.getTempRegister();

            System.out.println(tempRegister + "= load %.IntArrayType, %.IntArrayType* " +exprRegister);
            System.out.println("store %.IntArrayType "+tempRegister+" , %.IntArrayType* "+identifierRegister);
        }
        else{
            String convertRegister = Global.getTempRegister();
            String tempRegister =  Global.getTempRegister();            
            System.out.println(convertRegister+" = bitcast %class."+expr_type+"* " + exprRegister+" to %class."+type+"* ");
            System.out.println(tempRegister + "= load %class."+type+", %class."+type+"* " +convertRegister);
            System.out.println("store %class."+type+" "+tempRegister+" , %class."+type+"* "+identifierRegister);
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
        String expr1_register = n.f0.accept(this,argu);
        String expr2_register = n.f2.accept(this,argu);
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
        String expr1_register = n.f0.accept(this,argu);
        String expr2_register = n.f2.accept(this,argu);
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
        String expr1_register = n.f0.accept(this,argu);
        String expr2_register = n.f2.accept(this,argu);
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

    public String visit(AndExpression n , String argu){
        String expr1_register = n.f0.accept(this,argu);
        String expr2_register = n.f2.accept(this,argu);
        String expr1_value_register = Global.getTempRegister();
        String expr2_value_register = Global.getTempRegister(); 
        
        String tempRegister1 = Global.getTempRegister();
        String returnRegister = Global.getTempRegister();


        String expr1_true_label = "expr1_true"+Global.getLabelTag();
        String expr2_true_label = "expr2_true"+Global.getLabelTag();

        String expr1_false_label = "expr1_false"+Global.getLabelTag();
        String expr2_false_label = "expr2_false"+Global.getLabelTag();

        String end_label = "endAnd"+Global.getLabelTag();

        //load values
        System.out.println(expr1_value_register+" = load i1,i1* "+expr1_register);
        System.out.println(expr2_value_register+" = load i1,i1* "+expr2_register);
        System.out.println("br i1 "+expr1_value_register+" , label %"+expr1_true_label+",label %"+expr1_false_label);
        
        System.out.println(expr1_true_label+":");
        System.out.println("br i1 "+expr2_value_register+" , label %"+expr2_true_label+",label %"+expr2_false_label);
        
        System.out.println(expr2_true_label+":");
        System.out.println("br label %"+end_label);
        
        System.out.println(expr1_false_label+":");
        System.out.println("br label %"+end_label);

        System.out.println(expr2_false_label+":");
        System.out.println("br label %"+end_label);

        System.out.println(end_label+":");
        System.out.println(tempRegister1+" = phi i1 [1, %"+expr2_true_label+"] , [0, %"+expr1_false_label+"] , [0, %"+expr2_false_label+"]");
        System.out.println(returnRegister+" = alloca i1");
        System.out.println("store i1 "+tempRegister1+" , i1* "+returnRegister);

        return returnRegister;
    }

    public String visit(VarDeclaration n,String argu){
        String type = n.f0.accept(this,argu);
        String tempRegister1 = n.f1.accept(this,argu);
        if(type.equals("int")){
            System.out.println(tempRegister1 + " = alloca i32");
        }else if(type.equals("int[]")){
            System.out.println(tempRegister1 + " = alloca %.IntArrayType");
        }else if(type.equals("boolean")){
            System.out.println(tempRegister1 + " = alloca i1");
        }else if(type.equals("boolean[]")){
            System.out.println(tempRegister1 + " = alloca %.BooleanArrayType");
        }else{
            //type is identifier remove % char we get from accepting the identifier
            type = type.substring(1);
            System.out.println(tempRegister1 + " = alloca %class."+type);
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
        if(Global.getFieldOffset(n.f0.tokenImage, argu) != -1 && Global.ST.table.current.get(n.f0.tokenImage)==null){
            String type = Global.javaType2LLVM(Global.getFieldType(n.f0.tokenImage, argu));
            //System.out.println("test");

            String tempRegister1 = Global.getTempRegister();
            System.out.println(tempRegister1+" = getelementptr i8,i8* %this, i32 "+(Global.getFieldOffset(n.f0.tokenImage, argu)+8));
            
            String tempRegister2 = Global.getTempRegister();
            System.out.println(tempRegister2+" = bitcast i8* "+tempRegister1+" to "+type +"*");
            
            return tempRegister2;
        }
        return "%"+n.f0.tokenImage;
    }

    public String visit(FormalParameterList n, String argu){
        String type = Global.javaType2LLVM(n.f0.f0.accept(this,argu));
        String register = n.f0.f1.accept(this,argu);
        String list = n.f1.accept(this,argu);
        return type +" "+register + list;
    }
    
    public String visit(FormalParameterTerm n , String argu){
        String type = Global.javaType2LLVM(n.f1.f0.accept(this,argu));
        type = type.replace(".%", ".");
        String register = n.f1.f1.accept(this,argu);
        return " "+type+" "+register;
    }

    public String visit(FormalParameterTail n ,String argu){
        String list ="";
        if(n.f0.present()){
            for(Node node:n.f0.nodes){
                list =  list.concat(node.accept(this,argu));
            }
        }
        return list;
    }
    //TODO expr lists?

    public String visit(ExpressionList n, String argu){
       String type = Global.javaType2LLVM(Global.evaluated_expression.get(n.f0.toString()));
       String register = n.f0.accept(this,argu);
       String list = n.f1.accept(this,argu);
       return type +" "+register+list;
    }
    
    public String visit(ExpressionTerm n , String argu){
        String type = Global.javaType2LLVM(Global.evaluated_expression.get(n.f1.toString()));
        String register = n.f1.accept(this,argu);
        return " "+type+" "+register;
    }

    public String visit(ExpressionTail n , String argu){
        String list="";
        if(n.f0.present()){
            for(Node node:n.f0.nodes){
                list =  list.concat(node.accept(this,argu));
            }
        }
        
        return list;
    }

    public String visit(BracketExpression n , String argu){
        return n.f1.accept(this,argu);
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
        String returnRegister = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();

        //new expression expects a class name as an identifier that specifies the type
        String type = n.f1.f0.tokenImage;
    
        //allocate space for object in temp register , pointed to by tempregister 1
        int typeSize = Global.lastoffsetmap.get(type)[0]+8;
        System.out.println(tempRegister1+" = call i8* @calloc(i32 1,i32 "+typeSize+")");
        System.out.println(returnRegister+" = bitcast i8* "+tempRegister1+" to %class."+type+"*");


        //load first element in tempregister 2, its always pointer to vtable
        System.out.println(tempRegister2+" = getelementptr inbounds %class."+type +", %class."+type+"* "+returnRegister+", i32 0, i32 0");
        System.out.println(tempRegister3+" = bitcast i8** "+ tempRegister2+" to ["+Global.methodoffsets.get(type).size() +" x i8*]**");

        //store address of vtable in object 
        System.out.println("store ["+Global.methodoffsets.get(type).size() +" x i8*]* @."+type+"_vtable, ["+Global.methodoffsets.get(type).size() +" x i8*]** "+tempRegister3);
        


        return returnRegister;
    }



     public String visit(MessageSend n, String argu){
        String args ="";
        if(n.f4.present()){
            args = n.f4.accept(this,argu);
        }
        String[] argtable = args.split(" ");
        String expr_register = n.f0.accept(this,argu);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        String tempRegister5 = Global.getTempRegister();
        String tempRegister6 = Global.getTempRegister();
    


        String type = Global.evaluated_expression.get(n.f0.toString());
        String methodtype = Global.getMethodType(n.f2.f0.tokenImage, type);
        String rettype = methodtype.split(" ")[0];
        int methodoffset = Global.getMethodOffset(n.f2.f0.tokenImage, type);
                
        //get pointer to vtable
        System.out.println(tempRegister1+" = getelementptr inbounds %class."+type +", %class."+type+"* "+expr_register+", i32 0, i32 0");
        //load vtable 
        System.out.println(tempRegister2+" = load i8* , i8** "+tempRegister1);
        //cast to vtable type
        System.out.println(tempRegister3+" = bitcast i8* "+tempRegister2+" to ["+ Global.methodoffsets.get(type).size() +" x i8*]*");
        //get pointer to function
        System.out.println(tempRegister4+" = getelementptr ["+ Global.methodoffsets.get(type).size() +" x i8*], ["+ Global.methodoffsets.get(type).size() +" x i8*]* "+tempRegister3+", i32 0 , i32 "+methodoffset/8);
        //load address of funct
        System.out.println(tempRegister5+" = load i8* , i8** "+tempRegister4);
        //bitcast from i8* to actual funct type
        System.out.print(tempRegister6+" = bitcast i8* "+tempRegister5+" to "+Global.javaType2LLVM(rettype)+"(" );
        System.out.print("i8* ");
        if(n.f4.present()){
            for(int i=0;i<argtable.length;i=i+2){
                System.out.print(","+argtable[i]);
            }
        }
        System.out.print(")*\n");
        //call funct TODO args 
        if(n.f4.present()){
            for(int i=1;i<argtable.length;i=i+2){
                String tempRegister_loop = Global.getTempRegister();
                System.out.println(tempRegister_loop+" = load "+argtable[i-1]+ ","+argtable[i-1]+"* "+argtable[i]);
                argtable[i] = tempRegister_loop;
    
            }
        }
        
        String tempRegister8 = Global.getTempRegister();

        String tempRegister7 = Global.getTempRegister();
        String returnRegister = Global.getTempRegister();
        System.out.println(tempRegister8+" = bitcast %class."+type+"* "+ expr_register +" to i8*");
        System.out.print(tempRegister7+" = call "+Global.javaType2LLVM(rettype)+" "+tempRegister6+"(");

        System.out.print("i8* "+tempRegister8);
        
        if(n.f4.present()){
            for(int i=0;i<argtable.length;i=i+2){
                System.out.print(","+argtable[i]);
                System.out.print(" "+argtable[i+1]);
            }
        }

        System.out.print(")\n");
        //return register
        System.out.println(returnRegister+" = alloca "+Global.javaType2LLVM(rettype)+"");
        System.out.println("store "+Global.javaType2LLVM(rettype)+" "+tempRegister7 +", "+Global.javaType2LLVM(rettype)+"* "+returnRegister);

        return returnRegister;
    }


    public String visit(IntegerArrayAllocationExpression n ,String argu){
        String expr_register = n.f3.accept(this,argu);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        String tempRegister5 = Global.getTempRegister();
        String tempRegister6 = Global.getTempRegister();



        //allocate room in stack for array type -> a pointer for the actual array and an integer for its size
        System.out.println(tempRegister1+" = alloca %.IntArrayType");
        //load size of array integer
        System.out.println(tempRegister2+" = load i32 ,i32* "+expr_register);
        //allocate room in heap for actual array
        System.out.println(tempRegister3+" = call i8* @calloc(i32 32 , i32 "+ tempRegister2 +")");
        //cast to integer array type
        System.out.println(tempRegister4+" = bitcast i8* "+tempRegister3+" to i32*");

        //get pointers to pointer of array and to size
        System.out.println(tempRegister5+" = getelementptr %.IntArrayType,%.IntArrayType* "+tempRegister1+",i32 0,i32 1");
        System.out.println(tempRegister6+" = getelementptr %.IntArrayType,%.IntArrayType* "+tempRegister1+",i32 0,i32 0");

        //store size on size pointer
        System.out.println("store i32 "+tempRegister2+",i32* "+tempRegister6);
        //store pointer to heap array
        System.out.println("store i32* "+tempRegister4+", i32** "+tempRegister5);

        return tempRegister1;
    }



    public String visit(BooleanArrayAllocationExpression n, String argu){
        String expr_register = n.f3.accept(this,argu);
        String tempRegister1 = Global.getTempRegister();
        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        String tempRegister5 = Global.getTempRegister();
        String tempRegister6 = Global.getTempRegister();



        //allocate room in stack for array type -> a pointer for the actual array and an integer for its size
        System.out.println(tempRegister1+" = alloca %.BooleanArrayType");
        //load size of array integer
        System.out.println(tempRegister2+" = load i32 ,i32* "+expr_register);
        //allocate room in heap for actual array
        System.out.println(tempRegister3+" = call i8* @calloc(i32 32 , i32 "+ tempRegister2 +")");
        //cast to integer array type
        System.out.println(tempRegister4+" = bitcast i8* "+tempRegister3+" to i1*");

        //get pointers to pointer of array and to size
        System.out.println(tempRegister5+" = getelementptr %.BooleanArrayType,%.BooleanArrayType* "+tempRegister1+",i32 0,i32 1");
        System.out.println(tempRegister6+" = getelementptr %.BooleanArrayType,%.BooleanArrayType* "+tempRegister1+",i32 0,i32 0");

        //store size on size pointer
        System.out.println("store i32 "+tempRegister2+",i32* "+tempRegister6);
        //store pointer to heap array
        System.out.println("store i1* "+tempRegister4+", i1** "+tempRegister5);

        return tempRegister1;

    }


    public String visit(ArrayAssignmentStatement n , String argu){
        String assignment_value_register = n.f5.accept(this,argu);
        String array_register = n.f0.accept(this,argu);
        String index_register = n.f2.accept(this,argu);

        String type = Global.ST.lookup(n.f0.f0.tokenImage).get(argu);
        String arraytype="";
        String element_type="";
        if(type.equals("int[]")){
            arraytype="%.IntArrayType";
            element_type="i32";
        }else if(type.equals("boolean[]")){
            arraytype="%.BooleanArrayType";
            element_type="i1";
        }

        String index_value = Global.getTempRegister();
        String tempRegister1 = Global.getTempRegister();
        String array_size = Global.getTempRegister();
        String out_of_bounds_condition = Global.getTempRegister();

        System.out.println(index_value+" = load i32,i32* "+index_register);

        //ptr to array size
        System.out.println(tempRegister1+" = getelementptr "+arraytype+","+arraytype+"* "+array_register+", i32 0,i32 0");

        //load array size
        System.out.println(array_size+" =  load i32 ,i32* "+tempRegister1);
        System.out.println(out_of_bounds_condition+" = icmp slt i32 "+ index_value +", "+array_size);
      
        String OOBlabel = "oob"+Global.getLabelTag();
        String continuelabel = "continue"+ Global.getLabelTag();
      
        System.out.println("br i1 "+out_of_bounds_condition+",label %"+continuelabel+", label %"+OOBlabel);
        System.out.println(OOBlabel+":");
        System.out.println("call void () @throw_oob()");
        System.out.println("br label %"+continuelabel);
        System.out.println(continuelabel+":");

        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();
        String tempRegister5 = Global.getTempRegister();


        //load pointer to pointer to array in heap
        System.out.println(tempRegister2+" = getelementptr "+arraytype+","+arraytype+"* "+array_register+", i32 0,i32 1");

        System.out.println(tempRegister3+" =  load "+element_type+"* , "+element_type+"** "+tempRegister2);

        System.out.println(tempRegister4+" = getelementptr "+element_type+" ,"+element_type+"* "+tempRegister3+", i32 "+index_value);

        
        System.out.println(tempRegister5+" = load "+element_type+" , "+element_type+" *" +assignment_value_register);

        System.out.println("store "+element_type+" "+tempRegister5+" , "+element_type+"* "+tempRegister4);


        return null;
    }

    public String visit(ArrayLookup n , String argu){   
        String type = Global.evaluated_expression.get(n.f0.toString());
        String array_register = n.f0.accept(this,argu);
        String index_register =  n.f2.accept(this,argu);
        String arraytype="";
        String element_type="";
        if(type.equals("int[]")){
            arraytype="%.IntArrayType";
            element_type="i32";
        }else if(type.equals("boolean[]")){
            arraytype="%.BooleanArrayType";
            element_type="i1";
        }
    
        String index_value = Global.getTempRegister();
        String tempRegister1 = Global.getTempRegister();
        String array_size = Global.getTempRegister();
        String out_of_bounds_condition = Global.getTempRegister();

        System.out.println(index_value+" = load i32,i32* "+index_register);

        //ptr to array size
        System.out.println(tempRegister1+" = getelementptr "+arraytype+","+arraytype+"* "+array_register+", i32 0,i32 0");

        //load array size
        System.out.println(array_size+" =  load i32 ,i32* "+tempRegister1);
        System.out.println(out_of_bounds_condition+" = icmp slt i32 "+ index_value +", "+array_size);
      
        String OOBlabel = "oob"+Global.getLabelTag();
        String continuelabel = "continue"+ Global.getLabelTag();
      
        System.out.println("br i1 "+out_of_bounds_condition+",label %"+continuelabel+", label %"+OOBlabel);
        System.out.println(OOBlabel+":");
        System.out.println("call void () @throw_oob()");
        System.out.println("br label %"+continuelabel);
        System.out.println(continuelabel+":");


        String tempRegister2 = Global.getTempRegister();
        String tempRegister3 = Global.getTempRegister();
        String tempRegister4 = Global.getTempRegister();


        //load pointer to pointer to array in heap
        System.out.println(tempRegister2+" = getelementptr "+arraytype+","+arraytype+"* "+array_register+", i32 0,i32 1");

        System.out.println(tempRegister3+" = load "+element_type+"*,"+element_type+"**" +tempRegister2);
        
        System.out.println(tempRegister4+" = getelementptr "+element_type+" ,"+element_type+"* "+tempRegister3+", i32 "+index_value);
       

        return tempRegister4;
    }


    public String visit(IfStatement n , String argu){
        String condition_register = n.f2.accept(this,argu);
        String label1 = "if"+Global.getLabelTag();
        String label2 = "else"+Global.getLabelTag();
        String endif_label = "endif"+Global.getLabelTag();
        String condition_value = Global.getTempRegister();
        System.out.println(condition_value +" = load i1,i1* "+condition_register);
        System.out.println("br i1 "+condition_value+", label %"+label1 +", label %"+label2);
        System.out.println(label1+":");
        n.f4.accept(this,argu);
        System.out.println("br label %"+endif_label);
        System.out.println(label2+":");
        n.f6.accept(this,argu);
        System.out.println("br label %"+endif_label);
        System.out.println(endif_label+":");
        return null;
    }

    public String visit(WhileStatement n,String argu){
        String loopstart_label = "loopstart"+Global.getLabelTag();
        String loop_label = "loop"+Global.getLabelTag();
        String continue_label = "endloop"+Global.getLabelTag();

        System.out.println("br label %"+loopstart_label);
        System.out.println(loopstart_label+":");
        String condition_register = n.f2.accept(this,argu);
        String condition_value = Global.getTempRegister();

        System.out.println(condition_value +" = load i1,i1* "+condition_register);
        System.out.println("br i1 "+condition_value+", label %"+loop_label +", label %"+continue_label);
        System.out.println(loop_label+":");
        n.f4.accept(this,argu);
        System.out.println("br label %"+loopstart_label);
        System.out.println(continue_label+":");
        
        return null;
    }

    public String visit(ArrayLength n , String argu){
        String type = Global.evaluated_expression.get(n.f0.toString());
        String array_register = n.f0.accept(this,argu);

        String arraytype="";
        String element_type="";
        if(type.equals("int[]")){
            arraytype="%.IntArrayType";
            element_type="i32";
        }else if(type.equals("boolean[]")){
            arraytype="%.BooleanArrayType";
            element_type="i1";
        }

        String tempRegister1 = Global.getTempRegister();
        System.out.println(tempRegister1+" = getelementptr "+arraytype+","+arraytype+"* "+array_register+", i32 0,i32 0");
        return tempRegister1;
    }

    public String visit(ThisExpression n, String argu){
        String tempRegister1 = Global.getTempRegister();
        System.out.println(tempRegister1+" = bitcast i8* %this to %class."+argu+"*");

        return tempRegister1;
    }

    public String visit(NotExpression n , String argu){
        String clauseRegister = n.f1.accept(this,argu);
        String tempRegister = Global.getTempRegister();
        String true_label = "settrue"+Global.getLabelTag();
        String false_label = "setfalse"+Global.getLabelTag();
        String continue_label = "continue"+Global.getLabelTag();

        System.out.println(tempRegister+" = load i1,i1* "+clauseRegister);
        System.out.println("br i1 "+tempRegister+", label %"+false_label+", label %"+true_label);  
        
        System.out.println(true_label+":");
        System.out.println("store i1 1, i1* "+clauseRegister);
        System.out.println("br label %"+continue_label);

        System.out.println(false_label+":");
        System.out.println("store i1 0, i1* "+clauseRegister);
        System.out.println("br label %"+continue_label);
        System.out.println(continue_label+":");

        return clauseRegister;

    }

}