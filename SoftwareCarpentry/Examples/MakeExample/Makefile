# Create report for regression example

# Some syntax for telling Make that "all" and "clean" are names of rules rather
# than files
.PHONY: all clean

all: report.pdf

# Rule for creating the final report: the dependencies are report.tex, params.csv,
# linePlot.pdf, and simulate.R
report.pdf: report.tex params.csv linePlot.pdf
	pdflatex report.tex

# Rule for creating linePlot.pdf: dependancies are simulate.R params.csv
linePlot.pdf: simulate.R params.csv
	R CMD BATCH simulate.R

# "make clean" will provide some clean-up
clean:
	rm *.log *.aux Rplots.pdf *.Rout *~ report.pdf linePlot.pdf


