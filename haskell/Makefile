## Makefile for UWYO COSC 4780/5010 Homework 5 - Haskell side
## Author: Finley McIlwaine

.PHONY : bnfc parse test test_grad install assemble clean

all: install

clean:
	rm *.class
	rm *.j
	rm ccpp

bnfc/*.hs: CPP.cf
	bnfc -m -o bnfc $^
	cd bnfc && make
bnfc: bnfc/*.hs

runtime.class: runtime.java
	javac runtime.java

ccpp: *.hs bnfc/*.hs
	cabal install exe:ccpp --installdir . --overwrite-policy=always

install: ccpp runtime.class

assemble:
	python3 ./test/Krakatau/assemble.py ./*.j

test: install bnfc
	cp runtime.class test/good/
	cp runtime.class test/bad/
	cd test && cabal -v0 run tester haskell

test_grad: install bnfc
	cp runtime.class test/good/
	cp runtime.class test/bad/
	cp runtime.class test/grad/good/
	cp runtime.class test/grad/bad/
	cd test && cabal -v0 run tester haskell grad
