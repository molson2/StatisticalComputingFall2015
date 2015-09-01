################################################################################
#                           Load Rcpp/RcppArmadillo
################################################################################

library(Rcpp)
library(RcppArmadillo)
library(microbenchmark)
library(rbenchmark)

# Works if command-line tools installed on your Mac. Windows, who knows?
# install.packages("Rcpp", dep=T)
# install.packages("RcppArmadillo", dep=T)

################################################################################
#                               Overview
################################################################################

- Why bother with Rcpp?
-- Examples below show speed-ups of up to 1500 times
-- Code looks very similar to R in many circumstances
-- Very nice interface to C++ linear algebra libraries
-- Takes care of things like garbage collection and handles array bounds
   violations gracefully.

- When to use Rcpp?
-- loops
-- operations that involve manipulating memory extensively

- What will you leave here with?
-- TODO: read Rcpp Advanced R Rcpp chapter (if you get nothing else out of this
   talk, a couple days with that chapter and you are good to go)
-- A collection of Rcpp programs you can build from: Gibbs sampling, LM, PCA
- Look in the "Code" folder

- Roadmap
-- Resources
-- Basic Rcpp
-- Extended example
-- RcppArmadillo intro

(Everything will be posted online somewhere; if I forget remind me)

################################################################################
#                               Resources
################################################################################

- Advanced R: Hadley Wickham (Chapter RCpp)
-- http://adv-r.had.co.nz/Rcpp.html

- Rcpp By Example: Dirk Eddelbuettel

- Rcpp Vignettes

vignette("Rcpp-attributes")
vignette("Rcpp-introduction")
vignette("Rcpp-quickref")
vignette("Rcpp-sugar")
vignette("RcppArmadillo-intro")

- Armadillo "cheat sheet"
-- Armadillo: An Open Source C++ Linear Algebra Library for Fast Prototyping and Computationally Intensive Experiments

- Armadillo C++ API docs
-- http://arma.sourceforge.net/docs.html

################################################################################
#                          Before there was RCpp...
################################################################################

- Workflow using ".C" interface (apparently .C is now depreciated)
    
    1) Write a C function returning void (everything needs to be passed by
       reference...including the return value...)
    2) Compile into shared library
    3) Write R wrapper function
    4) Dynamically load shared library
    5) Hope there are no bugs...

- Time consuming and hard to debug; seg fault => R crashes

# Load library
dyn.load("Code/BeforeRcpp/gibbs.so")

# Write a wrapper
gibbs <- function(n=10000,thin=500){
              tmp=.C("gibbs",as.integer(n),as.integer(thin),
                                                x=as.double(1:n),y=as.double(1:n))
                        mat=cbind(1:n,tmp$x,tmp$y)
                        colnames(mat)=c("Iter","x","y")
                        mat
          }

# Test it out!
chainOld <- gibbs(1e4, thin=500) 

# Clean up
# rm(chain, gibbs)
# dyn.unload("Code/BeforeRcpp/gibbs.so")

################################################################################
#                          RCpp: Hello, World
################################################################################

-- evalCpp: evaluate a simple C++ expression
-- cppFunction: write a cpp function inline
-- sourceCpp: compile cpp file from source

# Hello, World
evalCpp("log(1)")
    
# Taken from Rcpp By Example
cppFunction('int fibC(int n){
   if(n<2) return n;
   return fibC(n-1) + fibC(n-2);
}')

fibR <- function(n){
    if (n<2) return(n)
    return(fibR(n-1) + fibR(n-2))
}

fibR(20)
fibC(20)
benchmark(fibR(20), fibC(20)) # And yea, about 350 times faster...

################################################################################
#                          RCpp: The Basics
################################################################################

- Unlike R, C++ is strongly typed so you need to be careful about the "type"!

- C++ Data type/class                         R Data Type
    
         int                                    integer
        double                                  numeric
         bool                                   logical
        string                                    char
     IntegerVector                                 ""               
     NumericVector
     LogicalVector
     CharacterVector
     IntegerMatrix
     NumericMatrix
     LogicalMatrix
     CharacterMatrix                               ""
         List                                      list
       DataFrame                                dataframe
       Function                                  function


- GOTCHAS
-- C indexing starts with 0
-- Type matters: if you type "int" instead of "double", digits get truncated
-- ^ operator is XOR in C++, not "raise to power"!

# Example 1: Euclidean norm
cppFunction('double normC(NumericVector x){
   int n = x.size();
   double sumSq = 0.0;
   for(int i = 0; i < n; i++) // indices start at 0!
      sumSq += pow(x[i],2.0);
   return sqrt(sumSq);
   
}')

# R version
normR <- function(x) sqrt(sum(x^2))

x <- rnorm(1e4)
normR(x)
normC(x)

microbenchmark(
    normR(x),
    normC(x))

# Example 2: Convolution
# Working with NumericVector (see also NumericMatrix class)
cppFunction('NumericVector convolveC(NumericVector x, NumericVector y){
  int n = x.size();
  int m = y.size();
  int l = n + m - 1;

  NumericVector f(l);

  for(int i = 0; i < n; i++)
    for(int j = 0; j < n; j++)
      f[i+j] += x[i]*y[j];

  return f;

}')

# The R version
convolveR <- function(x,y){
    f <- numeric(length(x)+length(y)-1)
    for(i in seq_along(x))
        for(j in seq_along(y))
            f[i+j] = f[i+j] + x[i] + y[j];
    f
}

x <- rnorm(1e2)
y <- rnorm(1e2)
benchmark(convolveC(x,y), convolveR(x,y)) # About 500-1500 times faster

# Example 3: simulating truncated normal (in the dumbest way)
cppFunction('NumericVector truncNormC(double mu, double sigma, double ub, int n){
  // Sets the same seed as global environment
  RNGScope scope;
  NumericVector sim(n);
  for(int i = 0; i < n; i++)
    // rnorm returns a NumericVector by default: we want the first draw
    while((sim[i] = rnorm(1, mu, sigma)[0]) > ub);
   return sim;
}')

x <- truncNormC(0, 1, -1, 1e6)
hist(x, xlim=c(-3,0))

################################################################################
#                                    RCpp: Sugar
################################################################################

- Many R functions have been "sugarized" which makes the learning curve less steep
-- the R and Rcpp code looks almost identical in many cases

-- +,-,*,/,<,>,<=,>=,==,!=, ...
-- any, all
-- head, tail, rep, rep_each, rep_len, rev, seq_along, seq_length
-- abs(), acos(), asin(), atan(), beta(), ceil(), ceiling(), choose(), cos(), cosh(), digamma(), exp(), expm1(), factorial(), floor(), gamma(), lbeta(), lchoose(), lfactorial(), lgamma(), log(), log10(), log1p(), pentagamma(), psigamma(), round(), signif(), sin(), sinh(), sqrt(), tan(), tanh(), tetragamma(), trigamma(), trunc()
-- mean, min, max, sum, sd, var
-- cumsum, diff, pmin, pmax
-- match, self_match, which_max, which_min
-- duplicated, unique
-- the standard type distributions d/q/p/r

# Example 4: Euclidean norm
cppFunction('double normCS(NumericVector x){
  return sqrt(sum(pow(x,2.0)));
}')

x <- c(1,2,3)
normCS(x)

# Example 5: Test for majorization
cppFunction('bool majorize(NumericVector x, NumericVector y){
  int n = x.size();
  int m = y.size();
  if(n!=m) stop("lengths of x and y must agree");

  return is_true(all(x <= y));
}')

majorize(1:10, 1:10+1)
majorize(1:10,1:10-1)
majorize(1:10,1) 

- (see vignette("Rcpp-sugar") for more)

################################################################################
#                               Rcpp: A Gibbs Sampler
################################################################################

- We will rewrite the Gibbs sampler from earlier using Rcpp
-- illustrate sourceRcpp

# Read in c++ source; see file for appropriate adornings...
# Example 6: Gibbs Sampler
sourceCpp("Code/gibbs.cpp")

chainNew <- gibbsCpp(1e4, 500)
plot(chainNew[,1], type="l")

################################################################################
#                       RCppArmadillo: Short Intro
################################################################################

- There are at least three major libraries for linear algebra in C++
-- Eigen
-- GSL (really a C library)
-- Armadillo

- These are all implemented in Rcpp extensions

- Armadillo is very nice because its syntax is deliberately close to Matlab
-- small learning curve

- Some common armadillo commands:

=====================================================================================
    
X(1,2) = 3                        Assign value 3 to element at location (2,3)
X = A + B                         Add matrices A and B
X( span(1,2), span(3,4) )         Provide read/write access to submatrix of X
zeros(rows [, cols [, slices]))   Generate vector (or matrix or cube) of zeros
ones(rows [, cols [, slices]))    Generate vector (or matrix or cube) of ones
eye(rows, cols)                   Identity Matrix
repmat(X, row_copies, col_copies) Replicate matrix X in block-like manner
det(X)                            Returns the determinant of matrix X
norm(X, p)                        Compute the p-norm of matrix or vector X
rank(X)                           Compute the rank of matrix X
min(X, dim=0); max(X, dim=0)      Extremum value of each column of X (row if dim=1)
trans(X) or X.t()                 Return transpose of X
R = chol(X)                       Cholesky decomposition of X such that RTR = X
inv(X) or X.i()                   Returns the inverse of square matrix X
pinv(X)                           Returns the pseudo-inverse of matrix X
lu(L, U, P, X)                    LU decomp. with partial pivoting; also lu(L, U, X)
qr(Q, R, X)                       QR decomp. into orthogonal Q and right-triangular R
X = solve(A, B)                   Solve system AX = B for X
s = svd(X); svd(U, s, V, X)       Singular-value decomposition of X

=====================================================================================
    
- The basic types one works with are "mat" and "vec" in the armadillo library.

- What you need to know when working with NumericMatrix and mat, etc;
-- to cast NumericMatrix XR to mat: 
    : mat X = as<mat>(XR)
-- to cast NumericMatrix xr to mat:
    : vec v = as<vec>(xr)

# Example 7: Implementing LS
sourceCpp("Code/lm.cpp")

# Generate some data to check 
X <- matrix(rnorm(1e4*3),1e4,3)
y <- cbind(1,X)%*%c(1,2,3,4) + rnorm(1e4)

modR <- summary(lm(y~X)) # R
modCpp <- lmCpp(X,y) # Rcpp

coef(modR)
modCpp$beta

modR$sigma
modCpp$sigma

- RcppArmadillo comes with a function fastLM (faster than lm function)

XX <- cbind(1,X)
microbenchmark( fastLm(XX,y), lm(y~X))

# Example 8: PCA
sourceCpp("Code/pca.cpp")

X <- matrix(rnorm(50),10,5)
outC <- pca(X) # with Rcpp

scaleX <- scale(X)

outR <- svd(scaleX) # with R
princompsR <- outR$v
pcaScoresR <- scaleX %*% outR$v

norm(princompsR - outC$princomps)
norm(pcaScoresR - outC$pcaScore)

# Example 9-: Some random examples
sourceCpp("Code/moreExamples.cpp")

cppFunction('double f(NumericVector x){
  double s = 0.0;
  int n = x.size();
  for(int i = 0; i < n; i++)
    s += x[i];
  return s/n;
}')

