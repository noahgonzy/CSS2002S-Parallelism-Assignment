#Parallel Computing make file
#Noah Gonsenhauser
#11/04/2023


JAVAC=/usr/bin/javac
JAVA=/usr/bin/java
JAVADOC=/usr/bin/javadoc
JFLAGS= -g

.SUFFIXES: .java .class
SRCDIR=src/MonteCarloMini/
BINDIR=bin
DOCDIR=doc
ARGS=1000 1000 500 500 500 500 0.8

$(BINDIR)/%.class:$(SRCDIR)/%.java
	$(JAVAC) $ -d $(BINDIR)/ -cp $(SRCDIR)*.java $(JFLAGS) $<

CLASSES=MonteCarloMinimization.class Search.class TerrainArea.class \

CLASS_FILES=$(CLASSES:%.class=$(BINDIR)/%.class)

default: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR) 

clean:
	rm $(BINDIR)/MonteCarloMini/*.class
#	rm -r $(DOCDIR)/*

run: $(CLASS_FILES)
#	$(JAVADOC) $(SRCDIR)/*.java -d $(DOCDIR)
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)

run_only:
	$(JAVA) -cp bin MonteCarloMini.MonteCarloMinimization $(ARGS)

run_tests:
	@echo "nothing yet"