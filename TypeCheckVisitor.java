
import java.nio.channels.AcceptPendingException;
import java.util.*;
import java.util.Arrays;

import javax.swing.tree.TreeNode;
import syntaxtree.*;
import visitor.GJDepthFirst;

public class TypeCheckVisitor extends GJDepthFirst<String,String>{





/**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> "public"
     * f4 -> "static"
     * f5 -> "void"
     * f6 -> "main"
     * f7 -> "("
     * f8 -> "String"
     * f9 -> "["
     * f10 -> "]"
     * f11 -> Identifier()
     * f12 -> ")"
     * f13 -> "{"
     * f14 -> ( VarDeclaration() )*
     * f15 -> ( Statement() )*
     * f16 -> "}"
     * f17 -> "}"
     */
     public String visit(MainClass n, String argu){
        String classname = n.f1.accept(this, null);

        Global.ST.nextChild();                                  //ENTER SCOPE

        n.f11.accept(this,null);

        for(Node node: n.f14.nodes){
            String temp = node.accept(this,null);
           // System.out.println(temp);
        }
        for(Node node: n.f15.nodes){
            String temp = node.accept(this,classname);
        }
        Global.ST.exit();                                   //EXIT SCOPE
        return null;
    }



     /**
    * f0 -> "class"
    * f1 -> Identifier()
    * f2 -> "{"
    * f3 -> ( VarDeclaration() )*
    * f4 -> ( MethodDeclaration() )*
    * f5 -> "}"
    */
    public String visit(ClassDeclaration n,  String argu) {
        String classname = n.f1.accept(this, null);
        for(Node node: n.f3.nodes){
            node.accept(this,null);
        }
        for(Node node: n.f4.nodes){
            node.accept(this,classname);
        }
        return null;
    }


    /**
    * f0 -> "class"
    * f1 -> Identifier()
    * f2 -> "extends"
    * f3 -> Identifier()
    * f4 -> "{"
    * f5 -> ( VarDeclaration() )*
    * f6 -> ( MethodDeclaration() )*
    * f7 -> "}"
    */
    public String visit(ClassExtendsDeclaration n, String argu) {
        String classname = n.f1.accept(this, null);
        String extendname =  n.f3.accept(this,null);
      //  System.out.println("Class: "+ classname);
        for(Node node: n.f5.nodes){
            node.accept(this,null);
        }
         for(Node node: n.f6.nodes){
            node.accept(this,classname+" "+extendname);
        }
        return null;
     }


         /**
    * f0 -> "public"
    * f1 -> Type()
    * f2 -> Identifier()
    * f3 -> "("
    * f4 -> ( FormalParameterList() )?
    * f5 -> ")"
    * f6 -> "{"
    * f7 -> ( VarDeclaration() )*
    * f8 -> ( Statement() )*
    * f9 -> "return"
    * f10 -> Expression()
    * f11 -> ";"
    * f12 -> "}"
    */
    public String visit(MethodDeclaration n, String argu) {
        String return_type = n.f1.accept(this,null);
        String methodname = n.f2.accept(this,null);
        String classname = argu.split(" ")[0];
        String extendname;
        if(argu.split(" ").length==2){
            extendname = argu.split(" ")[1];
        }
        Global.ST.nextChild();          //ENTER SCOPE
        if(n.f4.present()){
            n.f4.accept(this,null);
        }
        for(Node node:n.f7.nodes){
            node.accept(this,null);
        }
        for(Node node: n.f8.nodes){
            node.accept(this,classname);
        }
        //ensure return_expr_type is compatible with returntype
        String return_expr_type = n.f10.accept(this,classname);
       // System.out.println("Return type: "+ return_expr_type);
        if(!return_expr_type.equals(return_type)){
            System.err.println("Incompatible return types got |"+return_type+"| expected |"+return_expr_type+"|");
            System.exit(-1);
        }

        Global.ST.exit();       //EXIT SCOPE
        return null;
    }






    @Override
    public String visit(Identifier n, String argu) {
        if(Global.ST.lookup(n.f0.toString())!=null ){
            if(argu==null){
                return n.f0.toString();
            }else{
                LinkedHashMap<String,String> Value =  Global.ST.lookup(n.f0.toString());
                String Type = Value.get(argu);
                if(Type == null){
                    //not found in current class
                    String current_class = argu;
                    // go through the parent chain and see if there is a suitable identifier and return it
                    while(!current_class.equals(Global.getParentClass(current_class))){
                        current_class =  Global.getParentClass(current_class);
                        if((Type = Value.get(current_class))!=null){
                            return Type;
                        }
                    }
                    //if we go through the chain without finding one its an error
                    System.err.println(n.f0.toString() + " Identifier invalid");
                    System.exit(-1);
                    return null;
                }
              //  System.out.println("ID-> "+ n.f0.toString() + " Type: " + Type + " Class: " + argu);
                return Type;
            }
        }else{
            System.err.println("Identifier "+n.f0.toString()+" does not exist in current context");
            System.exit(-1);
            return null;
        }
    }
    @Override
    public String visit(IntegerType n, String argu) {
        return "int";
    }
    @Override
    public String visit(IntegerArrayType n, String argu) {
        return "int[]";
    }
    @Override
    public String visit(BooleanType n, String argu) {
        return "boolean";
    }
    @Override
    public String visit(BooleanArrayType n, String argu) {
        return "boolean[]";
     }
    

    public String visit(PrimaryExpression n ,String argu){
        String type = n.f0.accept(this,argu);
        Global.evaluated_expression.put(n.toString(), type);
        return type;
    }

    public String visit(Expression n,String argu){
        String type = n.f0.accept(this,argu);
        Global.evaluated_expression.put(n.toString(), type);
        return type;
    }

    
    public String visit(TrueLiteral n , String argu){
        return "boolean";
    }
    public String visit(FalseLiteral n , String argu){
        return "boolean";
    }
    public String visit(IntegerLiteral n , String argu){
        return "int";
    }
    public String visit(ThisExpression n , String argu){
        return argu;
    }

    public String visit(BooleanArrayAllocationExpression n , String argu){
        if(n.f3.accept(this,argu).equals("int")){
            return "boolean[]";
        }else{
            System.err.println("Array index must be integer");
            System.exit(-1);
            return null;
        }
    }



    public String visit(IntegerArrayAllocationExpression n , String argu){
        if(n.f3.accept(this,argu).equals("int")){
            return "int[]";
        }else{
            System.err.println("Array index must be integer");
            System.exit(-1);
            return null;
        }
    }
    
    public String visit(AllocationExpression n ,String argu){
        String identifiername =  n.f1.accept(this,null);
        LinkedHashMap<String,String> value = Global.ST.lookup(identifiername);
        String type = value.get("CLASS");
        if(type.equals("CLASS") || type.contains("SUBCLASS: ")){
           return identifiername;
            // return identifiername + "[]";
        }else{
            System.err.println("Allocation expression must be of custom type");
            System.exit(-1);
            return null;
        }        
    }

    public String visit(ArrayLookup n , String argu){
        String expr_type1 = n.f0.accept(this,argu);
        String expr_type2 = n.f2.accept(this,argu);
        if(!expr_type1.contains("[]") || !expr_type2.equals("int")){
            System.err.println("lookup expression must be used between an array and integer type");
            System.exit(-1);
            return null;
        }

        return expr_type1.replace("[]", "");
    }

    public String visit(AndExpression n ,String argu){
        String Clause_type1 = n.f0.accept(this,argu);
        String Clause_type2 = n.f2.accept(this,argu);
        if(!Clause_type1.equals("boolean") || !Clause_type2.equals("boolean")){
            System.err.println("&& operator must be used between boolean values");
            System.exit(-1);
            return null;
        }
        return "boolean";

    }

    public String visit(CompareExpression n ,String argu){
        String Clause_type1 = n.f0.accept(this,argu);
        String Clause_type2 = n.f2.accept(this,argu);
        if(!Clause_type1.equals("int") || !Clause_type2.equals("int")){
            System.err.println("< operator must be used between integer values");
            System.exit(-1);
            return null;
        }
        return "boolean";
    }

    public String visit(PlusExpression n ,String argu){
        String Clause_type1 = n.f0.accept(this,argu);
        String Clause_type2 = n.f2.accept(this,argu);
        if(!Clause_type1.equals("int") || !Clause_type2.equals("int")){
            System.err.println("+ operator must be used between integer values");
            System.exit(-1);
            return null;
        }
        return "int";
    }

    public String visit(MinusExpression n ,String argu){
        String Clause_type1 = n.f0.accept(this,argu);
        String Clause_type2 = n.f2.accept(this,argu);
        if(!Clause_type1.equals("int") || !Clause_type2.equals("int")){
            System.err.println("- operator must be used between integer values");
            System.exit(-1);
            return null;
        }
        return "int";
    }

    public String visit(TimesExpression n ,String argu){
        String Clause_type1 = n.f0.accept(this,argu);
        String Clause_type2 = n.f2.accept(this,argu);
        if(!Clause_type1.equals("int") || !Clause_type2.equals("int")){
            System.err.println("* operator must be used between integer values");
            System.exit(-1);
            return null;
        }
        return "int";
    }

    public String visit(ArrayLength n , String argu){
        String expr_type = n.f0.accept(this,argu);
        if(!expr_type.contains("[]")){
            System.err.println("length field cannot apply to non-array types");
            System.exit(-1);
            return null;
        }
        return expr_type.replace("[]", "");
    }

    public String visit(MessageSend n,String argu){
        String given_class = n.f0.accept(this,argu);
        String method_name = n.f2.accept(this,null);
        String method_type = n.f2.accept(this,given_class);
        String given_args = "";
        
        if(n.f4.present()){
            given_args=n.f4.accept(this, argu);
        }
        StringBuilder actual_args = new StringBuilder();
        for(int i=2;i<method_type.split(" ").length;i++){
            if(i==2){
                actual_args.append(method_type.split(" ")[i]);
            }else{
                actual_args.append(" ");
                actual_args.append(method_type.split(" ")[i]);
            }
        }
     //   System.out.println("Actual: "+ actual_args.toString());
      //  System.out.println("Given: "+ given_args);
        String ret_type = method_type.split(" ")[1];
        if(!Global.checkArguements(actual_args.toString().split(" "), given_args.split(" "))){
            System.err.println("Method call: " + method_name + " - wrong arguements! expected "+actual_args.toString()+" got "+given_args);
            System.exit(-1);
            return null;
        }

        return ret_type;
    }

    public String visit(ExpressionList n , String argu){
        String ret = n.f0.accept(this,argu);
        if(n.f1 != null){
            ret += n.f1.accept(this,argu);
        }
        return ret;
    }

    public String visit(ExpressionTail n , String argu){
        StringBuilder ret = new StringBuilder();
        for(Node node : n.f0.nodes){
            ret.append(" "+node.accept(this,argu));
        }
        return ret.toString();
    }

    public String visit(ExpressionTerm n , String argu){
        return n.f1.accept(this,argu);
    }


    public String visit(BracketExpression n , String argu){
        return n.f1.accept(this,argu);
    }

    public String visit(NotExpression n , String argu){
        return n.f1.accept(this,argu);
    }
   
    public String visit(AssignmentStatement n , String argu){
        String identifier_type = n.f0.accept(this,argu);
        String expression_type = n.f2.accept(this,argu);
        //if(!identifier_type.equals(expression_type) && !identifier_type.equals(Global.getParentClass(expression_type))){
        if(!Global.isSubtype(identifier_type,expression_type)){
            System.err.println("Assignment of invalid type expected " + identifier_type + " got " + expression_type);
            System.exit(-1);
            return null;
        }
       return null;
        // return identifier_type;
    }
    
    public String visit(ArrayAssignmentStatement n , String argu){
        String identifier_type = n.f0.accept(this,argu);
        String index_type = n.f2.accept(this,argu);
        String expression_type = n.f5.accept(this,argu);
        if(!index_type.equals("int")){
            System.err.println("Index should be of integer type , got "+ index_type);
            System.exit(-1);
            return null;
        }
        if(!identifier_type.contains("[]")){
            System.err.println("Array assignment in non-array type ,got "+ identifier_type + " instead");
            System.exit(-1);
            return null;
        }
        //probably here?
        if(!expression_type.equals(identifier_type.replace("[]", ""))){
            System.err.println("Array type incompatible with assignment element");
            System.exit(-1);
            return null;
        }
        return null;
        //return identifier_type.replace("[]", "");
    }

    public String visit(IfStatement n , String argu){
        String expression_type = n.f2.accept(this,argu);
        n.f4.accept(this,argu);
        n.f6.accept(this,argu);
        if(!expression_type.equals("boolean")){
            System.err.println("If statement expects boolean type expression");
            System.exit(-1);
            return null;
        } 
        return null;
    }

    public String visit(WhileStatement n , String argu){
        String expression_type = n.f2.accept(this,argu);
        n.f4.accept(this,argu);
        if(!expression_type.equals("boolean")){
            System.err.println("While statement expects boolean type expression");
            System.exit(-1);
            return null;
        } 
        return null;
    }

    public String visit(PrintStatement n , String argu){
        String expression_type = n.f2.accept(this,argu);
        if(!expression_type.equals("int")){
            System.err.println("Print statement expects integer type expression");
            System.exit(-1);
            return null;
        } 
        return null;
    }
    
}
