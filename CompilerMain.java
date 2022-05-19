import syntaxtree.*;
import java.io.*;

public class CompilerMain {
    public static void main (String [] args) throws Exception{
    if(args.length != 1){
        System.err.println("Usage: java Main <inputFile>");
        System.exit(1);
    }
    FileInputStream fis = null;
    try{
        fis = new FileInputStream(args[0]);
        MiniJavaParser parser = new MiniJavaParser(fis);
        Goal root = parser.Goal();
       // System.err.println("Program parsed successfully.");
        
        SymbolTableVisitor symboltablevisitor = new SymbolTableVisitor();
        root.accept(symboltablevisitor, null);
     //   System.err.println("Symbol table filled successfully");
        
      //  Global.ST.print();
        Global.ST.resetToRoot();
        TypeCheckVisitor typechecker = new TypeCheckVisitor();
        root.accept(typechecker,null);
     //   System.err.println("Typechecker successful");
        Global.ST.resetToRoot();
        VtableVisitor vtableVisitor = new VtableVisitor();
        root.accept(vtableVisitor,null);
    }
    catch(ParseException ex){
        System.out.println(ex.getMessage());
    }
    catch(FileNotFoundException ex){
        System.err.println(ex.getMessage());
    }
    finally{
        try{
        if(fis != null) fis.close();
        }
        catch(IOException ex){
        System.err.println(ex.getMessage());
        }
    }
    }
}
