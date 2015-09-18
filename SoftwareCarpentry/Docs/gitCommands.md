# Git Commands for Common Tasks #

#### Get help on something, i.e. git log --graph ####
```
man git-log
```

### Configure global variables ###
```
git config --global user.name "Your Name Comes Here"
git config --global user.email you@yourdomain.example.com
git config --list # see list of configs
git config --system core.editor emacs # set the editor for things like commit -m
```

### Create new git project ###
```
git init
```

### Add ALL files ###
```
git add .
```

### Add a file to the staging area ###
```
git add changedFile
```

### Another way to go: will add + commit modified files in one step ###
```
git commit -a
```

### See differences between repo and old commits ###
```
git diff --cached
git diff # difference between wd and staged
git diff --staged # difference between staged and last commit
```

### See which things have changed, yet to be commited, etc ###
```
git status
git status -s # abbreviated status message
```

### See history of commits ###
```
git log
git log -p # see diffs
git log --stat --summary
git log --graph --decorate --oneline
```

### Creating new branch (for experimenting perhaps) ###
If you create new file in different branch, doesn't seem to show up
when you "ls" in the same directory...
```
git branch mattsBranch
git branch # shows you which branch you are on
git checkout mattsBranch # switches you over
git checkout master # takes you back to original branch
```

### To merge branches ###
```
git merge mattBranch
git branch -d mattBranch # delete mattBranch (ensures that changes are in current branch)
git branch -D crazy-idea # totally get rid of something you tried, different from the previous command
```

### Clone repository ###
```
git clone /path/to/repo myNameForIt
```


### Pull in new changes (fetches changes and merges them into branch) ###
```
git pull /path/to/directory master
```

### Safely "look" at repository to see if there are changes worth "pulling" ###
```
git fetch /path/to/rep
git log -p HEAD..FETCH_HEAD
```

### Define an "alias" for the reporistory you are working with ###
```
git remote add bob /home/bob/myrepo
git fetch bob
```

### To use SSH protocol with cloning ###
When working on a server, you need to obtain an ssh-key and add it to
GitHub (if you want to work with a GitHub repository)
```
git clone molson@wharton.edu:home/molson/repo myRepName
```

#### See what your remotes are ###
```
git remote -v
git remote set-url origin git@github.com:USERNAME/REPOSITORY
git remote add  [shortname] [url] # gives alias for longer url
```

### Delete file and stop tracking it ###
```
git rm a.txt
```

### Have git stop tracking a file, but don't delete from working directory ###
```
git rm --cached fname
```

### To rename a file (old hat, just prefix with "git") ###
```
git mv a b
```

### Git push syntax ###
```
git push [remote-name] [branch-name]
```

### "Undo" changes made to file in working directory ###
```
git checkout -- fileToUndo
```

### Ignore files with certain extensions ###
File called ".gitignore" contains extensions of files you want git to completely ignore; i.e. compiled binaries.  In main directory, put the line in .gitignore *.o.

### Checking out a commit ###
Makes the entire working directory match that commit: view old state of project without altering current state
```
git checkout <commit> <file> # a single file
git checkout <commit> # every tracked file
```

### Create a new commit that undoes the changes from a certain commit ###
```
git revert <commit>
git revert --abort # if there are conflicts and you just want to run away
```

### Unstage every file ###
```
git reset # unstage everything (so it seems to basically undo the "adds"
```

### Unstage a file ###
```
git reset HEAD <file>
```


### Add a file to the last commit (if you forgot to add something) ###
```
git commit -m "i made a commit"
git add forgottenFile
git commit --amend
```

### List branches that have not been merged in ###
```
git branch --no-merged
```

### Tag important points in your work (release versions, etc.) ###
```
git tag # show tags
git tag -a v1.4 -m 'my version 1.4' # create annotated tag
git show v1.0 # show the commit realted to tag "v1.0"
git tag -a v1.2 9fceb02 # tag commit starting with 9fceb02
git push origin --tags # push your tags to a remote server
```

