import java.io.IOException;
import java.io.FileReader;

import bnfc.cpp.Absyn.*;

import bnfc.cpp.Yylex;
import bnfc.cpp.parser;

class Main {
    public static void main(String[] args) {
        Yylex l;
        parser p;
        if (args.length != 1) {
            System.err.println("icpp: expected source file as argument");
            System.err.println("usage: ccpp <source file>");
            System.exit(1);
        }
        try {
            FileReader input = new FileReader(args[0]);
            l = new Yylex(input);
            p = new parser(l, l.getSymbolFactory());
            bnfc.cpp.Absyn.PDefs ast;
            ast = (PDefs) p.pProgram();
            
            // Successful parse! Type check and compile here
            System.out.println("not implemented!");

        } catch (IOException e) {
            System.err.println("i/o error! oh no!");
            System.exit(1);
        } catch (Throwable e) {
            System.err.println("error!");
            e.printStackTrace();
            System.exit(1);
        }
    }
}