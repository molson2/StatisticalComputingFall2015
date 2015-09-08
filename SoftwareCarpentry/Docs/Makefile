# Rule to build html files from markdown

all: softwareCarpentry.html

%.html: %.md
	pandoc $< -s --highlight-style pygments -c pandoc.css --toc -o $@

clean:
	rm *.html *~

.PHONY: clean all
