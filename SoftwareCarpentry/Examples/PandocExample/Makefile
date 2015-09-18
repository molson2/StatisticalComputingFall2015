# Demonstrate some different output forms for markdown

OBJS=example.pdf example.tex example.html exampleBeamer.pdf
DEP=example.md

all: $(OBJS)

example.pdf: $(DEP)
	pandoc $(DEP) --variable 'geometry:margin=1in' -o example.pdf

example.tex: $(DEP)
	pandoc -s $(DEP) -o example.tex

example.html: $(DEP)
	pandoc $(DEP) -s --highlight-style pygments -c matt.css -o example.html --mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML

exampleBeamer.pdf: $(DEP)
	pandoc -t beamer $(DEP) -o exampleBeamer.pdf

clean:
	rm example.pdf example.tex example.html exampleBeamer.pdf

.PHONY: all clean
