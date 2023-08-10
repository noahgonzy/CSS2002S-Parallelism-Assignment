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
ARGS2=1000 1000 -1000 1000 -1000 1000 0.2
ARGS3=10 10 0 10 0 10 0.8
ARGS4=10 10 0 10 0 10 0.2
ARGS5=2 2 0 1 0 1 0.9
ARGS6=5000 5000 -100 100 -100 100 0.9

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

run_jt: $(CLASS_FILES)
	$(JAVA) -cp bin ParallelVersion.Testing

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
	@echo "---------------------------"
	@echo "Test 4"
	@echo "---------------------------"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS4)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS4)
	@echo "---------------------------"
	@echo "Test 5"
	@echo "---------------------------"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS5)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS5)
	@echo "---------------------------"
	@echo "Test 6"
	@echo "---------------------------"
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS6)
	$(JAVA) -cp bin ParallelVersion.MonteCarloMinimizationParallel $(ARGS6)

clean:
	rm -r bin/*
	rm -r Results/*