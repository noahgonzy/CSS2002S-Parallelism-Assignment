#Parallel Computing make file
#Noah Gonsenhauser
#11/04/2023


JAVAC=/usr/bin/javac
JAVA=/usr/bin/java
JAVADOC=/usr/bin/javadoc


.SUFFIXES: .java .class
SRCDIR=src/MonteCarloMini
BINDIR=bin/MonteCarloMini
DOCDIR=doc

#This code compiles the java files into class files and puts them in the bin directory
$(BINDIR)/%.class:$(SRCDIR)/%.java
	$(JAVAC) -d $(BINDIR)/ -cp $(BINDIR) $<

#this points the make file to what the classes are that will be compiles
CLASSES=MonteCarloMinimization.class Search.class TerrainArea.class  \

#This creates a substitution reference which will produce a list of file names with the same names but with the directory prefix
CLASS_FILES=$(CLASSES:%.class=$(BINDIR)/%.class)

#this runs CLASS_FILES and generates javadocs by default when run without a parameter
default: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR) 

#this removes all files from the bin directory and the document directory
clean:
	rm $(BINDIR)/*.class
	rm -r $(DOCDIR)/*

#this runs the same commands as default when run, but also runs the TokTik program
run: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR)
	$(JAVA) -cp MonteCarloMinimization 