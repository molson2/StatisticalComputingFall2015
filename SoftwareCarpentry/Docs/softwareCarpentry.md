% Software Carpentry
% Matt Olson
% September 11, 2015

# Overview #


* **Git**: keep a record of your workflow
* **Make**: automate your workflow
* **Markdown**: create flexible documents


There is no way to cover any one of these in a short time.  My hope is just to
convince you that these tools are worth knowing about (at worst), and worth
incorporating into your workflow (at best).  I want to emphasize the types of
problems that come up in everyday programming life and how these tools can help
solve them.  There are great tutorials on the web with much more depth than
what I present here, and I've provided references where appropriate.


# Git #


(See `/Docs/gitCommands.html` and `/Examples/GitExample`)


## Why Bother with Version Control: Common Scenarios ... ##


(1) You found a good model setting for some simulation results.  After playing
    around with your code and making some changes you can no longer replicate
    what you found a few days ago ...
(2) You want to try out a crazy new idea for your project without disrupting
    the "stable" work you have already done.  You copy your entire project
    into a new directory called "project_experiment" ...
(3) You are working on a paper with a co-author in Dropbox and you both try to
    modify it at the same time ...
(4) You are working on the Grid and are modifying files on the fly, and then
    copying them back and forth ...
(5) You find yourself naming files like "modelv1.R", "modelv2.R", ... or "temp",
    "old", "experimental", ...

## Git: The Conceptual Overview ##

You can think of version control as managing a collection of "snapshots" of your
project over time.  The basic workflow is as follows: create or modify some
files, `add` them to the *Staging Area*, and `commit` the files in the *Staging
Area* to create a "snapshot."  When thinking about how Git works, it is very
useful to think of working out of three directories:


(1) working directory (where you are working on files)
(2) *Staging Area* (a temporary "basket" for where you put files before you
  commit them)
(3) (what I'll call) the snapshot directory (the "place" where Git stores
  snapshots of your project)


(A figure might make this more clear ...)

You "add" files from your working directory to the *Staging Area* with the
`add` command, and you "commit" the files from the *Staging Area* to the
snapshot directory via the `commit` command.

As final note, "Github" and "git" are different objects: Github is a website
that hosts git repositories, while git is a version control system.  You can
use git profitably without ever using Github.

## Git: Examples ##

### Example 1: Using Our Repository ###

Some initializations if you've never used `git`:
```
git config --global user.name "Matt Olson"
git config --global user.email "molson5574@gmail.com"
git config --global color.ui "auto"
git config --global core.editor "emacs -w"
```

Pull the repository to your machine (you do this once - after that you "push"
and "pull" to interact with the Github repository):
```
git clone https://github.com/molson2/StatisticalComputingFall2015
```

Matt tells you that he added some new files to the repository:
```
git pull
```

Suppose you create your own tutorial in a file called `tutorial.md`.  Here are
the steps for adding it to our repository:
(MAY WANT TO REWORK ORDER OF COMMITING AND PULLING...)
```
git add tutorial.md # adds tutorial.md to stagin area
git commit -m "Added a tutorial" # creates a new commit
git pull # pulls in any new changes
git push # adds your new commit to Github
```

### Example 2: Retreiving an Old Version ###

### Example 3: Trying Out New Ideas with Branching ###

## Additional Resources ##

  * Github Book (https://git-scm.com/book/en/v2) Chapters 1-3
  * (https://www.atlassian.com/git/tutorials)
  * (http://swcarpentry.github.io/git-novice/)

# Make #

(See `/Examples/MakeExample`)

## Why Bother with Makefiles ##

You probably associate Makefiles will compiling `C++` projects, but their
usefulness extends far beyond this.  Makefiles are useful in any software project
in which the "final product" depends on the results of other files, functions, or
scripts.  At their core, they manage the dependencies between the files needed to
build your final product.  For example, if you are writing a report in latex, the
final product, your report, might depend on some `tex` files, some figures, and
the code needed to generate these figures.  When you change one of these, you
need to rebuild your entire project.  Make detects such changes, and allows you
to rebuild your project in a "minimal way" with a very few number of commands
(an example will make this clear).  You can think of Makefiles as "smart"
versions of ordinary shell scripts that you may already be using to carry out
this task.

Some typical scenarios...

(1) You are writing a paper that includes figures generated from some `R` code.
    You start modifying some of the `R` files that produce these figures.  It is
    clear that these need to be re-run to generate your figures, but is there
    anything else that needs to be re-run that depends on the output from these
    files?  Do you need to recompile everything?
(2) You Find Yourself Typing In `R CMD BATCH `, `g++ `, `pdflatex`, etc. over and
    over as you make changes to your source files.

## Make: Conceptual Overview ##

Makefiles consist of rules, and rules consist of three parts: targets,
dependencies, and actions (in pseudo-code)

```
target : dep1 dep2 dep3
    action
```

You would parse the previous piece of code as: "target depends on dep1, dep2, and
dep3.  To build the target, use the command action."  As a concrete example,
consider:
```
out.o : out.cpp
    g++ out.cpp -o out.o
```

This rule says that in order to create `out.o`, we need to run
`g++ out.cpp -o out.o`, and that `out.o` depends one `out.cpp`.  If we put this
in a Makefile, when we run the command `make` on the command line, `Make` will
check to see if `out.o` already exists.  If it doesn't, it compiles it with
`g++` as indicated above.  If it does exist, then it checks to make sure that
`out.cpp` hasn't been modified since `out.o` was last created.  If it has changed,
it recompiles the project, and if not it does nothing.

Makefiles generally consist of many such rules, and some rules depend on other
rules.  You can think of Make as organizing all the dependencies in an acyclic
graph, and every time a node gets modified, Make will re-compile all of the
descendents of that node.  (see the next example).

## Make: Examples ##

`/Examples/MakeExample`

The setting: we are writing a report that contains a plot of some simulation
results (specifically, fitting a regression line to data simulated from a
linear model).  The workflow: we have `R` code in a file `simulate.R` that reads
parameter values from `params.csv` and creates a plot.  This plot goes in the
tex file of our report `report.tex`.  If the file containing the parameters
changes, we want our Makefile to recognize that it has changed, re-run the
`R` code, and recompile our latex document.  If we change just the latex, there
is no need to re-generate the figure (a shell script designed to automate your
workflow wouldn't be able to figure this out).

~~~
.PHONY: all clean

all: report.pdf

report.pdf: report.tex params.csv linePlot.pdf
    pdflatex report.tex

linePlot.pdf: simulate.R params.csv
    R CMD BATCH simulate.R

clean:
    rm *.log *.aux Rplots.pdf *.Rout *~ report.pdf linePlot.pdf
~~~

(See `/Examples/MakeExample/Makefile`) for a more commented version).  To compile
the project simple type `make`.  There is no need to re-type a plethora of
commands each time you want to re-generate things, and unneccesary work is never
done by the computer when generating your final report.

## Additional Resources ##

* (http://swcarpentry.github.io/make-novice/)

# Markdown #

(See `/Examples/PandocExample`)

## Why Bother with Markdown ##

You go through the trouble of writing a nice document in HTML, but now you want
that document in PDF form, or TeX form, or Word form, or Beamer form, ...  heck,
you just want your original document to be readable as a standalone document
(good luck trying to read a paper just from the TeX source).  Markdown allows
you to write easy to read source documents, which can then be "compiled" into
any number of formats via the `pandoc`.  The source for this file was written
in `softwareCarpentry.md`, and then compiled into standalone HTML using `pandoc`.
See `/Examples/PandocExample` for a quick picture of how all of this looks.  If
you ever read blogs and wonder how people can produce such nice documents so
quickly, it is because of Markdown.

## Additional Resources ##

* (http://pandoc.org/demos.html)
