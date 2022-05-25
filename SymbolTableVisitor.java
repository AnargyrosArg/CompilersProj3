import java.util.*;


import syntaxtree.*;
import visitor.GJDepthFirst;

public class SymbolTableVisitor extends GJDepthFirst<String[],String[]>{
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
     public String[] visit(MainClass n, String[] argu){
        String classname = n.f1.accept(this, null)[0];
       //System.out.println(classname + "." +"main : 0" );
       //System.out.println("MainClass: "+ classname);
        LinkedHashMap<String,String> class_entry_value = new LinkedHashMap<String,String>();
        class_entry_value.put( "CLASS" , "CLASS");
        Global.ST.insert(classname, class_entry_value);
        Global.ST.enter();                                  //ENTER SCOPE
        for(Node node: n.f14.nodes){
            String temp = node.accept(this,null)[0];
            String Type=temp.split(" ")[0];
            String Name= temp.split(" ")[1];
            LinkedHashMap<String,String> value = new LinkedHashMap<String,String>();
            value.put(classname,Type);
            Global.ST.insert(Name, value);
        }
        LinkedHashMap<String,String> value = new LinkedHashMap<String,String>();
        value.put(classname, "String[] (main class args, this should never be used)");
        Global.ST.insert(n.f11.accept(this,null)[0], value);
        Global.ST.exit();                                   //EXIT SCOPE
        Global.fieldoffsets.put(classname, new LinkedHashMap<>());
        return new String[]{"Class: "+ classname};
    }

  

     /**
    * f0 -> "class"
    * f1 -> Identifier()
    * f2 -> "{"
    * f3 -> ( VarDeclaration() )*
    * f4 -> ( MethodDeclaration() )*
    * f5 -> "}"
    */
    public String[] visit(ClassDeclaration n,  String[] argu) {
        String classname = n.f1.accept(this, null)[0];
        int fieldoffset =0;
        int methodoffset =0;
        LinkedHashMap<String,Integer> current_field_offsets = new LinkedHashMap<String,Integer>();
        LinkedHashMap<String,Integer> current_method_offsets = new LinkedHashMap<String,Integer>();

      //  System.out.println("Class: "+ classname);
        LinkedHashMap<String,String> class_entry_value = new LinkedHashMap<String,String>();
        class_entry_value.put( "CLASS" , "CLASS");
        Global.ST.insert(classname, class_entry_value);
        for(Node node: n.f3.nodes){
            String temp = node.accept(this,null)[0];
            String Type=temp.split(" ")[0];
            String Name= temp.split(" ")[1];
            LinkedHashMap<String,String> value = new LinkedHashMap<String,String>();
            value.put(classname,Type);
            Global.ST.insert(Name, value);
            //System.out.println(classname+"."+Name +" : "+ fieldoffset);
            current_field_offsets.put(classname+"."+Name, fieldoffset);
            if(Type.equals("int")){
                fieldoffset += 4;
            }else if(Type.equals("boolean")){
                fieldoffset += 1;
            }else{
                fieldoffset += 8;
            }
        }
         for(Node node: n.f4.nodes){
            String[] temp = node.accept(this,new String[]{classname});
            String methodname =  temp[0];
            String Type = temp[1];
            LinkedHashMap<String,String> value = new LinkedHashMap<String,String>();
            value.put(classname,Type);
            Global.ST.insert(methodname, value);
            //System.out.println(classname+"."+methodname +" : "+ methodoffset);
            current_method_offsets.put(classname+"."+methodname, methodoffset);
            methodoffset += 8;
            
        }
        Global.lastoffsetmap.put(classname, new int[]{fieldoffset,methodoffset});
        Global.fieldoffsets.put(classname, current_field_offsets);
        Global.methodoffsets.put(classname, current_method_offsets);

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
    public String[] visit(ClassExtendsDeclaration n, String[] argu) {
        String classname = n.f1.accept(this, null)[0];
        String extendname =  n.f3.accept(this,null)[0];
        LinkedHashMap<String,String> value = new LinkedHashMap<String,String>();
        if((value=Global.ST.lookup(extendname))==null){
            System.err.println("Error:Parent class undefined!");
            System.exit(-1);
        }else if(!value.keySet().contains("CLASS")){
            System.err.println("Error:Parent class undefined!");
            System.exit(-1);
        }
        // int fieldoffset = 0;
        // int methodoffset =0;
        // for(String key: Global.ST.keySet() ){
        //     value = Global.ST.lookup(key);
        //     if(value.keySet().contains(extendname)){
        //         String Type = value.get(extendname);
        //         if(Type.contains("METHOD")){
        //             methodoffset += 8;
        //         }else{
        //             if(Type.equals("int")){
        //                 fieldoffset += 4;
        //             }else if(Type.equals("boolean")){
        //                 fieldoffset += 1;
        //             }else{
        //                 fieldoffset += 8;
        //             }
        //         }
        //     }
        // }
        int fieldoffset = Global.lastoffsetmap.get(extendname)[0];
        int methodoffset = Global.lastoffsetmap.get(extendname)[1];
        //get parent offsets
        LinkedHashMap<String,Integer> current_field_offsets = new LinkedHashMap<String,Integer>();
        for(String key:Global.fieldoffsets.get(extendname).keySet()){
            current_field_offsets.put(key, Global.fieldoffsets.get(extendname).get(key));
        }
        LinkedHashMap<String,Integer> current_method_offsets = new LinkedHashMap<String,Integer>();
        for(String key:Global.methodoffsets.get(extendname).keySet()){
            current_method_offsets.put(key, Global.methodoffsets.get(extendname).get(key));
        }

      //  System.out.println("Class: "+ classname);
        LinkedHashMap<String,String> class_entry_value = new LinkedHashMap<String,String>();
        class_entry_value.put( "CLASS" , "SUBCLASS: " + extendname);
        Global.ST.insert(classname, class_entry_value);
        for(Node node: n.f5.nodes){
            String temp = node.accept(this,null)[0];
            String Type=temp.split(" ")[0];
            String Name= temp.split(" ")[1];
            value = new LinkedHashMap<String,String>();
            value.put(classname,Type);
            Global.ST.insert(Name, value);
            //System.out.println(classname+"."+Name +" : "+ fieldoffset);
            current_field_offsets.put(classname+"."+Name, fieldoffset);
            if(Type.equals("int")){
                fieldoffset += 4;
            }else if(Type.equals("boolean")){
                fieldoffset += 1;
            }else{
                fieldoffset += 8;
            }
        }
         for(Node node: n.f6.nodes){
            String[] temp = node.accept(this,new String[]{classname,extendname});
            String methodname =  temp[0];
            String Type = temp[1];
            // if ( ((value=Global.ST.lookup(methodname))!=null)  && (value.keySet().contains(extendname)) &&  Type.equals(value.get(extendname))  ){
            //     //overwritten method no print or offset increase
            // }else if(((value=Global.ST.lookup(methodname))!=null)  && (value.keySet().contains(extendname)) && !Type.equals(value.get(extendname))    ){
            //     System.err.println("Duplicate method symbols with different types");
            //     System.exit(-1);
            // }
            // else{
            //     System.out.println(classname+"."+methodname +" : "+ methodoffset);
            //     methodoffset += 8;
            // }
            boolean print=true;
            if(((value=Global.ST.lookup(methodname))!=null)){
                for(String Class:value.keySet()){
                    if(Global.isSubtype(classname, Class)){
                        if(Type.equals(value.get(Class))){
                            //overwritten method
                            print=false;
                            break;
                        }else{
                            System.err.println("Duplicate method symbols with different types");
                            System.exit(-1);
                        }
                    }
                }
            }
            if(print==true){
                // System.out.println(classname+"."+methodname +" : "+ methodoffset);
                 current_method_offsets.put(classname+"."+methodname, methodoffset);
                 methodoffset += 8;
             }
            value = new LinkedHashMap<String,String>();
            value.put(classname,Type);
            Global.ST.insert(methodname, value);
        }
        Global.lastoffsetmap.put(classname, new int[]{fieldoffset,methodoffset});
        Global.fieldoffsets.put(classname, current_field_offsets);
        Global.methodoffsets.put(classname, current_method_offsets);
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
    public String[] visit(MethodDeclaration n, String[] argu) {
        Global.ST.enter();          //ENTER SCOPE
        String methodname = n.f2.accept(this, null)[0];
        String returntype = n.f1.accept(this,null)[0];
      //  System.out.println("Method: "+ methodname);
      //  System.out.println("{");
      String[] params;
      String classname = argu[0];

      String arguements = "";
        if(n.f4.present()){
           params =  n.f4.accept(this,null);
           for(String parameter:params){
                String[] temp = parameter.split(" ");
                arguements += temp[0] + " ";
                String Name =  temp[1];
                String Type = temp[0];
                LinkedHashMap<String,String> value = new LinkedHashMap<String,String>();
                value.put(classname,Type);
                Global.ST.insert(Name, value);
           }
        }else{
            params = new String[]{""};
        }
        
        for(Node node:n.f7.nodes){
            String temp = node.accept(this,null)[0];
            String Type=temp.split(" ")[0];
            String Name= temp.split(" ")[1];
            LinkedHashMap<String,String> value = new LinkedHashMap<String,String>();
            value.put(classname,Type);
            Global.ST.insert(Name, value);
        }
        Global.ST.exit();       //EXIT SCOPE
        return new String[]{methodname,"METHOD: " + returntype + " " + arguements};
    }


    /**
    * f0 -> Type()
    * f1 -> Identifier()
    * f2 -> ";"
    */
     public String[] visit(VarDeclaration n,String[] argu) {
        String type = n.f0.accept(this,null)[0];
        String name = n.f1.accept(this,null)[0];
      //  System.out.println(type + " " + name);
        return new String[]{type + " " + name};
     }

    /**
    * f0 -> Type()
    * f1 -> Identifier()
    */
    public String[] visit(FormalParameter n, String[] argu) {
        String type = n.f0.accept(this, argu)[0];
        String name = n.f1.accept(this, argu)[0];
      //  System.out.println(type + " " + name);
        return new String[]{type + " " + name};
    }



    public String[] visit(FormalParameterList n,String[] argu){        
        String[] part2;
        ArrayList<String> temp =  new ArrayList<String>();
        temp.add( n.f0.accept(this,null)[0]);
        if (n.f1 != null) {
            part2 = n.f1.accept(this, null); //formal parameter tail
        for(int i=0;i<part2.length;i++){
            temp.add(part2[i]);
        }
        String[] ret =  new String[temp.size()];
        ret = temp.toArray(ret);
        return ret;
        }else{
            return new String[]{temp.get(0)};
        }
    }


    public String[] visit(FormalParameterTail n, String[] argu){
        ArrayList<String> temp = new ArrayList<String>();
        for ( Node node: n.f0.nodes) {
            temp.add(node.accept(this, null)[0]);
        }
        String[] ret =  new String[temp.size()];
        ret= temp.toArray(ret);
        return ret;
    }

    public String[] visit(FormalParameterTerm n, String[] argu){
        return n.f1.accept(this, argu);
    }

    @Override
    public String[] visit(Identifier n, String[] argu) {
        return new String[]{n.f0.toString()};
    }
    @Override
    public String[] visit(IntegerType n, String[] argu) {
        return new String[]{"int"};
    }
    @Override
    public String[] visit(IntegerArrayType n, String[] argu) {
        return new String[]{"int[]"};
    }
    @Override
    public String[] visit(BooleanType n, String[] argu) {
        return new String[]{"boolean"};
    }
    @Override
    public String[] visit(BooleanArrayType n, String[] argu) {
        return new String[]{"boolean[]"};
     }

  

}
