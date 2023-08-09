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
ARGS3=10 10 0 10 0 10 0.8

$(BINDIR)/%.class:$(SRCDIR)/%.java
	$(JAVAC) $ -d $(BINDIR)/ -cp $(SRCDIR)*.java $(JFLAGS) $<

CLASSES=*.class \

CLASS_FILES=$(CLASSES:%.class=$(BINDIR)/%.class)

default: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR) 

run: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS)

run_m: $(CLASS_FILES)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)

run_p: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS)

run_tests: $(CLASS_FILES)
	@echo "Test 1"
	@echo "---------------------------"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS)
	@echo "---------------------------"
	@echo "Test 2"
	@echo "---------------------------"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS2)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS2)
	@echo "---------------------------"
	@echo "Test 3"
	@echo "---------------------------"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS3)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS3)

clean:
	rm -r bin/*