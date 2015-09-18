# Rule to build html files from markdown

OBJS=softwareCarpentry.html gitCommands.html

all: $(OBJS)

softwareCarpentry.html: softwareCarpentry.md
	pandoc $< -s --highlight-style pygments -c new.css --toc --toc-depth=1 -o $@

gitCommands.html: gitCommands.md
	pandoc $< -s --highlight-style pygments -c new.css -o $@

clean:
	rm *.html *~

.PHONY: clean all
