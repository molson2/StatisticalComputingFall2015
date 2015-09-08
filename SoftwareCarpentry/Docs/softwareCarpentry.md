% Software Carpentry
% Matt Olson
% September 11, 2015

# Git #

## Version Control with Git: High Level ##

You can think of version control systems as saving commented snapshots of your work in time.
- 
- 
- 
- 


### Why Bother with VC: Common Scenarios ... ###

(1) You found a good model setting for some simulation results.  After playing around with
    your code and making some changes you can no longer replicate what you found a few days
    ago ...
(2) You decide to use a Ridge instead of Lasso penalty in your regression.  You comment out
    all the code using the Lasso and add in new code for the Ridge.  The Ridge doesn't work
    that great - now you have to go through all of your code and "undo" these changes ...
(3) You are working on a paper with a co-author in Dropbox and you both try to modify it at
    the same time ...
(4) You find yourself naming files like "modelv1.R", "modelv2.R", ... or "temp", "old",
    "experimental", ...

### The Conceptual Model ###

Understanding this model is the key to everything!

- working directory | staging | commit model
  * maybe a figure or something ... ?
- github

### Additional Resources ###
  * Github Book (https://git-scm.com/book/en/v2) Chapters 1-3
  * (https://www.atlassian.com/git/tutorials)

## Getting Off the Ground with Our Repository ##

Some initializations if you've never used `git`:
```
git config --global user.name "Matt Olson"
git config --global user.email "molson5574@gmail.com"
git config --global color.ui "auto"
git config --global core.editor "emacs -w"
```

Pull the repository to your machine (you do this once - after that you "push" and "pull" to
interact with the Github repository):
```
git clone https://github.com/molson2/StatisticalComputingFall2015
```

Suppose you create your own tutorial in a file called `tutorial.md`.  Here are
the steps for adding it to our repository:
```
git add tutorial.md # adds tutorial.md to stagin area
git commit -m "Added a tutorial" # creates a new commit
git pull # pulls in any new changes
git push # adds your new commit to Github
```

## Case Studies ##

### Case I: Retrieving Good Simulation Results ###

### Case II: Trying Out a New Idea ###

### Case III: Working on a Project with Co-Author ###

## Command Reference ##

# Make #

# Pandoc #


