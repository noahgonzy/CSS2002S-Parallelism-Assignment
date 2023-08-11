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

$(BINDIR)/%.class:$(SRCDIR)/%.java
	$(JAVAC) $ -d $(BINDIR)/ -cp $(SRCDIR)*.java $(JFLAGS) $<

CLASSES=*.class \

CLASS_FILES=$(CLASSES:%.class=$(BINDIR)/%.class)

default: $(CLASS_FILES)

run: $(CLASS_FILES)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS)

run_s: $(CLASS_FILES)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)

run_p: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS)

run_test: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.Testing
	$(JAVA) -cp bin MonteCarloMini.Testing

run_test_p: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.Testing

run_test_s: $(CLASS_FILES)
	$(JAVA) -cp bin MonteCarloMini.Testing

clean:
	rm -r bin/*
	rm -r Results/*