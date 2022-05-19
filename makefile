all: compile

compile:
	java -jar ./javacc_jtb/jtb132di.jar minijava.jj
	java -jar ./javacc_jtb/javacc5.jar minijava-jtb.jj
	javac CompilerMain.java
	javac Main.java

test:
	javac Main.java
	javac CompilerMain.java
	java CompilerMain Example.txt

clean:
	rm -f *.class *~
