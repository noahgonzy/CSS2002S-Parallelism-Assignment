#Parallel Computing make file
#Noah Gonsenhauser
#11/04/2023

#this is setup for the java compiler
JAVAC=/usr/bin/javac
JAVA=/usr/bin/java
JAVADOC=/usr/bin/javadoc
JFLAGS= -g

.SUFFIXES: .java .class
SRCDIR=src/*/
BINDIR=bin
DOCDIR=doc

#these are the arguments for the program to run when running "make run"
ARGS=1000 1000 -1000 1000 -1000 1000 0.8

#compiling all java programs into their class files
$(BINDIR)/%.class:$(SRCDIR)/%.java
	$(JAVAC) $ -d $(BINDIR)/ -cp $(SRCDIR)*.java $(JFLAGS) $<

CLASSES=*.class \

CLASS_FILES=$(CLASSES:%.class=$(BINDIR)/%.class)

default: $(CLASS_FILES)

#this will run both the Serial and Parallel versions of the program
run: $(CLASS_FILES)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS)

#this will run only the serial program
run_s: $(CLASS_FILES)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)

#this will run only the parallel program
run_p: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS)


#this will run the testing program for both programs in each package and write results to the "Results" Folder
run_tests: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.Testing
	$(JAVA) -cp bin MonteCarloMini.Testing

#this runs only the testing program for the parallel program
run_test_p: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.Testing


#this runs only the testing program for the serial program
run_test_s: $(CLASS_FILES)
	$(JAVA) -cp bin MonteCarloMini.Testing

#this will clean the bin folder and results folder of any results or class files
clean:
	rm -r bin/*
	rm -r Results/*