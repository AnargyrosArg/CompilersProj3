import visitor.GJDepthFirst;
import syntaxtree.*;
import java.util.*;


public class VtableVisitor extends GJDepthFirst<String,String>{



    public String visit(MainClass n,String argu){
        System.out.print("declare i8* @calloc(i32, i32)\n"+
        "declare i32 @printf(i8*, ...)\n"+
        "declare void @exit(i32)\n\n"+
        "@_cint = constant [4 x i8] c\"%d\\0a\\00\"\n"+
        "@_cOOB = constant [15 x i8] c\"Out of bounds\\0a\\00\"\n"+
        "define void @print_int(i32 %i) {\n"+
        "   %_str = bitcast [4 x i8]* @_cint to i8*\n"+
        "   call i32 (i8*, ...) @printf(i8* %_str, i32 %i)\n"+
        "   ret void\n"+
        "   }\n"+
        
        "define void @throw_oob() {\n"+
        "%_str = bitcast [15 x i8]* @_cOOB to i8*\n"+
        "   call i32 (i8*, ...) @printf(i8* %_str)\n"+
        "   call void @exit(i32 1)"+
        "   ret void\n"+
        "   }\n");
        System.out.println("%.BooleanArrayType = type { i32 , i1*}");
        System.out.println("%.IntArrayType = type { i32 , i32*}");
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
        String classname = n.f1.f0.tokenImage;
        Set<String> fields = Global.fieldoffsets.get(classname).keySet();
        StringBuilder typeBuilder = new StringBuilder("%class."+classname+" = type { i8* ,");

        for(String field:fields){
            String fieldtype = Global.getFieldType(field.replace(classname+".", ""),classname);

            if(fieldtype.equals("int")){
                typeBuilder.append("i32 ,");
            }else if(fieldtype.equals("boolean")){
                typeBuilder.append("i1 ,");
            }else if(fieldtype.equals("boolean[]")){
                typeBuilder.append("%.BooleanArrayType ,");
            }else if(fieldtype.equals("int[]")){
                typeBuilder.append("%.IntArrayType ,");
            }else{
                typeBuilder.append("i8* ,");
            }
            
        }
        
        typeBuilder.replace(typeBuilder.length()-2, typeBuilder.length(), "}");
        System.out.println(typeBuilder);
        Set<String> methods = Global.methodoffsets.get(classname).keySet();
        if(methods.size()!=0){
        System.out.print("@."+classname+"_vtable = global ["+ methods.size()+"x i8*] [");
        String vtable_decl = "";
    
        for(String method:methods){
            String methodtype =  Global.getMethodType(method.replace(classname+".", ""), classname);
            vtable_decl = vtable_decl.concat("i8* bitcast (");
            String type = "";
            if(methodtype.split(" ")[0].equals("int")){
                type=type.concat("i32 (i8*");
            }else if(methodtype.split(" ")[0].equals("boolean")){
                type=type.concat("i1 (i8*");
            }else if(methodtype.split(" ")[0].equals("int[]")){
                type=type.concat("%.IntArrayType (i8*");
            }else if(methodtype.split(" ")[0].equals("boolean[]")){
                type=type.concat("%.BooleanArrayType (i8*");
            }else{
                type = type.concat("%class."+methodtype.split(" ")[0] + "(i8*");
            }
            for(int i=1;i<methodtype.split(" ").length;i++){
                if(methodtype.split(" ")[i].equals("int")){
                    type=type.concat(",i32 ");
                }else if(methodtype.split(" ")[i].equals("boolean")){
                    type=type.concat(",i1 ");
                }else if(methodtype.split(" ")[i].equals("int[]")){
                    type = type.concat(",%.IntArrayType ");
                }
                else if(methodtype.split(" ")[i].equals("boolean[]")){
                    type = type.concat(",%.BooleanArrayType ");
                }
                else{
                    type=type.concat(",%class."+methodtype.split(" ")[i]+" ");
                }
            }
            // if(methodtype.split(" ").length!=1){
            //     type = type.substring(0,type.length()-2);
            // }
            type = type.concat(")*");
            vtable_decl = vtable_decl.concat(type+" @"+method+ " to i8*),\n");
        }
        
            vtable_decl = vtable_decl.substring(0,vtable_decl.length()-2);
            vtable_decl = vtable_decl.concat("]");
            System.out.println(vtable_decl + "\n");
        }else{
            System.out.println("@."+classname+"_vtable = global [0 x i8*] []");
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
        String classname = n.f1.f0.tokenImage;
        Set<String> fields = Global.fieldoffsets.get(classname).keySet();
        StringBuilder typeBuilder = new StringBuilder("%class."+classname+" = type { i8* ,");

        for(String field:fields){
            field  = field.subSequence(field.indexOf(".", 0)+1, field.length()).toString();
            String fieldtype = Global.getFieldType(field.replace(classname+".", ""),classname);
            if(fieldtype.equals("int")){
                typeBuilder.append("i32 ,");
            }else if(fieldtype.equals("boolean")){
                typeBuilder.append("i1 ,");
            }else if(fieldtype.equals("boolean[]")){
                typeBuilder.append("%.BooleanArrayType ,");
            }else if(fieldtype.equals("int[]")){
                typeBuilder.append("%.IntArrayType ,");
            }else{
                typeBuilder.append("i8* ,");
            }
            
        }
        typeBuilder.replace(typeBuilder.length()-2, typeBuilder.length(), "}");
        System.out.println(typeBuilder);
        Set<String> methods = Global.methodoffsets.get(classname).keySet();
        if(methods.size()!=0){
        System.out.print("@."+classname+"_vtable = global ["+ methods.size()+"x i8*] [");
        String vtable_decl = "";
        
        for(String method:methods){
            String methodname = method.substring(method.indexOf(".", 0)+1);
            String methodtype =  Global.getMethodType(methodname, classname);
            vtable_decl = vtable_decl.concat("i8* bitcast (");
            String type = "";
            if(methodtype.split(" ")[0].equals("int")){
                type=type.concat("i32 (i8*");
            }else if(methodtype.split(" ")[0].equals("boolean")){
                type=type.concat("i1 (i8*");
            }else if(methodtype.split(" ")[0].equals("int[]")){
                type=type.concat("%.IntArrayType (i8*");
            }else if(methodtype.split(" ")[0].equals("boolean[]")){
                type=type.concat("%.BooleanArrayType (i8*");
            }else{
                type = type.concat("%class."+methodtype.split(" ")[0] + "(i8*");
            }
            for(int i=1;i<methodtype.split(" ").length;i++){
                if(methodtype.split(" ")[i].equals("int")){
                    type=type.concat(",i32 ");
                }else if(methodtype.split(" ")[i].equals("boolean")){
                    type=type.concat(",i1 ");
                }
                else if(methodtype.split(" ")[i].equals("boolean[]")){
                    type=type.concat(",%.BooleanArrayType ");
                }
                else if(methodtype.split(" ")[i].equals("int[]")){
                    type=type.concat(",%.IntArrayType ");
                }
                else{
                    type=type.concat(",%class."+methodtype.split(" ")[i]+" ");
                }
            }
            // if(methodtype.split(" ").length!=1){
            //     type = type.substring(0,type.length()-2);
            // }    
            type = type.concat(")*");
            //if method is also defined within current class override it at the vtable
            if(Global.ST.lookup(methodname).get(classname)!=null){
                method =  (classname+".").concat(methodname);
            }
            vtable_decl = vtable_decl.concat(type+" @"+method+ " to i8*),\n");
        }
        vtable_decl = vtable_decl.substring(0,vtable_decl.length()-2);
        vtable_decl = vtable_decl.concat("]");
        System.out.println(vtable_decl + "\n");
    }else{
        System.out.println("@."+classname+"_vtable = global [0 x i8*] []");
    }
        return null;
    }




}
