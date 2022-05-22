import java.util.*;



public class Global {
    public static SymbolTable ST=new SymbolTable();

    private static Integer RegisterCounter=1;

    public static void resetRegisterCounter(){
        RegisterCounter=1;
    }

    public static String getTempRegister(){
        String register = "%"+RegisterCounter;
        RegisterCounter++;
        return register;
    }

    public static LinkedHashMap<String,LinkedHashMap<String,Integer>> fieldoffsets = new LinkedHashMap<String,LinkedHashMap<String,Integer>>();
    public static LinkedHashMap<String,LinkedHashMap<String,Integer>> methodoffsets = new LinkedHashMap<String,LinkedHashMap<String,Integer>>();
    public static HashMap<String,String> evaluated_expression =  new HashMap<String,String>();

    public static String getMethodType(String methodname,String classname){
        String type;
        String current_class = classname;
        while((type = Global.ST.lookup(methodname).get(current_class))==null){
            current_class = getParentClass(current_class);
        }
        return type.replace("METHOD: ", "");
    }

    public static String getFieldType(String fieldname , String classname){
        String type;
        String current_class =  classname;
        while((type = Global.ST.lookup(fieldname).get(current_class))==null){
            current_class = getParentClass(current_class);
        }
        return type;
    }

    public static HashMap<String,int[]> lastoffsetmap=new HashMap<String,int[]>();

    public static boolean isSubtype(String type1, String type2){
        if(type2.equals(type1)){
            return true;
        }
        String temp = type1;
        while(!(temp.equals(getParentClass(temp)))){
            temp = getParentClass(temp);
            if(temp.equals(type2)){
                return true;
            }
        }
        return false;
    }

    

    public static String getParentClass(String type){
        if(Global.ST.originalkeySet().contains(type)){
            LinkedHashMap<String,String> value = Global.ST.lookup(type);
            String subtype = value.get("CLASS");
            return subtype.replace("SUBCLASS: ", "");
        }
        return type;
    }
    public static boolean checkArguements(String[] args1, String[] args2){
        if(args1.length!=args2.length){
            System.out.println("Wrong number of args!");
            return false;
        }
        for(int i=0;i<args1.length;i++){
            if(Global.isSubtype(args2[i],args1[i])){
                continue;
            }else{
                System.out.println("Expected "+ args1[i] + " got " + args2[i]);
                return false;
            }
        }
        return true;
    }
}

 class SymbolTable {
    public ScopeTable table;
    public ScopeTable original;
    public SymbolTable() {
        this.table = new ScopeTable();
        this.original = this.table;
    }
    public void insert(String name,LinkedHashMap<String,String> value){
         this.table.insert(name, value);
    }
    public Set<String> keySet(){
        return table.current.keySet();
    }
    public Set<String> originalkeySet(){
        return original.current.keySet();
    }

    public LinkedHashMap<String,String> lookup(String name){
        return table.lookup(name);
    }
    public void print(){
        this.resetToRoot();
        System.out.println("=====================");
        ScopeTable next = table;
        ScopeTable temp;
        while(next!=null){
            next.print();
            temp=next.nextChild();
            if(temp==null){
                next=next.exit();
                if(next==null){
                    return;
                }
                next=next.nextChild();
            }else{
                next=temp;
            }
        }
        
        this.resetToRoot();
    }
    public void enter(){
        this.table=this.table.enter();
    }
    public void exit(){
        this.table=this.table.exit();
    }
    public void resetToRoot(){
        //after the symbol table has been filled by the first visitor we use this to get back to the root of the tree
        //so that the typechecker visitor can traverse it with nextChild.
        //bad implementation i know 
        this.table=this.original;
        this.table.reset();
    }
    public void nextChild(){
        this.table=this.table.nextChild();
    }
}


class ScopeTable{
    LinkedHashMap<String,LinkedHashMap<String,String>> current;
    ArrayList<ScopeTable> children;
    protected int current_child=0;
    ScopeTable prev;
    public ScopeTable(){
        this.current =  new LinkedHashMap<String,LinkedHashMap<String,String>>();
        this.children = new ArrayList<ScopeTable>();
        this.prev=null;
    }
    public ScopeTable(ScopeTable previous){
        this.current =  new LinkedHashMap<String,LinkedHashMap<String,String>>();
        this.children = new ArrayList<ScopeTable>();
        this.prev=previous;
    }

    public void reset(){
        this.current_child =0;
        for(int i=0;i<children.size();i++){
            children.get(i).reset();
        }
    }
    public void insert(String name, LinkedHashMap<String,String> value) {
        if(current.get(name)!=null){
            for(String classname:value.keySet()){
                if(current.get(name).keySet().contains(classname)){
                    // this is where we would catch method - field overloading but i cant support it the way ive structured the typechecker, ill take the loss
                    System.err.println("SYMBOL REDEFINITION (sadly i dont support field-method overloading)");
                    System.exit(-1);
                }
            }
            for(String s:value.keySet()){
                current.get(name).put( s,value.get(s));

            }
            return;
        }else{
            this.current.put(name, value);
            return ;
        }
    }
    public LinkedHashMap<String,String> lookup(String name){
        ScopeTable temp=new ScopeTable(this);
        LinkedHashMap<String,String> ret=temp.current.get(name);
        while(ret==null){
            temp=temp.exit();
            if(temp==null){
              //  System.out.println("Error: name not found");
                return null;
            }
            ret = temp.current.get(name);
        }
        return ret;
    }
    public ScopeTable enter(){
        //enter creates an new sub-table at current node and returns it
        this.children.add(new ScopeTable(this));
        return this.children.get(this.children.size()-1);
    }

    public ScopeTable nextChild(){
        // identical to enter but traverses the table instead of creating new ones
        if(current_child > this.children.size()-1){
           // System.out.println("No new child");
           current_child=0;
            return null;
        }else{
            return this.children.get(current_child++);
        }

    }

    public ScopeTable exit(){
        //exit returns to parent node, if parent node is null we are at the top level scope table and 
        //we return null

        if(this.prev!=null){
            return this.prev;
        }
        else{
            //add exception?
           // System.out.println("Exit at Root null returned");
            return null;
        }
    }

    public void print(){
        for(String name:current.keySet()){
            LinkedHashMap<String,String> temp = current.get(name);
            for(String classname:temp.keySet()){
                String type = temp.get(classname);
                System.out.println(name + " " + classname + " " + type);
            }
        }
        System.out.println("=====================");
    }
}
