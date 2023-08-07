#Parallel Computing make file
#Noah Gonsenhauser
#11/04/2023


JAVAC=/usr/bin/javac
JAVA=/usr/bin/java
JAVADOC=/usr/bin/javadoc
JFLAGS= -g

.SUFFIXES: .java .class
SRCDIR=src/*/
BINDIR=bin
DOCDIR=doc
ARGS=1000 1000 -1000 1000 -1000 1000 0.8
ARGS2=1000 1000 -1000 1000 -1000 1000 0.4
ARGS3=10 10 -10 10 -10 10 0.8

$(BINDIR)/%.class:$(SRCDIR)/%.java
	$(JAVAC) $ -d $(BINDIR)/ -cp $(SRCDIR)*.java $(JFLAGS) $<

CLASSES=*.class \

CLASS_FILES=$(CLASSES:%.class=$(BINDIR)/%.class)

default: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR) 

clean:
	rm -r $(BINDIR)/*
#	rm -r $(DOCDIR)/*

run: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)
	$(JAVA) -cp bin ParallelVersion.ParallelMinimization $(ARGS)

run_only:
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)

run_tests: $(CLASS_FILES)
	@echo "Test 1"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)
	$(JAVA) -cp bin ParallelVersion.ParallelMinimization $(ARGS)
	@echo "Test 2"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS2)
	$(JAVA) -cp bin ParallelVersion.ParallelMinimization $(ARGS2)
	@echo "Test 3"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS3)
	$(JAVA) -cp bin ParallelVersion.ParallelMinimization $(ARGS3)

run_p: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.ParallelMinimization $(ARGS)