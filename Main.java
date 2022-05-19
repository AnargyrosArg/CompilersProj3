import java.util.*;
import java.io.*;

public class Main {

    public static void main(String[] args) {
        for(String s:args){
            try {
                System.out.println("=========================== File: "+s+" ===========================");
                Process process = Runtime.getRuntime().exec("java CompilerMain "+s);
                int ret_val =process.waitFor();
                if(ret_val==255 || ret_val == -1){
                    BufferedReader stdErr =  new BufferedReader(new InputStreamReader(process.getErrorStream()));
                    String string = null;
                    while ((string = stdErr.readLine()) != null) {
                        System.out.println(string);
                    }
                    System.out.println("Error occured while typechecking file "+ s +" return value: "+ret_val);
                }else{
                    
                    BufferedReader stdInput = new BufferedReader(new InputStreamReader(process.getInputStream()));
                    String string = null;
                    while ((string = stdInput.readLine()) != null) {
                        System.out.println(string);
                    }
                }
             } catch (Exception ex) {
                ex.printStackTrace();
             }
        }
        System.out.println("==============================================================================");
    }
 }