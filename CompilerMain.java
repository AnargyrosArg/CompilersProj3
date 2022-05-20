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
        

        SymbolTableVisitor symboltablevisitor = new SymbolTableVisitor();
        root.accept(symboltablevisitor, null);

        Global.ST.resetToRoot();
        TypeCheckVisitor typechecker = new TypeCheckVisitor();
        root.accept(typechecker,null);
        
        Global.ST.resetToRoot();
        VtableVisitor vtableVisitor = new VtableVisitor();
        root.accept(vtableVisitor,null);

        Global.ST.resetToRoot();
        IntermediateCodeVisitor intermediateCodeVisitor = new IntermediateCodeVisitor();
        root.accept(intermediateCodeVisitor,null);
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
